# For Layer decoupling 2.0
# Wlan Configuration for project

# sanity check
LD2_SUPPORT_CHIPS_CE := MT7902 MT7921
LD2_SUPPORT_CHIPS_SP  := CONSYS_6893 CONSYS_6983 CONSYS_6879 CONSYS_6895 CONSYS_6855 CONSYS_6789
LD2_SUPPORT_CHIPS := $(LD2_SUPPORT_CHIPS_SP) $(LD2_SUPPORT_CHIPS_CE)
ifeq ($(filter $(LD2_SUPPORT_CHIPS), $(MTK_COMBO_CHIP)),)
    $(error not support layer decoupling 2.0 for MTK_COMBO_CHIP=$(MTK_COMBO_CHIP))
endif

# chip/firmware configuration
wlan_patch_folder := vendor/mediatek/proprietary/hardware/connectivity/firmware/wlan
WLAN_CHIP_ID := $(patsubst consys_%,%,$(patsubst CONSYS_%,%,$(strip $(MTK_COMBO_CHIP))))

ifneq ($(filter $(LD2_SUPPORT_CHIPS_CE), $(MTK_COMBO_CHIP)),)
WLAN_CHIP_ID_CE := $(strip $(MTK_COMBO_CHIP))
endif

WLAN_BRANCH_2_2_SERIES := 6855 6789
WLAN_BRANCH_3_SERIES := 6893
WLAN_BRANCH_7_SERIES := 6983 6879 6895
ifneq ($(filter $(WLAN_BRANCH_7_SERIES), $(WLAN_CHIP_ID)),)
    WIFI_CHIP:= CONNAC2X2_SOC7_0
    WIFI_BRANCH_NAME := 7_0
    CONNAC_VER := 2_0
    WIFI_CHRDEV_VER := connac2
    DUTINFO_NAME := 6637_gen4m
else ifneq ($(filter $(WLAN_BRANCH_3_SERIES), $(WLAN_CHIP_ID)),)
    WIFI_CHIP:= CONNAC2X2_SOC3_0
    WIFI_BRANCH_NAME := 3_0
    CONNAC_VER := 2_0
    WIFI_CHRDEV_VER := connac2
    DUTINFO_NAME := 6635_gen4m
else ifneq ($(filter $(WLAN_BRANCH_2_2_SERIES), $(WLAN_CHIP_ID)),)
	WIFI_CHIP:= SOC2_1X1
	WIFI_BRANCH_NAME := 2_2
	CONNAC_VER := 1_0
else ifeq ($(filter $(LD2_SUPPORT_CHIPS_CE), $(WLAN_CHIP_ID_CE)),)
    $(error wrong chip for WLAN_CHIP_ID=$(WLAN_CHIP_ID))
endif

WLAN_IP_SET_1_SERIES := 6855 6789
WLAN_IP_SET_3_SERIES := 6893 6983 6879 6895
ifneq ($(filter $(WLAN_IP_SET_3_SERIES), $(WLAN_CHIP_ID)),)
    WIFI_IP_SET := 3
    ifeq ($(CONNAC_VER), 2_0)
        WIFI_IP_SET :=1
    endif
else ifneq ($(filter $(WLAN_IP_SET_1_SERIES), $(WLAN_CHIP_ID)),)
	WIFI_IP_SET := 1
endif
WIFI_ECO_VER := 1

ifneq ($(filter 6893, $(WLAN_CHIP_ID)),)
    ifeq ($(strip $(TARGET_PRODUCT)), vext_k6893v1_64_swrgo)
        WIFI_FLAVOR := d
    else ifeq ($(strip $(TARGET_PRODUCT)), vext_k6893v1_64_swrgo_hwasan)
        WIFI_FLAVOR := d
    else ifeq ($(strip $(TARGET_PRODUCT)), vext_k6893v1_64_swrgo_kasan)
        WIFI_FLAVOR := d
    else ifeq ($(strip $(TARGET_PRODUCT)), vext_k6893v1_64_swrgo_khwasan)
        WIFI_FLAVOR := d
    else
        WIFI_FLAVOR := a
    endif
else ifneq ($(filter 6879, $(WLAN_CHIP_ID)),)
    WIFI_FLAVOR := a
