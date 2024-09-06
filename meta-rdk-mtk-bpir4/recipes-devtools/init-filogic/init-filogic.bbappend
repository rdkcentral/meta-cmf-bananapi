do_install_append(){

   install -d ${D}${sbindir}
   sed -i '/brctl addif brlan0 lan0/d' ${D}${sbindir}/init-bridge.sh
}
