include recipes-ccsp/ccsp/ccsp_common_bananapi.inc


do_install_append() {

    install -d ${D}${sysconfdir}/
    install -d ${D}${sysconfdir}/utopia/	
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
      sed '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh
mkdir -p \/etc \
mkdir -p \/etc\/dibbler \
ln -s \/etc\/dibbler \/tmp \
touch \/etc\/dibbler\/radvd.conf \
    fi

#Adding telemetry defaults
    echo "#UniqueTelemetryId default values
\$unique_telemetry_enable=false
\$unique_telemetry_tag=
\$unique_telemetry_interval=0

#TR181 Telemetry Support via MessageBusSource
\$MessageBusSource=true

#Defaults for Telemetry T2 Enable
\$T2Enable=true
\$T2Version=2.0.1
\$T2ConfigURL=https://xconf.rdkcentral.com:19092/loguploader/getT2Settings"  >> ${D}${sysconfdir}/utopia/system_defaults
}
