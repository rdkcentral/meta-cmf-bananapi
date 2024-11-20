SRC_URI_append = " \
    git://github.com/rdkcentral/bananapi-sysint.git;branch=develop;protocol=https;destsuffix=git/devicebpi;name=sysintdevicebpi \
"
SRCREV_sysintdevicebpi = "${AUTOREV}"
SRCREV_FORMAT = "sysintgeneric_sysintdevicebpi"


do_install_append () {
  #Webpa ServerURL
  echo "SERVERURL=http://webpa.rdkcentral.com:8080" >> ${D}${sysconfdir}/device.properties
  echo "Box_Type=bpi" >> ${D}${sysconfdir}/device.properties
  ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'echo "OneWiFiEnabled=true" >> ${D}${sysconfdir}/device.properties', '', d)}

   #self heal support
   rm -rf ${D}/usr/ccsp/tad
   install -d ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/corrective_action.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/self_heal_connectivity_test.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/resource_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/task_health_monitor.sh ${D}/usr/ccsp/tad
}
