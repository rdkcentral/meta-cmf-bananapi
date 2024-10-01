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

#TODO add it common config file
CURL_RESPONSE="/tmp/.cURLresponse"

source /etc/device.properties

if [ $DEVICE_TYPE == "broadband" ]; then

        LOG_PATH="/rdklogs/logs"
        CONSOLEFILE="$LOG_PATH/WEBCONFIGlog.txt.0"
        exec 3>&1 4>&2 >>$CONSOLEFILE 2>&1
fi

echo_t()
{
        echo "`date +"%y%m%d-%T.%6N"` $1"
}


	echo_t "WEBCONFIG: read file script is called"

	echo_t "WEBCONFIG: CURL_RESPONSE path is $CURL_RESPONSE"
	if [ -f $CURL_RESPONSE ]; then
		printf `cat $CURL_RESPONSE` 1>&3
	else
		printf "ERROR" 1>&3
	fi
