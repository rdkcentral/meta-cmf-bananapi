do_install_append(){

   install -d ${D}${sbindir}
   sed -i '/brctl addif brlan0 lan0/d' ${D}${sbindir}/init-bridge.sh
sed -i '/model/a \
if [ ! -d /nvram/secure ]; then \
    mkdir -p /nvram/secure \
fi' ${D}${sbindir}/init-bridge.sh
}
