SRC_URI_remove = "git://github.com/rdkcentral/rfc.git;protocol=https;nobranch=1;name=rfc"
LIC_FILES_CHKSUM_remove = "file://LICENSE;md5=bef3b9130aa5d626df3f7171f2dadfe2"

LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

PACKAGECONFIG_remove = " tr181set"
#PACKAGECONFIG[tr181set]_append += "--enable-tr181set=no"

SRC_URI += "${CMF_GIT_ROOT}/rdk/components/generic/rfc;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=rfc"
SRCREV_rfc = "0f904d8ce15ba8e59d36f485729a373c630e260e"

CXXFLAGS_remove = " -Wall -Werror"

EXTRA_OECONF_remove = " --enable-rdkb=yes --enable-tr181set=yes"

do_install_append() {
        #Set the RFC_CONFIG_SERVER_URL by sed
        sed -i -e 's/RFC_CONFIG_SERVER_URL=.*$/RFC_CONFIG_SERVER_URL=https:\/\/xconf.rdkcentral.com\/featureControl\/getSettings/' ${D}${sysconfdir}/rfc.properties
}
