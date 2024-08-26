include ccsp_common_bananapi.inc

do_install_append () {
                if ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'true', 'false', d)}; then
                   install -m 0755 ${S}/../xb6/jst/wireless_network_configuration_onewifi.jst ${D}/usr/www2/wireless_network_configuration.jst
                   install -m 0755 ${S}/../xb6/jst/wireless_network_configuration_edit_onewifi.jst ${D}/usr/www2/wireless_network_configuration_edit.jst
                   install -m 0755 ${S}/../xb6/jst/actionHandler/ajaxSet_wireless_network_configuration_onewifi.jst ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration.jst
                   install -m 0755 ${S}/../xb6/jst/actionHandler/ajaxSet_wireless_network_configuration_edit_onewifi.jst ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_edit.jst
                   install -m 0755 ${S}/jst/actionHandler/ajaxSet_wireless_network_configuration_redirection_onewifi.jst ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_redirection.jst
                   install -m 0755 ${S}/jst/actionHandler/ajaxSet_wizard_step2_onewifi.jst ${D}/usr/www2/actionHandler/ajaxSet_wizard_step2.jst
                   install -m 0755 ${S}/jst/actionHandler/ajaxSet_wps_config_onewifi.jst ${D}/usr/www2/actionHandler/ajaxSet_wps_config.jst
                fi
}
