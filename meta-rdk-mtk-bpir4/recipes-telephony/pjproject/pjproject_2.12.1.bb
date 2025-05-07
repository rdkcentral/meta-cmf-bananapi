LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

require pjproject.inc

SRC_URI[sha256sum] = "d0feef6963b07934e821ba4328aecb4c36358515c1b3e507da5874555d713533"

SRC_URI += "\
    file://arm-arch.patch \
    file://install-perms.patch \
\
    file://0100-allow_multiple_auth_headers.patch \
    file://0200-potential-buffer-overflow-in-pjlib-scanner-and-pjmedia.patch \
    file://0201-potential-stack-buffer-overflow-when-parsing-message-as-a-STUN-client.patch \
"
