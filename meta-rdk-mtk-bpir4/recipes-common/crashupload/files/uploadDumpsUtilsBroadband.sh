#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2016 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

if [ -f /lib/rdk/utils.sh ];then
     . /lib/rdk/utils.sh
fi

if [ -f /etc/waninfo.sh ]; then
    . /etc/waninfo.sh
    INTERFACE=$(getWanInterfaceName)
else
    INTERFACE="erouter0"
fi
LANIPv6GUASupport=`sysevent get LANIPv6GUASupport`

 
getLastModifiedTimeOfFile()
{
    if [ -f $1 ] ; then
        stat -c '%y' $1 | cut -d '.' -f1 | sed -e 's/[ :]/-/g'
    fi
} 

get_core_value()
{
    core=""
    if [ -f /tmp/cpu_info ];then
         core=`cat /tmp/cpu_info`
    fi
    if [ ! "$core" ];then
           processor=`cat /proc/cpuinfo | grep Atom| wc -l`
           if [ $processor ] && [ $processor -gt 0 ] ;then
                  core="ATOM"
           fi
           processor=`cat /proc/cpuinfo | grep ARM| wc -l`
           if [ $processor ] && [ $processor -gt 0 ] ;then
                  core="ARM"
           fi
           if [ "$BOX_TYPE" = "SR300" ] || [ "$BOX_TYPE" = "SR213" ] || [ "$BOX_TYPE" = "SE501" ] || [ "$BOX_TYPE" = "WNXL11BWL" ] || [ "$BOX_TYPE" = "SCER11BEL" ];then
                  #ADA SR300,SR213,SE501,xle,XER10 - Handle aarch64
                  processor=`lscpu | grep aarch64| wc -l`
                  if [ $processor ] && [ $processor -gt 0 ] ;then
                      core="ARM"
                  fi
           fi
           echo $core > /tmp/cpu_info
    fi
    echo $core
}

#Refactor: On Arris XB6 on the ATOM the interface name is ARM_INTERFACE(erouter0)
#          XF3 Doesn't have ATOM or ARM
get_interface_value()
{
   output=""
   if [ "$BOX_TYPE" = "HUB4" ] || [ "$BOX_TYPE" = "SR300" ] || [ "$BOX_TYPE" = "SE501" ] || [ "$BOX_TYPE" = "SR213" ] || [ "$BOX_TYPE" = "WNXL11BWL" ] || [ "$BOX_TYPE" = "SCER11BEL" ] ; then
       #Set empty value for output so that interface name will be calculated from get_core_value 
       output=""
   else   
       if [ -f /tmp/if_info ];then
             output=`cat /tmp/if_info`
       fi
   fi
   if [ ! "$output" ];then
         output=`get_core_value`
         case "$output" in
             "ATOM")
                    output=$ATOM_INTERFACE ;;
             "ARM" )
                    output=$ARM_INTERFACE ;;
             *)
                    output="unknown" ;;
         esac
         echo $output > /tmp/if_info
  fi
  echo $output
}

