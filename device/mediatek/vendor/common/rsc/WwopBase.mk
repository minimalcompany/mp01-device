include device/mediatek/vendor/common/OpBase.mk

# For CXP
MTK_RSC_VENDOR_PROPERTIES += \
    ro.vendor.mtk_carrierexpress_pack=wwop \
    persist.vendor.mtk_usp_switch_mode=1

# For DSBP
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.mtk_md_sbp_custom_value=0

# For MTK_MOBILE_MANAGEMENT
MTK_RSC_VENDOR_PROPERTIES += \
    ro.vendor.mtk_mobile_management=0

# MTK_PRIVACY_PROTECTION_LOCK
MTK_RSC_VENDOR_PROPERTIES += \
    ro.vendor.mtk_privacy_protection_lock=0

# MTK_WAPI_SUPPORT
MTK_RSC_VENDOR_PROPERTIES += \
    ro.vendor.mtk_wapi_support=0
