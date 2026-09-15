# Bluetooth Configuration
$(warning [bt_drv][bluetooth_product_package-kernel] start, MTK_BT_SUPPORT[$(MTK_BT_SUPPORT)], MTK_BT_CHIP[$(MTK_BT_CHIP)], LINUX_KERNEL_VERSION[$(LINUX_KERNEL_VERSION)])

ifeq ($(strip $(MTK_BT_SUPPORT)), yes)
  # Connac1x Chip: mt6855, mt6789
    PRODUCT_PACKAGES += bt_drv_connac1x.ko
  ifneq ($(LINUX_KERNEL_VERSION), kernel-6.6)
  # 7902 driver
    PRODUCT_PACKAGES += btmtk_sdio_unify.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6885),)
    PRODUCT_PACKAGES += bt_drv_6885.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6893),)
    PRODUCT_PACKAGES += bt_drv_6893.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6877),)
    PRODUCT_PACKAGES += bt_drv_6877.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6983),)
    PRODUCT_PACKAGES += bt_drv_6983.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6879),)
    PRODUCT_PACKAGES += bt_drv_6879.ko
  endif
  ifneq ($(wildcard device/mediatek/mt6895),)
    PRODUCT_PACKAGES += bt_drv_6895.ko
  endif
endif

