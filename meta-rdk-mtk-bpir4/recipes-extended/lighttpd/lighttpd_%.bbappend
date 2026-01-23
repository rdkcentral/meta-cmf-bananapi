
#Remote Management
do_install:append(){
sed -i '$ a include_shell "sh /etc/webgui_config.sh"' ${D}${sysconfdir}/lighttpd.conf
}

