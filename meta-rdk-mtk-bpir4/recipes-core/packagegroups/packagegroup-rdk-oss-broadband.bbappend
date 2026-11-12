RDEPENDS:packagegroup-rdk-oss-broadband:append = " \
      evtest \
"
RDEPENDS:packagegroup-rdk-oss-broadband:remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'Core-RDKB', 'net-snmp lighttpd ', '', d)}"
