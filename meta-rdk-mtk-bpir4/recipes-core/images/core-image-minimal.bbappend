MACHINE_FEATURES:remove:wrynose = "efi"

IMAGE_INSTALL:remove:wrynose = "pciutils usbutils"
IMAGE_INSTALL:remove:wrynose = "dbus-tools systemd-extra-utils"

PACKAGE_EXCLUDE += "systemd-mime"
ROOTFS_POSTPROCESS_COMMAND += " strip_extra_share; "

strip_extra_share() {
    rm -rf ${IMAGE_ROOTFS}/usr/share/mime
    rm -rf ${IMAGE_ROOTFS}/usr/share/X11
}
