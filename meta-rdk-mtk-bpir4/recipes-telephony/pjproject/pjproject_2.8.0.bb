LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "d3923d2dc9aca1fac0f8a6c03591fca7205824d2"
GITREF = ";nobranch=1"
SRC_URI_BASE = "git://github.com/asterisk/pjproject.git;protocol=http${GITREF}"
S = "${WORKDIR}/git"

require pjproject.inc

SRC_URI += "\
    file://arm-arch.patch \
    file://pkgconfig-cleanup.patch \
    file://install-perms.patch \
    file://ipv6.patch \
\
    file://0000-set_apps_initial_log_level.patch \
    file://0010-outgoing_connected_line_method_update.patch \
    file://0020-Fixed-2172-Avoid-double-reference-counter-decrements.patch \
    file://0030-Re-2176-Removed-pop_freelist-push_freelist-after-rem.patch \
    file://0031-Re-2191-transport-timer-cleanup.patch \
    file://0032-Re-2191-Fixed-crash-in-SIP-transport-destroy-due-to-.patch \
    file://changeset_5891.diff;striplevel=3 \
"
