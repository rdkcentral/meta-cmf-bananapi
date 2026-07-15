MACHINE_FEATURES:remove = "efi"

IMAGE_INSTALL:remove = "pciutils usbutils"
IMAGE_INSTALL:remove = "dbus-tools systemd-extra-utils"
IMAGE_INSTALL:remove = "apparmor apparmor-utils"

PACKAGE_EXCLUDE += "systemd-mime"
ROOTFS_POSTPROCESS_COMMAND += " strip_extra_share; "

strip_extra_share() {
    rm -rf ${IMAGE_ROOTFS}/usr/share/mime
    rm -rf ${IMAGE_ROOTFS}/usr/share/X11
}
