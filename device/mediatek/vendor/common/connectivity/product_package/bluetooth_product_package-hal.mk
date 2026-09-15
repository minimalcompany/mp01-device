# Bluetooth Configuration

##########################
#### native library ######
##########################
ifeq ($(strip $(MTK_BT_SUPPORT)), yes)
ifeq ($(MTK_PRODUCT_LINE), tablet)
  ifeq ($(strip $(MTK_BT_CHIP_7XXX_SUPPORT)), yes)
    PRODUCT_PACKAGES += libbt-vendor
    PRODUCT_PACKAGES += libbluetooth_mtk
    PRODUCT_PACKAGES += boots_srv
    PRODUCT_PACKAGES += boots
    PRODUCT_PACKAGES += picus
  else
    PRODUCT_PACKAGES += libbt-vendor
    PRODUCT_PACKAGES += libbluetooth_mtk
    PRODUCT_PACKAGES += libbluetooth_mtk_pure
    PRODUCT_PACKAGES += libbluetoothem_mtk
    PRODUCT_PACKAGES += libbluetooth_relayer
    PRODUCT_PACKAGES += libbluetooth_hw_test
    PRODUCT_PACKAGES += autobt
  endif
else
  PRODUCT_PACKAGES += libbt-vendor
  PRODUCT_PACKAGES += libbluetooth_mtk
  PRODUCT_PACKAGES += libbluetooth_mtk_pure
  PRODUCT_PACKAGES += libbluetoothem_mtk
  PRODUCT_PACKAGES += libbluetooth_relayer
  PRODUCT_PACKAGES += libbluetooth_hw_test
  PRODUCT_PACKAGES += autobt
endif
endif

# BT_FW.cfg
cfg_folder := vendor/mediatek/proprietary/hardware/connectivity/bluetooth/driver/mt66xx
ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/BT_FW.cfg),)
  PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
else
  PRODUCT_COPY_FILES += $(cfg_folder)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
endif
