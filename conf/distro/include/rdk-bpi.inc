# USP-PA Feature
DISTRO_FEATURES_append = " usppa"

DISTRO_FEATURES_append = " WanManagerUnificationEnable"

DISTRO_FEATURES_append = " rdkb_wan_manager"

DISTRO_FEATURES_append = " halVersion3"

DISTRO_FEATURES_append = " bridgeUtilsBin"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES_append = " OneWifi onewifi_integration"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

MACHINEOVERRIDES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6', ':kernel6-6', bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ':kernel6-12','',d), d)}"

DISTRO_FEATURES_append = " CPUPROCANALYZER_BROADBAND"

# RDKB-51565,RDKB-50795: [HAL] Cellular Hal Implementation
DISTRO_FEATURES_append = " rdkb_cellular_manager_mm"

DISTRO_FEATURES_append = " partner_default_ext"

#Enable SDcard image as default
DISTRO_FEATURES_append = " sdmmc"

DISTRO_FEATURE_append = " rdkb_voice_manager_dmltr104_v2"

DISTRO_FEATURE_append = " telco_voice_feature_enable_persist"

#PPP Feature
#DISTRO_FEATURES_append = "ppp-enabled"

#disabling lan0_as_wan to allow lan0 interface to come
DISTRO_FEATURES_remove = " lan0_as_wan"

#Need to enable below distro once required changes are merged 
#DISTRO_FEATURES_append = " EasyMesh"
#DISTRO_FEATURES_append = " with_alsap"
#DISTRO_FEATURES_append = " Em_Unittest"
PREFERRED_VERSION_go = "1.24.%"

#Enable below distro to build Easymesh and dependent Wi-Fi components from tip (AUTOREV) during CI validation
#DISTRO_FEATURES_append = " BuildFromTip"

#Enable wps support
DISTRO_FEATURES_append = " wps_support"

#Enable resource optimization
DISTRO_FEATURES_append = " resource_optimization"

#Enable kernel_6_6 support
DISTRO_FEATURES_append = " kernel6-6"
#DISTRO_FEATURES_append = " kernel6-12"

DISTRO_FEATURES_append = " CONFIG_IEEE80211BE"

DISTRO_FEATURES_append = " matter"
PREFERRED_VERSION_barton-matter = "1.4.2"

DISTRO_FEATURES_append = " generic_mlo"

#Enable the below DISTRO to enable Hybrid Hal(rndis/modem) for cellular devices
#DISTRO_FEATURES_append_broadband = " cellular_hybrid_support"

#Disable RDM for reference platform
#DISTRO_FEATURES_append = "RDM"

DISTRO_FEATURES_append = " dhcp_manager "
DISTRO_FEATURES_append = " rdkb_configurable_wan_interface"
#Enable remote debugger
DISTRO_FEATURES_append = " rrd"

#Enable MAP-T
DISTRO_FEATURES_append = " feature_mapt"
DISTRO_FEATURES_append = " nat46"
LINUXLIBCVERSION = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', '6.12%', bb.utils.contains('DISTRO_FEATURES','kernel6-6', '6.6%', '5.4%',d), d)}"

PREFERRED_VERSION_bluez5_kirkstone = "${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', '5.66', '5.82',d)}"

#Enable Core RDKB builds
#CORE_RDKB_ENABLED = "1"
#CORE_RDKB_TIER-1_ENABLED = "1"
#CORE_RDKB_TIER-2_ENABLED = "1"
#CORE_RDKB_TIER-3_ENABLED = "1"

#Enable RDKB Optional builds
#RDKB_OPTIONAL_ENABLED = "1"

#Optional components present in RDKB_OPT_PKGS(comment an entry to remove from optional)
RDKB_OPTIONAL_LIST = "${@' '.join(d.getVarFlags('RDKB_OPT_PKGS') or [])}"
RDKB_OPTIONAL_LIST[vardepvalue] = "${RDKB_OPTIONAL_LIST}"

