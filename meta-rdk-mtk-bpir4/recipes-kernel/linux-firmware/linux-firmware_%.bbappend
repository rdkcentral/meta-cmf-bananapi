#Remove duplicate package installation in populate sdk
do_install:append() {
        if ${@bb.utils.contains('DISTRO_FEATURES','krikstone','true','false',d)}; then
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7996
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7988
                rm -rf ${D}${base_libdir}/firmware/mediatek/mt7996/mt7996*
        fi
}

