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
                else
                   install -m 0755 ${S}/../xb6/jst/wireless_network_configuration.jst ${D}/usr/www2/wireless_network_configuration.jst
                   install -m 0755 ${S}/../xb6/jst/wireless_network_configuration_edit.jst ${D}/usr/www2/wireless_network_configuration_edit.jst
                   install -m 0755 ${S}/../xb6/jst/actionHandler/ajaxSet_wireless_network_configuration.jst ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration.jst
                   install -m 0755 ${S}/../xb6/jst/actionHandler/ajaxSet_wireless_network_configuration_edit.jst ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_edit.jst
                fi
                install -m 0755 ${S}/../xb6/jst/at_a_glance.jst ${D}/usr/www2/at_a_glance.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_devices.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_services.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_port_forwarding.jst
                sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_allowed.jst
                sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_blocked.jst
                sed -i "s/\$clients_RSSI\[strtoupper(\$Host\[\$i.toString()\]\['PhysAddress'\])\]/\$Host\[\$i\]\['X_CISCO_COM_RSSI'\]/g" ${D}/usr/www2/connected_devices_computers.jst
}