else ifneq ($(filter 6895, $(WLAN_CHIP_ID)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc7_0_1c_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc7_0_1c_1.bin
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc7_0_ram_wmmcu_1c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc7_0_ram_wmmcu_1c_1_hdr.bin
    WIFI_FLAVOR := b
else ifneq ($(filter 6855, $(WLAN_CHIP_ID)),)
	PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_2_1b_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_2_1b_1.bin
	PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_2_ram_wifi_1b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_wifi_1b_1_hdr.bin
	WIFI_FLAVOR := c
else ifneq ($(filter 6789, $(WLAN_CHIP_ID)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_2_1d_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_2_1d_1.bin
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_2_ram_wifi_1d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_wifi_1d_1_hdr.bin
    WIFI_FLAVOR := e
endif

################################################################
#filter flavor
LOCAL_FIRMWARE_FLAVOR     = $(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)
LOCAL_CASAN_FLAVOR_FILTER = 7_0_1

ifeq ($(filter $(LOCAL_FIRMWARE_FLAVOR), $(LOCAL_CASAN_FLAVOR_FILTER)),)
ifneq ($(filter $(WLAN_BRANCH_7_SERIES), $(WLAN_CHIP_ID)),)
    # Use casan folder, only internal load
    ifneq ($(wildcard vendor/mediatek/internal/mtklog_enable),)
        ifneq ($(filter %san, $(MTK_TARGET_PROJECT) $(VEXT_TARGET_PROJECT)),)
            wlan_patch_folder := $(wlan_patch_folder)/casan
        endif
    endif
endif
endif
################################################################

ifneq ($(filter $(WLAN_BRANCH_7_SERIES), $(WLAN_CHIP_ID)),)
	MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
	WIFI_MCU_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
else ifneq ($(filter $(WLAN_BRANCH_3_SERIES), $(WLAN_CHIP_ID)),)
	MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
	WIFI_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wifi_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
	WIFI_MCU_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
	WIFI_MCU_ROM_PATCH_FILE := soc$(WIFI_BRANCH_NAME)_patch_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
else ifneq ($(filter $(WLAN_BRANCH_2_2_SERIES), $(WLAN_CHIP_ID)),)
	MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
	WIFI_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wifi_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
else ifneq ($(filter MT7902, $(WLAN_CHIP_ID_CE)),)
	MY_SRC_FILE := WIFI_RAM_CODE_MT7902_1.bin
else ifneq ($(filter MT7921, $(WLAN_CHIP_ID_CE)),)
	MY_SRC_FILE := WIFI_RAM_CODE_MT7961_1.bin
endif

ifneq ($(wildcard $(wlan_patch_folder)/WIFI_RAM_CODE_$(WLAN_CHIP_ID)),)
    MY_SRC_FILE := WIFI_RAM_CODE_$(WLAN_CHIP_ID)
endif


ifneq ($(strip $(MY_SRC_FILE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(MY_SRC_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MY_SRC_FILE)
else
    $(error no firmware for project=$(MTK_TARGET_PROJECT) $(VEXT_TARGET_PROJECT), combo_chip=$(MTK_COMBO_CHIP), WLAN_CHIP_ID=$(WLAN_CHIP_ID))
endif

ifneq ($(strip $(WIFI_ROM_EMI_FILE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(WIFI_ROM_EMI_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(WIFI_ROM_EMI_FILE)
endif

ifneq ($(strip $(WIFI_MCU_ROM_EMI_FILE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(WIFI_MCU_ROM_EMI_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(WIFI_MCU_ROM_EMI_FILE)
endif

ifneq ($(strip $(WIFI_MCU_ROM_PATCH_FILE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(WIFI_MCU_ROM_PATCH_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(WIFI_MCU_ROM_PATCH_FILE)
endif

# driver configuration
ifneq ($(filter $(LD2_SUPPORT_CHIPS_SP), $(MTK_COMBO_CHIP)),)
ifeq ($(CONNAC_VER), 1_0)
    MTK_OUT_OF_TREE_KERNEL_MODULES += wmt_chrdev_wifi.ko
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.chrdev=wmt_chrdev_wifi
else
    MTK_OUT_OF_TREE_KERNEL_MODULES += wmt_chrdev_wifi_$(WIFI_CHRDEV_VER).ko
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.chrdev=wmt_chrdev_wifi_$(WIFI_CHRDEV_VER)
endif

MTK_OUT_OF_TREE_KERNEL_MODULES += wlan_drv_gen4m_$(WLAN_CHIP_ID).ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4m_$(WLAN_CHIP_ID)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.standalone.log=y
else ifneq ($(filter MT7902, $(WLAN_CHIP_ID_CE)),)
    MTK_OUT_OF_TREE_KERNEL_MODULES += wlan_mt7902_sdio_$(TARGET_BOARD_PLATFORM).ko
    MTK_OUT_OF_TREE_KERNEL_MODULES += wlan_sdio_reset.ko
else ifneq ($(filter MT7921, $(WLAN_CHIP_ID_CE)),)
    MTK_OUT_OF_TREE_KERNEL_MODULES += wlan_mt7961_pcie_$(TARGET_BOARD_PLATFORM).ko
endif

# sigma tool
SIGMA_SRC_DIR := vendor/mediatek/proprietary/hardware/connectivity/sigma/mediatek
SIGMA_OUT_DIR := $(PRODUCT_OUT)/testcases/sigma
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/release,$(SIGMA_OUT_DIR))
ifneq ($(filter $(WLAN_BRANCH_2_2_SERIES), $(WLAN_CHIP_ID)),)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6631_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6631_gen4m)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6635_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6635_gen4m)
else
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/$(DUTINFO_NAME),$(SIGMA_OUT_DIR)/DUTInfo)
endif
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/device/mobile/CertProgram,$(SIGMA_OUT_DIR)/scripts/CertProgram)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/device/mobile/scripts,$(SIGMA_OUT_DIR)/scripts)

#cfg file for CE
wlan_drv_config_folder_ce := vendor/mediatek/proprietary/hardware/connectivity/wlan/drv_config
wlan_drv_config_folder_cust_ce := vendor/mediatek/proprietary/custom/$(VEXT_TARGET_PROJECT)/drv_config
ifneq ($(filter MT7902, $(WLAN_CHIP_ID_CE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_MT7902_1_TEST.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_MT7902_1_TEST.bin:mtk
    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/mt7902_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/mt7902_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/mt7902_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/TxPwrLimit_MT79x1.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/EEPROM_MT7902_1.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/EEPROM_MT7902_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7902_1.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/EEPROM_MT7902_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7902_1.bin:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/regulatory.db),)
    	PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/firmware/regulatory.db:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/regulatory.db.p7s),)
	PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/firmware/regulatory.db.p7s:mtk
    endif
else ifneq ($(filter MT7921, $(WLAN_CHIP_ID_CE)),)
    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/mt7961_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/mt7961_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/mt7961_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/TxPwrLimit_MT79x1.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_folder_cust_ce)/EEPROM_MT7961_1.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_cust_ce)/EEPROM_MT7961_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7961_1.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder_ce)/EEPROM_MT7961_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7961_1.bin:mtk
    endif
endif

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif
