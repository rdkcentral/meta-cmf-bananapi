# Example customization for barton-matter
# This shows how to customize the Matter configuration for your specific product

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://barton.zap \
    file://barton.matter \
    file://zzz_generated.tar.gz \
"

MATTER_ZAP_FILE = "${WORKDIR}/barton.zap"
# Adding the zzz_generated tarball to the SRC_URI will unpack it into WORKDIR
MATTER_ZZZ_GENERATED = "${WORKDIR}/zzz_generated"

# Set persistent storage location for production use
MATTER_CONF_DIR = "/nvram/icontrol"
MATTER_IDL_FILE = "${WORKDIR}/barton.matter"
do_configure[network] = "1"

do_configure:append() {
    sed -i 's|"${chip_root}/third_party/jsoncpp"|"${chip_root}/third_party/jsoncpp",\
    "${chip_root}/src/lib/support/jsontlv"|' \
    ${S}/third_party/barton/BUILD.gn
}

do_compile[network] = "1"