#Refactor: On Arris XB6 on the ATOM the interface name is ARM_INTERFACE(erouter0)
#          XF3 Doesn't have ATOM or ARM
get_mac_address()
{
    INTERFACE=$1
    output=`get_core_value`
    case "$output" in
         "ATOM")
           mac=""
           wanmac_cache="/tmp/.wan_mac"

           if [ ! -f $wanmac_cache ] || [ "`cat $wanmac_cache`" == "" ]; then
               mac=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_MAC`
               mac=`echo $mac | grep "Execution succeed" | sed 's/.*value://g' | sed 's/ //g;s/://g' | cut -c1-12`
               # ARRISXB6-9480 : fallback in case dmcli fails, e.g. CcspCrSsp crash
               if [ "$mac" == "" ]; then
                   mac=`ifconfig $ARM_INTERFACE | grep HWaddr | cut -d " " -f7 | sed 's/://g'` 
               fi
               if [ "$mac" != "" ]; then
                   echo $mac > $wanmac_cache
               fi
           else
               mac=`cat $wanmac_cache`
           fi

           ;;
         "ARM" )
           if [ "$BOX_TYPE" = "WNXL11BWL" ] || [ "$BOX_TYPE" = "HUB4" ]|| [ "$BOX_TYPE" = "SR213" ] || [ "$BOX_TYPE" = "SCER11BEL" ]  ; then
             #Common logic does not work for XLE, because ifconfig has different template ouptut.
             #Use deviceinfo for XLE.
             mac=`deviceinfo.sh -cmac | sed 's/://g' | tr '[a-f]' '[A-F]' `
           else
             mac=`ifconfig $ARM_INTERFACE | grep HWaddr | cut -d " " -f7 | sed 's/://g'` 
           fi
           #if we dont have mac on interface, use sysevent
           #mac from sysevent is irrespective of connection types(adsl(atm0),vdsl(erouter0),wanoe(erouter0))
           if [ -z "$mac" ]; then
                if [ "$BOX_TYPE" = "HUB4" ] || [ "$BOX_TYPE" = "SR300" ] || [ "$BOX_TYPE" = "SE501" ] || [ "$BOX_TYPE" = "SR213" ] || [ "$BOX_TYPE" = "WNXL11BWL" ] || [ "$BOX_TYPE" = "SCER11BEL" ]; then
                    mac=$(sysevent get eth_wan_mac | sed 's/://g')
                fi
           fi
           ;;
          *)
           mac="00000000";;
    esac
    echo $mac      
}


# Get the MAC address of the machine
getMacAddressOnly()
{
     interface=`get_interface_value`
     if [ "$interface" ];then
           INTERFACE=$interface
     fi
     mac=`get_mac_address "$INTERFACE"`
     echo $mac
}

#Refactor: This Method should really be device specific. This only works for XB3
network_commn_status()
{
    output=`get_core_value`
    case "$output" in
        "ARM")
           INTERFACE=`get_interface_value`
           if [ "$INTERFACE" != "unknown" ];then
             IF_STATE=`sysevent get wan-status`
             if [ "x$BOX_TYPE" = "xHUB4" ] || [ "x$BOX_TYPE" = "xSR300" ] || [ "x$BOX_TYPE" = "xSE501" ] || [ "x$BOX_TYPE" = "xSR213" ] || [ "$BOX_TYPE" = "WNXL11BWL" ] || [ "$LANIPv6GUASupport" = "true" ]; then
                 CURRENT_WAN_IPV6_STATUS=`sysevent get ipv6_connection_state`
                 if [ "xup" = "x$CURRENT_WAN_IPV6_STATUS" ] ; then
                     EROUTER_IP=`ifconfig $HUB4_IPV6_INTERFACE | grep Global |  awk '/inet6/{print $3}' | cut -d '/' -f1 | head -n1`
                 else
                     EROUTER_IP=`ifconfig $INTERFACE | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1`
                 fi
                 # Ensure both IP address and interface status
                 while [ "$EROUTER_IP" == "" ] || [ "$IF_STATE" != "started" ]; do
                     sleep 5
                     IF_STATE=`sysevent get wan-status`
                     CURRENT_WAN_IPV6_STATUS=`sysevent get ipv6_connection_state`
                     MAPT_CONFIG=`sysevent get mapt_config_flag`
                     if [ "xup" = "x$CURRENT_WAN_IPV6_STATUS" ] && [ "xset" = "x$MAPT_CONFIG" ] ; then
                         EROUTER_IP=`ifconfig $HUB4_IPV6_INTERFACE | grep Global |  awk '/inet6/{print $3}' | cut -d '/' -f1 | head -n1`
                     else
                         EROUTER_IP=`ifconfig $INTERFACE | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1`
                     fi
                 done
            else
             EROUTER_IP=`ifconfig $INTERFACE | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1`
             # Ensure the IP address here
             while [ "$EROUTER_IP" == "" ]; do
                   sleep 5
                   EROUTER_IP=`ifconfig $INTERFACE | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1`
             done
             # Ensure both IP address and interface status
             while [ "$IF_STATE" != "started" ] && [ "$EROUTER_IP" != "" ];do
                 sleep 5
                 IF_STATE=`sysevent get wan-status`
                 if [ ! "$EROUTER_IP" ];then
                    EROUTER_IP=`ifconfig $INTERFACE | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1`
                 fi
            done
	   fi
          fi
          ;;
        "ATOM")
            if [ ! -f /tmp/if_network_status ];then
                 while [ "$status" = "" ] 
                 do
                     output=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_MAC`
                     status=`echo $output| grep "Execution succeed"`
                     if [ "$status" ];then
                          echo $status > /tmp/if_network_status
                     fi
                 done
            else
                 echo "Network is Ready now..!"
            fi
          ;;
        "*")
          echo "Unknown core value, Not sure about the network config..!"
          ;;
   esac
}
# Get the SHA1 checksum
getSHA1()
{
    sha1sum $1 | cut -f1 -d" "

}


# Return system uptime in seconds
Uptime()
{
     cat /proc/uptime | awk '{ split($1,a,".");  print a[1]; }'
}

get_model_value()
{
    output=`get_core_value`
    case "$output" in
        "ARM")
               #ToDo: fss/gw is XB3 specific shouldn't be here
               model_value=`cat /fss/gw/version.txt | grep ^imagename: | cut -d ":" -f 2 | cut -d "_" -f 1`
               ;;
        "ATOM")
               model_value=`cat /version.txt | grep ^imagename: | cut -d ":" -f 2 | cut -d "_" -f 1`
               ;;
        *)
               model_value="unknown" ;;
    esac
    echo $model_value
}

## Get Model No of the box
getModel()
{
  #ToDo: fss/gw is XB3 specific shouldn't be here
  #This Method will only work for ARM
  echo `cat /fss/gw/version.txt | grep ^imagename: | cut -d ":" -f 2 | cut -d "_" -f 1`
}

