##########################################################################
# If not stated otherwise in this file or this component's LICENSE
# file the following copyright and licenses apply:
#
# Copyright 2024 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################
LIB_PRFIX := lib
LIB_NAME := $(LIB_PRFIX)$(NAME)
LIB_NAME_PKG := $(LIB_NAME).pc
LIB_NAME_REAL := $(LIB_NAME).so
LIB_NAME_LINKER := $(LIB_NAME_REAL).$(LIB_VERSION)
LIB_NAME_SO := $(LIB_NAME_REAL).$(LIB_VERSION_MAJOR)

LIB_OBJS := ../src/common/wpa_ctrl.o

#################part of `wpa_supplicant`#################
ifeq ($(WIFI_EMULATOR), true)
LIB_OBJS += ../wpa_supplicant/rrm_test.o
endif

LIB_OBJS += ../wpa_supplicant/sme.o
LIB_OBJS += ../wpa_supplicant/wmm_ac.o
LIB_OBJS += ../wpa_supplicant/rrm.o
LIB_OBJS += ../wpa_supplicant/wps_supplicant.o
LIB_OBJS += ../wpa_supplicant/wpas_glue.o
LIB_OBJS += ../wpa_supplicant/interworking.o
LIB_OBJS += ../wpa_supplicant/op_classes.o
LIB_OBJS += ../wpa_supplicant/events.o
LIB_OBJS += ../wpa_supplicant/hs20_supplicant.o
LIB_OBJS += ../wpa_supplicant/scan.o
LIB_OBJS += ../wpa_supplicant/bss.o
LIB_OBJS += ../wpa_supplicant/notify.o
LIB_OBJS += ../wpa_supplicant/wpa_supplicant.o
LIB_OBJS += ../wpa_supplicant/robust_av.o
LIB_OBJS += ../wpa_supplicant/bssid_ignore.o
LIB_OBJS += ../src/utils/bitfield.o

LIB_OBJS += ../wpa_supplicant/wnm_sta.o
LIB_OBJS += ../wpa_supplicant/config.o
LIB_OBJS += ../wpa_supplicant/gas_query.o
LIB_OBJS += ../wpa_supplicant/config_none.o
LIB_OBJS += ../wpa_supplicant/ctrl_iface.o
LIB_OBJS += ../wpa_supplicant/twt.o
LIB_OBJS += ../wpa_supplicant/offchannel.o
LIB_OBJS += ../wpa_supplicant/eap_register.o
LIB_OBJS += ../wpa_supplicant/ap.o
LIB_OBJS += ../wpa_supplicant/ctrl_iface_unix.o
LIB_OBJS += ../wpa_supplicant/mbo.o
LIB_OBJS += ../wpa_supplicant/wnm_sta.o

ifdef CONFIG_EAP_TLS
# EAP-TLS
CFLAGS += -DEAP_TLS
LIB_OBJS += ../src/eap_peer/eap_tls.o
SUPP_TLS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
ifdef CONFIG_EAP_TLSV1_3
CFLAGS += -DEAP_TLSV1_3
endif
endif

ifdef CONFIG_EAP_UNAUTH_TLS
# EAP-UNAUTH-TLS
CFLAGS += -DEAP_UNAUTH_TLS
ifndef CONFIG_EAP_TLS
LIB_OBJS += ../src/eap_peer/eap_tls.o
SUPP_TLS_FUNCS=y
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PEAP
# EAP-PEAP
CFLAGS += -DEAP_PEAP
LIB_OBJS += ../src/eap_peer/eap_peap.o
SUPP_TLS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_TTLS
# EAP-TTLS
CFLAGS += -DEAP_TTLS
LIB_OBJS += ../src/eap_peer/eap_ttls.o
SUPP_TLS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_MD5
# EAP-MD5
CFLAGS += -DEAP_MD5
LIB_OBJS += ../src/eap_peer/eap_md5.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_MSCHAPV2
# EAP-MSCHAPv2
CFLAGS += -DEAP_MSCHAPv2
LIB_OBJS += ../src/eap_peer/eap_mschapv2.o
LIB_OBJS += ../src/eap_peer/mschapv2.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_GTC
# EAP-GTC
CFLAGS += -DEAP_GTC
LIB_OBJS += ../src/eap_peer/eap_gtc.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_OTP
# EAP-OTP
CFLAGS += -DEAP_OTP
LIB_OBJS += ../src/eap_peer/eap_otp.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_LEAP
# EAP-LEAP
CFLAGS += -DEAP_LEAP
LIB_OBJS += ../src/eap_peer/eap_leap.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PSK
# EAP-PSK
CFLAGS += -DEAP_PSK
LIB_OBJS += ../src/eap_peer/eap_psk.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PAX
# EAP-PAX
CFLAGS += -DEAP_PAX
LIB_OBJS += ../src/eap_peer/eap_pax.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_SAKE
# EAP-SAKE
CFLAGS += -DEAP_SAKE
LIB_OBJS += ../src/eap_peer/eap_sake.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_GPSK
# EAP-GPSK
CFLAGS += -DEAP_GPSK
LIB_OBJS += ../src/eap_peer/eap_gpsk.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PWD
CFLAGS += -DEAP_PWD
LIB_OBJS += ../src/eap_peer/eap_pwd.o
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_IEEE8021X_EAPOL
# IEEE 802.1X/EAPOL state machines (e.g., for RADIUS authentication)
CFLAGS += -DIEEE8021X_EAPOL
LIB_OBJS += ../src/eapol_supp/eapol_supp_sm.o
LIB_OBJS += ../src/eap_peer/eap.o
LIB_OBJS += ../src/eap_peer/eap_methods.o
endif

