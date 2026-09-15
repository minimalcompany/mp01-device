# Layer Decoupling 2.0 for Conninfra & WMT driver, vendor external Configuration

BUILD_WMT_CFG_L2 := false
BUILD_WMT_CFG_L1 := false
BUILD_MT6620 := false
BUILD_MT6628 := false
BUILD_MT6630 := false
BUILD_MT6632 := false
BUILD_MT7668 := false
BUILD_MT7663 := false
BUILD_MT7921 := false
BUILD_MT7902 := false
BUILD_ROM_V2_LM := false
BUILD_ROM_V4_BE := false
BUILD_SOC_V1_0 := false
BUILD_SOC_V2_0 := false
BUILD_CONNAC2 := false

# Codedump Mode
# 0=no coredump
# 1=coredump available in AEE's EE DB
# 2=coredump stored by stp_dump daemon

# Customer user load: 0
# MTK user/eng/userdebug load: 1
# Customer eng/userdebug load: 2
COREDUMP_MODE := 0

ifeq ($(strip $(MTK_COMBO_SUPPORT)), yes)
    cfg_folder := vendor/mediatek/proprietary/hardware/connectivity/combo_tool/cfg_folder
    init_folder := device/mediatek/vendor/common/connectivity/init

    # Copy Connsys rc files
    MT7XXX_CHIPS := MT7668 MT7663 MT7921 MT7902
    ifeq ($(filter $(MT76XX_CHIPS), $(MTK_COMBO_CHIP)),)
        PRODUCT_COPY_FILES += $(init_folder)/init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.common.rc
        PRODUCT_COPY_FILES += $(init_folder)/factory_init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.connectivity.common.rc
        PRODUCT_COPY_FILES += $(init_folder)/meta_init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.connectivity.common.rc
    endif

    ifneq ($(filter CONSYS_6885 CONSYS_6893 CONSYS_6877 CONSYS_6983 CONSYS_6879 CONSYS_6895, $(MTK_COMBO_CHIP)),)
        BUILD_CONNAC2 := true
    endif

    ifeq ($(BUILD_CONNAC2), true)
        # for connac2 project

        MTK_OUT_OF_TREE_KERNEL_MODULES += conninfra.ko
        PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/conninfra/init.conninfra.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.conninfra.rc

        ifeq ($(filter $(MT76XX_CHIPS), $(MTK_COMBO_CHIP)),)
            PRODUCT_COPY_FILES += $(init_folder)/init.connectivity.connac2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc
            PRODUCT_COPY_FILES += $(cfg_folder)/init_conninfra.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init_conninfra.rc
            PRODUCT_COPY_FILES += $(init_folder)/factory_init.connectivity.connac2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.connectivity.rc
            PRODUCT_COPY_FILES += $(init_folder)/meta_init.connectivity.connac2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.connectivity.rc
        endif

        ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/conninfra.cfg),)
            PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/conninfra.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/conninfra.cfg:mtk
        else
            ifneq ($(wildcard device/mediatek/$(MTK_REL_PLATFORM)/conninfra.cfg),)
                PRODUCT_COPY_FILES += device/mediatek/$(MTK_REL_PLATFORM)/conninfra.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/conninfra.cfg:mtk
            else
                PRODUCT_COPY_FILES += $(cfg_folder)/conninfra.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/conninfra.cfg:mtk
            endif
        endif
        ifneq ($(filter CONSYS_6983 CONSYS_6877 CONSYS_6879 CONSYS_6895, $(MTK_COMBO_CHIP)),)
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.connsys.dedicated.log.port=bt,wifi,ics,btmcu,wifimcu
        else
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.connsys.dedicated.log.port=bt,wifi
        endif
    else
        # for connac1 project

        ifeq ($(filter $(MT76XX_CHIPS), $(MTK_COMBO_CHIP)),)
            MTK_OUT_OF_TREE_KERNEL_MODULES += wmt_drv.ko
            PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/common/init.wmt_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wmt_drv.rc
        endif

        ifeq ($(filter $(MT76XX_CHIPS), $(MTK_COMBO_CHIP)),)
            PRODUCT_COPY_FILES += $(init_folder)/init.connectivity.connac1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc
            PRODUCT_COPY_FILES += $(cfg_folder)/init_connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init_connectivity.rc
            PRODUCT_COPY_FILES += $(init_folder)/factory_init.connectivity.connac1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.connectivity.rc
            PRODUCT_COPY_FILES += $(init_folder)/meta_init.connectivity.connac1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.connectivity.rc
        endif

        ENABLE_SP := false
        ifeq ($(ENABLE_SP), false)
            patch_folder := vendor/mediatek/proprietary/hardware/connectivity/firmware/rom_patch
        else
            SP_PATH := vendor/mediatek/proprietary/hardware/connectivity/firmware/rom_patch_sp*
            patch_folder := $(wildcard $(SP_PATH))
        endif

        ifneq ($(filter MT6620 MT6620E3,$(MTK_COMBO_CHIP)),)
            BUILD_MT6620 := true
            BUILD_WMT_CFG_L1 := true
        endif

        ifneq ($(filter MT6628,$(MTK_COMBO_CHIP)),)
            BUILD_MT6628 := true
            BUILD_WMT_CFG_L1 := true
        endif

        ifneq ($(filter MT6630,$(MTK_COMBO_CHIP)),)
            BUILD_MT6630 := true
            BUILD_WMT_CFG_L1 := true
        endif

        ifneq ($(filter MT6632,$(MTK_COMBO_CHIP)),)
            BUILD_MT6632 := true
            BUILD_WMT_CFG_L1 := true
        endif

        ifneq ($(filter MT7668,$(MTK_COMBO_CHIP)),)
            BUILD_MT7668 := true
        endif

        ifneq ($(filter MT7663,$(MTK_COMBO_CHIP)),)
            BUILD_MT7663 := true
        endif

        ifneq ($(filter MT7921,$(MTK_COMBO_CHIP)),)
            BUILD_MT7921 := true
        endif

        ifneq ($(filter MT7902,$(MTK_COMBO_CHIP)),)
            BUILD_MT7902 := true
        endif

        ifneq ($(filter CONSYS_6771,$(MTK_COMBO_CHIP)),)
            BUILD_ROM_V4_BE := true
            BUILD_WMT_CFG_L2 := true
            BUILD_STEP_GEN3_5 := true
        endif

        ifneq ($(filter CONSYS_6580 CONSYS_6739,$(MTK_COMBO_CHIP)),)
            BUILD_ROM_V2_LM := true
            BUILD_WMT_CFG_L2 := true
            BUILD_STEP_GEN2 := true
        endif

        ifneq ($(filter CONSYS_7623 CONSYS_8163 CONSYS_8167,$(MTK_COMBO_CHIP)),)
            BUILD_ROM_V2_LM := true
            BUILD_WMT_CFG_L2 := true
        endif

        ifneq ($(filter CONSYS_6761 CONSYS_6765 CONSYS_6768 CONSYS_6785 CONSYS_8168,$(MTK_COMBO_CHIP)),)
            BUILD_SOC_V1_0 := true
            BUILD_WMT_CFG_L2 := true
            BUILD_STEP_CONNAC := true
        endif

        ifneq ($(filter CONSYS_6779 CONSYS_6833 CONSYS_6853 CONSYS_6855 CONSYS_6873,$(MTK_COMBO_CHIP)),)
            BUILD_SOC_V2_0 := true
            BUILD_WMT_CFG_L2 := true
            BUILD_STEP_CONNAC := true
        endif

        ifneq ($(filter CONSYS_6789,$(MTK_COMBO_CHIP)),)
            BUILD_SOC_V2_0 := true
            BUILD_WMT_CFG_L2 := true
            BUILD_STEP_CONNAC := true
        endif

        ##### INSTALL WMT.CFG FOR COMBO CONFIG #####

        ifeq ($(BUILD_WMT_CFG_L1), true)
            PRODUCT_COPY_FILES += $(cfg_folder)/WMT.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/WMT.cfg:mtk
        endif

        ifeq ($(BUILD_WMT_CFG_L2), true)
            ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/WMT_SOC.cfg),)
                PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/WMT_SOC.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/WMT_SOC.cfg:mtk
            else ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/WMT_SOC.cfg),)
                PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/WMT_SOC.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/WMT_SOC.cfg:mtk
            else
                ifneq ($(wildcard device/mediatek/$(MTK_REL_PLATFORM)/WMT_SOC.cfg),)
                    PRODUCT_COPY_FILES += device/mediatek/$(MTK_REL_PLATFORM)/WMT_SOC.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/WMT_SOC.cfg:mtk
                else
                    PRODUCT_COPY_FILES += $(cfg_folder)/WMT_SOC.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/WMT_SOC.cfg:mtk
                endif
            endif
        endif

        ifeq ($(BUILD_MT6620), true)
            ifneq ($(filter mt6620_ant_m1,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m1.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m2,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m2.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m2.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m3,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m3.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m3.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m4,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m4.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m4.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m5,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m5.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m5.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m6,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m6.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m6.cfg:mtk
            endif

            ifneq ($(filter mt6620_ant_m7,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6620_ant_m7.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6620_ant_m7.cfg:mtk
            endif
        endif

        ifeq ($(BUILD_MT6628), true)
            ifneq ($(filter mt6628_ant_m1,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6628_ant_m1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6628_ant_m1.cfg:mtk
            endif

            ifneq ($(filter mt6628_ant_m2,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6628_ant_m2.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6628_ant_m2.cfg:mtk
            endif

            ifneq ($(filter mt6628_ant_m3,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6628_ant_m3.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6628_ant_m3.cfg:mtk
            endif

            ifneq ($(filter mt6628_ant_m4,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6628_ant_m4.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6628_ant_m4.cfg:mtk
            endif
        endif

        ifeq ($(BUILD_MT6630), true)
            ifneq ($(filter mt6630_ant_m1,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6630_ant_m1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_ant_m1.cfg:mtk
            endif

            ifneq ($(filter mt6630_ant_m2,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6630_ant_m2.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_ant_m2.cfg:mtk
            endif

            ifneq ($(filter mt6630_ant_m3,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6630_ant_m3.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_ant_m3.cfg:mtk
            endif

            ifneq ($(filter mt6630_ant_m4,$(CUSTOM_HAL_ANT)),)
                PRODUCT_COPY_FILES += $(cfg_folder)/mt6630_ant_m4.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_ant_m4.cfg:mtk
            endif
            PRODUCT_COPY_FILES += $(patch_folder)/mt6630_patch_e3_0_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_patch_e3_0_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/mt6630_patch_e3_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6630_patch_e3_1_hdr.bin:mtk
        endif

        ifeq ($(BUILD_MT6632), true)
            ifneq ($(filter mt6632_ant_m1,$(CUSTOM_HAL_ANT)),)
                ifeq ($(MTK_WLAN_PATH_SET), siso)
                    PRODUCT_COPY_FILES += $(cfg_folder)/mt6632_ant_m1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_ant_m1.cfg:mtk
                else ifeq ($(MTK_WLAN_PATH_SET), mimo)
                    PRODUCT_COPY_FILES += $(cfg_folder)/mt6632_ant_m2.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_ant_m1.cfg:mtk
                else ifeq ($(MTK_WLAN_PATH_SET), 2g4siso_5gmimo)
                    PRODUCT_COPY_FILES += $(cfg_folder)/mt6632_ant_m3.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_ant_m1.cfg:mtk
                else ifeq ($(MTK_WLAN_PATH_SET), 2g4mimo_5gsiso)
                    PRODUCT_COPY_FILES += $(cfg_folder)/mt6632_ant_m4.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_ant_m1.cfg:mtk
                else
                    PRODUCT_COPY_FILES += $(cfg_folder)/mt6632_ant_m1.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_ant_m1.cfg:mtk
                endif
            endif
            PRODUCT_COPY_FILES += $(patch_folder)/mt6632_patch_e3_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt6632_patch_e3_hdr.bin:mtk
        endif

        ifeq ($(BUILD_MT7668), true)
            PRODUCT_COPY_FILES += $(patch_folder)/mt7668_patch_e2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt7668_patch_e2_hdr.bin:mtk
        endif

        ifeq ($(BUILD_MT7663), true)
            PRODUCT_COPY_FILES += $(patch_folder)/mt7663_patch_e2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt7663_patch_e2_hdr.bin:mtk
        endif

        ifeq ($(BUILD_MT7921), true)
            PRODUCT_COPY_FILES += $(patch_folder)/WIFI_MT7961_patch_mcu_1_2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_MT7961_patch_mcu_1_2_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/BT_RAM_CODE_MT7961_1_2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_RAM_CODE_MT7961_1_2_hdr.bin:mtk
        endif

        ifeq ($(BUILD_MT7902), true)
            PRODUCT_COPY_FILES += $(patch_folder)/BT_RAM_CODE_MT7902_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_RAM_CODE_MT7902_1_1_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/WIFI_MT7902_patch_mcu_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_MT7902_patch_mcu_1_1_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/WIFI_MT7902_patch_mcu_1_TEST_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_MT7902_patch_mcu_1_TEST_1_hdr.bin:mtk
        endif

        ifeq ($(BUILD_ROM_V2_LM), true)
            PRODUCT_COPY_FILES += $(patch_folder)/ROMv2_lm_patch_1_0_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv2_lm_patch_1_0_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/ROMv2_lm_patch_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv2_lm_patch_1_1_hdr.bin:mtk
        endif

        ifeq ($(BUILD_ROM_V4_BE), true)
            PRODUCT_COPY_FILES += $(patch_folder)/ROMv4_be_patch_1_0_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv4_be_patch_1_0_hdr.bin:mtk
            PRODUCT_COPY_FILES += $(patch_folder)/ROMv4_be_patch_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv4_be_patch_1_1_hdr.bin:mtk
        endif

        ifeq ($(BUILD_SOC_V1_0), true)
            ifneq ($(filter CONSYS_6768,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_patch_mcu_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_patch_mcu_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_mcu_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_mcu_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_bt_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_bt_1a_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6785,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_patch_mcu_2a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_patch_mcu_2a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_mcu_2a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_mcu_2a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_bt_2a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_bt_2a_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_8168,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_patch_mcu_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_patch_mcu_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_mcu_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_mcu_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_bt_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_bt_1a_1_hdr.bin:mtk
            else
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_patch_mcu_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_patch_mcu_1_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_mcu_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_mcu_1_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc1_0_ram_bt_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc1_0_ram_bt_1_1_hdr.bin:mtk
            endif

            ifneq ($(wildcard vendor/mediatek/proprietary/external/aee_config_internal/init.aee.mtk.system.rc),)
                COREDUMP_MODE := 1
            else
                COREDUMP_MODE := 2
            endif
        endif

        ifeq ($(BUILD_SOC_V2_0), true)
            ifneq ($(filter CONSYS_6873,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_patch_mcu_3b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_patch_mcu_3b_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_mcu_3b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_mcu_3b_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_bt_3b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_bt_3b_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6855,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1c_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1c_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1b_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1b_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1b_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6853,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_patch_mcu_3c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_patch_mcu_3c_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_mcu_3c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_mcu_3c_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_bt_3c_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_bt_3c_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_patch_mcu_3d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_patch_mcu_3d_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_mcu_3d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_mcu_3d_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_bt_3d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_bt_3d_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6833,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6789,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1d_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1d_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_mcu_1e_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_mcu_1e_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_2_ram_bt_1e_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_bt_1e_1_hdr.bin:mtk
            else ifneq ($(filter CONSYS_6779,$(MTK_COMBO_CHIP)),)
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_patch_mcu_3a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_patch_mcu_3a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_mcu_3a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_mcu_3a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_bt_3a_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_bt_3a_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_patch_mcu_3_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_patch_mcu_3_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_mcu_3_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_mcu_3_1_hdr.bin:mtk
                PRODUCT_COPY_FILES += $(patch_folder)/soc2_0_ram_bt_3_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_bt_3_1_hdr.bin:mtk
            endif

            ifneq ($(wildcard vendor/mediatek/proprietary/external/aee_config_internal/init.aee.mtk.system.rc),)
                COREDUMP_MODE := 1
            else
                COREDUMP_MODE := 2
            endif
        endif

        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.connsys.dedicated.log.port=bt,wifi,gps,mcu
    endif

    # Common for Connac2 and previous project
    ifneq ($(TARGET_BUILD_VARIANT),user)
        ifeq ($(strip $(MTK_AEE_SUPPORT)),yes)
            COREDUMP_MODE := 1
        else
            COREDUMP_MODE := 2
        endif

        ifeq (yes 0x20000000 userdebug,$(strip $(MTK_GMO_RAM_OPTIMIZE)) $(strip $(CUSTOM_CONFIG_MAX_DRAM_SIZE)) $(strip $(TARGET_BUILD_VARIANT)))
            COREDUMP_MODE := 0
        endif

        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.coredump.mode=$(COREDUMP_MODE)
    endif

    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.chipid=-1
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.patch.version=-1
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.connsys.dynamic.dump=0
    PRODUCT_PROPERTY_OVERRIDES += vendor.connsys.driver.ready=no
endif

ifeq ($(strip $(MTK_CONNSYS_DEDICATED_LOG_PATH)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.connsys.dedicated.log=1
endif

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
    PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif

$(call inherit-product-if-exists, $(LOCAL_PATH)/gps_product_package-vext.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/fm_product_package-vext.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/wlan_product_package-vext.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/bluetooth_product_package-vext.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/connfem_product_package-vext.mk)