# Including the Optional Components in below
#RDKB_OPT_PKGS[Test-and-diagnostic] = "test-and-diagnostic test-and-diagnostic-ccsp"
#RDKB_OPT_PKGS[WebUI] = "lighttpd ${@bb.utils.contains('DISTRO_FEATURES', 'bci', '', bb.utils.contains('DISTRO_FEATURES', 'webui_jst', 'jst ccsp-webui-jst', 'ccsp-webui-php', d), d)}"
#RDKB_OPT_PKGS[Platform-Manager] = "${@bb.utils.contains('DISTRO_FEATURES', 'pm_lan_mgr', 'platformmanager', '', d)}"
#RDKB_OPT_PKGS[Breakpad-wrapper] = "breakpad-wrapper"
#RDKB_OPT_PKGS[crashupload] = "crashupload"
#RDKB_OPT_PKGS[unified-wifi-mesh] = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', 'unified-wifi-mesh unified-wifi-mesh-cli', '', d)}"
#RDKB_OPT_PKGS[ieee1905] = "${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap', 'ieee1905-em', '', d)}"
#RDKB_OPT_PKGS[Telemetry_2] = "telemetry"
#RDKB_OPT_PKGS[RFC] = "rfc"
#RDKB_OPT_PKGS[rdkcertconfig] = "rdkcertconfig"
#RDKB_OPT_PKGS[webconfig] = "webconfig-framework ${@bb.utils.contains('DISTRO_FEATURES', 'webconfig_bin', 'webcfg', '', d)}"
#RDKB_OPT_PKGS[rdk-libunpriv] = "libunpriv"

# When Core=1,Optional=0 : Shouldn't comment below lines as these PKGS should be removed.
# When Core=1,Optional=1 : Below RDKB_OPT_PKGS should be considered/commented as per the requirement
RDKB_OPT_PKGS[Tr069] = "ccsp-tr069-pa ccsp-tr069-pa-ccsp"
RDKB_OPT_PKGS[cpuprocanalyzer] = "${@bb.utils.contains('DISTRO_FEATURES', 'CPUPROCANALYZER_BROADBAND', ' cpuprocanalyzer', '', d)}"
RDKB_OPT_PKGS[Speedtest] = "rdk-speedtest-cli"
RDKB_OPT_PKGS[rdk-oss-ssa] = "${@bb.utils.contains('DISTRO_FEATURES', 'rdk-oss-ssa', 'rdk-oss-ssa ecryptfs-utils', '', d)}"
RDKB_OPT_PKGS[usp-pa] = "${@bb.utils.contains('DISTRO_FEATURES', 'usppa', ' usp-pa', '', d)}"
RDKB_OPT_PKGS[dsm] = "dsm"
RDKB_OPT_PKGS[dobby] = "dobby crun"
RDKB_OPT_PKGS[WebPA] = "parodus2ccsp parodus start-parodus wdmp-c"
RDKB_OPT_PKGS[rdktelcovoicemanager] = "rdktelcovoicemanager"
RDKB_OPT_PKGS[hal-voice-asterisk] = "hal-voice-asterisk asterisk"
RDKB_OPT_PKGS[barton] = " cpcd otbr-agent bluez5-bluetoothd bt-host-cpc-hci-bridge barton"

# When Core=1,Optional=0 : Shouldn't comment below lines as these PKGS should be removed.
# When Core=1,Optional=1 : Below RDKB_OPT_PKGS should be commented unless we need.
RDKB_OPT_PKGS[ccsp-snmp-pa] = "ccsp-snmp-pa ccsp-snmp-pa-ccsp net-snmp"
RDKB_OPT_PKGS[fwupgrade-manager] = " rdk-fwupgrade-manager fw-upgrade"

# DISTRO_FEATURES of a component (removed when its RDKB_OPT_PKGS line is commented or optional is off). Keep these lines uncommented.
RDKB_OPT_FEATURES[barton] = "matter bluetooth bluez5"
RDKB_OPT_FEATURES[cpuprocanalyzer] = "CPUPROCANALYZER_BROADBAND"
RDKB_OPT_FEATURES[ccsp-snmp-pa] = "snmppa"
RDKB_OPT_FEATURES[usp-pa] = "usppa"
RDKB_OPT_FEATURES[rdk-oss-ssa] = "rdk-oss-ssa"

