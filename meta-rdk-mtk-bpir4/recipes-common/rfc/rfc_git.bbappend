do_install_append() {
        #Set the RFC_CONFIG_SERVER_URL by sed
        sed -i -e 's/RFC_CONFIG_SERVER_URL=.*$/RFC_CONFIG_SERVER_URL=https:\/\/xconf.rdkcentral.com:19092\/featureControl\/getSettings/' ${D}${sysconfdir}/rfc.properties
}
