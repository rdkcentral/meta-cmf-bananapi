do_install_append() {
        #Set the RFC_CONFIG_SERVER_URL by sed
        sed -i -e 's/RFC_CONFIG_SERVER_URL=.*$/RFC_CONFIG_SERVER_URL=https:\/\/xconf.rdkcentral.com\/featureControl\/getSettings/' ${D}${sysconfdir}/rfc.properties
        #Set the PresenceDetect.Enable as false
        sed -i '/rfcLogging "\$DCM_PARSER_RESPONSE file is present"/a \
    # Force PresenceDetect.Enable to false\nsed -i '\''/PresenceDetect.Enable/ s/#~true#~/#~false#~/'\'' $DCM_PARSER_RESPONSE' \
    ${D}${base_libdir}/rdk/RFCbase.sh
}
