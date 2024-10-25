include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/files:"
SRC_URI_append = " \
                   file://gwprovapp.conf \
                "
CFLAGS_aarch64_append = " -Werror=format-truncation=1 "

do_install_append_class-target() {
   sed -i 's#${PARODUS_START_LOG_FILE}#/rdklogs/logs/dcmrfc.log#g' ${D}${systemd_unitdir}/system/rfc.service
   sed -i 's/rfc.service /RFCbase.sh /g' ${D}${systemd_unitdir}/system/rfc.service

   DISTRO_OneWiFi_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','OneWifi','true','false',d)}"
   if [ $DISTRO_OneWiFi_ENABLED = 'true' ]; then
        install -D -m 0644 ${S}/systemd_units/onewifi.service ${D}${systemd_unitdir}/system/onewifi.service
        sed -i "s/Unit=ccspwifiagent.service/Unit=onewifi.service/g"  ${D}${systemd_unitdir}/system/filogicwifiinitialized.path
        sed -i "/OSW_DRV_TARGET_DISABLED=1/a ExecStartPre=\/bin\/sh \/usr\/ccsp\/wifi\/onewifi_pre_start.sh"  ${D}${systemd_unitdir}/system/onewifi.service
        rm ${D}${systemd_unitdir}/system/ccspwifiagent.service
   fi
   sed -i "s/wan-initialized.target/multi-user.target/g" ${D}${systemd_unitdir}/system/rfc.service

   if ${@bb.utils.contains('DISTRO_FEATURES', 'webconfig_bin', 'true', 'false', d)}; then
        install -D -m 0644 ${S}/systemd_units/webconfig.service ${D}${systemd_unitdir}/system/webconfig.service
   fi
   install -D -m 0644 ${S}/systemd_units/wan-initialized.target ${D}${systemd_unitdir}/system/wan-initialized.target
   install -D -m 0644 ${S}/systemd_units/wan-initialized.path ${D}${systemd_unitdir}/system/wan-initialized.path
   sed -i "s/CcspCrSsp.service CcspPandMSsp.service/CcspCrSsp.service RdkWanManager.service/g" ${D}${systemd_unitdir}/system/CcspEthAgent.service
   DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
   if [ $DISTRO_WAN_ENABLED = 'true' ]; then
       sed -i "s/After=CcspCrSsp.service utopia.service PsmSsp.service CcspEthAgent.service/After=CcspCrSsp.service PsmSsp.service/g" ${D}${systemd_unitdir}/system/RdkWanManager.service
    fi
    #Telemetry support
   install -D -m 0644 ${S}/systemd_units/CcspTelemetry.service ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "/Type=oneshot/a EnvironmentFile=\/etc/\device.properties" ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "/EnvironmentFile=\/etc\/device.properties/a EnvironmentFile=\/etc\/dcm.properties" ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "/EnvironmentFile=\/etc\/dcm.properties/a ExecStartPre=\/bin\/sh -c '\/bin\/touch \/rdklogs\/logs\/dcmscript.log'" ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "s/ExecStart=\/bin\/sh -c '\/lib\/rdk\/dcm.service \&'/ExecStart=\/bin\/sh -c '\/lib\/rdk\/StartDCM.sh \>\> \/rdklogs\/logs\/telemetry.log \&'/g" ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "s/wan-initialized.target/multi-user.target/g" ${D}${systemd_unitdir}/system/CcspTelemetry.service
   sed -i "s/wan-initialized.target/multi-user.target/g" ${D}${systemd_unitdir}/system/webconfig.service

   install -D -m 0644 ${S}/systemd_units/notifyComp.service ${D}${systemd_unitdir}/system/notifyComp.service
   install -D -m 0644 ${S}/systemd_units/gwprovapp.service ${D}${systemd_unitdir}/system/gwprovapp.service
   sed -i "s/After=securemount.service/After=PsmSsp.service/g" ${D}${systemd_unitdir}/system/gwprovapp.service
   install -D -m 0644 ${WORKDIR}/gwprovapp.conf ${D}${systemd_unitdir}/system/gwprovapp.service.d/gwprovapp.conf
   rm ${D}${systemd_unitdir}/system/utopia.service


}


SYSTEMD_SERVICE_${PN}_remove_onewifi = " ccspwifiagent.service"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'onewifi.service ', '', d)}"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'webconfig_bin', 'webconfig.service', '', d)}"
SYSTEMD_SERVICE_${PN} += " CcspTelemetry.service"
SYSTEMD_SERVICE_${PN} += " notifyComp.service"
SYSTEMD_SERVICE_${PN} += "gwprovapp.service"
SYSTEMD_SERVICE_${PN} += "wan-initialized.target"
SYSTEMD_SERVICE_${PN} += "wan-initialized.path"
SYSTEMD_SERVICE_${PN}_remove = " utopia.service"

FILES_${PN}_remove_onewifi = "${systemd_unitdir}/system/ccspwifiagent.service"
FILES_${PN}_remove = "${systemd_unitdir}/system/utopia.service" 
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ${systemd_unitdir}/system/onewifi.service ', '', d)}"
FILES_${PN}_append = " \
   ${systemd_unitdir}/system/wan-initialized.target \
   ${systemd_unitdir}/system/wan-initialized.path \
   ${systemd_unitdir}/system/CcspTelemetry.service \
   ${systemd_unitdir}/system/notifyComp.service \
   ${systemd_unitdir}/system/gwprovapp.service \
   ${systemd_unitdir}/system/gwprovapp.service.d/gwprovapp.conf \
   "
