//------------------------------ tabstop = 4 ----------------------------------
//
// Copyright (C) 2024 Comcast
//
// All rights reserved.
//
// This software is protected by copyright laws of the United States
// and of foreign countries. This material may also be protected by
// patent laws of the United States and of foreign countries.
//
// This software is furnished under a license agreement and/or a
// nondisclosure agreement and may only be used or copied in accordance
// with the terms of those agreements.
//
// The mere transfer of this software does not imply any licenses of trade
// secrets, proprietary technology, copyrights, patents, trademarks, or
// any other form of intellectual property whatsoever.
//
// Comcast retains all ownership rights.
//
//------------------------------ tabstop = 4 ----------------------------------
/*
 * CPCD Monitor Application
 *
 * Description:
 * ------------
 * This app monitors the CPCD state to ensure that it does not get stuck and stop communicating
 * with either the host application or the RCP also referred to as secondary device via the
 * secondary's endpoint. This app opens the same endpoint that are used by OTBR and Zigbeed.
 * If it fails to open the endpoint after several retries, it restarts the CPCD service.
 * If the monitor app detects no response from CPCD for an endpoint state, it retries a few times
 * before trying to restart the CPCD service. It also registers for events for the endpoint.
 * If it receives an event for the endpoint, it retries connecting to the endpoint in case of any issue,
 * and if it fails, restarts the CPCD service. Additionally, it registers for reset event and tries
 * to reconnect, and if it fails, restarts the CPCD service.
 *
 * Monitor app is intentionally avoiding the complexity of reading messages from the secondary source, as
 * that would require a deeper understanding of the CPCD code to ensure communication isn’t disrupted. However,
 * it is observed that instances where CPCD closes the endpoint socket for monitor_app, there is no way in
 * the library to detect this. This doesn’t cause any issues or indicate that cpcd is in a bad state.
 * CPCD simply checks the sockets for an endpoint, and if it detects that data sent to it isn’t being read,
 * it closes the socket. This doesn’t affect our ability to retrieve the endpoint state, as those calls
 * don’t rely on an our active socket connection. Instead, they just require the endpoint ID as an argument to
 * report the state accurately.
 *
 * If it exists on its own without restarting cpcd, it needs to be started again by its systemd service.
 */
