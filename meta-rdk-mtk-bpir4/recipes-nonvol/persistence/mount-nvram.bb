DESCRIPTION = "Mounting nvram partition for storing customized data"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

COMPATIBLE_MACHINE  = "^filogic$"

inherit deploy

PROVIDES = "mount-nvram"

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

# also get rid of the default dependency added in bitbake.conf
# since there is no 'main' package generated (empty)
RDEPENDS_${PN}-dev = ""

RDEPENDS:${PN} = "bash"
INSANE_SKIP:${PN} = "host-user-contaminated"

SRC_URI = " \
      file://mount-nvram.sh \
      file://mount-nvram.service \
      "

do_install() {
      echo "Installing service and script files."
      mkdir -p ${D}${base_libdir}/rdk
      install -m 0777 ${WORKDIR}/mount-nvram.sh ${D}${base_libdir}/rdk/
      mkdir -p ${D}${systemd_unitdir}/system
      install -m 0644 ${WORKDIR}/mount-nvram.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} = " \
      ${base_libdir}/rdk/mount-nvram.sh \
      ${systemd_unitdir}/system/mount-nvram.service \
      "

SYSTEMD_SERVICE_${PN} = "mount-nvram.service"
