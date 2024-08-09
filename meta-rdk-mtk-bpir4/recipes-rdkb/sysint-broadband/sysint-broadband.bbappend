do_install_append () {
  #Webpa ServerURL
  echo "SERVERURL=http://webpa.rdkcentral.com:8080" >> ${D}${sysconfdir}/device.properties
}
