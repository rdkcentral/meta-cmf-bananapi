FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://rdkb_cfg/iptables_nf.cfg \
    file://rdkb_cfg/bridge_mode.cfg \
    file://rdkb_cfg/coredump.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','dac', 'file://rdkb_cfg/container.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc','file://rdkb_cfg/sdmmc.cfg','',d)} \
    file://rdkb_cfg/wps_key.cfg \
"

SRC_URI_append_mt7988 = "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'file://rdkb_cfg/rdkb-usb.cfg', '', d)}"

CMDLINE_append = "${@bb.utils.contains('DISTRO_FEATURES','dac', 'cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1', '', d)}"
