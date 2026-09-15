# Add rilop capabilities
include device/mediatek/vendor/common/OpBase.mk

# For rat config
include device/mediatek/vendor/common/rsc/RatMode6mBase.mk

# Add common operator package properties
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.operator.optr=OP09 \
        ro.vendor.operator.spec=SPEC0212 \
        ro.vendor.operator.seg=SEGC \
        persist.vendor.operator.optr=OP09 \
        persist.vendor.operator.spec=SPEC0212 \
        persist.vendor.operator.seg=SEGC

# For CT Register
MTK_RSC_VENDOR_PROPERTIES += \
        ro.vendor.mtk_devreg_app=1 \
        ro.vendor.mtk_ct4greg_app=1

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
