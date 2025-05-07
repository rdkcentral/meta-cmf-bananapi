FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-18:"

LIC_FILES_CHKSUM = "\
    file://COPYING;md5=3c6764ffcbe996d1d8f919b393ccdd67 \
    file://LICENSE;md5=e8f2ac12f40125052f5a09c009f2f11a \
"

GITREF = ";nobranch=1"

SND_BASE_URI = "http://downloads.asterisk.org/pub/telephony/sounds/releases"

SRC_URI = "\
    git://github.com/asterisk/asterisk.git;protocol=https${GITREF} \
    ${SND_BASE_URI}/asterisk-moh-opsound-wav-2.03.tar.gz;unpack=0;name=moh-sounds;subdir=${S}/sounds \
    ${SND_BASE_URI}/asterisk-core-sounds-en-gsm-1.6.1.tar.gz;unpack=0;name=core-sounds-en-gsm;subdir=${S}/sounds \
    file://0002-Use-pkgconfig-to-find-libxml2.patch \
    file://recursive-autoconf.patch \
    file://paths.patch \
    file://asterisk.tmpfiles \
    file://asterisk.service \
    file://asterisk.socket \
"
PV = "18.15.1"
SRCREV = "226868d1139af566c481265ef9657a1b33aa065e"

SRC_URI[moh-sounds.sha256sum] = "449fb810d16502c3052fedf02f7e77b36206ac5a145f3dacf4177843a2fcb538"
SRC_URI[core-sounds-en-gsm.sha256sum] = "d79c3d2044d41da8f363c447dfccc140be86b4fcc41b1ca5a60a80da52f24f2d"

require asterisk.inc
