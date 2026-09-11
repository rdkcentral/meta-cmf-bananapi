FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://idevice_validate.service \
                   file://idevice_validate.sh "
RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'bash', '', d)}"

do_install_append () {
    # Config files and scripts
    install -d ${D}${exec_prefix}/rdk/cellularmanager
    #Install systemd unit.
    install -d ${D}${systemd_unitdir}/system
    if ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'true', 'false', d)}; then
    install -m 744 ${WORKDIR}/idevice_validate.sh ${D}${exec_prefix}/rdk/cellularmanager
    install -D -m 0644 ${WORKDIR}/idevice_validate.service ${D}${systemd_unitdir}/system/idevice_validate.service
    fi
}

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'idevice_validate.service', '', d)}"

FILES_${PN} += " \
   ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' ${exec_prefix}/rdk/cellularmanager/idevice_validate.sh', '', d)} \
   ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' ${systemd_unitdir}/system/idevice_validate.service', '', d)} \
"
