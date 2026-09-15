# Add rilop capabilities
include device/mediatek/vendor/common/OpBase.mk

# Add common operator package properties
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.operator.optr=OP02 \
        ro.vendor.operator.spec=SPEC0200 \
        ro.vendor.operator.seg=SEGA \
        persist.vendor.operator.optr=OP02 \
        persist.vendor.operator.spec=SPEC0200 \
        persist.vendor.operator.seg=SEGA

# For rat config
include device/mediatek/vendor/common/rsc/RatMode5mFddBase.mk

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
