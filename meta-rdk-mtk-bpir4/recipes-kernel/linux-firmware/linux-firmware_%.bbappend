#Remove duplicate package installation in populate sdk
do_install_append() {
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7996
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7988
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7996/mt7996*
}

