FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-add-support-for-port-triggering.patch"
SRC_URI += "file://BPI-resolving-port-triggering-errors.patch"

SRC_URI += " \
    file://rdkb_cfg/iptables_nf.cfg \
    file://rdkb_cfg/bridge_mode.cfg \
    file://rdkb_cfg/coredump.cfg \
    file://netfilter.cfg  \
    ${@bb.utils.contains('DISTRO_FEATURES','dac', 'file://rdkb_cfg/container.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc','file://rdkb_cfg/sdmmc.cfg','',d)} \
    file://rdkb_cfg/wps_key.cfg \
"

# Tell kernel to actually apply them
KERNEL_CONFIG_FRAGMENTS += " \
    mediatek/filogic.cfg \
"
#KERNEL_AUTO_APPEND_CONFIG = "1"

# Ensure DTBs are built even if we're using fitImage
do_compile:append() {
    if [ -n "${KERNEL_DEVICETREE}" ]; then
        oe_runmake ${KERNEL_DEVICETREE}
    fi
}

python __anonymous() {
    # Use the correct package name; often the package is 'kernel-module-*' or 'kernel-6'
    d.delVar("pkg_postinst:kernel-6")
    # also target the generated package name if different; check build output and change above accordingly
}

# Add on-target depmod instead
pkg_postinst_ontarget:kernel-6 () {
    if [ -x /sbin/depmod ] || [ -x /usr/sbin/depmod ]; then
        depmod -a || true
    fi
}

CMDLINE:append = "${@bb.utils.contains('DISTRO_FEATURES','dac', 'cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1', '', d)}"
