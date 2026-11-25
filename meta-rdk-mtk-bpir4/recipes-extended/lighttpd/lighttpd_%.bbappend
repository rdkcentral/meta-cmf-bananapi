RDEPENDS:${PN}:append:kirkstone = " \
 ${@bb.utils.contains('DISTRO_FEATURES','kernel6-12', ' lighttpd-module-fastcgi', '', d)} \
"
#Remote Management
do_install:append(){
sed -i '$ a include_shell "sh /etc/webgui_config.sh"' ${D}${sysconfdir}/lighttpd.conf
}

