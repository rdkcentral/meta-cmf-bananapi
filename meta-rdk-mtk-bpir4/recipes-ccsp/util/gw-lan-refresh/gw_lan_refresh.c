#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#include "ccsp/ccsp_hal_ethsw.h"

#define CONSOLE_LOG_FILE "/rdklogs/logs/Consolelog.txt.0"

#define DBG_PRINT(fmt ...)     {\
    FILE     *fp        = NULL;\
    fp = fopen ( CONSOLE_LOG_FILE, "a+");\
    if (fp)\
    {\
        fprintf(fp,fmt);\
        fclose(fp);\
    }\
}\


#define SLEEP_TIME 4

void refresh_external_switch()
{
    CCSP_HAL_ETHSW_PORT port;
    INT max_phy_eth_ports = 0;

    /* Total 3 LAN ports*/
    max_phy_eth_ports = CCSP_HAL_ETHSW_EthPort3;

    for (port = CCSP_HAL_ETHSW_EthPort1; port <= max_phy_eth_ports; port++)
    {
        // Disable the port
        DBG_PRINT("%s(): setting admin status down for port %d\n", __FUNCTION__, port);
        CcspHalEthSwSetPortAdminStatus(port, CCSP_HAL_ETHSW_AdminDown);
    }

    sleep(SLEEP_TIME);

    for (port = CCSP_HAL_ETHSW_EthPort1; port <= max_phy_eth_ports; port++)
    {
        // Enable the port
        DBG_PRINT("%s(): setting admin status up for port %d\n", __FUNCTION__, port);
        CcspHalEthSwSetPortAdminStatus(port, CCSP_HAL_ETHSW_AdminUp);
    }
}

void refresh_wifi()
{
    /* dis-associate connected wifi clients */
    system ("dmcli eRT setv Device.WiFi.AccessPoint.1.X_CISCO_COM_KickAssocDevices bool true");
    system ("dmcli eRT setv Device.WiFi.AccessPoint.2.X_CISCO_COM_KickAssocDevices bool true");

}

int main(int argc, char **argv)
{
    if (argc == 2) {
        if (strncmp (argv[1], "ethsw", strlen ("ethsw")) == 0) {
            DBG_PRINT ("[%s] calling to update ethsw setting \n",argv[0]);
            refresh_external_switch();
        }else if (strncmp (argv[1], "wifi", strlen ("wifi")) == 0) {
            DBG_PRINT ("[%s] calling to update wifi setting \n",argv[0]);
            refresh_wifi();
        }
        else {
            
        }
    }else {
        DBG_PRINT("gw_lan_refresh \n");
        refresh_external_switch();
        refresh_wifi();
    }
    return 0;
}
