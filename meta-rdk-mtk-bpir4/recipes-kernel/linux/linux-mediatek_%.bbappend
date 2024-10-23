FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://rdkb_cfg/iptables_nf.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES','dac', 'file://rdkb_cfg/container.cfg', '', d)} \
"

CMDLINE_append = "${@bb.utils.contains('DISTRO_FEATURES','dac', 'cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1', '', d)}"
