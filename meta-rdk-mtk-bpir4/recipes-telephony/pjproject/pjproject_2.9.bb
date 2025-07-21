LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI_BASE ?= "https://www.pjsip.org/release/${PV}/pjproject-${PV}.tar.bz2"

require pjproject.inc

SRC_URI[md5sum] = "66757078e7bd7cf316acb0425c2fdd6f"
SRC_URI[sha256sum] = "d185ef7855c8ec07191dde92f54b65a7a4b7a6f7bf8c46f7af35ceeb1da2a636"

SRC_URI += "\
    file://arm-arch.patch \
    file://pkgconfig-cleanup.patch \
    file://install-perms.patch \
    file://ipv6.patch \
\
    file://0000-set_apps_initial_log_level.patch \
    file://0010-ssl_sock_ossl-sip_transport_tls-Add-peer-to-error-me.patch \
    file://0020-patch_cnonce_only_digits_option.patch \
    file://0030-ssl-regression-fix.patch \
    file://0031-transport-regression-fix.patch \
    file://0040-brackets-in-via-received-params.patch \
    file://0040-ICE-Add-callback-for-finding-valid-pair.patch \
"
