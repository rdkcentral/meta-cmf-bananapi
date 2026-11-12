FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:kernel6-6 = " \
    ${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devicerpi;name=sysintdevicerpi \
"
SRC_URI:append:kernel6-6 = " \
    ${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=${BP}/devicerpi;name=sysintdevicerpi \
   ${CMF_GIT_ROOT}/rdkb/devices/intel-x86-pc/emulator/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=${BP}/device;name=sysintdevice \
"
SRC_URI:kernel6-6 = "${CMF_GITHUB_ROOT}/sysint-broadband;protocol=https;${BRANCH_sysint-broadband};name=sysintbroadband;destsuffix=${BP}"

SRC_URI:remove:kernel6-6 = "${CMF_GIT_ROOT}/rdkb/devices/intel-x86-pc/emulator/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/device;name=sysintdevice"

SRC_URI:append = "${CMF_GITHUB_ROOT}/bananapi-sysint;protocol=https;nobranch=1;destsuffix=${BP}/devicebpi;name=sysintdevicebpi"
SRCREV_sysintdevicebpi = "4ebc617660feedc84a184243167191ab7347814d"
SRCREV_FORMAT = "1.0.0"
S = "${UNPACKDIR}/${BP}"

SRC_URI:append = " \
   file://bpi_custom_device.properties \
   file://uploadRDKBLogs.sh \
 "
do_install:append () {
   install -m 644 ${UNPACKDIR}/bpi_custom_device.properties ${D}${sysconfdir}/device.properties
   ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'echo "OneWiFiEnabled=true" >> ${D}${sysconfdir}/device.properties', '', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'sed -i "s/eth0/brlan0/g" ${D}${base_libdir}/rdk/startSSH.sh', '', d)}
   #self heal support
   rm -rf ${D}/usr/ccsp/tad
   install -d ${D}/usr/ccsp/tad
   install -d ${D}${base_libdir}/rdk
   install -m 0755 ${S}/devicebpi/scripts/corrective_action.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/self_heal_connectivity_test.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/resource_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/task_health_monitor.sh ${D}/usr/ccsp/tad
   install -m 0755 ${S}/devicebpi/scripts/dca_utility.sh ${D}${base_libdir}/rdk
   install -m 0755 ${S}/devicebpi/scripts/DCMscript.sh ${D}${base_libdir}/rdk
   install -m 0755 ${S}/devicebpi/scripts/uploadSTBLogs.sh ${D}${base_libdir}/rdk
   install -m 0755 ${UNPACKDIR}/uploadRDKBLogs.sh ${D}/rdklogger/

   # Changing CLOUDURL and DCM_LOG_SERVER_URL values with migrated server
   sed -i -e 's|^CLOUDURL=.*$|CLOUDURL="https://xconf.rdkcentral.com/xconf/swu/stb?eStbMac="|' ${D}${sysconfdir}/include.properties
   sed -i -e 's|^DCM_LOG_SERVER_URL=.*$|DCM_LOG_SERVER_URL=https://xconf.rdkcentral.com/loguploader/getSettings|' ${D}${sysconfdir}/dcm.properties
   rm -f ${D}${systemd_unitdir}/system/swupdate.service
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm  ${D}${base_libdir}/rdk/bank_image_switch.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm  ${D}${base_libdir}/rdk/imageFlasher.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm  ${D}${base_libdir}/rdk/rpi_image_Flasher.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm  ${D}${base_libdir}/rdk/swupdate_utility.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm -f ${D}${base_libdir}/rdk/deviceInitiatedFWDnld.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm -f ${D}${base_libdir}/rdk/rpi_sw_install.sh', d)}
   ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', 'rm -f ${D}${base_libdir}/rdk/rpi_sw_install1.sh', d)}
}

SYSTEMD_SERVICE:${PN}:remove = "swupdate.service"
SYSTEMD_SERVICE:${PN}:remove:broadband:kernel6-12 = "${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', ' ','dropbear.service', d)}"
