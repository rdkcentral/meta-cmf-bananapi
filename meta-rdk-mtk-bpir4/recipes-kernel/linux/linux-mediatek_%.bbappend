FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

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

CMDLINE_append = "${@bb.utils.contains('DISTRO_FEATURES','dac', 'cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1', '', d)}"

do_install_append() {
    echo "Installing gpio_keys.ko..."
    if [ -f ${B}/drivers/input/keyboard/gpio_keys.ko ]; then
        install -m 0644 ${B}/drivers/input/keyboard/gpio_keys.ko \
            ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/input/keyboard/gpio_keys.ko
        install -d ${D}/etc/modules-load.d
        echo "gpio_keys" > ${D}/etc/modules-load.d/gpio_keys.conf

    else
        echo "Warning: gpio_keys.ko not found in expected location."
    fi
}
