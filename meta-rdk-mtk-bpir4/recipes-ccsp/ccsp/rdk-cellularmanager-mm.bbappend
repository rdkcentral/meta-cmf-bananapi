FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://idevice_validate.service \
                   file://idevice_validate.sh "
RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'bash', '', d)}"

do_install:append () {
    # Config files and scripts
    install -d ${D}${exec_prefix}/rdk/cellularmanager
    #Install systemd unit.
    install -d ${D}${systemd_unitdir}/system
    if ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'true', 'false', d)}; then
    install -m 744 ${UNPACKDIR}/idevice_validate.sh ${D}${exec_prefix}/rdk/cellularmanager
    install -D -m 0644 ${UNPACKDIR}/idevice_validate.service ${D}${systemd_unitdir}/system/idevice_validate.service
    fi
}

SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'idevice_validate.service', '', d)}"

FILES:${PN} += " \
   ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' ${exec_prefix}/rdk/cellularmanager/idevice_validate.sh', '', d)} \
   ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' ${systemd_unitdir}/system/idevice_validate.service', '', d)} \
"
