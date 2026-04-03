do_install_append_class-target() {
       sed -i \
       -e '/After=network.target/s/After=network.target/After=network.target mount-nvram.service/' \
       -e '/After=network.target/a Requires=mount-nvram.service' \
${D}${systemd_system_unitdir}/mysqld.service
}
