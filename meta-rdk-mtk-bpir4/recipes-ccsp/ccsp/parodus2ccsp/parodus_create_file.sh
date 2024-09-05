#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2019 RDK Management
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

SER_NUM=$1
MAC=$2
TIMEOUT=30
#TODO add it common config file
CURL_RESPONSE="/tmp/.cURLresponse"
CERT_PATH="/etc/ssl/certs/ca-certificates.crt"
HTTP_CODE="/tmp/cfg_http_code"
CURL_FILE_RESPONSE="/tmp/adzvfchig-res.mch"
CONFIG_FILE="/usr/bin/GetConfigFile"
RDKSSACLI="/usr/bin/rdkssacli"
DEVICE_CERT="devicecert_1.pk12"
STATIC_CERT="/etc/ssl/certs/staticXpkiCrt.pk12"
XPKIEXTRACT="/tmp/.adzvfchigc1ssa"
CFG_IN="/tmp/.cfgStaticxpki"
STATICCPGCFG="/tmp/.staticCpgCfg"
OPENSSLCLI="/usr/bin/openssl"
CURRENT_INTERFACE="/etc/CURRENT_INTERFACE"

source /etc/device.properties
source /lib/rdk/getpartnerid.sh

echo_t()
{
        echo "`date +"%y%m%d-%T.%6N"` $1"
}

if [ $DEVICE_TYPE == "broadband" ]; then
		DEVICE_CERT_PATH=/nvram/certs
        LOG_PATH="/rdklogs/logs"
        CONSOLEFILE="$LOG_PATH/WEBCONFIGlog.txt.0"
        exec 3>&1 4>&2 >>$CONSOLEFILE 2>&1
elif [ $DEVICE_TYPE == "mediaclient" -o $DEVICE_TYPE == "hybrid" ]; then
		DEVICE_CERT_PATH=/opt/certs
else
		echo_t "WEBCONFIG: $DEVICE_CERT_PATH, not expected"
		DEVICE_CERT_PATH=/tmp/certs
fi

getCpgConfig()
{
	if [ -f $CONFIG_FILE ]; then
		$CONFIG_FILE $STATICCPGCFG
		mv $STATICCPGCFG $CURL_FILE_RESPONSE
		rm -f $STATICCPGCFG
	else
		echo_t "WEBCONFIG: No $CONFIG_FILE to fetch $STATICCPGCFG"
	fi
}

#cpu intensive routine hence reduce the usage
getDeviceConfigFile()
{
	if [ ! -f $CURL_FILE_RESPONSE ]; then
		if [ ! -f $OPENSSLCLI ]; then
			echo_t "WEBCONFIG: no openssl cli, use cpg config"
			getCpgConfig
			return
		fi

		if [ ! -f $DEVICE_CERT_PATH/$DEVICE_CERT ]; then 
			if [ -x /usr/bin/rdkssacertcheck.sh ]; then
				echo_t "WEBCONFIG: Procure xPki Cert"
				sh /usr/bin/rdkssacertcheck.sh nonotify
			fi
		fi

		if [ -f $DEVICE_CERT_PATH/$DEVICE_CERT ]; then
			if [ -f $RDKSSACLI ]; then
				openssl pkcs12 -nodes -password pass:$(xxxxxxxxxxxx) -in $DEVICE_CERT_PATH/$DEVICE_CERT -out $XPKIEXTRACT
				sed -n '/--BEGIN PRIVATE KEY--/,/--END PRIVATE KEY--/p; /--END PRIVATE KEY--/q' $XPKIEXTRACT  > $CURL_FILE_RESPONSE
				sed -n '/--BEGIN CERTIFICATE--/,/--END CERTIFICATE--/p; /--END CERTIFICATE--/q' $XPKIEXTRACT  >> $CURL_FILE_RESPONSE
				rm -f $XPKIEXTRACT
			else
				echo_t "WEBCONFIG: No $RDKSSACLI support "
			fi
		else
			echo_t "WEBCONFIG: No $DEVICE_CERT_PATH/$DEVICE_CERT using static cert"
			if [ -f $CONFIG_FILE ]; then
				$CONFIG_FILE $CFG_IN
				if [ -f $CFG_IN ]; then
					openssl pkcs12 -nodes -password pass:$(cat $CFG_IN) -in $STATIC_CERT -out $XPKIEXTRACT
					sed -n '/--BEGIN PRIVATE KEY--/,/--END PRIVATE KEY--/p; /--END PRIVATE KEY--/q' $XPKIEXTRACT  > $CURL_FILE_RESPONSE
					sed -n '/--BEGIN CERTIFICATE--/,/--END CERTIFICATE--/p; /--END CERTIFICATE--/q' $XPKIEXTRACT  >> $CURL_FILE_RESPONSE
					rm -f $XPKIEXTRACT
				else
					echo_t "WEBCONFIG: $CFG_IN not available"
				fi
			else
				echo_t "WEBCONFIG: No $CONFIG_FILE to fetch $CFG_IN"
			fi
		fi
	fi
}

