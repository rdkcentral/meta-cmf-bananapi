#!/bin/bash

LOOP=1
while [ "36" -gt "$LOOP" ] ; do
   if [ `idevice_id -l 2>/dev/null | wc -l` == 1 ]; then
      if [ `cat /sys/class/net/eth0/carrier` == 1 ]; then
         echo "breaking..."
         break
      fi
      idevicepair validate
   fi
   sleep 5
   LOOP=`expr $LOOP + 1`
done
