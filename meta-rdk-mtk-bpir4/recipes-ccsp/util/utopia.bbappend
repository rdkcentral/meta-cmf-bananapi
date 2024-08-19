include ccsp_common_bananapi.inc


do_install_append() {

    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
      sed -i '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh \
mkdir -p \/etc \
mkdir -p \/etc\/dibbler \
ln -s \/etc\/dibbler \/tmp \
touch \/etc\/dibbler\/radvd.conf
    fi
}
