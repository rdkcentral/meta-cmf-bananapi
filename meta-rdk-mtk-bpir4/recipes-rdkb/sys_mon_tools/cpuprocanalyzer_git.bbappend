EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'CPUPROCANALYZER_BROADBAND', ' --enable-procanalyzer-broadband', '', d)}"
DEPENDS += "telemetry json-c"
 
CFLAGS:append = " -DPROCANALYZER_BROADBAND"
