# Wlan Configuration
ENABLE_SP := false
CONNAC_VER := 0_0
WLAN_GEN3_CHIPS := CONSYS_6797 CONSYS_6759 CONSYS_6758 CONSYS_6775 CONSYS_6771
WLAN_GEN4M_CHIPS := CONSYS_6765 CONSYS_6761 CONSYS_3967 CONSYS_6779 CONSYS_6768 CONSYS_6785 CONSYS_6885 CONSYS_6873 CONSYS_8168 CONSYS_6853 CONSYS_6893 CONSYS_6833 CONSYS_6877 CONSYS_6781 CONSYS_6983 CONSYS_6879 CONSYS_6895 CONSYS_6855 CONSYS_6789
WLAN_MT7XXX_CHIPS := MT7668 MT7663 MT7921 MT7902
ifeq ($(ENABLE_SP), false)
    wlan_patch_folder := vendor/mediatek/proprietary/hardware/connectivity/firmware/wlan
else
    WLAN_SP_PATH := vendor/mediatek/proprietary/hardware/connectivity/firmware/wlan_sp*
    $(warning [wlan] enable sp $(wildcard $(WLAN_SP_PATH)))
    wlan_patch_folder := $(wildcard $(WLAN_SP_PATH))
endif

ifneq ($(filter $(WLAN_MT7XXX_CHIPS), $(MTK_COMBO_CHIP)),)
    wlan_drv_config_folder := vendor/mediatek/proprietary/hardware/connectivity/wlan/drv_config
    ifeq ($(strip $(MTK_BASE_PROJECT)),)
        MTK_PROJECT_NAME := $(subst full_,,$(TARGET_PRODUCT))
    else
        MTK_PROJECT_NAME := $(MTK_BASE_PROJECT)
    endif
	wlan_drv_config_cust_folder := vendor/mediatek/proprietary/custom/$(MTK_PROJECT_NAME)/drv_config
endif

ifeq ($(strip $(MTK_COMBO_CHIP)), MT6632)
    MY_SRC_FILE := WIFI_RAM_CODE_$(MTK_COMBO_CHIP)
else ifeq ($(strip $(MTK_COMBO_CHIP)), MT6630)
    MY_SRC_FILE := WIFI_RAM_CODE_$(MTK_COMBO_CHIP)
else ifeq ($(strip $(MTK_COMBO_CHIP)), MT7668)
    MY_SRC_FILE := WIFI_RAM_CODE_$(MTK_COMBO_CHIP).bin
else ifeq ($(strip $(MTK_COMBO_CHIP)), MT7663)
    MY_SRC_FILE := WIFI_RAM_CODE_$(MTK_COMBO_CHIP).bin
else ifeq ($(strip $(MTK_COMBO_CHIP)), MT7921)
    MY_SRC_FILE := WIFI_RAM_CODE_MT7961_1.bin
else ifeq ($(strip $(MTK_COMBO_CHIP)), MT7902)
    MY_SRC_FILE := WIFI_RAM_CODE_$(MTK_COMBO_CHIP)_1.bin
