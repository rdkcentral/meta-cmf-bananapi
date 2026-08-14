#components used in EasyMesh AP extender
RDEPENDS_packagegroup-ap-extender = "\
    ccsp-common-library \
    ccsp-common-startup \
    sysint-broadband \
    ccsp-one-wifi \
    telemetry \
    webconfig-framework \  
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
"
DEPENDS += " ccsp-common-library"