runcURL()
{
		getDeviceConfigFile

		if [ -f $CURL_FILE_RESPONSE ]; then
			UUID=$(uuidgen -r)
			echo_t "WEBCONFIG: generated uuid is $UUID"
			echo_t "WEBCONFIG: MAC is $MAC"
			echo_t "WEBCONFIG: SER_NUM is $SER_NUM"
			echo_t "WEBCONFIG: Transaction-Id is $UUID"
			if [ -f $CURRENT_INTERFACE ]; then
				CURRENT_WAN_INTERFACE=`sysevent get current_wan_ifname`
				echo_t "WEBCONFIG: WEBCONFIG_CURRENT_INTERFACE is $CURRENT_WAN_INTERFACE"
			else	
			echo_t "WEBCONFIG: WEBCONFIG_INTERFACE is $WEBCONFIG_INTERFACE"
			fi
			PartnerId=$(getPartnerId)
			if [ "$PartnerId" == "" ] || [ "$PartnerId" == "unknown" ]; then
				PartnerId=""
			else
				PartnerId="*,$PartnerId"
			fi
			echo_t "WEBCONFIG: X-Midt-Partner-Id header is $PartnerId"
                        SERVER_URL=`psmcli get Device.X_RDKCENTRAL-COM_Webpa.TokenServer.URL` 
                        echo_t "WEBCONFIG: Server Url is $SERVER_URL"
                        
			retry_count=1
			while [ true ]
			do
				if [ "$CURRENT_WAN_INTERFACE" != "" ]; then
					CURL_TOKEN="curl -w '%{http_code}\n' --interface $CURRENT_WAN_INTERFACE --connect-timeout $TIMEOUT -m $TIMEOUT --output $CURL_RESPONSE -E $CURL_FILE_RESPONSE --header X-Midt-Mac-Address:\"$MAC\" --header X-Midt-Serial-Number:\"$SER_NUM\" --header X-Midt-Uuid:\"$UUID\" --header X-Midt-Transaction-Id:\"$UUID\" --header X-Midt-Partner-Id:\"$PartnerId\" $SERVER_URL"
				elif [ "$WEBCONFIG_INTERFACE" != "" ]; then
					CURL_TOKEN="curl -w '%{http_code}\n' --interface $WEBCONFIG_INTERFACE --connect-timeout $TIMEOUT -m $TIMEOUT --output $CURL_RESPONSE -E $CURL_FILE_RESPONSE --header X-Midt-Mac-Address:\"$MAC\" --header X-Midt-Serial-Number:\"$SER_NUM\" --header X-Midt-Uuid:\"$UUID\" --header X-Midt-Transaction-Id:\"$UUID\" --header X-Midt-Partner-Id:\"$PartnerId\" $SERVER_URL"
				else
					 CURL_TOKEN="curl -w '%{http_code}\n' --connect-timeout $TIMEOUT -m $TIMEOUT --output $CURL_RESPONSE -E $CURL_FILE_RESPONSE --header X-Midt-Mac-Address:\"$MAC\" --header X-Midt-Serial-Number:\"$SER_NUM\" --header X-Midt-Uuid:\"$UUID\" --header X-Midt-Transaction-Id:\"$UUID\" --header X-Midt-Partner-Id:\"$PartnerId\" $SERVER_URL"
				fi
				result= eval $CURL_TOKEN > $HTTP_CODE
				ret=$?
				sleep 1
				http_code=$(awk -F\" '{print $1}' $HTTP_CODE)
				echo_t "WEBCONFIG: ret = $ret http_code: $http_code"
				if [ $ret == 0 ] && [ $http_code == 200 ]; then
					echo_t "WEBCONFIG: cURL success."
					break;
				elif [ $retry_count == 3 ]; then
					echo_t "WEBCONFIG: Curl retry is reached to max 3 attempts, exiting the script."
					break;
				fi
				echo_t "WEBCONFIG: Curl execution is failed, retry attempt: $retry_count."
				retry_count=$((retry_count+1));
			done
			rm -f $HTTP_CODE
			#Check for cURL success and its response file
			if [ $http_code -eq 200 ] && [ -f $CURL_RESPONSE ]; then
						echo_t "WEBCONFIG: cURL success"
						echo_t "WEBCONFIG: File generated successfully"
						printf "SUCCESS" 1>&3
                        echo_t "WEBCONFIG: After update"
			else
				echo_t "WEBCONFIG: cURL request failed or it's response file not created "
			fi
		else
			echo_t "WEBCONFIG: Failure configuration file missing"
		fi
}

	runcURL
