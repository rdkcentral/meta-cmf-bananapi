#!/bin/bash
board="bpi-r4"
device="sdmmc"
OS="rdk-broadband-image"
IMGDIR=.
IMGNAME=${board}_${device}_${OS}
LDEV=`sudo losetup -f`
REALSIZE=7456
echo "create $IMGNAME.img"
dd if=/dev/zero of=$IMGDIR/$IMGNAME.img bs=1M count=$REALSIZE 1> /dev/null 2>&1
LDEV=`sudo losetup -f`
DEV=`echo $LDEV | cut -d "/" -f 3`     #mount image to loop device
echo "run losetup to assign image $IMGNAME.img to loopdev $LDEV ($DEV)"
sudo losetup $LDEV $IMGDIR/$IMGNAME.img 1> /dev/null #2>&1

bootstart=17408
bootsize=100
rootsize=6600
bootend=$(( ${bootstart}+(${bootsize}*1024*2)-1 ))
rootstart=$(( ${bootend}+1 ))
rootend=$(( ${rootstart} + (${rootsize}*1024*2) ))
sudo sgdisk -o ${LDEV}
sudo sgdisk -a 1 -n 1:34:8191 -A 1:set:2 -t 1:8300 -c 1:"bl2"           ${LDEV}
sudo sgdisk -a 1 -n 2:13312:17407 -A 2:set:63   -t 2:8300 -c 2:"fip"            ${LDEV}
sudo sgdisk -a 1024 -n 3:17408:${bootend}       -t 3:8300 -c 3:"boot"           ${LDEV}
sudo sgdisk -a 1024 -n 4:${rootstart}:${rootend} -t 4:8300 -c 4:"rootfs"        ${LDEV}

sudo losetup -d $LDEV
sudo losetup -P $LDEV $IMGDIR/$IMGNAME.img 1> /dev/null #2>&1
sudo dd if=atf/bpi-r4_sdmmc_bl2.img of=${LDEV}p1 conv=notrunc,fsync #1> /dev/null 2>&1
sudo dd if=atf/bpi-r4_sdmmc_fip.bin of=${LDEV}p2 conv=notrunc,fsync #1> /dev/null 2>&1
sudo mkfs.vfat "${LDEV}p3" -n BPI-BOOT #1> /dev/null 2>&1
sudo mkfs.ext4 -O ^metadata_csum,^64bit "${LDEV}p4" -L BPI-ROOT #1> /dev/null 2>&1
sudo mount "${LDEV}p3" /mnt/
sudo cp fitImage /mnt/
sudo cp mt7988a-bananapi-bpi-r4-sd.dtb /mnt/
sudo umount "${LDEV}p3"
sudo dd if=rdk-generic-broadband-image-bananapi4-rdk-broadband.ext4 of=${LDEV}p4
sudo losetup -d $LDEV
echo "packing image..."
gzip $IMGDIR/$IMGNAME.img
