include ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
          file://snmpd.conf \
          "

do_install:append(){
         install -m 0664 ${WORKDIR}/snmpd.conf ${D}/usr/ccsp/snmp/
         sed -i "s/<mibFile>Ccsp_SA-RG-MIB-MoCA.xml<\/mibFile>/<\!--<mibFile>Ccsp_SA-RG-MIB-MoCA.xml<\/mibFile>-->/g" ${D}/usr/ccsp/snmp/CcspMibList.xml
         sed -i "s/<mibFile>Ccsp_RDKB-RG-MIB-MoCA.xml<\/mibFile>/<\!--<mibFile>Ccsp_RDKB-RG-MIB-MoCA.xml<\/mibFile>-->/g" ${D}/usr/ccsp/snmp/CcspRDKBMibList.xml
}