# All optional packages (keep in sync with RDKB_OPT_PKGS above). Any not installed by an active RDKB_OPT_PKGS line are removed
RDKB_OPT_ALL_PKGS = "ccsp-adv-security breakpad-wrapper ccsp-xdns cpuprocanalyzer crashupload dcmjsonparser harvester ccsp-home-security ccsp-hotspot ccsp-hotspot-kmod ieee1905-em rdk-interdevicemanager ipoe-health-check json-hal-lib rdk-ledmanager mesh-agent notify-comp platformmanager rdk-fwupgrade-manager fw-upgrade rdk-ppp-manager rdkcertconfig libunpriv rdk-oss-ssa ecryptfs-utils rfc xupnp ccsp-snmp-pa ccsp-snmp-pa-ccsp net-snmp memstress syslog-helper telemetry test-and-diagnostic test-and-diagnostic-ccsp unified-wifi-mesh unified-wifi-mesh-cli usp-pa webconfig-framework webcfg lighttpd jst ccsp-webui-jst ccsp-webui-php ccsp-webui-bci-jst ccsp-webui-bci-php ccsp-webui-csrf ccsp-xconf cpcd otbr-agent bluez5-bluetoothd bt-host-cpc-hci-bridge barton dobby crun dsm hal-voice-asterisk asterisk parodus2ccsp parodus start-parodus wdmp-c rdktelcovoicemanager ccsp-tr069-pa ccsp-tr069-pa-ccsp rdk-speedtest-cli"

# Always removed in Core (not part of the optional list)
RDKB_CORE_REMOVED_FEATURES = " bridgeUtilsBin"

# Core + Optional Enabled List
RDKB_OPT_ENABLED_LIST = "${@(d.getVar('RDKB_OPTIONAL_LIST')) if d.getVar('CORE_RDKB_ENABLED') == '1' and d.getVar('RDKB_OPTIONAL_ENABLED') == '1' else ''}"

# Core Enabled List
RDKB_OPT_DISABLED_LIST = "${@' '.join(c for c in d.getVar('RDKB_OPTIONAL_LIST').split() if c not in d.getVar('RDKB_OPT_ENABLED_LIST').split()) if d.getVar('CORE_RDKB_ENABLED') == '1' else ''}"

# Packages/features to be enabled or disabled
RDKB_OPT_PKGS_ENABLED = "${@' '.join((d.getVarFlag('RDKB_OPT_PKGS', c) or '') for c in d.getVar('RDKB_OPT_ENABLED_LIST').split())}"
RDKB_OPT_PKGS_DISABLED = "${@' '.join([p for p in d.getVar('RDKB_OPT_ALL_PKGS').split() if p not in d.getVar('RDKB_OPT_PKGS_ENABLED').split()]) if d.getVar('CORE_RDKB_ENABLED') == '1' else ''}"
RDKB_OPT_FEATURES_DISABLED = "${@' '.join([d.getVar('RDKB_CORE_REMOVED_FEATURES') or ''] + [(d.getVarFlag('RDKB_OPT_FEATURES', c) or '') for c in (d.getVarFlags('RDKB_OPT_FEATURES') or []) if c not in d.getVar('RDKB_OPT_ENABLED_LIST').split()]) if d.getVar('CORE_RDKB_ENABLED') == '1' else ''}"

#Flags used to avoid stale component usage
RDKB_OPT_PKGS_ENABLED[vardepvalue] = "${RDKB_OPT_PKGS_ENABLED}"
RDKB_OPT_PKGS_DISABLED[vardepvalue] = "${RDKB_OPT_PKGS_DISABLED}"

DISTRO_FEATURES:append = "${@bb.utils.contains('CORE_RDKB_ENABLED', '1', ' Core-RDKB', '', d)}"
DISTRO_FEATURES:append = "${@' Optional-RDKB' if d.getVar('RDKB_OPT_ENABLED_LIST').strip() else ''}"
DISTRO_FEATURES:remove = "${@bb.utils.contains('CORE_RDKB_ENABLED', '1', bb.utils.contains('RDKB_OPTIONAL_ENABLED', '1', ' ${RDKB_OPT_FEATURES_DISABLED}', ' ${RDKB_OPT_FEATURES_DISABLED}', d), '', d)}"
