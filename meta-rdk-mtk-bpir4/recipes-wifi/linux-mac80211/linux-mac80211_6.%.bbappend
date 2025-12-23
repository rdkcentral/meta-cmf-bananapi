FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','file://0001-Allow-to-cancel-CSA-if-requested-kernel_6_6.patch','file://0001-Allow-to-cancel-CSA-if-requested-kernel_5_4.patch', d)}" 
