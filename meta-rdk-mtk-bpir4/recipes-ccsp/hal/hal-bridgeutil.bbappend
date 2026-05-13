DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','libsyswrapper','',d)}"
