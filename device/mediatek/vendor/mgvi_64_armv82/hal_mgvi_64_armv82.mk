HAL_TARGET_PROJECT := mgvi_64_armv82
HAL_BASE_PROJECT := mgvi_64_armv82
ifndef HAL_TARGET_PROJECT_FOLDER
HAL_TARGET_PROJECT_FOLDER := $(LOCAL_PATH)
endif
HAL_PROJECT_FOLDER := $(HAL_TARGET_PROJECT_FOLDER)
MTK_TARGET_PROJECT := $(HAL_TARGET_PROJECT)
MTK_BASE_PROJECT := $(HAL_BASE_PROJECT)
MTK_TARGET_PROJECT_FOLDER := $(HAL_TARGET_PROJECT_FOLDER)
MTK_PROJECT_FOLDER := $(HAL_PROJECT_FOLDER)

HAL_VENDOR_CONFIG_MK := $(HAL_TARGET_PROJECT_FOLDER)/VendorConfig.mk
include $(HAL_VENDOR_CONFIG_MK)
include $(wildcard $(HAL_TARGET_PROJECT_FOLDER)/RuntimeSwitchConfig.mk)
$(call inherit-product, $(HAL_TARGET_PROJECT_FOLDER)/device.mk)
include device/mediatek/vendor/common/mgvi.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mgvi_name=mgvi_64_armv82

ifndef SYS_TARGET_PROJECT
PRODUCT_BUILD_SYSTEM_IMAGE := false
PRODUCT_BUILD_PRODUCT_IMAGE := false
endif
PRODUCT_BUILD_USERDATA_IMAGE := true
PRODUCT_BUILD_VENDOR_IMAGE :=

PRODUCT_LOCALES := en_US zh_CN zh_TW es_ES pt_BR ru_RU fr_FR de_DE tr_TR vi_VN ms_MY in_ID th_TH it_IT ar_EG hi_IN bn_IN ur_PK fa_IR pt_PT nl_NL el_GR hu_HU tl_PH ro_RO cs_CZ ko_KR km_KH iw_IL my_MM pl_PL es_US bg_BG hr_HR lv_LV lt_LT sk_SK uk_UA de_AT da_DK fi_FI nb_NO sv_SE en_GB hy_AM zh_HK et_EE ja_JP kk_KZ sr_RS sl_SI ca_ES
PRODUCT_MANUFACTURER := alps
PRODUCT_NAME := hal_mgvi_64_armv82
PRODUCT_DEVICE := mgvi_64_armv82
PRODUCT_MODEL := mgvi_64_armv82
PRODUCT_POLICY := android.policy_phone
PRODUCT_BRAND := alps

