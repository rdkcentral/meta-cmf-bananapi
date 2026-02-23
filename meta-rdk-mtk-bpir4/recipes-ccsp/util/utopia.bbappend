DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

do_configure_prepend() {
    # Remove forward declarations
    sed -i '/void addMeshBhaulVlan();/d' ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/void createMeshVlan();/d'   ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/void addRadiusVlan();/d'    ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/void addIpcVlan();/d'       ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/void setMulticastMac();/d'  ${S}/source/service_multinet/service_multinet_main.c

    # Remove actual call sites
    sed -i '/addMeshBhaulVlan();/d' ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/createMeshVlan();/d'   ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/addRadiusVlan();/d'    ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/addIpcVlan();/d'       ${S}/source/service_multinet/service_multinet_main.c
    sed -i '/setMulticastMac();/d'  ${S}/source/service_multinet/service_multinet_main.c
}
