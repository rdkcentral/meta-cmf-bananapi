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
                   sed -i "/^After=/ s/$/ CcspPandMSsp.service/" ${D}${systemd_unitdir}/system/CcspWebUI.service
                fi
                install -m 0755 ${S}/../xb6/jst/at_a_glance.jst ${D}/usr/www2/at_a_glance.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_devices.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_services.jst
                sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_port_forwarding.jst
                sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_allowed.jst
                sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_blocked.jst
                sed -i "s/\$clients_RSSI\[strtoupper(\$Host\[\$i.toString()\]\['PhysAddress'\])\]/\$Host\[\$i\]\['X_CISCO_COM_RSSI'\]/g" ${D}/usr/www2/connected_devices_computers.jst
                sed -i '/<?%if (strpos($partnerId, "sky-") !== false)/ s/sky-/RDKM/' ${D}/usr/www2/wireless_network_configuration_edit.jst
                rm -f  ${D}/usr/www2/cmn/syndication/device_pause_screen/device_pause_screen_comcast.js

                # Remove navigation entries for the pages being removed.
                find "${D}" -type f -name 'nav.jst' -exec sed -i \
                            -e '/moca\.jst/d' \
                            -e '/moca_diagnostics\.jst/d' \
                            -e '/mta_Line_Diagnostics\.jst/d' \
                            -e '/mta_Line_Status\.jst/d' \
                            -e '/mta_sip_packet_log\.jst/d' \
                            -e '/qos\.jst/d' \
                            -e '/Voip_Debug_GlobalParameter\.jst/d' \
                            -e '/Voip_Debug_ServiceProvider\.jst/d' \
                            -e '/Voip_SipAdvanced_ServiceProvider\.jst/d' \
                            -e '/Voip_SipBasic_GlobalParamaters\.jst/d' \
                            -e '/Voip_SipBasic_ServiceProvider\.jst/d' \
                            -e '/wizard_step1\.jst/d' \
                            -e '/wizard_step2\.jst/d' \
                            -e '/battery\.jst/d' \
                            -e '/callsignallog\.jst/d' \
                            -e '/voice_quality_metrics\.jst/d' \
                            -e '/voip_hidden\.jst/d' {} +

                # Remove MoCA indicators from At a Glance.
                find "${D}" -type f -name 'at_a_glance.jst' -exec sed -i \
                   -e '/MoCA On/d' \
                   -e '/MoCA Off/d' {} +

                # Remove the MoCA Edit link from Connection Status.
                find "${D}" -type f \( -name 'connection_status.jst' \
                -o -name 'connection_status_onewifi.jst' \) -exec sed -i \
                -e '/href="moca\.jst"/d' {} +


                find "${D}" -type f -name 'userbar.jst' -exec sed -i \
                 -e '/id="sta_moca"/d' {} +

                for f in moca.jst moca_diagnostics.jst mta_Line_Diagnostics.jst \
                         mta_Line_Status.jst mta_sip_packet_log.jst qos.jst \
                         Voip_Debug_GlobalParameter.jst Voip_Debug_ServiceProvider.jst \
                         Voip_SipAdvanced_ServiceProvider.jst Voip_SipBasic_GlobalParamaters.jst \
                         Voip_SipBasic_ServiceProvider.jst wizard_step1.jst wizard_step2.jst \
                         battery.jst callsignallog.jst voice_quality_metrics.jst voip_hidden.jst DPoE.jst DSXlog.jst; do
                         find ${D} -type f -name "$f" -delete
                done

}
