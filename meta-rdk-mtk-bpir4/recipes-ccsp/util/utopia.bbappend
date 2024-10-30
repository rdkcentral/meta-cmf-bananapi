include meta-rdk-mtk-bpir4/recipes-ccsp/ccsp/ccsp_common_bananapi.inc


do_install_append() {

install -d ${D}${sysconfdir}/
install -d ${D}${sysconfdir}/utopia/
DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
if [ $DISTRO_WAN_ENABLED = 'true' ]; then

sed -i '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh
sed -i '/wan-status started/a \
rm -f \/etc\/dibbler\/server.pid \
ln -s \/etc\/dibbler \/tmp \
touch \/etc\/dibbler\/radvd.conf ' ${D}${sysconfdir}/utopia/utopia_init.sh
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
\$T2ConfigURL=https://xconf.rdkcentral.com:19092/loguploader/getT2Settings

#TR069support
\$EnableTR69Binary=true

#Custom Data Model
$custom_data_model_enabled=0
$custom_data_model_file_name=/usr/ccsp/tr069pa/custom_mapper.xml"  >> ${D}${sysconfdir}/utopia/system_defaults

#lan0 used for WAN Connectivity
sed -i "s/\$\$lan_ethernet_physical_ifnames=lan0 lan1 lan2 lan3 lan4/\$\$lan_ethernet_physical_ifnames=lan1 lan2 lan3 lan4/g" ${D}${sysconfdir}/utopia/system_defaults
}
