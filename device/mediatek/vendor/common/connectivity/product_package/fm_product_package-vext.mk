FM_SOC_CHIPS  := 6580 6570 0633
FM_6627_CHIPS := 6572 6582 6592 8127 6752 0321 0335 0337 6735 8163 6755 0326 6757 6763 6739 6625
FM_6630_CHIPS := 6630 8167
FM_6631_CHIPS := 6758 6759 6771 6775 6765 6761 3967 6797 6768 6785 8168
FM_6632_CHIPS := 6632
FM_6635_CHIPS := 6873
FM_6631_6635_CHIPS := 6779 6781 6853 6833 6855 6789
FM_CONNAC2X_CHIPS := 6885 6886 6893 6877 6878 6879 6895 6897 6983

FM_CHIP_ID := $(patsubst consys_%,%,$(patsubst CONSYS_%,%,$(strip $(MTK_COMBO_CHIP))))
ifneq ($(filter $(FM_SOC_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := soc
else ifneq ($(filter $(FM_6627_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := mt6627
else ifneq ($(filter $(FM_6630_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := mt6630
else ifneq ($(filter $(FM_6631_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := mt6631
else ifneq ($(filter $(FM_6632_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := mt6632
else ifneq ($(filter $(FM_6635_CHIPS), $(FM_CHIP_ID)),)
    ifeq ($(strip $(MTK_CONSYS_ADIE)), MT6631)
        FM_CHIP := mt6631
    else
        FM_CHIP := mt6635
    endif
else ifneq ($(filter $(FM_6631_6635_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := mt6631_6635
else ifneq ($(filter $(FM_CONNAC2X_CHIPS), $(FM_CHIP_ID)),)
    FM_CHIP := connac2x
else
    ifeq ($(strip $(MTK_COMBO_CHIP)), MT6632)
        FM_CHIP := mt6632
    else ifeq ($(strip $(MTK_COMBO_CHIP)), MT6627)
        FM_CHIP := mt6627
    else ifeq ($(strip $(MTK_COMBO_CHIP)), MT6630)
        FM_CHIP := mt6630
    else
        FM_CHIP := mt6631_6635
    endif
endif

# select kernel module
ifneq ($(FM_CHIP),)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.fm_chipid=$(FM_CHIP)
endif

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.fm.platform=$(FM_CHIP)
MTK_OUT_OF_TREE_KERNEL_MODULES += fmradio_drv_$(FM_CHIP).ko
PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/fmradio/init.fmradio_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.fmradio_drv.rc

ifeq ($(strip $(MTK_FM_TX_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.fm_tx_support=1
endif

ifeq ($(strip $(MTK_FM_SHORT_ANTENNA_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.fm_short_antenna_support=1
endif

ifeq ($(strip $(MTK_FM_50KHZ_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.fm_50khz_support=1
endif

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
    PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif
