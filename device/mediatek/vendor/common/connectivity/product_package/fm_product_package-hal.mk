# lib
#PRODUCT_PACKAGES += libfmjni
ifeq ($(MTK_FM_TX_SUPPORT), yes)
    PRODUCT_PACKAGES += libfmtxjni
endif

# autofm
PRODUCT_PACKAGES_ENG += autofm

# hidl
#PRODUCT_PACKAGES += fm_hidl_service

FM_CHIPS_v1 := soc mt6627 mt6630 mt6631 mt6632 mt6635
FM_CHIPS_v2 := mt6630

FM_CFG_FILE := fm_cust.cfg
FM_CFG_PATH := vendor/mediatek/proprietary/hardware/connectivity/fmradio/config
PRODUCT_COPY_FILES += $(FM_CFG_PATH)/mt6635/$(FM_CFG_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(FM_CFG_FILE):mtk

PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v1),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v1_patch.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v1_patch.bin:mtk)
PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v1),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v1_coeff.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v1_coeff.bin:mtk)

PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v2),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v2_patch.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v2_patch.bin:mtk)
PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v2),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v2_coeff.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v2_coeff.bin:mtk)

# fm with tx support
PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v2),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v2_patch_tx.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v2_patch_tx.bin:mtk)
PRODUCT_COPY_FILES += $(foreach chip,$(FM_CHIPS_v2),\
    $(FM_CFG_PATH)/$(chip)/$(chip)_fm_v2_coeff_tx.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/$(chip)_fm_v2_coeff_tx.bin:mtk)
