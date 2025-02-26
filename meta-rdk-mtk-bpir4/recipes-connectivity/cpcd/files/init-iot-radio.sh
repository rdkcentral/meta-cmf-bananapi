#!/usr/bin/env sh
log() {
    echo "$(date '+%Y-%m-%dT%H:%M:%S') - ${1}"
}
VERSION=1.0.0
log "Version: $VERSION"
FIRMWARE_PATH="/lib/firmware"
CONFIGURATION_FILE="/etc/cpcd.conf"
IOT_RADIO_DEFAULT_FIRMWARE_FILE=""
IOT_RADIO_DEV_FIRMWARE_FILE=""
IOT_RADIO_UNSIGNED_FIRMWARE_FILE=""
reset_radio() {
    RESET_PIN=$(grep 'bootloader_reset_gpio:' "${CONFIGURATION_FILE}" | awk -F': ' '{print $2}')
    WAKE_PIN=$(grep 'bootloader_wake_gpio:' "${CONFIGURATION_FILE}" | awk -F': ' '{print $2}')
    if echo "${RESET_PIN}" | grep -Eq '^[0-9]+$' && echo "${WAKE_PIN}" | grep -Eq '^[0-9]+$'; then
        log "Resetting radio MCU"
        echo "${RESET_PIN}" > /sys/class/gpio/export
        echo "${WAKE_PIN}" > /sys/class/gpio/export
        echo "out" > /sys/class/gpio/gpio"${RESET_PIN}"/direction
        echo "out" > /sys/class/gpio/gpio"${WAKE_PIN}"/direction
        echo 0 > /sys/class/gpio/gpio"${RESET_PIN}"/value
        echo 1 > /sys/class/gpio/gpio"${WAKE_PIN}"/value
        usleep 26
        echo 1 > /sys/class/gpio/gpio"${RESET_PIN}"/value
        sleep 7.5
        echo 1 > /sys/class/gpio/gpio"${WAKE_PIN}"/value
        echo "$RESET_PIN" > /sys/class/gpio/unexport
        echo "$WAKE_PIN" > /sys/class/gpio/unexport
    else
        log "ERROR - Invalid or missing GPIO pin value: ${RESET_PIN}"
    fi
}
# If no firmware files are found, log an error and skip firmware updates
if ! ls "${FIRMWARE_PATH}"/iot-radio*-v*.gbl >/dev/null 2>&1; then
    log "ERROR - No valid IoT radio firmware files found in ${FIRMWARE_PATH}"
else
    for FILE in "${FIRMWARE_PATH}"/iot-radio*-v*.gbl; do
        case "${FILE}" in
            *signed-v*.gbl) IOT_RADIO_DEFAULT_FIRMWARE_FILE="${FILE}" ;;
            *signed-dev-v*.gbl) IOT_RADIO_DEV_FIRMWARE_FILE="${FILE}" ;;
            *) IOT_RADIO_UNSIGNED_FIRMWARE_FILE="${FILE}" ;;
        esac
    done
    log "Firmware files are:"
    log "  Prod: ${IOT_RADIO_DEFAULT_FIRMWARE_FILE:-Not Found}"
    log "  Dev: ${IOT_RADIO_DEV_FIRMWARE_FILE:-Not Found}"
    log "  Unsigned: ${IOT_RADIO_UNSIGNED_FIRMWARE_FILE:-Not Found}"
    # All firmware files must be the same version. Extract the version from the prod firmware file name.
    FIRMWARE_FILE_VER=$(echo "${IOT_RADIO_DEFAULT_FIRMWARE_FILE}" | cut -d'v' -f2 | awk -F'.gbl' '{print $1}')
    if [ -z "${FIRMWARE_FILE_VER}" ]; then
        log "ERROR - Failed to determine firmware version from file: ${IOT_RADIO_DEFAULT_FIRMWARE_FILE:-Not Found}"
    else
        log "Firmware file version determined: ${FIRMWARE_FILE_VER}"
        # Reset the radio to get it out of any bad state
        reset_radio
        # Get the version of running firmware on the radio
        /usr/bin/cpcd -c ${CONFIGURATION_FILE} -p > /tmp/.cpcdver$$ 2>&1 &
        CPCD_PID=$!
        sleep 5
        kill -9 $CPCD_PID >/dev/null 2>&1
        # Wait for the cpcd process to be killed or timeout
        TIMEOUT_S=$((SECONDS + 10))
        while kill -0 $CPCD_PID >/dev/null 2>&1; do
            if [ $SECONDS -ge $TIMEOUT_S ]; then
                echo "Timeout reached. Process $CPCD_PID may not have been killed."
                exit 1
            fi
            sleep 1
        done
        RUNNING_FIRMWARE_VER=$(sed -n '/Secondary APP v/s/.*v\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p' /tmp/.cpcdver$$)
        rm /tmp/.cpcdver$$
        log "Running firmware version: ${RUNNING_FIRMWARE_VER}"
        # If the running version differs, attempt firmware update with fallback mechanism
        if [ "${RUNNING_FIRMWARE_VER}" != "${FIRMWARE_FILE_VER}" ]; then
            log "Updating firmware to version ${FIRMWARE_FILE_VER}"
            if /usr/bin/cpcd -c "${CONFIGURATION_FILE}" -f "${IOT_RADIO_DEFAULT_FIRMWARE_FILE}" || \
               /usr/bin/cpcd -c "${CONFIGURATION_FILE}" -f "${IOT_RADIO_DEV_FIRMWARE_FILE}" || \
               /usr/bin/cpcd -c "${CONFIGURATION_FILE}" -f "${IOT_RADIO_UNSIGNED_FIRMWARE_FILE}"; then
                log "Firmware update successful."
            else
                log "ERROR - Firmware update failed after all attempts."
                exit 1  # Fail it so that process running it can take appropriate decision
            fi
        else
            log "Firmware is already up to date."
        fi
    fi
fi
reset_radio
log "Pre-start steps for cpcd completed."
