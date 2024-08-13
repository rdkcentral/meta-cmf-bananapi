include recipes-ccsp/ccsp/ccsp_common_bananapi.inc


do_install_append() {

    install -d ${D}${sysconfdir}/
    install -d ${D}${sysconfdir}/utopia/	
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
      sed '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh
mkdir -p \/etc \
mkdir -p \/etc\/dibbler \
ln -s \/etc\/dibbler \/tmp \
touch \/etc\/dibbler\/radvd.conf \
    fi
}
