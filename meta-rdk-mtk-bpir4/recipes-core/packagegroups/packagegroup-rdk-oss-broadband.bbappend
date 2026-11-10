RDEPENDS_packagegroup-rdk-oss-broadband_append = " \
      evtest \
"
RDEPENDS_packagegroup-rdk-oss-broadband_remove += " ${@bb.utils.contains('DISTRO_FEATURES', 'Core-RDKB', 'net-snmp lighttpd ', '', d)}"
