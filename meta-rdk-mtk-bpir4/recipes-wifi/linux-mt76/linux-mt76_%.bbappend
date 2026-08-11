#Installing header files from mac80211 before mt76 compiles
do_compile[depends] += "linux-mac80211:do_install" 
