include ccsp_common_bananapi.inc

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
}


SYSTEMD_SERVICE_${PN}_remove_onewifi = " ccspwifiagent.service"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'onewifi.service ', '', d)}"

FILES_${PN}_remove_onewifi = "${systemd_unitdir}/system/ccspwifiagent.service"
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ${systemd_unitdir}/system/onewifi.service ', '', d)}"
