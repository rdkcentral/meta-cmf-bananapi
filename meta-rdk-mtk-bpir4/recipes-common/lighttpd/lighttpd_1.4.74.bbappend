SRC_URI:remove:scarthgap += " file://0001-Force-UTC-for-lighttpd-log-messages.patch "
do_install:append(){
sed -i '$ a include_shell "sh /etc/webgui_config.sh"' ${D}${sysconfdir}/lighttpd.conf
}
