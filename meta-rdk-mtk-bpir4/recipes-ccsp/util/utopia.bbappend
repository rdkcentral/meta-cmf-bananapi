include meta-rdk-mtk-bpir4/recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://service_bridge_bpi.sh"

do_install_append() {

install -d ${D}${sysconfdir}/
install -d ${D}${sysconfdir}/utopia/
install -d -m 0777 ${D}/minidumps
DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
if [ $DISTRO_WAN_ENABLED = 'true' ]; then

sed -i '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh
sed -i '/ip_forward/a \
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
\$T2ConfigURL=https://xconf.rdkcentral.com:19092/loguploader/getT2Settings"  >> ${D}${sysconfdir}/utopia/system_defaults

#lan0 used for WAN Connectivity
sed -i "s/\$\$lan_ethernet_physical_ifnames=lan0 lan1 lan2 lan3 lan4/\$\$lan_ethernet_physical_ifnames=lan1 lan2 lan3 lan4/g" ${D}${sysconfdir}/utopia/system_defaults

#Bridge-mode virtual interface net0 instead of lan0
sed -i "s/\$\$cmdiag_ifname=lan0$/\$\$cmdiag_ifname=net0/g" ${D}${sysconfdir}/utopia/system_defaults

#Port Triggering feature has to be disabled by default
sed -i 's/^$CosaNAT::port_trigger_enabled=1/$CosaNAT::port_trigger_enabled=0/' ${D}${sysconfdir}/utopia/system_defaults

#Script for enabling bridge mode in BPIR4.
install -m 755 ${WORKDIR}/service_bridge_bpi.sh ${D}${sysconfdir}/utopia/service.d/
install -m 755 ${WORKDIR}/service_bridge_bpi.sh ${D}${sysconfdir}/utopia/service.d/service_bridge.sh

#Adding self heal defaults
echo "#SelfHeal
\$ConnTest_PingInterval=60
\$ConnTest_NumPingsPerServer=3
\$ConnTest_MinNumPingServer=1
\$ConnTest_PingRespWaitTime=1000
\$ConnTest_CorrectiveAction=false
\$Ipv4PingServer_Count=0
\$Ipv6PingServer_Count=0
\$resource_monitor_interval=15
\$avg_cpu_threshold=100
\$avg_memory_threshold=100
\$selfheal_enable=true
\$max_reboot_count=3
\$max_reset_count=3
\$todays_reboot_count=0
\$todays_reset_count=0
\$lastActiontakentime=0
\$process_memory_log_count=0
\$todays_atom_reboot_count=0
\$selfheal_dns_pingtest_enable=false
\$selfheal_dns_pingtest_url=www.google.com
\$highloadavg_reboot_count=0
\$selfheal_ping_DataBlockSize=56
\$Selfheal_DiagnosticMode=false
\$diagMode_LogUploadFrequency=1440
\$router_reboot_Interval=28800
\$last_router_reboot_time=0
\$AggressiveInterval=5

#TR069support
\$EnableTR69Binary=true

#Custom Data Model
$custom_data_model_enabled=0
$custom_data_model_file_name=/usr/ccsp/tr069pa/custom_mapper.xml"  >> ${D}${sysconfdir}/utopia/system_defaults
}

FILES_${PN} += " \
                /minidumps/ \
"
