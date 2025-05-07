DESCRIPTION = "Asterisk is an Open Source PBX and telephony toolkit."
LICENSE = "GPLv2"

S = "${WORKDIR}/git"

DEPENDS += "util-linux libxml2-native ncurses-native"

inherit autotools-brokensep pkgconfig useradd systemd

EXTRA_AUTORECONF += "\
    -I ${S}/third-party/jansson \
    -I ${S}/third-party/pjproject \
"

PACKAGECONFIG ?= "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'largefile', 'largefile', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd',   'systemd', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'largefile', 'largefile', '', d)} \
    libxml2 \
    jansson \
    sqlite3 \
    libedit \
    pjproject \
\
    timerfd \
    zlib \
    ncurses \
    asteriskssl openssl crypto \
    gsm \
"
# Optional features
PACKAGECONFIG[jansson] = "--with-jansson,--without-jansson,jansson"
PACKAGECONFIG[sqlite3] = "--with-sqlite3,--without-sqlite3,sqlite3"
PACKAGECONFIG[libedit] = "--with-libedit,--without-libedit,libedit"
PACKAGECONFIG[dev-mode] = "--enable-dev-mode,--disable-dev-mode"
PACKAGECONFIG[coverage] = "--enable-coverage,--disable-coverage"
PACKAGECONFIG[xmldoc] = "--enable-xmldoc,--disable-xmldoc"
PACKAGECONFIG[largefile] = "--enable-largefile,--disable-largefile"
PACKAGECONFIG[internal-poll] = "--enable-internal-poll,--disable-internal-poll"
PACKAGECONFIG[asteriskssl] = "--enable-asteriskssl,--disable-asteriskssl,openssl"
PACKAGECONFIG[rpath] = "--enable-rpath,--disable-rpath"
# Optional packages
PACKAGECONFIG[bfd] = "--with-bfd,--without-bfd"
PACKAGECONFIG[bluetooth] = "--with-bluetooth,--without-bluetooth,bluez5"
PACKAGECONFIG[backtrace] = "--with-execinfo,--without-execinfo"
PACKAGECONFIG[cap] = "--with-cap,--without-cap,libcap"
PACKAGECONFIG[corosync] = "--with-cpg,--without-cpg,corosync"
PACKAGECONFIG[curses] = "--with-curses,--without-curses,ncurses"
PACKAGECONFIG[crypt] = "--with-crypt,--without-crypt"
PACKAGECONFIG[crypto] = "--with-crypto,--without-crypto"
PACKAGECONFIG[dahdi] = "--with-dahdi,--without-dahdi,dahdi-tools"
# To enable FFMPEG add LICENSE_FLAGS_WHITELIST = "commercial" to your local.conf
PACKAGECONFIG[ffmpeg] = "--with-avcodec,--without-avcodec,libav"
PACKAGECONFIG[gsm] = "--with-gsm,--without-gsm,libgsm"
PACKAGECONFIG[ilbc] = "--with-ilbc,--without-ilbc"
PACKAGECONFIG[gtk2] = "--with-gtk2,--without-gtk2,gtk+"
PACKAGECONFIG[gmime] = "--with-gmime,--without-gmime"
PACKAGECONFIG[openh323] = "--with-h323,--without-h323"
PACKAGECONFIG[hoard] = "--with-hoard,--without-hoard"
PACKAGECONFIG[ical] = "--with-ical,--without-ical"
PACKAGECONFIG[iconv] = "--with-iconv,--without-iconv,libiconv"
PACKAGECONFIG[iksemel] = "--with-iksemel,--without-iksemel,iksemel"
PACKAGECONFIG[imap_tk] = "--with-imap,--without-imap,uw-imap"
PACKAGECONFIG[inotify] = "--with-inotify,--without-inotify"
PACKAGECONFIG[iodbc] = "--with-iodbc,--without-iodbc"
PACKAGECONFIG[isdnnet] = "--with-isdnnet,--without-isdnnet"
# Jack depends on kqeueu
PACKAGECONFIG[jack] = "--with-jack,--without-jack,jack"
PACKAGECONFIG[uriparser] = "--with-uriparser,--without-uriparser"
PACKAGECONFIG[kqueue] = "--with-kqueue,--without-kqueue"
PACKAGECONFIG[ldap] = "--with-ldap,--without-ldap,openldap"
PACKAGECONFIG[libcurl] = "--with-libcurl,--without-libcurl,curl"
PACKAGECONFIG[libxml2] = "--with-libxml2,--without-libxml2,libxml2"
PACKAGECONFIG[libxslt] = "--with-libxslt,--without-libxslt,libxslt"
PACKAGECONFIG[ltdl] = "--with-ltdl,--without-ltdl,libtool"
PACKAGECONFIG[lua] = "--with-lua,--without-lua,lua"
PACKAGECONFIG[misdn] = "--with-misdn,--without-misdn,misdn-utils"
PACKAGECONFIG[mysqlclient] = "--with-mysqlclient,--without-mysqlclient,mariadb"
PACKAGECONFIG[nbs] = "--with-nbs,--without-nbs"
PACKAGECONFIG[ncurses] = "--with-curses,--without-curses,ncurses"
PACKAGECONFIG[neon] = "--with-neon,--without-neon,neon"
PACKAGECONFIG[netsnmp] = "--with-netsnmp,--without-netsnmp,net-snmp"
PACKAGECONFIG[newt] = "--with-newt,--without-newt,libnewt"
PACKAGECONFIG[ogg] = "--with-ogg,--without-ogg,libogg"
PACKAGECONFIG[openr2] = "--with-openr2,--without-openr2"
PACKAGECONFIG[opus] = "--with-opus,--without-opus,libopus"
PACKAGECONFIG[osptk] = "--with-osptk,--without-osptk"
PACKAGECONFIG[oss] = "--with-oss,--without-oss,alsa-oss"
PACKAGECONFIG[pgsql] = "--with-postgres,--without-postgres,postgresql"
PACKAGECONFIG[pjproject] = "--with-pjproject --with-pjproject-bundled=no,--without-pjproject,pjproject"
PACKAGECONFIG[popt] = "--with-popt,--without-popt,popt"
PACKAGECONFIG[portaudio] = "--with-portaudio,--without-portaudio,portaudio-v19"
PACKAGECONFIG[pri] = "--with-pri,--without-pri,misdn-utils"
PACKAGECONFIG[pwlib] = "--with-pwlib,--without-pwlib,pwlib"
PACKAGECONFIG[radius] = "--with-radius,--without-radius,radiusclient-ng"
PACKAGECONFIG[resample] = "--with-resample,--without-resample,ncurses"
# Need to enable sdl_images to use sdl
PACKAGECONFIG[sdl] = "--with-sdl,--without-sdl,libsdl"
PACKAGECONFIG[sdl_image] = "--with-SDL_image,--without-SDL_image,libsdl-image"
PACKAGECONFIG[sounds-cache] = "--with-sounds-cache,--without-sounds-cache"
PACKAGECONFIG[spandsp] = "--with-spandsp,--without-spandsp"
PACKAGECONFIG[ss7] = "--with-ss7,--without-ss7"
PACKAGECONFIG[speex] = "--with-speex,--without-speex,speex"
PACKAGECONFIG[speexdsp] = "--with-speexdsp,--without-speexdsp,speexdsp"
PACKAGECONFIG[srtp] = "--with-srtp,--without-srtp"
PACKAGECONFIG[openssl] = "--with-ssl,--without-ssl,openssl"
PACKAGECONFIG[suppserv] = "--with-suppserv,--without-suppserv,misdn-utils"
PACKAGECONFIG[freetds] = "--with-tds,--without-tds"
PACKAGECONFIG[termcap] = "--with-termcap,--without-termcap,libcap"
PACKAGECONFIG[timerfd] = "--with-timerfd,--without-timerfd"
PACKAGECONFIG[tinfo] = "--with-tinfo,--without-tinfo,ncurses"
PACKAGECONFIG[tonezone] = "--with-tonezone,--without-tonezone"
PACKAGECONFIG[unixodbc] = "--with-unixodbc,--without-unixodbc,libodbc"
PACKAGECONFIG[vorbis] = "--with-vorbis,--without-vorbis,libvorbis"
PACKAGECONFIG[vpb] = "--with-vpb,--without-vpb"
PACKAGECONFIG[x11] = "--with-x11,--without-x11,libx11"
PACKAGECONFIG[zlib] = "--with-z,--without-z,zlib"
PACKAGECONFIG[systemd] = "--with-systemd,--without-systemd,systemd"

