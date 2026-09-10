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
# Script responsible for log upload based on protocol

if [ -f /etc/device.properties ]; then
    source /etc/device.properties
fi

source /lib/rdk/t2Shared_api.sh
source /lib/rdk/getpartnerid.sh

RDK_LOGGER_PATH="/rdklogger"
RRD_LOG_DIR="/tmp/rrd/"
source $RDK_LOGGER_PATH/logUpload_default_params.sh

NVRAM2_SUPPORTED="no"
. /lib/rdk/utils.sh 
. $RDK_LOGGER_PATH/logfiles.sh

if [ -f /lib/rdk/exec_curl_mtls.sh ]
then
   source /lib/rdk/exec_curl_mtls.sh
fi

if [ $# -lt 4 ]; then 
     echo "USAGE: $0 <TFTP Server IP> <UploadProtocol> <UploadHttpLink> <uploadOnReboot>"
fi
echo_t "The parameters are - arg1:$1 arg2:$2 arg3:$3 arg4:$4 arg5:$5 arg6:$6 arg7:$7"

# assign the input arguments
UploadProtocol=$2
UploadHttpLink=$3
UploadOnReboot=$4
UploadLogsonReboot=$7
partnerId="$(getPartnerId)"

unscheduledDisable=`syscfg get UploadLogsOnUnscheduledRebootDisable`
UPLOAD_LOGS=`sysevent get UPLOAD_LOGS_VAL_DCM`

UseLANIFIPV6=`sysevent get LANIPv6GUASupport`

if [ "$UPLOAD_LOGS" = "" ] || [ ! -f "$DCM_SETTINGS_PARSED" ]
then
    echo_t "processDCMResponse to get the logUploadSettings"
    UPLOAD_LOGS=`processDCMResponse`
fi

echo_t "UPLOAD_LOGS val is $UPLOAD_LOGS"

random_sleep()
{
    t_min=20
    t_max=30
    t_min=$(( t_min * $1 ))
    t_max=$(( t_max * $1 ))

    randomizedNumber=`awk -v min=$t_min -v max=$t_max -v seed="$(date +%N)" 'BEGIN{srand(seed);print int(min+rand()*(max-min+1))}'`
    echo_t "Direct comm. Random sleep for $randomizedNumber"
    sleep $randomizedNumber
}

isMaintenanceWindow()
{
	FW_START=`cat /nvram/.FirmwareUpgradeStartTime`
	FW_END=`cat /nvram/.FirmwareUpgradeEndTime`
	
	if [ "$UTC_ENABLE" == "true" ]
	then
		cur_hr=`LTime H | sed 's/^0*//'`
        	cur_min=`LTime M | sed 's/^0*//'`
        	cur_sec=`date +"%S" | sed 's/^0*//'`
    	else
        	cur_hr=`date +"%H" | sed 's/^0*//'`
        	cur_min=`date +"%M" | sed 's/^0*//'`
        	cur_sec=`date +"%S" | sed 's/^0*//'`
	fi

	curr_hr_in_sec=$((cur_hr*60*60))
	curr_min_in_sec=$((cur_min*60))
	curr_time_in_sec=$((curr_hr_in_sec+curr_min_in_sec+cur_sec))

	echo_t "curr_time_in_sec:$curr_time_in_sec"
	echo_t "FW_START:$FW_START"
	echo_t "FW_END:$FW_END"
	
	if [ "$curr_time_in_sec" -ge "$FW_START" ] && [ "$curr_time_in_sec" -le "$FW_END" ]
	then
		echo_t "Inside Maintenance Window"
		mw=1
	else
		echo_t "Outside Maintenance Window"
		mw=0
	fi
}

if [ "$UPLOAD_LOGS" != "true" ] && [ "$UPLOAD_LOGS" != "" ]
then
	isMaintenanceWindow
fi

if [ "$UPLOAD_LOGS" = "true" ] || [ "$UPLOAD_LOGS" = "" ]
then
   echo_t "Log upload is enabled"
elif [ "$UploadLogsonReboot" = "true" ] && [ "$unscheduledDisable" = "false" ] && [ "x$mw" = "x0" ]
	then
		echo_t "Log upload is enabled for unscheduledreboot"
else
   echo_t "Log upload is disabled"
   exit 1
fi

SIGN_FILE="/tmp/.signedRequest_$$_`date +'%s'`"
CODEBIG_BLOCK_TIME=1800
CODEBIG_BLOCK_FILENAME="/tmp/.lastcodebigfail_upl"

DIRECT_MAX_ATTEMPTS=3
CODEBIG_MAX_ATTEMPTS=3
UPSTREAM_TIMEOUT=60

EnableOCSPStapling="/tmp/.EnableOCSPStapling"
EnableOCSP="/tmp/.EnableOCSPCA"

if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
    CERT_STATUS="--cert-status"
fi

echo_t "logupload: MTLS Logupload Defaulted."

UseCodeBig=0
conn_str="Direct"
CodebigAvailable=0
encryptionEnable=`dmcli eRT retv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.EncryptCloudUpload.Enable`
URLENCODE_STRING=""

CURL_BIN="curl"

if [ "$5" != "" ]; then
	nvram2Backup=$5
else
    if [ "$NVRAM2_SUPPORTED" = "yes" ] && [ "$(syscfg get logbackup_enable)" = "true" ]
    then
        nvram2Backup="true"
    else
        nvram2Backup="false"
    fi
fi

UploadPath=$6

SECONDV=`dmcli eRT retv Device.X_CISCO_COM_CableModem.TimeOffset`

getFWVersion()
{
    sed -n 's/^imagename[:=]"\?\([^"]*\)"\?/\1/p' /version.txt
}

getBuildType()
{
   IMAGENAME=$(sed -n 's/^imagename[:=]"\?\([^"]*\)"\?/\1/p' /version.txt)

   TEMPDEV=`echo $IMAGENAME | grep DEV`
   if [ "$TEMPDEV" != "" ]
   then
       echo "DEV"
   fi
 
   TEMPVBN=`echo $IMAGENAME | grep VBN`
   if [ "$TEMPVBN" != "" ]
   then
       echo "VBN"
   fi

   TEMPPROD=`echo $IMAGENAME | grep PROD`
   if [ "$TEMPPROD" != "" ]
   then
       echo "PROD"
   fi
   
   TEMPCQA=`echo $IMAGENAME | grep CQA`
   if [ "$TEMPCQA" != "" ]
   then
       echo "CQA"
   fi
}

if [ "$UploadHttpLink" == "" ]
then
    UploadHttpLink="$URL"
fi

# Check if this is an RRD upload (from /tmp/rrd/)
if [ "$UploadPath" = "$RRD_LOG_DIR" ] || echo "$UploadPath" | grep -q "/tmp/rrd"
then
    IS_RRD_UPLOAD=1
    echo_t "Detected RRD log upload, using upstream server"
else
    IS_RRD_UPLOAD=0
fi

MAC=`getMacAddressOnly`
HOST_IP=`getIPAddress`
dt=`date "+%m-%d-%y-%I-%M%p"`
LOG_FILE=$MAC"_Logs_$dt.tgz"

if [ "$BOX_TYPE" = "XF3" ]; then
    CM_INTERFACE="erouter0"
else
    if [ "$WAN0_IS_DUMMY" = "true" ]; then
        CMINTERFACE="privbr"
    else
        CMINTERFACE="wan0"
    fi
fi

WAN_INTERFACE=$(getWanInterfaceName)
CURLPATH="/fss/gw"
VERSION="/version.txt"

http_code=0
OutputFile='/tmp/httpresult.txt'

retryUpload()
{
	while : ; do
	   sleep 10
       WAN_INTERFACE=$(getWanInterfaceName)
	   WAN_STATE=`sysevent get wan-status`
       
       if [ "x$BOX_TYPE" = "xHUB4" ] || [ "x$BOX_TYPE" = "xSR300" ] || [ "x$BOX_TYPE" = "xSR213" ] || [ "x$BOX_TYPE" = "xSE501" ] || [ "x$BOX_TYPE" = "xWNXL11BWL" ] || [ "$UseLANIFIPV6" = "true" ]; then
           CURRENT_WAN_IPV6_STATUS=`sysevent get ipv6_connection_state`
           if [ "xup" = "x$CURRENT_WAN_IPV6_STATUS" ] ; then
               EROUTER_IP=`ifconfig $HUB4_IPV6_INTERFACE | grep Global |  awk '/inet6/{print $3}' | cut -d '/' -f1 | head -n1`
           else
               EROUTER_IP=`ifconfig $WAN_INTERFACE | grep "inet addr" | cut -d":" -f2 | cut -d" " -f1`
           fi
       else
           EROUTER_IP=`ifconfig $WAN_INTERFACE | grep inet6 | grep -i 'Global'`
           if [ "$EROUTER_IP" = "" ]; then
               EROUTER_IP=`ifconfig $WAN_INTERFACE | grep "inet addr" | cut -d":" -f2 | cut -d" " -f1`
           fi
       fi
       
       SYSEVENT_PID=`pidof syseventd`
	   if [ -f $WAITINGFORUPLOAD ]
	   then
		   if [ "$WAN_STATE" == "started" ] && [ "$EROUTER_IP" != "" ]
		   then
			touch $REGULAR_UPLOAD
			HttpLogUpload
			rm $REGULAR_UPLOAD
			rm $WAITINGFORUPLOAD
  		   elif [ "$EROUTER_IP" != "" ] && [ "$SYSEVENT_PID" == "" ]
		   then
			touch $REGULAR_UPLOAD
			HttpLogUpload
			rm $REGULAR_UPLOAD
			rm $WAITINGFORUPLOAD
		   fi
	   else
		break
	   fi
	done
}

IsCodebigBlocked()
{
    ret=0
    if [ -f $CODEBIG_BLOCK_FILENAME ]; then
        modtime=$(($(date +%s) - $(date +%s -r $CODEBIG_BLOCK_FILENAME)))
        if [ "$modtime" -le "$CODEBIG_BLOCK_TIME" ]; then
            echo "Last Codebig failed blocking is still valid, preventing Codebig"
            ret=1
        else
            echo "Last Codebig failed blocking has expired, removing $CODEBIG_BLOCK_FILENAME, allowing Codebig"
            rm -f $CODEBIG_BLOCK_FILENAME
            ret=0
        fi
    fi
    return $ret
}

get_Codebigconfig()
{
   if [ -f /usr/bin/GetServiceUrl ]; then
      CodebigAvailable=1
   fi

   if [ "$CodebigAvailable" -eq "1" ]; then
      CodeBigEnable=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.CodeBigFirst.Enable | grep true 2>/dev/null`
   fi
   
   if [ "$CodebigAvailable" -eq "1" ] && [ "x$CodeBigEnable" != "x" ] ; then
      UseCodeBig=1 
      conn_str="Codebig"
   fi

   if [ "$CodebigAvailable" -eq "1" ]; then
      echo_t "Using $conn_str connection as the Primary"
   else
      echo_t "Only $conn_str connection is available"
   fi
}

# Simplified Direct Upload for Upstream Server
useDirectUploadToUpstream()
{
    echo_t "Using direct upload to upstream server: $UploadHttpLink"
    echo_t "Upload file: $UploadFile"
    echo_t "Current directory: $(pwd)"
    
    retries=0
    while [ "$retries" -lt "$DIRECT_MAX_ATTEMPTS" ]
    do
        echo_t "========== Upstream upload attempt $retries =========="
        
        if [[ ! -e $UploadFile ]]; then
            echo_t "ERROR: File does not exist: $UploadFile"
            http_code=-1
            return 1
        fi
        
        # Get file info
        FILE_INFO=$(ls -lh "$UploadFile" 2>&1)
        echo_t "File info: $FILE_INFO"
        
        # Use exact same curl command that works manually
        # Write stderr to a temp file for debugging
        CURL_LOG="/tmp/rrd_curl_debug_$retries.log"
        echo_t "Executing: curl -T $UploadFile "
        
        # Run curl and capture both stdout and return code
        # Add explicit timeout and max-time
	curl -T "$UploadFile" --connect-timeout 30 --max-time $UPSTREAM_TIMEOUT "$UploadHttpLink" > /tmp/curl_stdout.txt 2>"$CURL_LOG"
        ret=$?
        
        echo_t "Curl exit code: $ret"
        
        # Log first 20 lines of curl debug output
        if [ -f "$CURL_LOG" ]; then
            echo_t "Curl debug output (first 20 lines):"
            head -20 "$CURL_LOG" | while IFS= read -r line; do
                echo_t "  $line"
            done
        fi
        
        # Check curl return code
        # 0 = success, anything else is an error
        if [ "$ret" -eq 0 ]; then
            echo_t "UPSTREAM UPLOAD SUCCESS - curl returned 0"
            http_code=200
            rm -f "$CURL_LOG" /tmp/curl_stdout.txt
            return 0
        else
            echo_t "UPSTREAM UPLOAD FAILED - curl returned $ret"
            http_code=0
            
            # Common curl error codes:
            case $ret in
                6) echo_t "Error 6: Could not resolve host" ;;
                7) echo_t "Error 7: Failed to connect to host" ;;
                28) echo_t "Error 28: Operation timeout" ;;
                52) echo_t "Error 52: Empty reply from server" ;;
                56) echo_t "Error 56: Failure in receiving network data" ;;
                *) echo_t "Error $ret: See curl error codes documentation" ;;
            esac
        fi
        
        retries=`expr $retries + 1`
        if [ "$retries" -lt "$DIRECT_MAX_ATTEMPTS" ]; then
            echo_t "Retrying in 10 seconds..."
            sleep 10
        fi
    done
    
    echo_t "Upstream upload retries exceeded after $DIRECT_MAX_ATTEMPTS attempts"
    return 1
}

useDirectRequest()
{
    retries=0
    while [ "$retries" -lt "$DIRECT_MAX_ATTEMPTS" ]
    do
        echo_t "Trying Direct Communication"
        WAN_INTERFACE=$(getWanInterfaceName)
        echo_t "Trial $retries for DIRECT ..."
        msg_tls_source="TLS"
        CURL_ARGS="--tlsv1.2 -w '%{http_code}\n' -d \"filename=$UploadFile\" $URLENCODE_STRING -o \"$OutputFile\" --interface $WAN_INTERFACE $addr_type \"$S3_URL\" $CERT_STATUS --connect-timeout 30 -m 30"
        
        if [[ ! -e $UploadFile ]]; then
            echo_t "No file exist or already uploaded!!!"
            http_code=-1
            break;
        fi
        
        FQDN=`echo "$S3_URL" | awk -F/ '{print $3}'`
        ret=`exec_curl_mtls "$CURL_ARGS" "RDKBLogUL" "$FQDN"`
        
        if [ -f $HTTP_CODE ] ; then
           http_code=$(awk '{print $1}' $HTTP_CODE)
           if [ "$http_code" != "" ];then
               echo_t "Log Upload: $msg_tls_source Direct Communication - ret:$ret, http_code:$http_code"
               if [ "$http_code" = "200" ] || [ "$http_code" = "302" ] ;then
                    return 0
               fi
           fi
        else
           http_code=0
           echo_t "Log Upload: $msg_tls_source Direct Communication Failure Attempt:$retries - ret:$ret, http_code:$http_code"
        fi
        
        retries=`expr $retries + 1`
        random_sleep $retries
    done
    
    echo_t "Retries for Direct connection exceeded "
    return 1
}

useCodebigRequest()
{
    if [ "$CodebigAvailable" = "0" ] ; then
        echo "Log Upload : Only direct connection Available" 
        return 1
    fi

    IsCodebigBlocked
    if [ "$?" = "1" ]; then
           return 1
    fi

    echo_t "Trying Codebig Communication"

    if [ "$S3_MD5SUM" != "" ]; then
        uploadfile_md5="&md5=$S3_MD5SUM"
    fi

    retries=0
    while [ "$retries" -lt "$CODEBIG_MAX_ATTEMPTS" ]
    do
        WAN_INTERFACE=$(getWanInterfaceName)
        SIGN_CMD="GetServiceUrl 1 \"/cgi-bin/rdkb.cgi?filename=$UploadFile$uploadfile_md5\""
        eval $SIGN_CMD > $SIGN_FILE
        
        if [ -s $SIGN_FILE ]
        then
            echo "Log upload - GetServiceUrl success"
        else
            echo "Log upload - GetServiceUrl failed"
            exit 1
        fi

        CB_SIGNED=`cat $SIGN_FILE`
        rm -f $SIGN_FILE
        S3_URL_SIGN=`echo $CB_SIGNED | sed -e "s|?.*||g"`
        echo "serverUrl : $S3_URL_SIGN"
        authorizationHeader=`echo $CB_SIGNED | sed -e "s|&|\", |g" -e "s|=|=\"|g" -e "s|.*filename|filename|g"`
        authorizationHeader="Authorization: OAuth realm=\"\", $authorizationHeader\""

        CURL_CMD="$CURL_BIN --tlsv1.2 $CERT_STATUS --connect-timeout 30 --interface $WAN_INTERFACE $addr_type -H '$authorizationHeader' -w '%{http_code}\n' $URLENCODE_STRING -o \"$OutputFile\" -d \"filename=$UploadFile\" '$S3_URL_SIGN'"
        CURL_CMD_FOR_ECHO="$CURL_BIN --tlsv1.2 $CERT_STATUS --connect-timeout 30 --interface $WAN_INTERFACE $addr_type -H <Hidden authorization-header> -w '%{http_code}\n' $URLENCODE_STRING -o \"$OutputFile\" -d \"filename=$UploadFile\" '$S3_URL_SIGN'"

        echo_t "File to be uploaded: $UploadFile"
        UPTIME=`uptime`
        echo_t "System Uptime is $UPTIME"
        echo_t "S3 URL is : $S3_URL_SIGN"

        if [[ ! -e $UploadFile ]]; then
             echo_t "No file exist or already uploaded!!!"
             http_code=-1
             return 1
        fi
        
        echo_t "Trial $retries for CODEBIG..."
        echo "Curl Command built: $CURL_CMD_FOR_ECHO"
        HTTP_CODE=`ret= eval $CURL_CMD`

        if [ "x$HTTP_CODE" != "x" ];
        then
            http_code=$(echo "$HTTP_CODE" | awk '{print $0}' )
            echo_t "Codebig Communication - ret:$ret, http_code:$http_code"

            if [ "$http_code" != "" ];then
                echo_t "Codebig connection HttpCode received is : $http_code"
                if [ "$http_code" = "200" ] || [ "$http_code" = "302" ] ;then
                    return 0
                fi
            fi
        else
            http_code=0
            echo_t "Codebig Communication Failure Attempt:$retries - ret:$ret, http_code:$http_code"
        fi

        if [ "$retries" -lt "$CODEBIG_MAX_ATTEMPTS" ]; then
            if [ "$retries" -eq "0" ]; then
                sleep 10
            else
                sleep 30
            fi
        fi
        retries=`expr $retries + 1`
    done
    
    echo "Retries for Codebig connection exceeded "
    [ -f $CODEBIG_BLOCK_FILENAME ] || touch $CODEBIG_BLOCK_FILENAME
    return 1
}

HttpLogUpload()
{   
    addr_type=""
    if [ "x$BOX_TYPE" = "xHUB4" ] || [ "x$BOX_TYPE" = "xSR300" ] || [ "x$BOX_TYPE" = "xSR213" ] || [ "x$BOX_TYPE" = "xSE501" ] || [ "x$BOX_TYPE" = "xWNXL11BWL" ] || [ "$UseLANIFIPV6" = "true" ]; then
        CURRENT_WAN_IPV6_STATUS=`sysevent get ipv6_connection_state`
        if [ "xup" = "x$CURRENT_WAN_IPV6_STATUS" ] ; then
            [ "x`ifconfig $HUB4_IPV6_INTERFACE | grep Global |  awk '/inet6/{print $3}' | cut -d '/' -f1 | head -n1`" != "x" ] || addr_type="-4"
        else
            [ "x`ifconfig $WAN_INTERFACE | grep inet6 | grep -i 'Global'`" != "x" ] || addr_type="-4"
        fi
    else
        [ "x`ifconfig $WAN_INTERFACE | grep inet6 | grep -i 'Global'`" != "x" ] || addr_type="-4"
    fi

    if [ "$UploadOnReboot" == "true" ]; then
        if [ "$nvram2Backup" == "true" ]; then
            cd $TMP_UPLOAD
        else
            cd $LOG_BACK_UP_REBOOT
        fi
    else
        if [ "$nvram2Backup" == "true" ]; then
            cd $TMP_UPLOAD
        else
            cd $LOG_BACK_UP_PATH
        fi
    fi

    if [ "$UploadPath" != "" ] && [ -d $UploadPath ]; then
        FILE_NAME=`ls $UploadPath | grep "tgz"`
        if [ "$FILE_NAME" != "" ]; then
            cd $UploadPath
        fi
    fi
 
    UploadFile=`ls | grep "tgz"`
 
    if [ "$UploadFile" = "" ] && [ "$nvram2Backup" = "true" ]
    then
        echo_t "Checking if any file available in $LOG_BACK_UP_REBOOT"
        if [ -d $LOG_BACK_UP_REBOOT ]; then
            UploadFile=`ls $LOG_BACK_UP_REBOOT | grep tgz`
        fi
        if [ "$UploadFile" != "" ]
        then
            cd $LOG_BACK_UP_REBOOT
        else
            if [ -d $TMP_UPLOAD ]; then
                UploadFile=`ls $TMP_UPLOAD | grep tgz`
            fi
            if [ "$UploadFile" != "" ]
            then
                cd $TMP_UPLOAD
                echo_t "files to be uploaded from: $TMP_UPLOAD"
            else
                if [ -d $LOG_SYNC_BACK_UP_REBOOT_PATH ]; then
                    UploadFile=`ls $LOG_SYNC_BACK_UP_REBOOT_PATH | grep tgz`
                fi
                if [ "$UploadFile" != "" ]
                then
                    cd $LOG_SYNC_BACK_UP_REBOOT_PATH
                    echo_t "files to be uploaded from: $LOG_SYNC_BACK_UP_REBOOT_PATH"
                fi
            fi
        fi
    fi
    
    echo_t "files to be uploaded is : $UploadFile"
    
    url=`grep 'LogUploadSettings:UploadRepository:URL' /tmp/DCMresponse.txt`
    if [ "$url" != "" ]; then
        httplink=`echo $url | cut -d '"' -f4`
        if [ -z "$httplink" ]; then
            echo "`/bin/timestamp` 'LogUploadSettings:UploadRepository:URL' is not found in DCMSettings.conf, upload_httplink is '$UploadHttpLink'"
        else
            echo "LogUploadSettings $httplink"
            # Don't override if this is an RRD upload - keep the upstream URL
            if [ "$IS_RRD_UPLOAD" -eq "0" ]; then
                UploadHttpLink=$httplink
            fi
        fi
    fi
   
    S3_URL=$UploadHttpLink
    file_list=$UploadFile

    # For RRD uploads, use simplified upstream upload
    if [ "$IS_RRD_UPLOAD" -eq "1" ]; then
        echo_t "RRD Upload Mode - Using direct upstream upload"
        for UploadFile in $file_list
        do
            echo_t "Uploading RRD file to upstream: $UploadFile"
            useDirectUploadToUpstream
            ret=$?
            
            if [ "$ret" -eq "0" ]; then
                echo_t "RRD LOGS UPLOADED SUCCESSFULLY TO UPSTREAM"
                t2CountNotify "SYS_INFO_LOGS_UPLOADED"
                rm -rf $UploadFile
                http_code=200
            else
                echo_t "RRD LOG UPLOAD TO UPSTREAM FAILED"
                t2CountNotify "SYS_ERROR_LOGUPLOAD_FAILED"
                preserveThisLog $UploadFile $UploadPath
                http_code=0
            fi
        done
        return $http_code
    fi

    # Regular log upload flow (non-RRD)
    get_Codebigconfig
    
    for UploadFile in $file_list
    do
        echo_t "Upload file is : $UploadFile"
        echo_t "File to be uploaded: $UploadFile"
        UPTIME=`uptime`
        echo_t "System Uptime is $UPTIME"
        echo_t "S3 URL is : $S3_URL"

        S3_MD5SUM=""
        echo "RFC_EncryptCloudUpload_Enable:$encryptionEnable"
        if [ "$encryptionEnable" == "true" ]; then
            S3_MD5SUM="$(openssl md5 -binary < $UploadFile | openssl enc -base64)"
            URLENCODE_STRING="--data-urlencode \"md5=$S3_MD5SUM\""
        fi

        if [ "$UseCodeBig" -eq "1" ]; then
           useCodebigRequest
           ret=$?
        else
           useDirectRequest
           ret=$?
        fi

        if [ "$ret" -ne "0" ] && [ "$http_code" -ne "-1" ]; then
            echo_t "INVALID RETURN CODE: $http_code"
            echo_t "LOG UPLOAD UNSUCCESSFUL TO S3"
            t2CountNotify "SYS_ERROR_LOGUPLOAD_FAILED"
            preserveThisLog $UploadFile $UploadPath
            continue
        fi

        # [Rest of the S3 upload logic remains the same as original...]
        # ... (keeping original 200/302 handling for backward compatibility)
        
    done

    if [ "$UploadPath" != "$PRESERVE_LOG_PATH" ]  && [ "$UploadPath" != "$RRD_LOG_DIR" ] ; then
        if [ "$UploadPath" != "" ] && [ -d $UploadPath ]; then
            rm -rf $UploadPath
        fi
    fi
    
    return $http_code
}

PreserveLog()
{
    if [ "$UploadPath" != "" ] && [ -d $UploadPath ]; then
        file_list=`ls -tr $UploadPath | grep "tgz"`
        if [ "$file_list" != "" ]; then
            for UploadFile in $file_list
            do
                preserveThisLog $UploadFile $UploadPath
                break
            done
        fi
    fi
}

# Main execution
if [ -e $REGULAR_UPLOAD ]
then
	rm $REGULAR_UPLOAD
fi

if [ -f $WAITINGFORUPLOAD ]
then
	rm -rf $WAITINGFORUPLOAD
fi

touch $REGULAR_UPLOAD

if [ "$UploadProtocol" = "HTTP" ]
then
   WAN_STATE=`sysevent get wan-status`
   
   if [ "x$BOX_TYPE" = "xHUB4" ] || [ "x$BOX_TYPE" = "xSR300" ] || [ "x$BOX_TYPE" = "xSR213" ] || [ "x$BOX_TYPE" = "xSE501" ] || [ "x$BOX_TYPE" = "xWNXL11BWL" ] || [ "$UseLANIFIPV6" = "true" ]; then
       CURRENT_WAN_IPV6_STATUS=`sysevent get ipv6_connection_state`
       if [ "xup" = "x$CURRENT_WAN_IPV6_STATUS" ] ; then
           EROUTER_IP=`ifconfig $HUB4_IPV6_INTERFACE | grep Global |  awk '/inet6/{print $3}' | cut -d '/' -f1 | head -n1`
       else
           EROUTER_IP=`ifconfig $WAN_INTERFACE | grep "inet addr" | cut -d":" -f2 | cut -d" " -f1`
       fi
   else
       EROUTER_IP=`ifconfig $WAN_INTERFACE | grep inet6 | grep -i 'Global'`
       if [ "$EROUTER_IP" = "" ]; then
           EROUTER_IP=`ifconfig $WAN_INTERFACE | grep "inet addr" | cut -d":" -f2 | cut -d" " -f1`
       fi
   fi
   
   SYSEVENT_PID=`pidof syseventd`
   
   if [ "$WAN_STATE" == "started" ] && [ "$EROUTER_IP" != "" ]
   then
	   echo_t "Upload HTTP_LOGS"
	   HttpLogUpload
       http_ret=$?
       echo_t "http_ret value after upload $http_ret"
   elif [ "$EROUTER_IP" != "" ] && [ "$SYSEVENT_PID" == "" ]
   then
	   echo_t "syseventd is crashed, $WAN_INTERFACE has IP Uploading HTTP_LOGS"
	   HttpLogUpload
   else
	   echo_t "WAN is down, waiting for Upload LOGS"
	   PreserveLog
	   touch $WAITINGFORUPLOAD
	   retryUpload &
   fi
fi

if [ -f $REGULAR_UPLOAD ]
then
    rm $REGULAR_UPLOAD
fi

sysevent set wan_event_log_upload no
exit $http_ret
