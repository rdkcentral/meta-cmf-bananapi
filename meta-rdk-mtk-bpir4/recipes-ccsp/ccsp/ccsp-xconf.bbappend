include ccsp_common_bananapi.inc

# Changed from hal-fwupgrade-header to hal-fwupgrade
DEPENDS += "hal-fwupgrade"
DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

