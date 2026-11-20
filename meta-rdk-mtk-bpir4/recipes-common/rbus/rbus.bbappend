#Following change is required for eSDK build creation
DEPENDS:remove = "${@bb.utils.contains('DISTRO_FEATURES', 'matter', 'linenoise', '', d)}"
DEPENDS:append = "${@bb.utils.contains('DISTRO_FEATURES', 'matter', ' barton-linenoise', '', d)}"
