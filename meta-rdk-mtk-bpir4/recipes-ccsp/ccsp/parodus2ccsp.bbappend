FILESEXTRAPATHS_prepend := "${THISDIR}/parodus2ccsp:"

SRC_URI += "\
    file://parodus_read_file.sh \
    file://parodus_create_file.sh \
    file://webpa_pre_setup.sh \
"
EXTRA_OECMAKE += "-DBUILD_BANANAPI_R4=ON "
 
do_install_append () {
    install -d ${D}${base_libdir_native}/rdk
    install -m 0755 ${WORKDIR}/webpa_pre_setup.sh ${D}${base_libdir_native}/rdk
    install -d ${D}/etc/parodus
    install -m 777 ${WORKDIR}/parodus_read_file.sh ${D}/etc/parodus/
    install -m 777 ${WORKDIR}/parodus_create_file.sh ${D}/etc/parodus/

}

 
FILES_${PN}_append = " \
     ${base_libdir_native}/rdk/* \
     /etc/parodus/* \
     "