else
    # remove prefix and subffix chars, only left numbers.
    WLAN_CHIP_ID := $(patsubst consys_%,%,$(patsubst CONSYS_%,%,$(strip $(MTK_COMBO_CHIP))))
    WIFI_WMT := y
    WIFI_EMI := y
    # WLAN_CHIP_ID exist
    ifneq ($(strip $(WLAN_CHIP_ID)),)
        # If your chip will share the same ram code with other chips, and the ram code name is not WIFI_RAM_CODE_SOC, \
          please give a specific chip id to WLAN_CHIP_ID, it will override the previous value of WLAN_CHIP_ID \
          for example:
        WLAN_6759_SERIES := 6758 6775 6771
        WLAN_6755_SERIES := 6757 6763 6739
        WLAN_6765_SERIES := 6765 6761
        WLAN_CONNAC_SERIES := $(WLAN_6765_SERIES) 3967 6779 6768 6785 6885 6873 8168 6853 6893 6833 6877 6781 6983 6879 6895 6855 6789
        ifneq ($(filter $(WLAN_6755_SERIES), $(WLAN_CHIP_ID)),)
            WLAN_CHIP_ID := 6755
        else ifneq ($(filter $(WLAN_6759_SERIES), $(WLAN_CHIP_ID)),)
            WLAN_CHIP_ID := 6759
        else ifneq ($(filter $(WLAN_CONNAC_SERIES), $(WLAN_CHIP_ID)),)
            WIFI_HIF := axi
            WLAN_BRANCH_1_SERIES := $(WLAN_6765_SERIES) 3967 6768 6785
            WLAN_BRANCH_2_SERIES := 6779 6873 6853
            WLAN_BRANCH_2_2_SERIES := 6833 6781 6855 6789
            WLAN_BRANCH_3_SERIES := 6885 6893
            WLAN_BRANCH_5_SERIES := 6877
            WLAN_BRANCH_7_SERIES := 6983 6879 6895
            ifneq ($(filter $(WLAN_BRANCH_7_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_CHIP:= CONNAC2X2_SOC7_0
                WIFI_BRANCH_NAME := 7_0
                CONNAC_VER := 2_0
                WIFI_WLAN_SERVICE:= yes
            else ifneq ($(filter $(WLAN_BRANCH_5_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_CHIP:= CONNAC2X2_SOC5_0
                WIFI_BRANCH_NAME := 5_0
                CONNAC_VER := 2_0
                WIFI_WLAN_SERVICE:= yes
            else ifneq ($(filter $(WLAN_BRANCH_3_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_CHIP:= CONNAC2X2_SOC3_0
                WIFI_BRANCH_NAME := 3_0
                CONNAC_VER := 2_0
                WIFI_WLAN_SERVICE:= yes
            else ifneq ($(filter $(WLAN_BRANCH_2_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_CHIP:= SOC2_2X2
                WIFI_BRANCH_NAME := 2_0
                CONNAC_VER := 1_0
                WIFI_WLAN_SERVICE:= yes
            else ifneq ($(filter $(WLAN_BRANCH_2_2_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_CHIP:= SOC2_1X1
                WIFI_BRANCH_NAME := 2_2
                CONNAC_VER := 1_0
                WIFI_WLAN_SERVICE:= yes
            else
                WIFI_CHIP:= CONNAC
                WIFI_BRANCH_NAME := 1_0
                CONNAC_VER := 1_0
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

            # 1:1X1_L, 2:1X1_P, 3:2X2_P
            WLAN_IP_SET_1_SERIES := $(WLAN_6765_SERIES) 6833 6855 6789
            WLAN_IP_SET_2_SERIES := 3967 6785 6781
            WLAN_IP_SET_3_SERIES := 6779 6885 6873 6853 6893 6877 6983 6879 6895
            ifneq ($(filter $(WLAN_IP_SET_3_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_IP_SET := 3

                ifeq ($(CONNAC_VER), 2_0)
                    WIFI_IP_SET :=1
                endif
            else ifneq ($(filter $(WLAN_IP_SET_2_SERIES), $(WLAN_CHIP_ID)),)
                WIFI_IP_SET := 2
            else
                WIFI_IP_SET := 1
            endif
            WIFI_ECO_VER := 1

            ifneq ($(filter 6768, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
            else ifneq ($(filter 6779, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_0_3_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_0_3_1.bin
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_0_ram_wifi_3_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_wifi_3_1_hdr.bin
            else ifneq ($(filter 6785, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
            else ifneq ($(filter 6873, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := b
            else ifneq ($(filter 8168, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
            else ifneq ($(filter 6853, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := c
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_0_3d_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_0_3d_1.bin
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_0_ram_wifi_3d_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_0_ram_wifi_3d_1_hdr.bin
            else ifneq ($(filter 6833, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_2_1_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_2_1_1.bin
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_2_ram_wifi_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_wifi_1_1_hdr.bin
            else ifneq ($(filter 6893, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
            else ifneq ($(filter 6781, $(WLAN_CHIP_ID)),)
                WIFI_FLAVOR := a
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/WIFI_RAM_CODE_soc2_2_2_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_soc2_2_2_1.bin
                PRODUCT_COPY_FILES += $(wlan_patch_folder)/soc2_2_ram_wifi_2_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/soc2_2_ram_wifi_2_1_hdr.bin
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
            else
                WIFI_FLAVOR :=
            endif
            ifneq ($(filter $(WLAN_6765_SERIES), $(WLAN_CHIP_ID)),)
                WLAN_CHIP_ID := 6765
            endif
            ifneq ($(filter $(WLAN_BRANCH_5_SERIES), $(WLAN_CHIP_ID)),)
                MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
                WIFI_MCU_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
            else ifneq ($(filter $(WLAN_BRANCH_3_SERIES), $(WLAN_CHIP_ID)),)
                MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
                WIFI_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wifi_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
                WIFI_MCU_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
                WIFI_MCU_ROM_PATCH_FILE := soc$(WIFI_BRANCH_NAME)_patch_wmmcu_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
            else
                MY_SRC_FILE := WIFI_RAM_CODE_soc$(WIFI_BRANCH_NAME)_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER).bin
                WIFI_ROM_EMI_FILE := soc$(WIFI_BRANCH_NAME)_ram_wifi_$(WIFI_IP_SET)$(WIFI_FLAVOR)_$(WIFI_ECO_VER)_hdr.bin
            endif
        endif
        ifneq ($(wildcard $(wlan_patch_folder)/WIFI_RAM_CODE_$(WLAN_CHIP_ID)),)
            MY_SRC_FILE := WIFI_RAM_CODE_$(WLAN_CHIP_ID)
        endif
    endif
endif

ifneq ($(strip $(MY_SRC_FILE)),)
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(MY_SRC_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MY_SRC_FILE)
else
    $(error no firmware for project=$(MTK_TARGET_PROJECT) $(VEXT_TARGET_PROJECT), combo_chip=$(MTK_COMBO_CHIP), WLAN_CHIP_ID=$(WLAN_CHIP_ID))
endif

ifeq ($(strip $(MTK_COMBO_CHIP)), MT6632)
    MY_SRC_FILE := WIFI_RAM_CODE2_$(strip $(MTK_COMBO_CHIP))
    PRODUCT_COPY_FILES += $(wlan_patch_folder)/$(MY_SRC_FILE):$(TARGET_COPY_OUT_VENDOR)/firmware/$(MY_SRC_FILE)
endif

ifeq ($(strip $(MTK_COMBO_CHIP)), MT7668)
    MY_SRC_FILE := WIFI_RAM_CODE2_SDIO_$(strip $(MTK_COMBO_CHIP)).bin
endif

#cfg file for CE
ifneq ($(filter MT7902, $(MTK_COMBO_CHIP)),)
    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/mt7902_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/mt7902_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/mt7902_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/TxPwrLimit_MT79x1.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/EEPROM_MT7902_1.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/EEPROM_MT7902_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7902_1.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/EEPROM_MT7902_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7902_1.bin:mtk
    endif
else ifneq ($(filter MT7921, $(MTK_COMBO_CHIP)),)
    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/mt7961_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/mt7961_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/mt7961_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/TxPwrLimit_MT79x1.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/TxPwrLimit_MT79x1.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT79x1.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/EEPROM_MT7961_1.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/EEPROM_MT7961_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7961_1.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/EEPROM_MT7961_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7961_1.bin:mtk
    endif
else ifneq ($(filter MT7663, $(MTK_COMBO_CHIP)),)
    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/mt7663_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/mt7663_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/mt7663_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/TxPwrLimit_MT76x3.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/TxPwrLimit_MT76x3.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT76x3.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/TxPwrLimit_MT76x3.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT76x3.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/EEPROM_MT7663.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/EEPROM_MT7663.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7663.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/EEPROM_MT7663.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7663.bin:mtk
    endif
else ifneq ($(filter MT7668, $(MTK_COMBO_CHIP)),)
    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/mt7668_wifi.cfg),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/mt7668_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/mt7668_wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/TxPwrLimit_MT76x8.dat),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/TxPwrLimit_MT76x8.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT76x8.dat:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/TxPwrLimit_MT76x8.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT76x8.dat:mtk
    endif

    ifneq ($(wildcard $(wlan_drv_config_cust_folder)/EEPROM_MT7668.bin),)
        PRODUCT_COPY_FILES += $(wlan_drv_config_cust_folder)/EEPROM_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7668.bin:mtk
    else
        PRODUCT_COPY_FILES += $(wlan_drv_config_folder)/EEPROM_MT7668:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7668.bin:mtk
    endif
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

ifeq ($(MTK_TC10_FEATURE),yes)
    PRODUCT_PACKAGES += WIFI
endif

# for decoupled kernel object (.ko) of wifi driver
ifneq ($(filter MT6630, $(MTK_COMBO_CHIP)),)
PRODUCT_PACKAGES += wlan_drv_gen3.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen3
endif

ifneq ($(filter MT6632, $(MTK_COMBO_CHIP)),)
PRODUCT_PACKAGES += wlan_drv_gen4.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4
endif

ifneq ($(filter MT7668, $(MTK_COMBO_CHIP)),)
PRODUCT_PACKAGES += wlan_drv_gen4_mt7668.ko
PRODUCT_PACKAGES += wlan_drv_gen4_mt7668_prealloc.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4_mt7668
endif

ifneq ($(filter MT7663, $(MTK_COMBO_CHIP)),)
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7663.ko
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7663_prealloc.ko
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7663_reset.ko
 PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4_mt7663
endif

ifneq ($(filter MT7921, $(MTK_COMBO_CHIP)),)
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7961.ko
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7961_prealloc.ko
 PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4_mt7961
endif

ifneq ($(filter MT7902, $(MTK_COMBO_CHIP)),)
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7902.ko
 PRODUCT_PACKAGES += wlan_drv_gen4_mt7902_prealloc.ko
 PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4_mt7902
endif

ifneq ($(filter $(WLAN_GEN3_CHIPS), $(MTK_COMBO_CHIP)),)
DUTINFO_NAME := 6631_gen3
PRODUCT_PACKAGES += wlan_drv_gen3.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen3
else ifneq ($(filter $(WLAN_GEN4M_CHIPS), $(MTK_COMBO_CHIP)),)
    ifneq ($(filter $(WLAN_BRANCH_5_SERIES) $(WLAN_BRANCH_3_SERIES), $(WLAN_CHIP_ID)),)
        DUTINFO_NAME := 6635_gen4m
    else
        DUTINFO_NAME := 6631_gen4m
    endif
PRODUCT_PACKAGES += wlan_drv_gen4m.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.standalone.log=y
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen4m
WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 2}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{AP}, 1},}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{AP}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{P2P}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{NAN}, 1}}
else ifneq ($(filter CONSYS_%, $(MTK_COMBO_CHIP)),)
DUTINFO_NAME := 6625_gen2
PRODUCT_PACKAGES += wlan_drv_gen2.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.gen=gen2
endif

ifeq ($(filter $(WLAN_MT7XXX_CHIPS), $(MTK_COMBO_CHIP)),)
PRODUCT_PACKAGES += wmt_chrdev_wifi.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wlan.chrdev=wmt_chrdev_wifi
endif

ifeq ($(ENABLE_KBUILD), true)
	PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/wlan/adaptor/init.wlan_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wlan_drv.rc
endif

PRODUCT_PACKAGES += wlan_assistant

ifneq ($(filter $(WLAN_MT7XXX_CHIPS), $(MTK_COMBO_CHIP)),)
PRODUCT_PACKAGES += wifitest
endif

# sigma tool
SIGMA_SRC_DIR := vendor/mediatek/proprietary/hardware/connectivity/sigma/mediatek
SIGMA_OUT_DIR := $(PRODUCT_OUT)/testcases/sigma
PRODUCT_PACKAGES += libwfadut_static
PRODUCT_PACKAGES += wfa_dut
PRODUCT_PACKAGES += wfa_ca
PRODUCT_PACKAGES += wfa_con
PRODUCT_PACKAGES += mtk_inband_cmd.sh
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/release,$(SIGMA_OUT_DIR))
ifneq ($(filter $(WLAN_BRANCH_2_SERIES), $(WLAN_CHIP_ID)),)
# for dynamic 6631/6635 switch, we have to copy both DUTInfo
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6631_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6631_gen4m)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6635_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6635_gen4m)
else ifneq ($(filter 6855, $(WLAN_CHIP_ID)),)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6631_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6631_gen4m)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6635_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6635_gen4m)
else ifneq ($(filter 6789, $(WLAN_CHIP_ID)),)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6631_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6631_gen4m)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/6635_gen4m,$(SIGMA_OUT_DIR)/DUTInfo/DUTInfo_6635_gen4m)
else
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/DUTInfo/$(DUTINFO_NAME),$(SIGMA_OUT_DIR)/DUTInfo)
endif
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/device/mobile/CertProgram,$(SIGMA_OUT_DIR)/scripts/CertProgram)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(SIGMA_SRC_DIR)/device/mobile/scripts,$(SIGMA_OUT_DIR)/scripts)

# quicktrack tool
QT_SRC_DIR := vendor/mediatek/proprietary/hardware/connectivity/quicktrack
QT_OUT_DIR := $(PRODUCT_OUT)/testcases/quicktrack
PRODUCT_PACKAGES += mtk_qt_dut
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(QT_SRC_DIR)/release,$(QT_OUT_DIR))
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(QT_SRC_DIR)/tests,$(QT_OUT_DIR)/tests)
