RDEPENDS_packagegroup-rdk-oss-broadband_append = " \
      evtest \
"

# When Core=1: Drop net-snmp/lighttpd/rdk-oss-ssa unless an enabled optional component installs them
RDEPENDS_packagegroup-rdk-oss-broadband:remove = "${@' '.join(pkg for pkg in ['net-snmp', 'net-snmp-client', 'net-snmp-server', 'net-snmp-mibs', 'net-snmp-server-snmpd', 'lighttpd', 'rdk-oss-ssa'] if bb.utils.contains('DISTRO_FEATURES', 'Core-RDKB', True, False, d) and pkg not in d.getVar('RDKB_OPT_PKGS_ENABLED').split())}"
