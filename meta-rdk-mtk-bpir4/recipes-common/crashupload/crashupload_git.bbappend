FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append  += " file://uploadDumpsUtilsBroadband.sh "
SRC_URI_append  += " file://uploadDumpsToS3.sh "

do_install_append () {
        install -m 0755 ${S}/../uploadDumpsUtilsBroadband.sh ${D}${base_libdir}/rdk/uploadDumpsUtils.sh
        install -m 0755 ${S}/../uploadDumpsToS3.sh ${D}${base_libdir}/rdk/uploadDumpsToS3.sh

	sed -i '/After=network-online.target/d' ${D}${systemd_unitdir}/system/coredump-upload.path
	sed -i '/Requires=network-online.target/d' ${D}${systemd_unitdir}/system/coredump-upload.path
}
