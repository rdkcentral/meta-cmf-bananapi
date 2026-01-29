FILESEXTRAPATHS:prepend := "${THISDIR}/parodus2ccsp:"

SRC_URI += "\
    file://parodus_read_file.sh \
    file://parodus_create_file.sh \
    file://webpa_pre_setup.sh \
"
EXTRA_OECMAKE += "-DBUILD_BANANAPI_R4=ON "
 
do_install:append () {
    install -d ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/webpa_pre_setup.sh ${D}${base_libdir}/rdk
    install -d ${D}/etc/parodus
    install -m 777 ${WORKDIR}/parodus_read_file.sh ${D}/etc/parodus/
    install -m 777 ${WORKDIR}/parodus_create_file.sh ${D}/etc/parodus/

}

FILES:${PN}:append = " \
     ${base_libdir}/rdk/* \
     /etc/parodus/* \
     "
