include ccsp_common_bananapi.inc
RDEPENDS_${PN} += "ndisc6"

GIT_TAG = "v2.14.0"
SRC_URI = "git://github.com/rdkcentral/wan-manager.git;branch=releases/2.14.0-main;protocol=https;name=WanManager;tag=${GIT_TAG}"
SRCREV = ""

DEPENDS_remove = "hal-cm"
