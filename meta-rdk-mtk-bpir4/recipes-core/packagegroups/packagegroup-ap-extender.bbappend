#components used in EasyMesh AP extender
RDEPENDS_packagegroup-ap-extender = "\
    ccsp-common-library \
    ccsp-common-startup \
    sysint-broadband \
    ccsp-one-wifi \
    rbus \
    ccsp-gwprovapp \
    ccsp-cr \
    ccsp-cr-ccsp \
    unified-wifi-mesh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap','ieee1905-em ','',d)} \
    bpi-macaddress \
    bpi-serialnumber \
    mount-nvram \
    e2fsprogs-mke2fs \
    rdk-fwupgrade-manager \
    hal-fwupgrade \
    ccsp-dmcli \
    ccsp-dmcli-ccsp \
"
DEPENDS += " ccsp-common-library"
