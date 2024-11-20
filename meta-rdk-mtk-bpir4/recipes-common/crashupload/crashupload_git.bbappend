
do_install_append () {
	sed -i '/After=network-online.target/d' ${D}${systemd_unitdir}/system/coredump-upload.path
	sed -i '/Requires=network-online.target/d' ${D}${systemd_unitdir}/system/coredump-upload.path
}
