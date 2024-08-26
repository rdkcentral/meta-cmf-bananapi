do_install_append () {
  #Webpa ServerURL
  echo "SERVERURL=http://webpa.rdkcentral.com:8080" >> ${D}${sysconfdir}/device.properties
  ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'echo "OneWiFiEnabled=true" >> ${D}${sysconfdir}/device.properties', '', d)}
}
