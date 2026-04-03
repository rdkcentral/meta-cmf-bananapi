FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-add-support-for-port-triggering.patch"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES','kernel6-12','file://BPI-resolving-port-triggering-errors_6_12.patch',bb.utils.contains('DISTRO_FEATURES','kernel6-6','file://BPI-resolving-port-triggering-errors_6_6.patch','file://BPI-resolving-port-triggering-errors.patch',d), d)}"
SRC_URI:append = " \
    file://rdkb_cfg/iptables_nf.cfg \
    file://rdkb_cfg/bridge_mode.cfg \
    file://rdkb_cfg/coredump.cfg \
    file://rdkb_cfg/ip6tables_nf.cfg \
    ${@bb.utils.contains_any('DISTRO_FEATURES','kernel6-12 kernel6-6', ' file://netfilter_v6.cfg', ' file://netfilter.cfg', d)}  \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-12', ' file://rdkb_cfg/kernel_v6.cfg',bb.utils.contains('DISTRO_FEATURES','kernel6-6',' file://rdkb_cfg/kernel_6_6.cfg', '',d), d)}  \
    file://rdkb_cfg/container.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc',bb.utils.contains_any('DISTRO_FEATURES','kernel6-12 kernel6-6', ' file://rdkb_cfg/sdmmc_v6.cfg', ' file://rdkb_cfg/sdmmc.cfg',d), '', d)} \
    file://rdkb_cfg/wps_key.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6', ' file://enable_sdcard_6_6.patch;apply=no', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6', ' file://bluetooth_6_6.patch;apply=no', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-12', ' file://enable_sdcard_v6.patch;apply=no', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-12', ' file://bluetooth_v6.patch;apply=no', '', d)} \
"
SRC_URI:append:mt7988 = "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' file://rdkb_cfg/rdkb-usb.cfg', '', d)}"

CMDLINE:append = " cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 "

do_filogic_patches:append() {
    cd ${S}
    Enable_sd_6_6="${@bb.utils.contains( 'DISTRO_FEATURES','kernel6-6','true','false',d)}"
    Enable_sd_v6="${@bb.utils.contains( 'DISTRO_FEATURES','kernel6-12','true','false',d)}"
    if [ ! -e patch_applied_v6 ];then
         if [ $Enable_sd_6_6 = 'true' ]; then
              patch -p1 < ${WORKDIR}/enable_sdcard_6_6.patch
              patch -p1 < ${WORKDIR}/bluetooth_6_6.patch
         elif [ $Enable_sd_v6 = 'true' ]; then
              patch -p1 < ${WORKDIR}/enable_sdcard_v6.patch
             patch -p1 < ${WORKDIR}/bluetooth_v6.patch
         fi
         touch patch_applied_v6
    fi
}
do_install:append() {
    # Remove any empty directories under /etc in ${D}
    find ${D}${sysconfdir} -type d -empty -delete
}

