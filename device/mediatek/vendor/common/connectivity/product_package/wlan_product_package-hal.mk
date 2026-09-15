# For Layer decoupling 2.0
# Wlan Configuration for user space module only

# HAL combinations
WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 2}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{AP}, 1},}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{AP}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{P2P}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{NAN}, 1}}

PRODUCT_PACKAGES += wlan_assistant

# sigma tool
SIGMA_SRC_DIR := vendor/mediatek/proprietary/hardware/connectivity/sigma/mediatek
SIGMA_OUT_DIR := $(PRODUCT_OUT)/testcases/sigma
PRODUCT_PACKAGES += libwfadut_static
PRODUCT_PACKAGES += wfa_dut
PRODUCT_PACKAGES += wfa_ca
PRODUCT_PACKAGES += wfa_con
PRODUCT_PACKAGES += mtk_inband_cmd.sh

# wifitest tool
PRODUCT_PACKAGES_DEBUG += wifitest

# let vendor layer aware WAPI
ifneq ($(wildcard vendor/mediatek/proprietary/hardware/connectivity/wapi-v2*),)
MTK_WAPI_SUPPORT := yes
endif
