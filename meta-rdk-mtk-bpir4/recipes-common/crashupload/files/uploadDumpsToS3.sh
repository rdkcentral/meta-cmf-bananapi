#!/bin/busybox sh
##########################################################################
# If not stated otherwise in this file or this component's LICENSE
# file the following copyright and licenses apply:
#
# Copyright 2024 Comcast Cable Communications Management, LLC
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
#

S3BUCKET="ccp-stbcrashes"
s3bucketurl="s3.amazonaws.com"
POTOMAC_USER=ccpstbscp

logMessage()
{
    message="$1"
    if [ "$DEVICE_TYPE" = "extender" ];then
        CORE_LOG="/var/log/messages"
        POD_TIMESTAMP=$(date +"%b %d %H:%M:%S")
        echo "$POD_TIMESTAMP CRASH_UPLOAD[$$]: $message" >> $CORE_LOG
    else
        echo "`/bin/timestamp` [CRASH_UPLOAD] [PID:$$]: $message" >> $CORE_LOG
    fi
}

if [ "$DEVICE_TYPE" = "broadband" ];then
     PORTAL_URL="rdkbcrashportal.stb.r53.xcal.tv"
     REQUEST_TYPE=18
elif [ "$DEVICE_TYPE" = "mediaclient" ]; then
     PORTAL_URL=$(tr181 -g Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.CrashUpload.crashPortalSTBUrl 2>&1)
     if [ -z "$PORTAL_URL" ]; then
         PORTAL_URL="crashportal.stb.r53.xcal.tv"
     fi
     REQUEST_TYPE=17
fi

