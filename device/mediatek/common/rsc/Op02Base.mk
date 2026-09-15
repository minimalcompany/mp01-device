# Add common operator package properties
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.operator.optr=OP02 \
        ro.vendor.operator.spec=SPEC0200 \
        ro.vendor.operator.seg=SEGA \
        persist.vendor.operator.optr=OP02 \
        persist.vendor.operator.spec=SPEC0200 \
        persist.vendor.operator.seg=SEGA

# For rat config
include device/mediatek/common/rsc/RatMode5mFddBase.mk

# Set locale to simplified Chinese for China operator project
MTK_RSC_SYSTEM_PROPERTIES += persist.sys.locale=zh-Hans-CN

# MAPC configuration file
ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/custom.conf),)
else ifneq ($(wildcard vendor/mediatek/proprietary/operator/SPEC/OP02/custom.conf),)
MTK_RSC_COPY_FILES += \
        vendor/mediatek/proprietary/operator/SPEC/OP02/custom.conf:SYSTEM:custom.conf
endif

#For DSBP
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.mtk_md_sbp_custom_value=0

# For network 5g icon
MTK_RSC_VENDOR_PROPERTIES += \
        persist.vendor.radio.nr_display_rule=4 \
        persist.vendor.radio.jp_mode_timer1_delay_timer=30 \
        persist.vendor.radio.jp_mode_timer2_delay_timer=30 \
        persist.vendor.radio.nr_display_rule.2=4 \
        persist.vendor.radio.jp_mode_timer1_delay_timer.2=30 \
        persist.vendor.radio.jp_mode_timer2_delay_timer.2=30

MTK_RSC_MODULES += OP02Telephony

#MTK_RSC_APKS += OP02Dialer:SYSTEM:app
MTK_RSC_APKS += OP02Settings:SYSTEM_EXT:app
MTK_RSC_APKS += OP02SystemUI:SYSTEM_EXT:app
MTK_RSC_APKS += OP02Mms:SYSTEM:app
MTK_RSC_APKS += OP02Stk:SYSTEM:priv-app
MTK_RSC_APKS += OP02StkOverlay:SYSTEM:overlay
MTK_RSC_APKS += OP02Telecom:SYSTEM:app

MTK_RSC_MODULES += mtkbootanimation
MTK_RSC_MODULES += libmtkbootanimation

MTK_RSC_XML_OPTR := OP02_SPEC0200_SEGA