EXTRA_OECONF += "\
    ac_cv_file_bridges_bridge_softmix_include_hrirs_h=no \
    "

MENUSELECT_OECONF = "\
    CC='${BUILD_CC}' \
    CXX='${BUILD_CXX}' \
    CFLAGS='${BUILD_CFLAGS}' \
    CXXFLAGS='${BUILD_CXXFLAGS}' \
    LDFLAGS='${BUILD_LDFLAGS}' \
"

do_configure_menuselect[dirs] = "${B}/menuselect"
do_configure_menuselect() {
	./configure ${MENUSELECT_OECONF}
}
addtask do_configure_menuselect after do_configure before do_compile

do_install:append() {
	install -D -p -m 0644 ${WORKDIR}/asterisk.tmpfiles ${D}${libdir}/tmpfiles.d/asterisk.conf
	install -D -p -m 0644 ${WORKDIR}/asterisk.socket   ${D}${systemd_system_unitdir}/asterisk.socket
	install -D -p -m 0644 ${WORKDIR}/asterisk.service  ${D}${systemd_system_unitdir}/asterisk.service

	rm -rf ${D}/var/run
	rm -rf ${D}/var/log
	rm -rf ${D}/tmp
}

FILES:${PN} += "\
    ${systemd_system_unitdir}/asterisk*.* \
    ${libdir}/tmpfiles.d/asterisk.conf \
"
RDEPENDS:${PN} += "bash"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN}  = "--system --home-dir /var/lib/asterisk -g asterisk --shell /bin/false asterisk"
GROUPADD_PARAM:${PN} = "--system asterisk"

SYSTEMD_SERVICE:${PN} = "${PN}.service"

PACKAGES =+ "${PN}-sounds-en"
FILES:${PN}-sounds-en = "${datadir}/asterisk/sounds/en"
