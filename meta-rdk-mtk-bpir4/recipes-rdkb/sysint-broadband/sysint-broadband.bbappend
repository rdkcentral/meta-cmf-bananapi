FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "${CMF_GITHUB_ROOT}/bananapi-sysint;protocol=https;nobranch=1;destsuffix=git/devicebpi;name=sysintdevicebpi"
SRCREV_sysintdevicebpi = "9c9644d7cdb8a50db53b69995d10729192991b21"
SRCREV_FORMAT = "1.0.0"

SRC_URI += "file://bpi_custom_device.properties \
            file://uploadRDKBLogs.sh \
"

do_install_append () {
   install -m 644 ${WORKDIR}/bpi_custom_device.properties ${D}${sysconfdir}/device.properties
   ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'echo "OneWiFiEnabled=true" >> ${D}${sysconfdir}/device.properties', '', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'sed -i "s/eth0/brlan0/g" ${D}/lib/rdk/startSSH.sh', '', d)}

   #self heal support
   rm -rf ${D}/usr/ccsp/tad
   install -d ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/corrective_action.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/self_heal_connectivity_test.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/resource_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/task_health_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${WORKDIR}/uploadRDKBLogs.sh ${D}/rdklogger/

   # Changing CLOUDURL and DCM_LOG_SERVER_URL values with migrated server
   sed -i -e 's|^CLOUDURL=.*$|CLOUDURL="https://xconf.rdkcentral.com/xconf/swu/stb?eStbMac="|' ${D}${sysconfdir}/include.properties
   sed -i -e 's|^DCM_LOG_SERVER_URL=.*$|DCM_LOG_SERVER_URL=https://xconf.rdkcentral.com/loguploader/getSettings|' ${D}${sysconfdir}/dcm.properties
   rm -f ${D}${systemd_unitdir}/system/swupdate.service
   rm  ${D}${base_libdir}/rdk/bank_image_switch.sh
   rm  ${D}${base_libdir}/rdk/imageFlasher.sh
   rm  ${D}${base_libdir}/rdk/rpi_image_Flasher.sh
   rm  ${D}${base_libdir}/rdk/swupdate_utility.sh
   rm -f ${D}${base_libdir}/rdk/deviceInitiatedFWDnld.sh
   rm -f ${D}${base_libdir}/rdk/rpi_sw_install.sh
   rm -f ${D}${base_libdir}/rdk/rpi_sw_install1.sh
}

SYSTEMD_SERVICE:${PN}:remove = "swupdate.service"
