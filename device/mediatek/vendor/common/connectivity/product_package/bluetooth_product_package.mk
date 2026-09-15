$(warning [bt_drv][bluetooth_product_package] LINUX_KERNEL_VERSION = $(LINUX_KERNEL_VERSION))
# Bluetooth Configuration
ifeq ($(strip $(MTK_BT_SUPPORT)), yes)
ifneq ($(filter MTK_MT76%, $(MTK_BT_CHIP)),)
  PRODUCT_PACKAGES += libbt-vendor
  PRODUCT_PACKAGES += libbluetooth_mtk
  PRODUCT_PACKAGES += boots_srv
  PRODUCT_PACKAGES += boots
  PRODUCT_PACKAGES += picus
  PRODUCT_PACKAGES += btmtksdio.ko
  cfg_folder := vendor/mediatek/proprietary/hardware/connectivity/bluetooth/driver/mt76xx/config

  # bt.cfg
  ifeq (MTK_MT7668, $(MTK_BT_CHIP))
  ifneq ($(wildcard $(cfg_folder)/mt7668/bt.cfg),)
    PRODUCT_COPY_FILES += $(cfg_folder)/mt7668/bt.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/bt.cfg:mtk
  endif
  endif
  ifeq (MTK_MT7663, $(MTK_BT_CHIP))
  ifneq ($(wildcard $(cfg_folder)/mt7663/bt.cfg),)
    PRODUCT_COPY_FILES += $(cfg_folder)/mt7663/bt.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/bt.cfg:mtk
  endif
  endif
else
  PRODUCT_PACKAGES += libbt-vendor
  PRODUCT_PACKAGES += libbluetooth_mtk
  PRODUCT_PACKAGES += libbluetooth_mtk_pure
  PRODUCT_PACKAGES += libbluetoothem_mtk
  PRODUCT_PACKAGES += libbluetooth_relayer
  PRODUCT_PACKAGES += libbluetooth_hw_test
  PRODUCT_PACKAGES += autobt

  # bt driver
  BT_PLAT := $(patsubst MTK_CONSYS_MT%,%,$(strip $(MTK_BT_CHIP)))
  BT_PLAT_CONNAC20_SERIES := 6885 6893 6877 6983 6879 6895
  ifneq ($(filter $(BT_PLAT), $(BT_PLAT_CONNAC20_SERIES)),)
    $(warning [bt_drv][bluetooth_product_package]  PRODUCT_PACKAGES = bt_drv_$(BT_PLAT).ko)
    PRODUCT_PACKAGES += bt_drv_$(BT_PLAT).ko
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bt.platform=$(BT_PLAT)
  else
    $(warning [bt_drv][bluetooth_product_package]  PRODUCT_PACKAGES = bt_drv_connac1x)
    PRODUCT_PACKAGES += bt_drv_connac1x.ko
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bt.platform=connac1x
  endif
endif
endif


# BT_FW.cfg
cfg_folder := vendor/mediatek/proprietary/hardware/connectivity/bluetooth/driver/mt66xx
ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/BT_FW.cfg),)
  PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
else
  PRODUCT_COPY_FILES += $(cfg_folder)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
endif

##########################
#### fw binary ###########
##########################
CHIP_ID := $(patsubst MTK_CONSYS_MT%,%,$(strip $(MTK_BT_CHIP)))
CHIP_ID_6885_SERIES := 6885 6893
CHIP_ID_6877_SERIES := 6877
CHIP_ID_6983_SERIES := 6983 6879 6895

BT_CFG_PATH := vendor/mediatek/proprietary/hardware/connectivity/firmware/rom_patch
################################################################
LOCAL_FIRMWARE_FLAVOR     = $(CHIP_ID)
LOCAL_CASAN_FLAVOR_FILTER = 6983

ifeq ($(filter $(LOCAL_FIRMWARE_FLAVOR), $(LOCAL_CASAN_FLAVOR_FILTER)),)
ifneq ($(filter $(CHIP_ID), $(CHIP_ID_6983_SERIES)),)
    # Use casan folder, only internal load
    ifneq ($(wildcard vendor/mediatek/internal/mtklog_enable),)
        ifneq ($(filter %san, $(MTK_TARGET_PROJECT) $(VEXT_TARGET_PROJECT)),)
            BT_CFG_PATH := $(BT_CFG_PATH)/casan
        endif
    endif
endif
endif
################################################################

# 6885 6893
ifneq ($(filter $(CHIP_ID), $(CHIP_ID_6885_SERIES)),)
  BT_CHIP := soc3_0
  MCU_RAM_PATCH := $(BT_CHIP)_ram_mcu_e1_hdr.bin
  MCU_RAM_1_PATCH := $(BT_CHIP)_ram_mcu_1_1_hdr.bin
  MCU_RAM_1A_PATCH := $(BT_CHIP)_ram_mcu_1a_1_hdr.bin
  #MCU_RAM_1B_PATCH := $(BT_CHIP)_ram_mcu_1b_1_hdr.bin
  BT_RAM_1_PATCH := $(BT_CHIP)_ram_bt_1_1_hdr.bin
  BT_RAM_1A_PATCH := $(BT_CHIP)_ram_bt_1a_1_hdr.bin
  #BT_RAM_1B_PATCH := $(BT_CHIP)_ram_bt_1b_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_1_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_1_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_1A_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_1A_PATCH):mtk
  #PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_1B_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_1B_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_1_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_1_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_1A_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_1A_PATCH):mtk
  #PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_1B_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_1B_PATCH):mtk
endif

# 6877
ifneq ($(filter $(CHIP_ID), $(CHIP_ID_6877_SERIES)),)
  MCU_RAM_PATCH := soc5_0_ram_mcu_1_1_hdr.bin
  BT_RAM_PATCH := soc5_0_ram_bt_1_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_PATCH):mtk
  
  # 6877 flavor bin: MTK_SISO_SUPPORT
  ifeq ($(strip $(MTK_SISO_SUPPORT)), yes)
    MCU_RAM_PATCH := soc5_0_ram_mcu_1c_1_hdr.bin
    BT_RAM_PATCH := soc5_0_ram_bt_1c_1_hdr.bin
    PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_PATCH):mtk
    PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_PATCH):mtk
  endif
endif

# 6983 6879 6895
ifneq ($(filter $(CHIP_ID), $(CHIP_ID_6983_SERIES)),)
  MCU_RAM_PATCH := soc7_0_ram_mcu_1_1_hdr.bin
  BT_RAM_PATCH := soc7_0_ram_bt_1_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_PATCH):mtk

  MCU_RAM_FLAVOR_PATCH := soc7_0_ram_mcu_1a_1_hdr.bin
  BT_RAM_FLAVOR_PATCH := soc7_0_ram_bt_1a_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_FLAVOR_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_FLAVOR_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_FLAVOR_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_FLAVOR_PATCH):mtk

  MCU_RAM_FLAVOR_PATCH := soc7_0_ram_mcu_1b_1_hdr.bin
  BT_RAM_FLAVOR_PATCH := soc7_0_ram_bt_1b_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_FLAVOR_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_FLAVOR_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_FLAVOR_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_FLAVOR_PATCH):mtk
endif
