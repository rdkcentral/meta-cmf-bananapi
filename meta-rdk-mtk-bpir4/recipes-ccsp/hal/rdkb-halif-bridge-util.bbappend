CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', ' -DFEATURE_RNDIS_HAL', '', d)}"