encryptionEnable=false
if [ "$DEVICE_TYPE" == "broadband" ]; then
    #we are swaping dmcli and syscfg because dmcli will not work once rbus is down
    logMessage "Checking for Encryption Support through syscfg"
    encryptionEnable=`syscfg get encryptcloudupload`
    if [ "$encryptionEnable" = "" -a "$BOX_TYPE" = "XB3" ]; then
        logMessage "syscfg value got null, it may be due to calling script from atom side"
        encryptionEnable=`rpcclient $ARM_ARPING_IP "syscfg get encryptcloudupload" | cut -d$'\n' -f4`
        if [ "$encryptionEnable" = "" ];then
            logMessage "Checking for Encryption Support through dmcli"
            encryptionEnable=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.EncryptCloudUpload.Enable | grep value`
            encryptionEnable=`echo $encryptionEnable | cut -d ":" -f 3 | tr -d ' '`
        fi
    fi
elif [ "$DEVICE_TYPE" = "mediaclient" ]; then
    encryptionEnable=`tr181Set Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.EncryptCloudUpload.Enable 2>&1 > /dev/null`
fi

if [ -f /lib/rdk/t2Shared_api.sh ]; then
    source /lib/rdk/t2Shared_api.sh
    IS_T2_ENABLED="true"
fi

if [ -f $RDK_PATH/exec_curl_mtls.sh ]; then
    source $RDK_PATH/exec_curl_mtls.sh
fi

if [ -f /lib/rdk/getSecureDumpStatus.sh ];then
    . /lib/rdk/getSecureDumpStatus.sh
fi

read_httpcode_file()
{
    IFS=" " read -r http_code server_ip port_num < /tmp/httpcode
}

uploadToS3()
{
    URLENCODE_STRING=""
    local file=$(basename $1)
    local WORKING_DIR=$(cat /tmp/uploadtos3params | cut -d ' ' -f 1)
    local partnerId=$(cat /tmp/uploadtos3params | cut -d ' ' -f 2)
    local DUMP_NAME=$(cat /tmp/uploadtos3params | cut -d ' ' -f 3)
    local DEVICE_TYPE=$(cat /tmp/uploadtos3params | cut -d ' ' -f 4)
    local VERSION_FILE=$(cat /tmp/uploadtos3params | cut -d ' ' -f 5)
    local encryptionEnable=$(cat /tmp/uploadtos3params | cut -d ' ' -f 6)
    local EnableOCSPStapling=$(cat /tmp/uploadtos3params | cut -d ' ' -f 7)
    local EnableOCSP=$(cat /tmp/uploadtos3params | cut -d ' ' -f 8)
    local TLS=$(cat /tmp/uploadtos3params | cut -d ' ' -f 9)
    local BUILD_TYPE=$(cat /tmp/uploadtos3params | cut -d ' ' -f 10)
    local modNum=$(cat /tmp/uploadtos3params | cut -d ' ' -f 11)
    local CURL_LOG_OPTION=$(cat /tmp/uploadtos3params | cut -d ' ' -f 12)

    local count=`find "$WORKING_DIR" -name "$file" | wc -l`
    if [ $count -eq 0 ]; then logMessage "DEBUG_ERROR:UPLOAD_FAILED:No ${file} for uploading In Dir:${WORKING_DIR}" ; exit 0; fi

    logMessage "DEBUG Original File Name : $file"
    logMessage "DEBUG Value Required for Check : ${file:0:3}"
    logMessage "uploadToS3 $1 and partnerId=$partnerId"
    
    if [ "${file:0:3}" = "mac" ]; then
        # Update upload time to corefile from uploadToS3 function.
        corefiletime=`echo $file | awk -F '_' '{print substr($2,4)}'`
        logMessage "DEBUG $DUMP_NAME file timestamp (2,4) received to uploadToS3: $corefiletime"
    else
        # Update upload time to corefile from uploadToS3 function.
        corefiletime=`echo $file | awk -F '_' '{print substr($3,4)}'`
        logMessage "DEBUG $DUMP_NAME file timestamp (3,4) received to uploadToS3: $corefiletime"
    fi

    uploadcurtime=`date +%Y-%m-%d-%H-%M-%S`
    logMessage "$DUMP_NAME file timestamp before upload: $uploadcurtime"
    
    updatedfile=`echo $file | sed "s/$corefiletime/$uploadcurtime/g"`
    logMessage "DEBUG $DUMP_NAME file to be uploaded: `echo $updatedfile`"
    
    if [ -f $WORKING_DIR"/"$file ]; then
        logMessage "DEBUG Renaming the $DUMP_NAME file under $WORKING_DIR"
        logMessage "DEBUG mv $WORKING_DIR"/"$file $WORKING_DIR"/"$updatedfile"
        mv $WORKING_DIR"/"$file $WORKING_DIR"/"$updatedfile
        S3_FILENAME=$updatedfile
        logMessage "DEBUG S3 File Name : $S3_FILENAME"
    else
        logMessage "$DUMP_NAME file: $file not found under $WORKING_DIR folder..!!!"
    fi
    
    local count=`find "$WORKING_DIR" -name "$S3_FILENAME" | wc -l`
    if [ $count -eq 0 ]; then logMessage "DEBUG_ERROR:UPLOAD_FAILED:No ${S3_FILENAME} for uploading In Dir:${WORKING_DIR}" ; exit 0; fi

    local app=${updatedfile%%.signal*}
    #get signed parameters from server
    local OIFS=$IFS
    IFS=$'\n'
    
    if [ "$DEVICE_TYPE" = "extender" ];then
        logMessage "S3_AMAZON_SIGNING_URL $S3_AMAZON_SIGNING_URL"
    elif [ "$DEVICE_TYPE" != "broadband" ]; then
        S3_AMAZON_SIGNING_URL=$(tr181 -g Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.CrashUpload.S3SigningUrl 2>&1)
        if [ -z "$S3_AMAZON_SIGNING_URL" ];then
            . /etc/device.properties
        fi
    elif [ "$DEVICE_TYPE" = "broadband" ]; then
        dml_url="$(dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.CrashPortal | grep string | cut -d":" -f3- | cut -d" " -f2- | tr -d ' ')"
        if [ "$dml_url" != "" ]
        then
           S3_AMAZON_SIGNING_URL=$dml_url
        else
           if [ "$partnerId" = "sky-uk" ]
           then
               S3_AMAZON_SIGNING_URL="$S3_AMAZON_SIGNING_URL_EU"
           fi
        fi
    fi
    
    logMessage "[$0]: S3 Amazon Signing URL: $S3_AMAZON_SIGNING_URL"   
    CurrentVersion=`tar -zxf $updatedfile version.txt -O | grep "imagename" | cut -d':' -f2`
    if [ -z "$CurrentVersion" ];then
        CurrentVersion=`grep imagename /$VERSION_FILE | cut -d':' -f2`
        logMessage "Sending current image"
    fi

    IF_OPTION=""
    if [ "$DEVICE_TYPE" = "broadband" ] && [ "$MULTI_CORE" = "yes" ];then
        core_output=`get_core_value`
        if [ "$core_output" = "ARM" ];then 
              IF_OPTION="$ARM_INTERFACE"
        fi
    elif [ "$DEVICE_TYPE" = "extender" ]; then
        ARM_INTERFACE=$(getWanInterfaceName)
        IF_OPTION="$ARM_INTERFACE"
    fi

    logMessage "RFC_EncryptCloudUpload_Enable:$encryptionEnable"
    if [ "$encryptionEnable" == "true" ]; then
        S3_MD5SUM="$(openssl md5 -binary < $updatedfile | openssl enc -base64)"
        URLENCODE_STRING="--data-urlencode \"md5=$S3_MD5SUM\""
    fi
    crashportalEndpointUrl=""
    logMessage "$DEVICE_TYPE/$MODEL_NUM MTLS Crashdump upload"
    if [ "$DEVICE_TYPE" = "hybrid" ] || [ "$DEVICE_TYPE" = "mediaclient" ]; then
        crashportalEndpointUrl=$(tr181Set Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.CrashportalEndpoint.URL 2>&1 > /dev/null)
    fi
    if [ "$crashportalEndpointUrl" ]; then
        S3_AMAZON_SIGNING_URL="$crashportalEndpointUrl"
        logMessage "Overriding the S3 Amazon SIgning URL: $S3_AMAZON_SIGNING_URL"
    fi
    if [ "$DEVICE_TYPE" = "broadband" ]; then
        URL=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.CrashUpload.S3SigningUrl |grep value | awk '{print $5}'`
        if [ "$URL" ]; then
            S3_AMAZON_SIGNING_URL="$URL"
            logMessage "Overriding the S3 Amazon SIgning URL: $S3_AMAZON_SIGNING_URL"
        fi
    fi

    if [ ! -f /etc/ssl/certs/cpe-clnt.xcal.tv.cert.pem ]; then
        logMessage "Using Xpki cert for CrashdumpUpload"
    fi

    signed_url_file="/tmp/signed_url_$$"
    if [ ! -z "$IF_OPTION" ]; then
        if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
            CURL_ARGS="-s $TLS --interface $IF_OPTION --cert-status -o $signed_url_file -w \"%{http_code} ${CURL_LOG_OPTION}\" --data-urlencode "filename=\"$updatedfile\""\
                                             --data-urlencode "firmwareVersion=$CurrentVersion"\
                                             --data-urlencode "env=$BUILD_TYPE"\
                                             --data-urlencode "model=$modNum"\
                                             --data-urlencode "type=$DUMP_NAME" \
                                             $URLENCODE_STRING\
                                             "$S3_AMAZON_SIGNING_URL""
        else
            CURL_ARGS="-s $TLS --interface $IF_OPTION -o $signed_url_file -w \"%{http_code} ${CURL_LOG_OPTION}\" --data-urlencode "filename=\"$updatedfile\""\
                                             --data-urlencode "firmwareVersion=$CurrentVersion"\
                                             --data-urlencode "env=$BUILD_TYPE"\
                                             --data-urlencode "model=$modNum"\
                                             --data-urlencode "type=$DUMP_NAME" \
                                             $URLENCODE_STRING\
                                             "$S3_AMAZON_SIGNING_URL""
        fi
    else
        CURL_ARGS="-s $TLS -o $signed_url_file -w \"%{http_code} ${CURL_LOG_OPTION}\" --data-urlencode "filename=\"$updatedfile\""\
                --data-urlencode "firmwareVersion=$CurrentVersion"\
                --data-urlencode "env=$BUILD_TYPE"\
                --data-urlencode "model=$modNum"\
                --data-urlencode "type=$DUMP_NAME" \
                $URLENCODE_STRING\
                "$S3_AMAZON_SIGNING_URL""

        if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
            CURL_ARGS="$CURL_ARGS --cert-status"
        fi
    fi
    FQDN=`echo "$S3_AMAZON_SIGNING_URL" | awk -F/ '{print $3}'`
    if [ "$DEVICE_TYPE" = "broadband" ] || [ "$DEVICE_TYPE" = "extender" ]; then
        local ec=` exec_curl_mtls "$CURL_ARGS" "DumpUL" "$FQDN"`
    elif [ "$DEVICE_TYPE" = "mediaclient" ]; then
        ec=` exec_curl_mtls "$CURL_ARGS" "logMessage"`
    else
        logMessage "Unknown device"
        echo "[ERROR] Unknown DEVICE_TYPE: $DEVICE_TYPE"
        ec=1
    fi

    if [ "$DEVICE_TYPE" != "broadband" ]; then
        read_httpcode_file
        logMessage "Curl Connected to $FQDN ($server_ip) port $port_num"
        logMessage "[$0]: Curl return code : $ec, HTTP SIGN URL Response: $http_code"
        if [ "$IS_T2_ENABLED" == "true" ]; then
            t2ValNotify "coreUpld_split" "$ec, $http_code"
        fi
    else
        http_code=$(awk '{print $1}' $HTTP_CODE)
        logMessage "[$0]: Execution Status: $ec, HTTP SIGN URL Response: $http_code"
    fi

    case $ec in
        35|51|53|54|58|59|60|64|66|77|80|82|83|90|91)
            if [ "$DEVICE_TYPE" != "broadband" ]; then
                tlsLog "CERTERR, DumpUL, $ec, $FQDN"
                t2ValNotify "certerr_split" "DumpUL, $ec, $FQDN"
            fi
            ;;
    esac
    IFS=$OIFS
    if [ $ec -eq 0 ]; then
        if [ -z "$1" ]; then
            ec=1
            logMessage "[$0]: S3 Amazon Signing Request Failed..!"
            if [ "$IS_T2_ENABLED" == "true" ]; then
                t2CountNotify "SYST_ERR_S3signing_failed"
            fi
        else
            #make params shell-safe
            local validDate=`sanitize "$updatedfile"`
            local auth=`sanitize "$2"`
            local remotePath=`sanitize "$3"`
            logMessage "Safe params: $validDate -- $auth -- $remotePath"
            tlsMessage="with TLS1.2"
            logMessage "Attempting TLS1.2 connection to Amazon S3"
            S3_URL=$(cat $signed_url_file)

            if [ "$encryptionEnable" != "true" ]; then
                S3_URL=\"$S3_URL\"
            fi
            if [ "$DEVICE_TYPE" = "broadband" ] && [ "$MULTI_CORE" = "yes" ];then
                core_output=`get_core_value`
                if [ "$core_output" = "ARM" ];then
                    if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
                        CURL_ARGS="-v -fgL --tlsv1.2 --cert-status --interface $ARM_INTERFACE -T \"$updatedfile\" -w \"%{http_code}\" $S3_URL"
                    else
                        CURL_ARGS="-v -fgL --tlsv1.2 --interface $ARM_INTERFACE -T \"$updatedfile\" -w \"%{http_code}\" $S3_URL"
                    fi
                else
                    if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
                        CURL_ARGS="-v -fgL --tlsv1.2 --cert-status -T \"$updatedfile\" -w \"%{http_code}\" $S3_URL"
                    else
                        CURL_ARGS="-v -fgL --tlsv1.2 -T \"$updatedfile\" -w \"%{http_code}\" $S3_URL"
                    fi
                fi
            else
                CURL_ARGS="-v -fgL $TLS -T \"$updatedfile\" -w \"%{http_code} ${CURL_LOG_OPTION}\" $S3_URL"
                if [ -f $EnableOCSPStapling ] || [ -f $EnableOCSP ]; then
                    CURL_ARGS="$CURL_ARGS --cert-status"
                fi
            fi

            fqdn=`echo "$S3_URL" | awk -F/ '{print $3}'`
            if [ "$DEVICE_TYPE" = "broadband" ] || [ "$DEVICE_TYPE" = "extender" ]; then
                ec=` exec_curl_mtls "$CURL_ARGS" "DumpUL" "$fqdn"`
            elif [ "$DEVICE_TYPE" = "mediaclient" ]; then
                ec=` exec_curl_mtls "$CURL_ARGS" "logMessage"`
            else
                echo "[ERROR] Unknown DEVICE_TYPE: $DEVICE_TYPE"
                ec=1
            fi

            if [ "$DEVICE_TYPE" != "broadband" ]; then
                read_httpcode_file
                logMessage "Curl Connected to $fqdn ($server_ip) port $port_num"
                logMessage "Curl return code: $ec HTTP Response code: $http_code"
            else
                http_code=$(awk '{print $1}' $HTTP_CODE)
                logMessage "Execution Status:$ec HTTP Response code: $http_code "
            fi

            case $ec in
                35|51|53|54|58|59|60|64|66|77|80|82|83|90|91)
                  if [ "$DEVICE_TYPE" != "broadband" ]; then
                      tlsLog "CERTERR, DumpUL, $ec, $fqdn"
                      t2ValNotify "certerr_split" "DumpUL, $ec, $fqdn"
                  fi
                  ;;
            esac
            rm $signed_url_file
        fi
    fi
    if [ $ec -ne 0 ]; then
        logMessage "Curl finished unsuccessfully! Error code: $ec"
        if [ "$IS_T2_ENABLED" == "true" ]; then
            t2CountNotify "SYS_ERROR_S3CoreUpload_Failed"
            if [ "$ec" -eq 6 ]; then
                 t2CountNotify "SYST_INFO_CURL6"
            fi
            t2CountNotify "SYS_ERR_CoreUpload_Curl${ec}"
            t2ValNotify "CoredumpFail_split" ${ec}
        fi
     else
        logMessage "S3 ${DUMP_NAME} Upload is successful $tlsMessage"
        if [ "$IS_T2_ENABLED" == "true" ]; then
            t2CountNotify "SYS_INFO_S3CoreUploaded"
        fi
        #Removing updated timestamp minidump/coredump file since processDumps func will remove old timestamp minidump/coredump file.
        logMessage "Removing uploaded $DUMP_NAME file $updatedfile"
        rm -rf $updatedfile
     fi
    return $ec
}
