FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

OPENSYNC_VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-rpi.git;protocol=${CMF_GIT_PROTOCOL};branch=main;name=vendor;destsuffix=git/vendor/rpi"
OPENSYNC_VENDOR_URI += "file://updated_vendor_arch_to_support_bpi.patch;patchdir=../vendor/rpi"

DEPENDS_append = " rdk-logger"


do_compile_prepend_broadband(){
	cd ${WORKDIR}/git/vendor/rpi/
	rm -rf src
	cd -
}
FILES_${PN} += "${includedir}/src"
