# For rat config
include device/mediatek/common/rsc/RatMode6mBase.mk

# Add common operator package properties
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.operator.optr=OP01 \
        ro.vendor.operator.spec=SPEC0200 \
        ro.vendor.operator.seg=SEGC \
        persist.vendor.operator.optr=OP01 \
        persist.vendor.operator.spec=SPEC0200 \
        persist.vendor.operator.seg=SEGC


# Set locale to simplified Chinese for China operator project
MTK_RSC_SYSTEM_PROPERTIES += persist.sys.locale=zh-Hans-CN

#For DSBP
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.mtk_md_sbp_custom_value=1

#For NR 5G icon display
MTK_RSC_VENDOR_PROPERTIES += \
        persist.vendor.radio.nr_display_rule=4 \
        persist.vendor.radio.jp_mode_timer1_delay_timer=30 \
        persist.vendor.radio.jp_mode_timer2_delay_timer=30 \
        persist.vendor.radio.nr_display_rule.2=4 \
        persist.vendor.radio.jp_mode_timer1_delay_timer.2=30 \
        persist.vendor.radio.jp_mode_timer2_delay_timer.2=30

# MAPC configuration file
ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/custom.conf),)
else ifneq ($(wildcard vendor/mediatek/proprietary/operator/SPEC/OP01/SPEC0200/SEGC/custom.conf),)
MTK_RSC_COPY_FILES += \
        vendor/mediatek/proprietary/operator/SPEC/OP01/SPEC0200/SEGC/custom.conf:SYSTEM:custom.conf
endif

MTK_RSC_MODULES += OP01Telephony

MTK_RSC_APKS += OP01Dialer:SYSTEM:app
MTK_RSC_APKS += Op01Contacts:SYSTEM_EXT:app
MTK_RSC_APKS += OP01Telecom:SYSTEM:app
MTK_RSC_APKS += OP01TeleService:SYSTEM:app
MTK_RSC_APKS += OP01Mms:SYSTEM:app
#MTK_RSC_APKS += OP01Email:SYSTEM_EXT:app
MTK_RSC_APKS += MtkEmail:SYSTEM_EXT:app
MTK_RSC_APKS += OP01Settings:SYSTEM_EXT:app
MTK_RSC_APKS += OP01SystemUI:SYSTEM_EXT:app
MTK_RSC_APKS += OP01SoundRecorder:SYSTEM:app

MTK_RSC_XML_OPTR := OP01_SPEC0200_SEGC

