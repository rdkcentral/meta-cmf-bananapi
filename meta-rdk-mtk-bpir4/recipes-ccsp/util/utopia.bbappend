include meta-rdk-mtk-bpir4/recipes-ccsp/ccsp/ccsp_common_bananapi.inc


do_install_append() {

install -d ${D}${sysconfdir}/
install -d ${D}${sysconfdir}/utopia/
DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
if [ $DISTRO_WAN_ENABLED = 'true' ]; then

sed -i '/\/tmp\/dibbler/d' ${D}${sysconfdir}/utopia/utopia_init.sh
sed -i '/wan-status started/a \
rm -f \/etc\/dibbler\/server.pid \
ln -s \/etc\/dibbler \/tmp \
touch \/etc\/dibbler\/radvd.conf ' ${D}${sysconfdir}/utopia/utopia_init.sh
fi

}
