SRC_URI_append = "${CMF_GITHUB_ROOT}/bananapi-sysint;protocol=https;nobranch=1;destsuffix=git/devicebpi;name=sysintdevicebpi"
SRCREV_sysintdevicebpi = "9c9644d7cdb8a50db53b69995d10729192991b21"
SRCREV_FORMAT = "1.0.0"

do_install_append () {
  #Webpa ServerURL
  echo "SERVERURL=https://webpa.rdkcentral.com:8080" >> ${D}${sysconfdir}/device.properties
  echo "Box_Type=bpi" >> ${D}${sysconfdir}/device.properties
  ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'echo "OneWiFiEnabled=true" >> ${D}${sysconfdir}/device.properties', '', d)}

   #self heal support
   rm -rf ${D}/usr/ccsp/tad
   install -d ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/corrective_action.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/self_heal_connectivity_test.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/resource_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/task_health_monitor.sh ${D}/usr/ccsp/tad

   # Changing CLOUDURL and DCM_LOG_SERVER_URL values with migrated server
   sed -i -e 's|^CLOUDURL=.*$|CLOUDURL="https://xconf.rdkcentral.com/xconf/swu/stb?eStbMac="|' ${D}${sysconfdir}/include.properties
   sed -i -e 's|^DCM_LOG_SERVER_URL=.*$|DCM_LOG_SERVER_URL=https://xconf.rdkcentral.com/loguploader/getSettings|' ${D}${sysconfdir}/dcm.properties
}
