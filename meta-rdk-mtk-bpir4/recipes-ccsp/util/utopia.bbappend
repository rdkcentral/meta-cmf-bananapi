include meta-rdk-mtk-bpir4/recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://cellular_firewall_updated.patch;apply=no "
SRC_URI += " file://BPI-Utopia-changes.patch;apply=no "

do_filogic_patches_append() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-Utopia-changes.patch"
        patch -p1 < ${WORKDIR}/BPI-Utopia-changes.patch
        bbnote "Patching cellular_firewall_updated.patch"
        patch -p1 < ${WORKDIR}/cellular_firewall_updated.patch
    touch bananapi_patch_applied
    fi
}

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
\$T2ConfigURL=https://xconf.rdkcentral.com:19092/loguploader/getT2Settings"  >> ${D}${sysconfdir}/utopia/system_defaults
}
