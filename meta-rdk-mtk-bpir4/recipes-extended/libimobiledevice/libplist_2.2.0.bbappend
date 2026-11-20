DEPENDS:remove = "swig"
do_install:append () {
    cp ${D}${libdir}/pkgconfig/libplist-2.0.pc ${D}${libdir}/pkgconfig/libplist.pc
}