ifdef SUPP_TLS_FUNCS
LIB_OBJS += ../src/eap_peer/eap_tls_common.o
endif

ifndef CONFIG_NO_WPA
LIB_OBJS += ../src/rsn_supp/wpa.o
LIB_OBJS += ../src/rsn_supp/preauth.o
LIB_OBJS += ../src/rsn_supp/pmksa_cache.o
LIB_OBJS += ../src/rsn_supp/wpa_ie.o
LIB_OBJS += ../src/common/wpa_common.o
else
CFLAGS += -DCONFIG_NO_WPA
endif

ifdef CONFIG_IEEE80211R
LIB_OBJS += ../src/rsn_supp/wpa_ft.o
endif

ifdef CONFIG_MBO
CFLAGS += -DCONFIG_MBO
LIB_OBJS += ../src/ap/mbo_ap.o
endif

#################part of `wpa_supplicant`#################

ifeq ($(call VERSION_CMP,$(LIB_VERSION_MAJOR),$(LIB_VERSION_MINOR),gt,2,9),true)
# This configuration has been removed and enabled by default since 2.10.
CFLAGS += -DCONFIG_IEEE80211W
endif

# Someone is incorrectly calling functions that were not included in the library.
ifdef CONFIG_SAE
ifndef NEED_AES_OMAC1
ifneq ($(CONFIG_TLS), openssl)
LIB_OBJS += -DCONFIG_OPENSSL_CMAC
endif
endif
ifdef NEED_SHA384
ifndef NEED_HMAC_SHA384_KDF
LIB_OBJS += ../src/crypto/sha384-kdf.o
endif
endif
ifdef NEED_SHA512
ifndef NEED_HMAC_SHA512_KDF
LIB_OBJS += ../src/crypto/sha512-kdf.o
endif
endif
endif

ifdef CONFIG_DRIVER_NL80211
ifdef CONFIG_DRIVER_BRCM
CFLAGS += -DCONFIG_DRIVER_BRCM
endif
endif

ifdef CONFIG_WPS
ifdef CONFIG_DRIVER_BRCM_MAP
CFLAGS += -DCONFIG_DRIVER_BRCM_MAP
endif
endif

ifdef ONE_WIFI
CFLAGS += -DRDK_ONEWIFI
endif

ifdef FEATURE_SUPPORT_RADIUSGREYLIST
CFLAGS += -DFEATURE_SUPPORT_RADIUSGREYLIST
LIB_OBJS += ../src/ap/greylist.o
endif

EXPORT_COMPILE_DEFINITIONS := $(filter -D%, $(CFLAGS)) -DHOSTAPD_$(subst .,_,$(LIB_VERSION))

CFLAGS += -fPIC -DPIC
CFLAGS += $(shell $(PKG_CONFIG) --cflags $(PKG_CONFIG_LIST))

_OBJS_VAR := LIB_OBJS
ifneq ("$(wildcard ../src/objs.mk)","")
include ../src/objs.mk
else
ROOTDIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROOTDIR := $(dir $(ROOTDIR:%../src/=%))../
PROJ := $(NAME)

_DIRS := $(BUILDDIR)/$(PROJ)
.PHONY: _make_dirs common-clean
_make_dirs:
	$(Q)mkdir -p $(_DIRS)

$(BUILDDIR)/$(PROJ)/src/%.o: $(ROOTDIR)src/%.c $(CONFIG_FILE) | _make_dirs
	$(Q)$(CC) -c -o $@ $(CFLAGS) $<

$(BUILDDIR)/$(PROJ)/%.o: %.c $(CONFIG_FILE) | _make_dirs
	$(Q)$(CC) -c -o $@ $(CFLAGS) $<

common-clean:
	$(Q)rm -rf $(BUILDDIR)/$(PROJ) $(BUILDDIR)/src

BUILDOBJ = $(patsubst %,$(BUILDDIR)/$(PROJ)/%,$(patsubst $(ROOTDIR)%,%,$(1)))

$(_OBJS_VAR) := $(call BUILDOBJ,$($(_OBJS_VAR)))
OBJS := $(call BUILDOBJ,$(OBJS))
_DIRS += $(dir $($(_OBJS_VAR)) $(OBJS))
endif

LIB_OBJS += $(OBJS)

