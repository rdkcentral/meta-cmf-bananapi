LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

require pjproject.inc

SRC_URI[sha256sum] = "936a4c5b98601b52325463a397ddf11ab4106c6a7b04f8dc7cdd377efbb597de"

SRC_URI += "\
    file://arm-arch.patch \
    file://pkgconfig-cleanup.patch \
    file://install-perms.patch \
    file://ipv6.patch \
\
    file://0000-set_apps_initial_log_level.patch \
    file://0011-sip_inv_patch.patch \
    file://0020-pjlib_cancel_timer_0.patch \
    file://0050-fix-race-parallel-build.patch \
    file://0060-clone-sdp-for-sip-timer-refresh-invite.patch \
    file://0070-fix-incorrect-copying-when-creating-cancel.patch \
    file://0080-fix-sdp-neg-modify-local-offer.patch \
    file://0090-Skip-unsupported-digest-algorithm-2408.patch \
    file://0100-fix-double-stun-free.patch \
    file://0110-tls-parent-listener-destroyed.patch \
    file://0111-ssl-premature-destroy.patch \
    file://0120-pjmedia_sdp_attr_get_rtpmap-Strip-param-trailing-whi.patch \
    file://0130-sip_inv-Additional-multipart-support-2919-2920.patch \
    file://0140-Fix-incorrect-unescaping-of-tokens-during-parsing-29.patch \
    file://0150-Create-generic-pjsip_hdr_find-functions.patch \
    file://0160-Additional-multipart-improvements.patch \
"
