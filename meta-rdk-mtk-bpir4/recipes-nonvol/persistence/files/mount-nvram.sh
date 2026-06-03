#!/bin/bash

# If not stated otherwise in this file or this component's LICENSE
# file the following copyright and licenses apply:
#
#Copyright [2026] [RDK Management]
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

blkid_output=$(blkid /dev/mmcblk0p9 | grep 'TYPE="ext4"')

echo "blkid_output:$blkid_output" >>/tmp/mount-nvram.log
if [ -z "$blkid_output" ]; then
echo "First boot after flashing SD card -- nvram partition is not formatted." >>/tmp/mount-nvram.log
echo "Formatting nvram partition." >>/tmp/mount-nvram.log
mkfs.ext4 -F /dev/mmcblk0p9
else
echo "Nvram partition already formatted." >>/tmp/mount-nvram.log
fi

mkdir -p /nvram
mount /dev/mmcblk0p9 /nvram
if [ "$?" != "0" ]; then
echo "Mounting nvram partition failed." >>/tmp/mount-nvram.log
fi
mkdir -p /nvram/secure
# OneWifi DB stored under /opt/secure/wifi
mkdir -p /opt/secure
mount --bind /nvram /opt/secure
# MariaDB stored under /var/lib/mysql
if [ -f /lib/systemd/system/mysqld.service ] ; then
mkdir -p /nvram/mysql
mkdir -p /var/lib/mysql
mount --bind /nvram/mysql /var/lib/mysql
chown mysql:mysql /var/lib/mysql
if [ ! -d /var/lib/mysql/mysql ]; then
echo "First boot: initializing MariaDB system tables..." >>/tmp/mount-nvram.log
/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm
chown -R mysql:mysql /var/lib/mysql
else
echo "Already MariaDB has been initialized " >> /tmp/mount-nvram.log
fi
fi
exit 0
