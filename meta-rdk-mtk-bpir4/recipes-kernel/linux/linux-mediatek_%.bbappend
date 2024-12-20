FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://rdkb_cfg/iptables_nf.cfg \
    file://rdkb_cfg/bridge_mode.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','dac', 'file://rdkb_cfg/container.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc','file://rdkb_cfg/sdmmc.cfg','',d)} \
"

CMDLINE_append = "${@bb.utils.contains('DISTRO_FEATURES','dac', 'cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1', '', d)}"