#include <iostream>
#include <thread>
#include <chrono>
#include <csignal>
#include <cstring>
#include <atomic>
#include <cerrno>
#include <functional>
#include <systemd/sd-bus.h>
extern "C" {
    #include "sl_cpc.h"
}
namespace {
    constexpr auto VERSION = "1.1.0";
    constexpr int MAX_RETRY_ATTEMPTS = 5;
    constexpr uint32_t SLEEP_TIME_SEC = 350;
    constexpr uint32_t POLL_TIME_SEC = 5;
    std::atomic<bool> running{false};
    std::atomic<bool> secondaryReset{false};
    extern "C" void signalHandler(int signum) {
        running.store(false);
    }
    // Reset callback function called by the cpcd library
    extern "C" void reset_callback() {
        std::cerr << "Secondary reset detected." << std::endl;
        secondaryReset.store(true);
    }
    void restartCpcdService() {
        // cpp_monitor's systemd service should be designed in a way that gets restarted when cpcd restarts.
        std::cout << "Restarting cpcd service..." << std::endl;
        sd_bus_error error = SD_BUS_ERROR_NULL;
        sd_bus_message *m = nullptr;
        sd_bus *bus = nullptr;
        int ret;
        const char *cmdPath = "/bin/sh";
        const char *args[] = { "sh", "-c", "sleep 2; systemctl restart cpcd.service" };
        size_t numArgs = sizeof(args) / sizeof(args[0]);
        int ignoreFailure = 1; // ignore failures of transient service
        ret = sd_bus_default_system(&bus);
        if (ret < 0) {
            std::cerr << "Failed to connect to system bus: " << strerror(-ret) << std::endl;
            return;
        }
        constexpr const char* unitName = "cpcd-restart.service";
        std::cout << "Starting a transient systemd service : " << unitName << std::endl;
        // We are creating transient unit as there is no timer unit available to restart cpcd. May be we create one and
        // get rid of the most of the code here.
        ret = sd_bus_message_new_method_call(bus, &m, "org.freedesktop.systemd1",
                                            "/org/freedesktop/systemd1",
                                            "org.freedesktop.systemd1.Manager",
                                            "StartTransientUnit");
        if (ret < 0) {
            std::cerr << "Failed to create method call: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // StartTransientUnit(in  s name,
        //                    in  s mode,
        //                    in  a(sv) properties,
        //                    in  a(sa(sv)) aux,
        //                    out o job);
        // Here object path (o) is not needed as we dont need to track the progress of transient job.
        ret = sd_bus_message_append(m, "ss", unitName, "replace");
        if (ret < 0) {
            std::cerr << "systemd transient service: Failed to append unit name and mode: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'a', "(sv)");
        if (ret < 0) {
            std::cerr << "Failed to open array of properties: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'r', "sv");
        if (ret < 0) {
            std::cerr << "Failed to open (sv) container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_append_basic(m, 's', "ExecStart");
        if (ret < 0) {
            std::cerr << "Failed to append property name: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'v', "a(sasb)");
        if (ret < 0) {
            std::cerr << "Failed to open variant container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'a', "(sasb)");
        if (ret < 0) {
            std::cerr << "Failed to open array of exec commands: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'r', "sasb");
        if (ret < 0) {
            std::cerr << "Failed to open struct container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_append_basic(m, 's', cmdPath);
        if (ret < 0) {
            std::cerr << "Failed to append command path: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_open_container(m, 'a', "s");
        if (ret < 0) {
            std::cerr << "Failed to open arguments array: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        for (size_t i = 0; i < numArgs; ++i) {
            ret = sd_bus_message_append_basic(m, 's', args[i]);
            if (ret < 0) {
                std::cerr << "Failed to append argument: " << strerror(-ret) << std::endl;
                goto cleanup;
            }
        }
        // Close array of arguments "as"
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close arguments array: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_append_basic(m, 'b', &ignoreFailure);
        if (ret < 0) {
            std::cerr << "Failed to append ignore failure boolean: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // Close struct (sasb)
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close struct container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // Close array of exec commands a(sasb)
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close array of exec commands: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // Close variant from (sv)
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close variant container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // Close (sv) struct
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close (sv) container: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // Close array of properties a(sv)
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close array of properties: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        // It is not supported yet as per doc, so append empty array of auxiliary units
        ret = sd_bus_message_open_container(m, 'a', "(sa(sv))");
        if (ret < 0) {
            std::cerr << "Failed to open auxiliary units array: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_message_close_container(m);
        if (ret < 0) {
            std::cerr << "Failed to close auxiliary units array: " << strerror(-ret) << std::endl;
            goto cleanup;
        }
        ret = sd_bus_call(bus, m, 0, &error, nullptr);
        if (ret < 0) {
            std::cerr << "Failed to start transient service unit: " << unitName << " " << (error.message ? error.message : strerror(-ret)) << std::endl;
        } else {
            std::cout << "cpcd.service restart scheduled successfully" << std::endl;
        }
    cleanup:
        sd_bus_message_unref(m);
        sd_bus_error_free(&error);
        sd_bus_unref(bus);
    }
}
class RetryOperation {
public:
    using Operation = std::function<int()>;
    static bool retry(Operation func, int max_attempts, int delay_seconds) {
        int attempts = 0;
        while (attempts < max_attempts && running.load()) {
            int ret = func();
            if (ret >= 0) {
                return true;
            }
            std::cerr << "Operation failed: " << strerror(-ret) << ". Retrying..." << std::endl;
            std::this_thread::sleep_for(std::chrono::seconds(delay_seconds));
            attempts++;
        }
        return false;
    }
};
class EndpointEventHandler {
private:
    cpc_handle_t cpcdHandle_;
    sl_cpc_service_endpoint_id_t_enum endpointId_;
    std::thread eventThread_;
    std::atomic<bool> continueRunning_;
    const char* getEventTypeString(cpc_event_type_t eventType) {
        switch (eventType) {
            case SL_CPC_EVENT_ENDPOINT_UNKNOWN:
                return "UNKNOWN";
            case SL_CPC_EVENT_ENDPOINT_OPENED:
                return "OPENED";
            case SL_CPC_EVENT_ENDPOINT_CLOSED:
                return "CLOSED";
            case SL_CPC_EVENT_ENDPOINT_CLOSING:
                return "CLOSING";
            case SL_CPC_EVENT_ENDPOINT_ERROR_DESTINATION_UNREACHABLE:
                return "ERROR_DESTINATION_UNREACHABLE";
            case SL_CPC_EVENT_ENDPOINT_ERROR_SECURITY_INCIDENT:
                return "ERROR_SECURITY_INCIDENT";
            case SL_CPC_EVENT_ENDPOINT_ERROR_FAULT:
                return "ERROR_FAULT";
            default:
                return "INVALID_EVENT_TYPE";
        }
    }
    void eventThread() {
        cpc_endpoint_event_handle_t eventHandle{};
        int eventFd = cpc_init_endpoint_event(cpcdHandle_, &eventHandle, endpointId_);
        if (eventFd < 0) {
            std::cerr << "Failed to initialize event monitoring for endpoint " << endpointId_
                    << ": " << strerror(eventFd) << std::endl;
            running.store(false);
            return;
        }
        std::cout << "Event monitoring initialized for endpoint" << std::endl;
        int retry_count = 0;
        while (running.load() && !secondaryReset.load() && continueRunning_.load()) {
            fd_set readFds;
            FD_ZERO(&readFds);
            FD_SET(eventFd, &readFds);
            int maxFd = eventFd;
            struct timeval timeout;
            timeout.tv_sec = POLL_TIME_SEC;
            timeout.tv_usec = 0;
            errno = 0;
            int ret = select(maxFd + 1, &readFds, NULL, NULL, &timeout);
            if (ret == -1) {
                if (errno == EINTR) {
                    continue;
                }
                perror("select");
                break;
            } else if (ret == 0) {
                continue;
            }
            if (FD_ISSET(eventFd, &readFds)) {
                cpc_event_type_t eventType{};
                ret = cpc_read_endpoint_event(eventHandle, &eventType, CPC_ENDPOINT_EVENT_FLAG_NONE);
                if (ret == 0) {
                    std::cout << "Received event on endpoint " << endpointId_
                            << ": " << getEventTypeString(eventType) << std::endl;
                    retry_count = 0;
                    if (eventType == SL_CPC_EVENT_ENDPOINT_CLOSED ||
                        eventType == SL_CPC_EVENT_ENDPOINT_ERROR_DESTINATION_UNREACHABLE ||
                        eventType == SL_CPC_EVENT_ENDPOINT_ERROR_SECURITY_INCIDENT ||
                        eventType == SL_CPC_EVENT_ENDPOINT_ERROR_FAULT) {
                        break;
                    }
                } else if (++retry_count >= MAX_RETRY_ATTEMPTS) {
                    std::cerr << "Failed to read endpoint event after " << MAX_RETRY_ATTEMPTS << " attempts." << std::endl;
                    break;
                } else {
                    std::cerr << "Failed to read endpoint event" << std::endl;
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                }
            }
        }
        secondaryReset.store(true);
        int ret = cpc_deinit_endpoint_event(&eventHandle);
        if (ret != 0) {
            std::cerr << "Failed to deinitialize event monitoring: " << strerror(-ret) << std::endl;
        } else {
            std::cout << "Event monitoring deinitialized successfully for endpoint" << std::endl;
        }
    }
public:
    EndpointEventHandler(cpc_handle_t cpcHandle, sl_cpc_service_endpoint_id_t_enum endpointId) : cpcdHandle_(cpcHandle), endpointId_(endpointId), continueRunning_(false) {}
    ~EndpointEventHandler() {
        stop();
    }
    void start()
    {
        continueRunning_.store(true);
        eventThread_ = std::thread(&EndpointEventHandler::eventThread, this);
    }
    void stop() {
        continueRunning_.store(false);
        if (eventThread_.joinable()) {
            eventThread_.join();
        }
    }
};
class CpcdEndpoint {
private:
    cpc_handle_t cpcdHandle_;
    cpc_endpoint_t endpoint_;
    int endpointFd_;
    sl_cpc_service_endpoint_id_t_enum endpointId_;
    std::unique_ptr<EndpointEventHandler> eventHandler_;
public:
     CpcdEndpoint(sl_cpc_service_endpoint_id_t_enum endpointId) : cpcdHandle_{}, endpoint_{}, endpointFd_(-1), endpointId_(endpointId), eventHandler_(nullptr) {}
    ~CpcdEndpoint() {
        close();
    }
    bool open() {
        return RetryOperation::retry([this]() -> int {
            endpointFd_ = cpc_open_endpoint(cpcdHandle_, &endpoint_, SL_CPC_ENDPOINT_15_4, 1);
            if (endpointFd_ < 0) {
                std::cerr << "CPC endpoint opening failed with error: " << strerror(endpointFd_) << std::endl;
            }
            return endpointFd_;
        }, MAX_RETRY_ATTEMPTS, 1);
    }
    void close() {
        if (endpointFd_ > 0) {
            cpc_close_endpoint(&endpoint_);
            endpointFd_ = -1;
            std::cout << "CPC endpoint closed." << std::endl;
        }
    }
    bool initializeCpc() {
        return RetryOperation::retry([this]() -> int {
            int ret = cpc_init(&cpcdHandle_, "cpcd_0", false, reset_callback);
            if (ret < 0 ) {
                std::cerr << "CPC initialization failed with error: " << strerror(-ret) << std::endl;
            }
            return ret;
        }, MAX_RETRY_ATTEMPTS, 1);
    }
    bool checkCommunication() {
        cpc_endpoint_state_t state = SL_CPC_STATE_ERROR_FAULT;
        bool stateSuccess = RetryOperation::retry([this, &state]() -> int {
            int ret = cpc_get_endpoint_state(cpcdHandle_, endpointId_, &state);
            if (ret < 0) {
                std::cerr << "Get CPC endpoint status failed with error: " << strerror(-ret) << std::endl;
            }
            return ret;
        }, MAX_RETRY_ATTEMPTS, 1);
        if (stateSuccess && state != SL_CPC_STATE_OPEN)
        {
                std::cerr << "CPC endpoint is not opened. State: "<< state << std::endl;
                stateSuccess = -1;
        }
        return stateSuccess;
    }
    bool handleCpcReset() {
        close();
        std::this_thread::sleep_for(std::chrono::seconds(1));
        std::cout << "Attempting to reconnect to CPC..." << std::endl;
        bool reconnectSuccess = RetryOperation::retry([this]() -> int {
            return cpc_restart(&cpcdHandle_); // That's a library function to reconnect to cpcd. It is not restarting cpcd service.
        }, MAX_RETRY_ATTEMPTS, 1);
        if (!reconnectSuccess) {
            std::cerr << "Failed to reconnect CPC after " << MAX_RETRY_ATTEMPTS << " attempts." << std::endl;
        }
        return reconnectSuccess;
    }
    void startEventHandler()
    {
        eventHandler_ = std::make_unique<EndpointEventHandler>(cpcdHandle_, endpointId_);
        eventHandler_->start();
    }
    void stopEventHandler()
    {
        if (eventHandler_) {
            eventHandler_->stop();
        }
    }
};
class CpcdMonitor
{
private:
    CpcdEndpoint endpoint_;
    enum class cpcdState {
        INIT = 0,
        OPEN_ENDPOINT,
        REGISTER_EVENT_HANDLER,
        CHECK_COMM
    };
    void longWaitInSecs(uint32_t wait_period_sec) {
        uint32_t waited_sec = 0;
        while (waited_sec < wait_period_sec && running.load() && !secondaryReset.load()) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
            waited_sec += 1;
        }
    }
    bool handleSecondaryReset() {
        std::cout << "Handling reset..." << std::endl;
        endpoint_.stopEventHandler();
        secondaryReset.store(false);
        bool resetResult = endpoint_.handleCpcReset();
        if (!resetResult) {
            std::cerr << "Failed to handle CPC reset." << std::endl;
        }
        return resetResult;
    }
public:
    CpcdMonitor() : endpoint_(SL_CPC_ENDPOINT_15_4) {}
    void run()
    {
        cpcdState currentState = cpcdState::INIT;
        while (running.load()) {
            if (secondaryReset.load()) {
                if (!handleSecondaryReset()) {
                    restartCpcdService();
                    running.store(false);
                    continue;
                }
                std::cout << "Re-opening CPC endpoint after reset..." << std::endl;
                currentState = cpcdState::OPEN_ENDPOINT;
            }
            switch (currentState) {
                case cpcdState::INIT: {
                    if (!endpoint_.initializeCpc()) {
                        std::cerr << "Failed to initialize CPC after retries. Restarting cpcd." << std::endl;
                        restartCpcdService();
                        running.store(false);
                        continue;
                    }
                    currentState = cpcdState::OPEN_ENDPOINT;
                    break;
                }
                case cpcdState::OPEN_ENDPOINT: {
                    if (!endpoint_.open()) {
                        std::cerr << "Failed to open CPC endpoint after retries. Restarting cpcd." << std::endl;
                        restartCpcdService();
                        running.store(false);
                        continue;
                    }
                    currentState = cpcdState::REGISTER_EVENT_HANDLER;
                    break;
                }
                case cpcdState::REGISTER_EVENT_HANDLER: {
                    std::cout << "CPC Initialization completed successfully." << std::endl;
                    endpoint_.startEventHandler();
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                    currentState = cpcdState::CHECK_COMM;
                    break;
                }
                case cpcdState::CHECK_COMM: {
                    std::cout << "State: CHECK_COMM. Checking communication..." << std::endl;
                    if (!endpoint_.checkCommunication()) {
                        std::cerr << "Communication check failed after retries. Restarting cpcd service." << std::endl;
                        restartCpcdService();
                        running.store(false);
                        continue;
                    }
                    std::cout << "Communication with CPC endpoint is healthy." << std::endl;
                    longWaitInSecs(SLEEP_TIME_SEC);
                    break;
                }
                default: {
                    std::cerr << "Unknown state. Switching to INIT state." << std::endl;
                    currentState = cpcdState::INIT;
                    break;
                }
            }
        }
        endpoint_.stopEventHandler();
        endpoint_.close();
    }
};
int main() {
    std::cout << "CPCD monitor app version: "<< VERSION << std::endl;
    running.store(true);
    std::signal(SIGINT, signalHandler);
    std::signal(SIGTERM, signalHandler);
    CpcdMonitor cpcd;
    cpcd.run();
    std::cout << "CPCD Monitor App closed." << std::endl;
    return 0;
}
