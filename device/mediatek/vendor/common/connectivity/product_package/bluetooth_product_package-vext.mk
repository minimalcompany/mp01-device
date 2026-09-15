# Bluetooth Configuration

##########################
#### driver ##############
##########################
BT_PLAT := $(patsubst MTK_CONSYS_MT%,%,$(strip $(MTK_BT_CHIP)))
BT_PLAT_CONNAC20_SERIES := 6885 6893 6877 6983 6879 6895

ifneq ($(filter $(BT_PLAT), $(BT_PLAT_CONNAC20_SERIES)),)
  MTK_OUT_OF_TREE_KERNEL_MODULES += bt_drv_$(BT_PLAT).ko
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bt.platform=$(BT_PLAT)
else
  MTK_OUT_OF_TREE_KERNEL_MODULES += bt_drv_connac1x.ko
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bt.platform=connac1x
endif

##### 7902 driver #####
ifeq ($(MTK_PRODUCT_LINE), tablet)
ifneq ($(filter MTK_MT7902, $(MTK_BT_CHIP)),)
  MTK_OUT_OF_TREE_KERNEL_MODULES += btmtk_sdio_unify.ko
endif
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

# 7902 firmware
ifeq ($(MTK_PRODUCT_LINE), tablet)
ifeq (MTK_MT7902, $(MTK_BT_CHIP))
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/BT_RAM_CODE_MT7902_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_RAM_CODE_MT7902_1_1_hdr.bin
endif

# 7902 cfg
cfg_folder_76xx := vendor/mediatek/proprietary/hardware/connectivity/bluetooth/driver/mt76xx/config
ifeq (MTK_MT7902, $(MTK_BT_CHIP))
ifneq ($(wildcard $(cfg_folder_76xx)/mt7902/bt_mt7902_1_1.cfg),)
    PRODUCT_COPY_FILES += $(cfg_folder_76xx)/mt7902/bt_mt7902_1_1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/bt_mt7902_1_1.cfg:mtk
    PRODUCT_COPY_FILES += $(cfg_folder_76xx)/mt7902/woble_setting_7902.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/woble_setting_7902.bin:mtk
	PRODUCT_COPY_FILES += $(cfg_folder_76xx)/mt7902/sdio_debug_7902.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/sdio_debug_7902.bin:mtk
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

  MCU_RAM_1D_PATCH := $(BT_CHIP)_ram_mcu_1d_1_hdr.bin
  BT_RAM_1D_PATCH := $(BT_CHIP)_ram_bt_1d_1_hdr.bin
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(MCU_RAM_1D_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MCU_RAM_1D_PATCH):mtk
  PRODUCT_COPY_FILES += $(BT_CFG_PATH)/$(BT_RAM_1D_PATCH):$(TARGET_COPY_OUT_VENDOR)/firmware/$(BT_RAM_1D_PATCH):mtk
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

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif
