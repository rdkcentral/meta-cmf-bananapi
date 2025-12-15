FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-add-support-for-port-triggering.patch"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','file://BPI-resolving-port-triggering-errors_6_6.patch','file://BPI-resolving-port-triggering-errors.patch', d)}"
SRC_URI_append = " \
    file://rdkb_cfg/iptables_nf.cfg \
    file://rdkb_cfg/bridge_mode.cfg \
    file://rdkb_cfg/coredump.cfg \
    file://rdkb_cfg/ip6tables_nf.cfg \
    file://netfilter.cfg  \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6', 'file://rdkb_cfg/kernel_6_6.cfg', '', d)}  \
    file://rdkb_cfg/container.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc','file://rdkb_cfg/sdmmc.cfg','',d)} \
    file://rdkb_cfg/wps_key.cfg \
    file://enable_sdcard_6_6.patch;apply=no \
"

SRC_URI_append_mt7988 = "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'file://rdkb_cfg/rdkb-usb.cfg', '', d)}"

CMDLINE_append = " cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 "

do_filogic_patches_append() {
    cd ${S}
    Enable_sd_6_6="${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','true','false',d)}"
    if [ ! -e patch_applied_6_6 ]; then
         if [ $Enable_sd_6_6 = 'true' ]; then
              patch -p1 < ${WORKDIR}/enable_sdcard_6_6.patch
         fi
         touch patch_applied_6_6
    fi
}
