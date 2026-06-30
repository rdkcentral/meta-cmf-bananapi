#To avoid do_package_qa issue for files not shipped but installed.
do_install:append() {
        # Remove empty dirs in libdir when gconv or locales are not copied
        find ${D}${libdir} -type d -empty -delete
}

