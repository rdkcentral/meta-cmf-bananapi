LICENSE = "CLOSED"

DEPENDS = "hal-ethsw"

SRC_URI = "file://configure.ac  \
           file://gw_lan_refresh.c  \
           file://Makefile.am \
          "


S = "${WORKDIR}"
inherit autotools pkgconfig
