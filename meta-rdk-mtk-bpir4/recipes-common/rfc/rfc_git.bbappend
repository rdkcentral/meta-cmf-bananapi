FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append  += " file://RFCbase.sh "

do_install_append() {
        install -m 0755 ${S}/../RFCbase.sh ${D}${base_libdir}/rdk/RFCbase.sh

        #Set the RFC_CONFIG_SERVER_URL by sed
        sed -i -e 's/RFC_CONFIG_SERVER_URL=.*$/RFC_CONFIG_SERVER_URL=https:\/\/xconf.rdkcentral.com\/featureControl\/getSettings/' ${D}${sysconfdir}/rfc.properties
}
