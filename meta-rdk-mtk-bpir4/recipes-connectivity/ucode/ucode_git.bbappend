<<<<<<< HEAD
DEPENDS_remove = "ubus"
EXTRA_OECMAKE += " \
    -DUBUS_SUPPORT=OFF \
=======
DEPENDS_remove = "ubus uci"
EXTRA_OECMAKE += " \
    -DUBUS_SUPPORT=OFF \
    -DUCI_SUPPORT=OFF \
>>>>>>> fc2be91 (RDKBACCL-1036: Remove the openwrt pieces in our rdk-b banana pi)
"