# Do not install all header files. This will help resolve dl lookup errors at compile time.
LIB_HDRS := $(patsubst src/%,../src/%,$(patsubst $(BUILDDIR)/$(PROJ)/%,%,$(LIB_OBJS:%.o=%.h)))
#for sha
LIB_HDRS := $(shell echo "$(LIB_HDRS)" | sed -E 's/sha([0-9]+)-([a-zA-Z0-9]+)\.h/sha\1.h/g')
LIB_HDRS += ../src/ap/wpa_auth_i.h
ifdef CONFIG_DRIVER_NL80211_BRCM
LIB_HDRS += ../src/common/brcm_vendor.h
endif
LIB_HDRS += ../src/crypto/crypto.h
LIB_HDRS += ../src/crypto/tls.h
LIB_HDRS += ../src/common/defs.h
# Since 2.10, some headers (like `hostapd.h`) started including this file without checking `CONFIG_DPP`.
# Of course this doesn't lead to ld issues and etc., but it does cause compilation errors.
ifeq ($(call VERSION_CMP,$(LIB_VERSION_MAJOR),$(LIB_VERSION_MINOR),gt,2,9),true)
LIB_HDRS += ../src/common/dpp.h
endif
LIB_HDRS += ../src/common/eapol_common.h
ifdef CONFIG_MACSEC
LIB_HDRS += ../src/common/ieee802_1x_defs.h
endif
LIB_HDRS += ../src/common/ieee802_11_defs.h
LIB_HDRS += ../src/drivers/driver.h
LIB_HDRS += ../src/drivers/nl80211_copy.h
LIB_HDRS += ../src/eap_common/eap_defs.h
LIB_HDRS += ../src/eap_peer/eap_config.h
LIB_HDRS += ../src/fst/fst.h
ifdef CONFIG_SAE
LIB_HDRS += ../src/pasn/pasn_common.h
endif
ifndef CONFIG_NO_WPA
LIB_HDRS += ../src/rsn_supp/wpa_i.h
endif
LIB_HDRS += ../src/utils/build_config.h
LIB_HDRS += ../src/utils/includes.h
LIB_HDRS += ../src/utils/list.h
# We should not use `os.h` in our projects, as it is not part of the hostapd public API and is only used in translation units.
# WORKAROUND: since we started using it in our project, I'll add it here.
LIB_HDRS += ../src/utils/os.h
LIB_HDRS += ../src/wps/wps_defs.h

.PHONY: $(LIB_NAME) $(LIB_NAME_PKG) install_$(LIB_NAME) clean_$(LIB_NAME)

$(LIB_NAME): $(BUILDDIR)/$(LIB_NAME_LINKER)
$(LIB_NAME_PKG): $(BUILDDIR)/$(LIB_NAME_PKG)

$(BUILDDIR)/$(LIB_NAME_LINKER): $(LIB_OBJS)
	$(Q)$(CC) $(LDFLAGS) -shared -Wl,-soname,$(LIB_NAME_SO) -o $@ $^

$(BUILDDIR)/$(LIB_NAME_PKG):
	$(Q)echo "prefix=$(prefix)" > $@
	$(Q)echo "exec_prefix=\$${prefix}" >> $@
	$(Q)echo "includedir=\$${prefix}/include" >> $@
	$(Q)echo "libdir=\$${exec_prefix}/lib" >> $@
	$(Q)echo "" >> $@
	$(Q)echo "Name: $(LIB_NAME)" >> $@
	$(Q)echo "Description: User space shared lib for access points" >> $@
	$(Q)echo "Version: $(LIB_VERSION)" >> $@
	$(Q)echo "Requires: $(PKG_CONFIG_LIST)" >> $@
	$(Q)echo "Libs: -L\$${libdir} -l$(NAME)" >> $@
	$(Q)echo "Libs.private: $(LIBS)" >> $@
# We must add `-I\$${includedir}/$(PN)/src/utils` to the include path because some `libhostapd` headers are included without the full path.
	$(Q)echo "Cflags: -I\$${includedir}/$(PN) -I\$${includedir}/$(PN)/src -I\$${includedir}/$(PN)/src/utils -I\$${includedir}/$(PN)/src/ap $(EXPORT_COMPILE_DEFINITIONS)" >> $@

install_$(LIB_NAME): $(LIB_NAME) $(LIB_NAME_PKG)
	$(Q)install -D -m 0644 $(BUILDDIR)/$(LIB_NAME_PKG) $(DESTDIR)$(libdir)/pkgconfig/$(LIB_NAME_PKG)
	$(Q)install -D -m 0755 $(BUILDDIR)/$(LIB_NAME_LINKER) $(DESTDIR)$(libdir)/$(LIB_NAME_LINKER)
	$(Q)for file in $(LIB_HDRS); do test -f $$file && install -D -m 0644 $$file $(DESTDIR)$(includedir)/$(PN)/$(notdir $(CURDIR))/$$file; done
	$(Q)ln -sf $(LIB_NAME_LINKER) $(DESTDIR)$(libdir)/$(LIB_NAME_SO)
	$(Q)ln -sf $(LIB_NAME_LINKER) $(DESTDIR)$(libdir)/$(LIB_NAME_REAL)

clean_$(LIB_NAME): common-clean
	$(Q)rm -rf $(BUILDDIR)/$(LIB_NAME_LINKER) $(BUILDDIR)/$(LIB_NAME_PKG)
