# Example customization for barton-matter
# This shows how to customize the Matter configuration for your specific product

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://barton.zap \
    file://zzz_generated.tar.gz \
"

MATTER_ZAP_FILE := "${WORKDIR}/barton.zap"
# Adding the zzz_generated tarball to the SRC_URI will unpack it into WORKDIR
MATTER_ZZZ_GENERATED := "${WORKDIR}/zzz_generated"

# Set persistent storage location for production use
MATTER_CONF_DIR := "/nvram/icontrol"

# Export for tasks
export MATTER_ZAP_FILE
export MATTER_CONF_DIR
export MATTER_ZZZ_GENERATED
