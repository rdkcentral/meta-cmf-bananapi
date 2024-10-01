DEPENDS += "breakpad-wrapper"
LDFLAGS += "-lbreakpadwrapper"

LDFLAGS_append = " -lpthread -lcrypto"

