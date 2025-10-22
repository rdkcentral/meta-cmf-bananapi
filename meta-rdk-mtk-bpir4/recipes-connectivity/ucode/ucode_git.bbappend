DEPENDS_remove = "ubus uci"
EXTRA_OECMAKE += " \
    -DUBUS_SUPPORT=OFF \
    -DUCI_SUPPORT=OFF \
"
