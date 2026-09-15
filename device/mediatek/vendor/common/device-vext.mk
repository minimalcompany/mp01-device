MTK_PLATFORM_DIR := $(call to-lower,$(MTK_PLATFORM))
MTK_REL_PLATFORM := $(MTK_PLATFORM_DIR)

VEXT_PRODUCT_SHIPPING_API_LEVEL_OVERRIDE ?= 31
KATI_READONLY := VEXT_PRODUCT_SHIPPING_API_LEVEL_OVERRIDE
# Set API level to override inherited value
PRODUCT_SHIPPING_API_LEVEL := $(VEXT_PRODUCT_SHIPPING_API_LEVEL_OVERRIDE)

ifdef TARGET_BOARD_PLATFORM
ifneq ($(wildcard device/mediatek/$(TARGET_BOARD_PLATFORM)),)
  MTK_REL_PLATFORM := $(TARGET_BOARD_PLATFORM)
endif
endif

ifndef VEXT_TARGET_PROJECT_FOLDER
  VEXT_TARGET_PROJECT_FOLDER := $(MTK_TARGET_PROJECT_FOLDER)
endif
ifndef VEXT_PROJECT_FOLDER
  VEXT_PROJECT_FOLDER := $(MTK_PROJECT_FOLDER)
endif

ifdef VEXT_BASE_PROJECT
  MTK_PATH_CUSTOM := vendor/mediatek/proprietary/custom/$(VEXT_BASE_PROJECT)
else ifdef MTK_BASE_PROJECT
  MTK_PATH_CUSTOM := vendor/mediatek/proprietary/custom/$(MTK_BASE_PROJECT)
endif

# VENDOR_SECURITY_PATCH
$(call inherit-product-if-exists, vendor/mediatek/proprietary/buildinfo_vnd/device.mk)

ifdef VEXT_TARGET_PROJECT
ifndef HAL_TARGET_PROJECT
ifneq ($(wildcard $(strip $(VEXT_TARGET_PROJECT_FOLDER))/security),)
  PRODUCT_DEFAULT_DEV_CERTIFICATE := $(strip $(VEXT_TARGET_PROJECT_FOLDER))/security/releasekey
else ifneq ($(wildcard device/mediatek/security),)
  PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/security/releasekey
else
  ifeq ($(MTK_SIGNATURE_CUSTOMIZATION),yes)
    ifeq ($(wildcard device/mediatek/security/$(strip $(VEXT_TARGET_PROJECT))),)
      $(error Please create device/mediatek/security/$(strip $(VEXT_TARGET_PROJECT))/ and put your releasekey there!!)
    else
      PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/security/$(strip $(VEXT_TARGET_PROJECT))/releasekey
    endif
  else
#   Not specify PRODUCT_DEFAULT_DEV_CERTIFICATE and the default testkey will be used.
  endif
endif
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
endif#HAL_TARGET_PROJECT
endif#VEXT_TARGET_PROJECT

# MTK Single Image
PRODUCT_VEXT_MTK_RSC_ROOT_PATH ?= etc/rsc
ifeq ($(wildcard vendor/mediatek/internal/build vendor/mediatek/libs_internal),vendor/mediatek/internal/build vendor/mediatek/libs_internal)
CURRENT_VEXT_RSC_NAMES := $(PRODUCT_VEXT_MTK_RSC_NAMES)
else
CURRENT_VEXT_RSC_NAMES := $(PRODUCT_VEXT_CUSTOMER_RSC_NAMES)
endif
$(foreach mk,$(CURRENT_VEXT_RSC_NAMES),\
  $(eval vext_mtk_rsc_name := $(mk))\
  $(eval include device/mediatek/build/tasks/tools/config_vext_mtk_rsc.mk))


#################################################
# device/mediatek/vendor/common/device.mk start #
#################################################

# pq color mode, default mode is 1 (DISP)
ifeq ($(strip $(MTK_PQ_COLOR_MODE)), OFF)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_color_mode=0
else
  ifeq ($(strip $(MTK_PQ_COLOR_MODE)), MDP)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_color_mode=2
  else
    ifeq ($(strip $(MTK_PQ_COLOR_MODE)), DISP_MDP)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_color_mode=3
    else
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_color_mode=1
    endif
  endif
endif

# support mediaserver 64-bit
ifneq ($(strip $(MTK_REL_PLATFORM)),mt6983)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_prefer_64bit_proc=0
endif

ifeq ($(strip $(MTK_DRE30_SUPPORT)), yes)
    ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), 2)
      PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dre30_support=3
    else
      PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dre30_support=1
    endif
else ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), 2)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dre30_support=2
endif

ifneq ($(strip $(MTK_PQ_SUPPORT)), no)
    ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_OFF)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=0
    else
        ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_2)
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=2
            ifdef MTK_GENERIC_HAL #LD2.0
                PRODUCT_COPY_FILES += \
                    vendor/mediatek/proprietary/hardware/pq/v2.0/cmds/vendor.mediatek.hardware.pq@2.2-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.mediatek.hardware.pq@2.2-service.rc
            endif
        else
            ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_3)
                PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=3
                ifdef MTK_GENERIC_HAL #LD2.0
                    PRODUCT_COPY_FILES += \
                        vendor/mediatek/proprietary/hardware/pq/v2.0/cmds/vendor.mediatek.hardware.pq@2.2-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.mediatek.hardware.pq@2.2-service.rc
                endif
            else
                PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=0
            endif
        endif
    endif
endif

ifeq ($(strip $(MTK_PQ_VIDEO_WHITELIST_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_pq_video_whitelist_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_pq_video_whitelist_support=0
endif

ifeq ($(strip $(MTK_VIDEO_TRANSITION)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_video_transition=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_video_transition=0
endif

ifeq ($(strip $(MTK_BACKLIGHT_HWC_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES +=  ro.vendor.mtk_backlight_hwc_support=1
else
    PRODUCT_PROPERTY_OVERRIDES +=  ro.vendor.mtk_backlight_hwc_support=0
endif

ifeq ($(strip $(MTK_SCLTM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_scltm_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_scltm_support=0
endif

ifeq ($(strip $(MTK_MML_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mml.mtk_mml_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mml.mtk_mml_support=0
endif

ifeq ($(strip $(MTK_AI_SCENE_PQ_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ai_scence_pq_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ai_scence_pq_support=0
endif

ifeq ($(strip $(MTK_HDR10_PLUS_RECORDING)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_hdr10_plus_recording_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_hdr10_plus_recording_support=0
endif

ifeq ($(strip $(MTK_MDP_LITE_PQ_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_mdp_lite_pq_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_mdp_lite_pq_support=0
endif

ifeq ($(strip $(MTK_AI_SDR_TO_HDR_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ai_sdr_to_hdr_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ai_sdr_to_hdr_support=0
endif

ifeq ($(strip $(MTK_ULTRA_RESOLUTION_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ultra_resolution_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ultra_resolution_support=0
endif

ifeq ($(strip $(MTK_DC_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_dc_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_dc_support=0
endif

ifeq ($(strip $(MTK_DS_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ds_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ds_support=0
endif

ifeq ($(strip $(MTK_HFG_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_hfg_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_hfg_support=0
endif

ifeq ($(strip $(MTK_CALTM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_caltm_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_caltm_support=0
endif

ifeq ($(strip $(MTK_CLEARZOOM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_clearzoom_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_clearzoom_support=0
endif

ifeq ($(strip $(MTK_MDP_CCORR_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_mdp_ccorr_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_mdp_ccorr_support=0
endif

ifeq ($(strip $(MTK_PQ_INTERFACE_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_pq_interface_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_pq_interface_support=0
endif


# DISP PQ CONFIG PROPERTY START
ifeq ($(strip $(MTK_DISP_C3D_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_c3d_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_c3d_support=0
endif

ifeq ($(strip $(MTK_DISP_TDSHP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_tdshp_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_tdshp_support=0
endif

ifeq ($(strip $(MTK_DISP_COLOR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_color_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_color_support=0
endif

ifeq ($(strip $(MTK_DISP_CCORR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_ccorr_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_ccorr_support=0
endif

ifeq ($(strip $(MTK_DISP_GAMMA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_gamma_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_gamma_support=0
endif

ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), 1)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_appgamepq_support=1
    PRODUCT_PROPERTY_OVERRIDES += debug.mediatek.appgamepq=1
endif

ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), 2)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_appgamepq_support=1
    PRODUCT_PROPERTY_OVERRIDES += debug.mediatek.appgamepq=2
endif

ifeq ($(strip $(MTK_AAL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_aal_support=1
  PRODUCT_PACKAGES += libaal_cust

  #for VendorExt support
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_aal_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_aal_support=0
endif
PRODUCT_PACKAGES += libpq_cust_base

ifeq ($(strip $(MTK_DRE30_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_dre30_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_dre30_support=0
endif

ifeq ($(strip $(MTK_DISP_GAME_PQ_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_game_pq_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_disp_game_pq_support=0
endif

ifeq ($(strip $(MTK_BACKLIGHT_SMOOTH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_backlight_smooth_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_backlight_smooth_support=0
endif

ifeq ($(strip $(MTK_ULTRA_DIMMING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ultra_dimming_support=1

  #for VendorExt support
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ultra_dimming_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_ultra_dimming_support=0
endif

ifeq ($(strip $(MTK_BLULIGHT_DEFENDER_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_blulight_def_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pq.mtk_blulight_def_support=0
endif
# DISP PQ CONFIG PROPERTY END

# CarrierExpress starts
ifdef MTK_CARRIEREXPRESS_PACK
  ifneq ($(strip $(MTK_CARRIEREXPRESS_PACK)),no)

  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_carrierexpress_pack=$(strip $(MTK_CARRIEREXPRESS_PACK))
  ifeq ($(strip $(MTK_CARRIEREXPRESS_APK_INSTALL_SUPPORT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_carrierexpress_inst_sup=1
  endif
  ifdef MTK_CARRIEREXPRESS_SWITCH_MODE
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_usp_switch_mode=$(strip $(MTK_CARRIEREXPRESS_SWITCH_MODE))
  endif

  endif #ifneq ($(strip $(MTK_CARRIEREXPRESS_PACK)),no)
endif #ifdef MTK_CARRIEREXPRESS_PACK
# CarrierExpress ends

ifeq ($(MTK_DYNAMIC_PARTITION_SUPPORT), yes)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
endif

ifdef VEXT_TARGET_PROJECT
  PRODUCT_PACKAGES += mtk_vext_info
endif

ifeq (yes,$(MTK_TINYSYS_SCP_SUPPORT))
  PRODUCT_PACKAGES += tinysys-scp
endif

ifeq (yes,$(MTK_TINYSYS_VCP_SUPPORT))
  PRODUCT_PACKAGES += tinysys-vcp
endif

#fingerprint hal
ifneq (,$(wildcard vendor/mediatek/kernel_modules/mtk_input))
ifeq ($(strip $(MTK_FINGERPRINT_SUPPORT)),yes)
  ifeq ($(strip $(MTK_FINGERPRINT_SELECT)),$(filter $(MTK_FINGERPRINT_SELECT), GF5216 GF3658))
    ifeq ($(LINUX_KERNEL_VERSION), kernel-6.6)
      PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/mtk_input/fingerprint/goodix/6.6/init.gf_spi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gf_spi.rc
    endif
    VEXT_PRODUCT_SYMLINK_FILES += fingerprint.mediatek.so:vendor/lib/hw/fingerprint.$(TARGET_BOARD_PLATFORM).so
    VEXT_PRODUCT_SYMLINK_FILES += fingerprint.mediatek.so:vendor/lib64/hw/fingerprint.$(TARGET_BOARD_PLATFORM).so
  endif
endif
endif

# kcm added by phf, 20240827, for copy focaltech fingerprint TA
ifeq ($(strip $(FOCALTECH_FINGERPRINT)),yes)
  ifeq (,$(wildcard $(MTK_PATH_CUSTOM)/focaltech_fp_ta/466f6361-6c54-6563-6800000000003545.ta))
	$(warning !!!!!!!! Please copy focaltech singed TA to: $(MTK_PATH_CUSTOM)/focaltech_fp_ta/ !!!!!!!!!)
  endif
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,$(MTK_PATH_CUSTOM)/focaltech_fp_ta/466f6361-6c54-6563-6800000000003545.ta:vendor/app/t6/466f6361-6c54-6563-6800000000003545.ta)
endif


# Audio policy config
USE_XML_AUDIO_POLICY_CONF ?= 1
ifeq ($(strip $(USE_XML_AUDIO_POLICY_CONF)), 1)
AUDIO_POLICY_PROJECT_CONFIGS := \
  $(strip \
    $(notdir $(wildcard $(VEXT_TARGET_PROJECT_FOLDER)/audio_policy_config/*.xml)\
    ) \
  )
AUDIO_POLICY_BASE_PROJECT_CONFIGS := \
  $(strip \
    $(filter-out $(AUDIO_POLICY_PROJECT_CONFIGS), \
      $(notdir $(wildcard $(VEXT_PROJECT_FOLDER)/audio_policy_config/*.xml)) \
    ) \
  )
AUDIO_POLICY_PLATFORM_CONFIGS := \
  $(strip \
    $(filter-out $(AUDIO_POLICY_PROJECT_CONFIGS) $(AUDIO_POLICY_BASE_PROJECT_CONFIGS), \
      $(notdir $(wildcard device/mediatek/$(MTK_REL_PLATFORM)/audio_policy_config/*.xml)) \
    ) \
  )
AUDIO_POLICY_COMMON_CONFIGS := \
  $(strip \
    $(filter-out $(AUDIO_POLICY_PROJECT_CONFIGS) $(AUDIO_POLICY_BASE_PROJECT_CONFIGS) $(AUDIO_POLICY_PLATFORM_CONFIGS), \
      $(notdir $(wildcard $(LOCAL_PATH)/audio_policy_config/*.xml)) \
    ) \
  )

$(foreach x,$(AUDIO_POLICY_PROJECT_CONFIGS), \
  $(eval PRODUCT_COPY_FILES += $(VEXT_TARGET_PROJECT_FOLDER)/audio_policy_config/$(x):$(TARGET_COPY_OUT_VENDOR)/etc/$(x)) \
)

$(foreach x,$(AUDIO_POLICY_BASE_PROJECT_CONFIGS), \
  $(eval PRODUCT_COPY_FILES += $(VEXT_PROJECT_FOLDER)/audio_policy_config/$(x):$(TARGET_COPY_OUT_VENDOR)/etc/$(x)) \
)

$(foreach x,$(AUDIO_POLICY_PLATFORM_CONFIGS), \
  $(eval PRODUCT_COPY_FILES += device/mediatek/$(MTK_REL_PLATFORM)/audio_policy_config/$(x):$(TARGET_COPY_OUT_VENDOR)/etc/$(x)) \
)

$(foreach x,$(AUDIO_POLICY_COMMON_CONFIGS), \
  $(eval PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio_policy_config/$(x):$(TARGET_COPY_OUT_VENDOR)/etc/$(x)) \
)
endif

# audio hal
VEXT_PRODUCT_SYMLINK_FILES += audio.primary.mediatek.so:vendor/lib/hw/audio.primary.$(TARGET_BOARD_PLATFORM).so
VEXT_PRODUCT_SYMLINK_FILES += audio.primary.mediatek.so:vendor/lib64/hw/audio.primary.$(TARGET_BOARD_PLATFORM).so

PRODUCT_COPY_FILES += \
  $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/aurisys_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config.xml:mtk) \
  $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/aurisys_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config.xml:mtk) \
  $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_PLATFORM_DIR)/aurisys_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config.xml:mtk) \

PRODUCT_COPY_FILES += \
  $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/aurisys_config_rv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_rv.xml:mtk) \
  $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/aurisys_config_rv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_rv.xml:mtk) \
  $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_PLATFORM_DIR)/aurisys_config_rv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_rv.xml:mtk) \

ifeq (yes,$(MTK_AUDIODSP_SUPPORT))
  PRODUCT_PACKAGES += tinysys-adsp
  PRODUCT_COPY_FILES += \
    $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/aurisys_config_hifi3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_hifi3.xml:mtk) \
    $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/aurisys_config_hifi3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_hifi3.xml:mtk) \
    $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_REL_PLATFORM)/aurisys_config_hifi3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_hifi3.xml:mtk) \
    vendor/mediatek/proprietary/external/aurisys/aurisys_config_hifi3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_hifi3.xml:mtk
  $(foreach bin,$(wildcard vendor/mediatek/proprietary/external/aurisys_3rdparty/libgoodix/libgoodixspeech/goodix_param/*.bin), \
      $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/goodix/$(notdir $(bin)):mtk)) \
  )
  $(foreach bin,$(wildcard vendor/mediatek/proprietary/external/aurisys_3rdparty/libnxp/libnxpspeech/nxp_param/*.bin), \
      $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/nxp/$(notdir $(bin)):mtk)) \
  )
  $(foreach bin,$(wildcard vendor/mediatek/proprietary/external/aurisys_3rdparty/libnxp/libnxprecord/nxp_im/*.bin), \
      $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/nxp/$(notdir $(bin)):mtk)) \
  )
  PRODUCT_COPY_FILES += \
      $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/external/aurisys_3rdparty/libfvaudio/FV-SAM-MTKXX.dat:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_param/FV-SAM-MTKXX.dat:mtk)
  PRODUCT_COPY_FILES += \
      $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/external/aurisys_3rdparty/lib_gv_enh/gv_enh_param.bin:$(TARGET_COPY_OUT_VENDOR)/etc/gv_enh_param.bin:mtk)
endif

ifeq (yes,$(MTK_TINYSYS_SSPM_SUPPORT))
  PRODUCT_PACKAGES += tinysys-sspm
endif

ifeq (yes,$(MTK_TINYSYS_MCUPM_SUPPORT))
  PRODUCT_PACKAGES += tinysys-mcupm
endif

ifeq (yes,$(MTK_TINYSYS_GPUEB_SUPPORT))
PRODUCT_PACKAGES += tinysys-gpueb
endif

ifeq (yes,$(MTK_APUSYS_TINYSYS_SUPPORT))
  PRODUCT_PACKAGES += tinysys-apusys
endif

ifeq ($(strip $(MTK_DPM_SUPPORT)),yes)
  PRODUCT_PACKAGES += dpm.img
endif

# VoW
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/voiceunlock2/voicecommand.mk)

# touch related file for copy firmware
PRODUCT_COPY_FILES += $(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
                      $(call find-copy-subdir-files,*,vendor/mediatek/proprietary/custom/touch/$(TOUCH),$(TARGET_COPY_OUT_VENDOR)/firmware))

# touch init.rc copy
#PRODUCT_COPY_FILES += $(foreach TOUCH,$(MTK_TOUCH_KO),\
                     vendor/mediatek/proprietary/custom/touch/touch_init_rc/$(TOUCH)/init.$(shell echo $(TOUCH) | tr '[A-Z]' '[a-z]').rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(shell echo $(TOUCH) | tr '[A-Z]' '[a-z]').rc)

#touch driver
$(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
        $(if $(filter $(TOUCH),FT3518U),$(eval MTK_OUT_OF_TREE_KERNEL_MODULES += ft3518u.ko)))
$(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
        $(if $(filter $(TOUCH),FT3518),$(eval MTK_OUT_OF_TREE_KERNEL_MODULES += ft3518.ko)))
$(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
        $(if $(filter $(TOUCH),synaptics_tcm),$(eval MTK_OUT_OF_TREE_KERNEL_MODULES += synaptics_tcm.ko)))
$(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
        $(if $(filter $(TOUCH),ST61Y),$(eval MTK_OUT_OF_TREE_KERNEL_MODULES += st61y.ko)))
$(foreach TOUCH,$(MTK_TOUCHPANEL_FIRMWARE),\
        $(if $(filter $(TOUCH),GT9916P),$(eval MTK_OUT_OF_TREE_KERNEL_MODULES += gt9916p.ko)))

#FP
MTK_OUT_OF_TREE_KERNEL_MODULES += gf_spi.ko

SPMFW_ROOT_DIR := vendor/mediatek/proprietary/hardware/spmfw
ifneq (yes,$(strip $(SPM_FW_USE_PARTITION)))
  $(call inherit-product-if-exists,$(SPMFW_ROOT_DIR)/build/product_package.mk)
else
  PRODUCT_PACKAGES += spmfw.img
endif

MCUPMFW_ROOT_DIR := vendor/mediatek/proprietary/hardware/mcupmfw
ifeq (yes,$(strip $(MCUPM_FW_USE_PARTITION)))
  PRODUCT_PACKAGES += mcupmfw.img
endif

ifeq ($(strip $(MTK_ENABLE_GENIEZONE)),yes)
  PRODUCT_PACKAGES += gz.img
  PRODUCT_PACKAGES += gz.bin
endif

ifeq ($(strip $(MTK_VPU_SUPPORT)), yes)
  PRODUCT_PACKAGES += cam_vpu1.img
  PRODUCT_PACKAGES += cam_vpu2.img
  PRODUCT_PACKAGES += cam_vpu3.img
endif

PRODUCT_PACKAGES += libmvpu_config_data
ifeq ($(strip $(MTK_VPU2_SUPPORT)), yes)
  PRODUCT_PACKAGES += mvpu_algo.img
endif

ifeq ($(strip $(MTK_VPU2_SECURITY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mvpu_security_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mvpu_security_support=0
endif

# Add for Display HDR feature
ifeq ($(strip $(MTK_HDR_VIDEO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_hdr_video_support=1
endif

# Add for CUVA HDR feature
ifeq ($(strip $(MTK_CUVA_HDR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_cuva_hdr_support=1
endif

# Add for HDR10+ Adaptive feature
ifeq ($(strip $(MTK_HDR10PLUS_ADAPTIVE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_hdr10p_adaptive_support=1
endif

# Read MTK_GPU_VERSION from ProjectConfig.mk
ifeq ($(strip $(word 3,$(MTK_GPU_VERSION))), r38p1)
  VEXT_PRODUCT_SYMLINK_FILES += \
    /vendor/bin/hw/$(TARGET_BOARD_PLATFORM)/android.hardware.graphics.allocator@4.0-service-mediatek.$(TARGET_BOARD_PLATFORM)_r38p1:vendor/bin/hw/android.hardware.graphics.allocator@4.0-service-mediatek
else ifneq ($(filter $(MTK_GPU_VERSION),m24.2ED6620798),)
  VEXT_PRODUCT_SYMLINK_FILES += \
    /vendor/bin/hw/$(TARGET_BOARD_PLATFORM)/android.hardware.graphics.allocator@4.0-service-mediatek.$(TARGET_BOARD_PLATFORM)_m24.2ED6620798:vendor/bin/hw/android.hardware.graphics.allocator@4.0-service-mediatek
else
  VEXT_PRODUCT_SYMLINK_FILES += \
    /vendor/bin/hw/$(TARGET_BOARD_PLATFORM)/android.hardware.graphics.allocator@4.0-service-mediatek.$(TARGET_BOARD_PLATFORM):vendor/bin/hw/android.hardware.graphics.allocator@4.0-service-mediatek
endif

#inherit test case
$(call inherit-product-if-exists, vendor/mediatek/tests/kernel/test_list_kernel.mk)

ifeq ($(strip $(MTK_FD_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fd_support=1
endif

ifneq ($(MTK_BUILD_IGNORE_IMS_REPO),yes)
MTK_IMS_DEPENDENCY_ENABLED := 1
ifdef CUSTOM_MODEM
  ifeq ($(strip $(TARGET_BUILD_VARIANT)),eng)
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  else
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))_prod/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  endif
  MTK_MODEM_APPS_MAKEFILES :=
  $(foreach f,$(MTK_MODEM_MODULE_MAKEFILES),\
    $(if $(strip $(MTK_MODEM_APPS_MAKEFILES)),,\
      $(eval MTK_MODEM_APPS_MAKEFILES := $(wildcard $(patsubst %/Android.mk,%/makefile/product_*.mk,$(f))))\
    )\
  )
  $(foreach f,$(MTK_MODEM_APPS_MAKEFILES),\
    $(eval $(call inherit-product-if-exists,$(f)))\
  )
endif
endif
ifdef CUSTOM_MODEM
  PRODUCT_PACKAGES += mcf_ota

  ifeq ($(strip $(TARGET_BUILD_VARIANT)),eng)
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  else
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))_prod/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  endif
  MTK_MODEM_MDDB_MCF_ODB_FILES :=
  $(foreach f,$(MTK_MODEM_MODULE_MAKEFILES),\
    $(if $(strip $(MTK_MODEM_MDDB_MCF_ODB_FILES)),,\
      $(eval MTK_MODEM_MDDB_MCF_ODB_FILES := $(wildcard $(patsubst %/Android.mk,%/MDDB.MCF.ODB.tar.gz,$(f))))\
    )\
  )
  $(foreach f,$(MTK_MODEM_MDDB_MCF_ODB_FILES),\
    $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(f):MDDB.MCF.ODB.tar.gz))\
  )
endif
ifdef CUSTOM_MODEM
$(foreach item,$(CUSTOM_MODEM),\
    $(eval PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,vendor/mediatek/proprietary/modem/$(item)/mddata,$(TARGET_COPY_OUT_VENDOR)/etc/md)))
endif

ifeq ($(strip $(MTK_SINGLE_BIN_MODEM_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_single_bin_modem_support=1
endif

ifdef VEXT_TARGET_PROJECT
ifeq ($(strip $(MTK_COMBO_SUPPORT)), yes)
  $(call inherit-product-if-exists, $(LOCAL_PATH)/connectivity/product_package/product_package-vext.mk)
endif
endif

# WAPI
ifeq ($(strip $(MTK_WAPI_SUPPORT)), yes)
  ifeq ($(wildcard vendor/mediatek/proprietary/hardware/connectivity/wapi-v2*),)
    $(error WAPI library not exist. Contact vendor and sign WAPI license!)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_wapi_support=0
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_wapi_support=1
  endif
endif

PRODUCT_PACKAGES_RESET := $(PRODUCT_PACKAGES)
ifeq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
  ifneq ($(strip $(LINUX_KERNEL_VERSION)),kernel-4.14)
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
    PRODUCT_PROPERTY_OVERRIDES += ro.virtual_ab.userspace.snapshots.enabled=true
  else
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
  endif
endif
PRODUCT_PACKAGES := $(PRODUCT_PACKAGES_RESET)

# add for mtk bt enable SAP profile, this will override default property (e.g., defined in system/common)
ifeq ($(strip $(MTK_BT_SAP_ENABLE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk.bt_sap_enable=true
    PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.sap.server.enabled=true
else
    PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.sap.server.enabled=false
endif

#add for bluetooth ldac abr
ifeq ($(strip $(MTK_BLUETOOTH_LDAC_ABR)), yes)
PRODUCT_PROPERTY_OVERRIDES += vendor.bluetooth.ldac.abr=true
endif
#SettingsProviderResOverlay
PRODUCT_PACKAGES += SettingsProviderResOverlay

# HotwordEnrollmentOKGoogleCOMMONOverlay HotwordEnrollmentOKGoogleCOMMONOverlay
ifeq ($(strip $(MTK_VOW_SUPPORT)),yes)
  ifeq ($(strip $(MTK_VOW_GVA_SUPPORT)),yes)
    ifeq ($(strip $(BUILD_GMS)), yes)
      PRODUCT_PACKAGES += HotwordEnrollmentOKGoogleCOMMONOverlay
      PRODUCT_PACKAGES += HotwordEnrollmentXGoogleCOMMONOverlay
    endif
  endif
endif

# MtkSettingsResOverlay RRO
PRODUCT_PACKAGES += MtkSettingsResOverlay

#add for vendorext control overlay
PRODUCT_PACKAGES += FrameworkResOverlayExt

# Resource overlay for MtkSystemui
ifeq ($(strip $(MTK_TELEPHONY_ADD_ON_POLICY)), 0)
    ifneq ($(strip $(MTK_TC1_COMMON_SERVICE)), yes)
        PRODUCT_PACKAGES += SystemUIResOverlay
    endif
endif

# Resource overlay for WmShell
ifeq ($(strip $(MTK_PIP_RIGHT_ANGLE)), yes)
    PRODUCT_PACKAGES += SystemUIWmShellResOverlay
endif

PRODUCT_PACKAGES+=libcustom_nvram

ifeq ($(strip $(MTK_EMBMS_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_embms_support=1
endif

ifeq ($(strip $(MTK_IMSI_SWITCH_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_imsi_switch_support=1
endif

ifeq ($(strip $(MTK_FEMTO_CELL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_femto_cell_support=1
endif

ifeq ($(strip $(MTK_SIM_HOT_SWAP_COMMON_SLOT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_sim_hot_swap_common_slot=1
endif

ifneq ($(strip $(MTK_SIM_CARD_ONOFF)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_sim_card_onoff=$(strip $(MTK_SIM_CARD_ONOFF))
endif

ifneq ($(filter $(strip $(MTK_MULTIPLE_IMS_SUPPORT)),2 3 4),)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mims_support=$(strip $(MTK_MULTIPLE_IMS_SUPPORT))
else
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mims_support=1
endif

# Telephony RIL log configurations
ifeq ($(strip $(MTK_TELEPHONY_CONN_LOG_CTRL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.log.tel_log_ctrl=1
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.AT=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RILC=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMainThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRoot=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRilAdapter=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RilOpProxy=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RILC-OP=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaCcciDataHeaderEncoder=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaCcciReader=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaCcciSender=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaControlMsgHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriver=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverAccept=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverAdapter=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverDeReg=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverMessage=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverRegFilter=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverULIpPkt=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverUtilis=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaDriverVersion=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaFilterRuleReqHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaRingBuffer=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaShmAccessController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaShmReadMsgHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaShmSynchronizer=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaShmWriteMsgHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.wpfa_iptable_android=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaRuleRegister=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaParsing=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WpfaRuleContainer=I
ifneq ($(strip $(TARGET_BUILD_VARIANT)),eng)
  # user/userdebug load
  # V/D/(I/W/E)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDct=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDcc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkRetryManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DcFcMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetAgentService=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetAgent_IO=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetLnkEventHdlr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.C2K_RIL-DATA=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.GsmCdmaPhone=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RILMD2-SS=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.CapaSwitch=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelector=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorOm=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorOP01=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorOP02=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorOP09=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorOP18=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DSSelectorUtil=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SimSwitchOP01=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SimSwitchOP02=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SimSwitchOP18=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IccProvider=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IccPhoneBookIM=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.AdnRecordCache=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.AdnRecordLoader=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.AdnRecord=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkIccProvider=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkIccPHBIM=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkAdnRecord=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkRecordLoader=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.VT=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsVTProvider=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IccCardProxy=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IsimFileHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IsimRecords=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SIMRecords=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SpnOverride=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.UiccCard=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.UiccController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.CountryDetector=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetworkStats=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetworkPolicy=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DataDispatcher=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsService=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IMS_RILA=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.IMSRILRequest=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsApp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsBaseCommands=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkImsManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkImsService=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsCall=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsPhone=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsPhoneCall=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsPhoneBase=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsCallSession=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsCallProfile=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsEcbm=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ImsEcbmProxy=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.OperatorUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WfoApp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.GsmCdmaConn=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.GsmCdmaPhone=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.Phone=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.GsmCallTkrHlpr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkPhoneNotifr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkFactory=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkGsmCdmaConn=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RadioManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL_UIM_SOCKET=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RILD=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMessage=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxDebugInfo=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxTimer=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxObject=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SlotQueueEntry=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxAction=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RFX=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PhoneFactory=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ProxyController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.SpnOverride=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.AirplaneHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ExternalSimMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.VsimAdaptor=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkCsimFH=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkIsimFH=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkRuimFH=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSIMFH=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSIMRecords=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSmsCbHeader=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSmsManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSmsMessage=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSpnOverride=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkIccCardProxy=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkUiccCard=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkUiccCardApp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkUiccCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkUsimFH=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkSubCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkEmbmsAdaptor=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RilClient=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRilAdapter=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MTKSST=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRilUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.WORLDMODE=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkPhoneNumberUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkPhoneSwitcher=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Parcel=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Socket=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-SocListen=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Netlink=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MwiRIL=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PQ_DS=I
ifeq ($(strip $(TARGET_BUILD_VARIANT)),user)
  # Only user load
  # V/D/(I/W/E)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.CarrierExpressServiceImpl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.CarrierExpressServiceImplExt=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PhoneConfigurationSettings=I
endif
else
  # eng load
  # V/(D/I/W/E)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDct=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDc=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkDcc=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkRetryManager=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DcFcMgr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetAgentService=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetAgent_IO=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.NetLnkEventHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkEmbmsAdaptor=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.ExternalSimMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.VsimAdaptor=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MTKSST=V
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRilUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxRilAdapter=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMessage=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MtkPhoneSwitcher=V
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Parcel=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Socket=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-SocListen=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Netlink=D
endif
# endif for TARGET_BUILD_VARIANT
else
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DCT=D
endif
# endif for MTK_TELEPHONY_CONN_LOG_CTRL_SUPPORT

##Gaming with smooth lte mobile data
ifeq ($(strip $(MTK_GWSD_V2_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gwsd_capability=2
else
    ifeq ($(strip $(MTK_GWSD_SUPPORT)), yes)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gwsd_capability=1
    endif
endif

ifeq ($(strip $(MTK_NUM_MODEM_PROTOCOL)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.num_md_protocol=1
endif
ifeq ($(strip $(MTK_NUM_MODEM_PROTOCOL)), 2)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.num_md_protocol=2
endif
ifeq ($(strip $(MTK_NUM_MODEM_PROTOCOL)), 3)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.num_md_protocol=3
endif
ifeq ($(strip $(MTK_NUM_MODEM_PROTOCOL)), 4)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.num_md_protocol=4
endif

# MCF feature support
ifeq ($(strip $(MTK_MCF_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mcf_support=1
endif

# mtk powerhal
PRODUCT_PACKAGES += power_app_cfg.xml
PRODUCT_PACKAGES += powerscntbl.xml
PRODUCT_PACKAGES += powercontable.xml
PRODUCT_PACKAGES += fstb.cfg
PRODUCT_PACKAGES += gbe.cfg
PRODUCT_PACKAGES += xgf.cfg

# Camera app
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_camera_app_version=$(strip $(MTK_CAMERA_APP_VERSION))

# For performance tuning
ifeq ($(strip $(MTK_PAPE)), 0)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pref_scale_enable_cfg=0
else ifeq ($(strip $(MTK_PAPE)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pref_scale_enable_cfg=1
else ifeq ($(strip $(MTK_PAPE)), 2)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.pref_scale_enable_cfg=2
endif

# Receiver/speaker path customization for gain table
ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),int_spk_amp)
  AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_INT=yes
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_INT=yes
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),2_in_1_spk)
  AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_2_IN_1_SPK=yes
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_INT=yes
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),3_in_1_spk)
  AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_3_IN_1_SPK=yes
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_INT=yes
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),int_lo_buf)
  AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_INT=yes
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_LO=yes
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),int_hp_buf)
  AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_INT=yes
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_HP=yes
else
  ifeq ($(strip $(MTK_AUDIO_NUMBER_OF_SPEAKER)), 2)
    AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_NO_ANA=yes
  else
    AUDIO_PARAM_OPTIONS_LIST += RCV_PATH_INT=yes
  endif
  AUDIO_PARAM_OPTIONS_LIST += SPK_PATH_NO_ANA=yes
endif

# Audio device xml
PRODUCT_COPY_FILES += \
      $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/audio_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_device.xml:mtk) \
      $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/audio_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_device.xml:mtk) \
      device/mediatek/$(MTK_REL_PLATFORM)/audio_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_device.xml:mtk

# AudioParamParser
PRODUCT_PACKAGES += AudioParamOptions_vext.xml
PRODUCT_PACKAGES += AudioParamPhonyXmls

XML_CUS_FOLDER_ON_DEVICE := /data/vendor/audiohal/audio_param/
AUDIO_PARAM_OPTIONS_LIST += CUST_XML_DIR=$(XML_CUS_FOLDER_ON_DEVICE)
MTK_AUDIO_PARAM_DIR_LIST := $(strip $(MTK_AUDIO_PARAM_DIR_LIST))
ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  ifneq ($(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)),V1)
        MTK_AUDIO_PARAM_DIR_LIST += $(VEXT_TARGET_PROJECT_FOLDER)/audio_param
        MTK_AUDIO_PARAM_DIR_LIST += $(VEXT_PROJECT_FOLDER)/audio_param
        MTK_AUDIO_PARAM_DIR_LIST += device/mediatek/$(TARGET_BOARD_PLATFORM)/audio_param
        MTK_AUDIO_PARAM_DIR_LIST += device/mediatek/vendor/common/audio_param
        MTK_AUDIO_PARAM_DIR_LIST += device/mediatek/vendor/common/audio_param_smartpa

        AUDIO_PARAM_OPTIONS_LIST += 5_POLE_HS_SUPPORT=$(MTK_HEADSET_ACTIVE_NOISE_CANCELLATION)
        #MTK_AUDIO_PARAM_FILE_LIST += SOME_ZIP_FILE
        AUDIO_PARAM_OPTIONS_LIST += VIR_MTK_USB_PHONECALL=yes

        # Speech Parameter Tuning
        # SPH_PARAM_VERSION: 0 support single network(MD ability related)
        # SPH_PARAM_VERSION: 1.0 support multiple networks(MD ability related)
        # SPH_PARAM_VERSION: 2.0 support IIR and fix WBFIR(Gen93)
        # SPH_PARAM_VERSION: 3.0 support SWIP Parser(above Gen95)
        AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_VERSION=3.0
        AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_TTY=yes
        AUDIO_PARAM_OPTIONS_LIST += FIX_WB_ENH=yes
        AUDIO_PARAM_OPTIONS_LIST += MTK_IIR_ENH_SUPPORT=yes
        AUDIO_PARAM_OPTIONS_LIST += MTK_IIR_MIC_SUPPORT=no
        AUDIO_PARAM_OPTIONS_LIST += MTK_FIR_IIR_ENH_SUPPORT=no

        # Speech Loopback Tunning
        ifeq ($(MTK_TC10_FEATURE),yes)
          AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_LPBK_NODELAY=yes
        endif
        # Super Volume Parameter
        AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_SV=no

        # Custom scene support
        ifeq ($(strip $(MTK_GMO_RAM_OPTIMIZE)),yes)
          AUDIO_PARAM_OPTIONS_LIST += VIR_SCENE_CUSTOMIZATION_SUPPORT=no
        else
          AUDIO_PARAM_OPTIONS_LIST += VIR_SCENE_CUSTOMIZATION_SUPPORT=yes
        endif
    endif
endif

# Audio Speaker Path
ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),smartpa_nxp_tfa9874)
    $(foreach bin,$(wildcard $(VEXT_TARGET_PROJECT_FOLDER)/*.bin), \
        $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/$(notdir $(bin)):mtk)) \
    )
    $(foreach bin,$(wildcard $(VEXT_PROJECT_FOLDER)/*.bin), \
        $(eval PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/$(notdir $(bin)):mtk)) \
    )
    $(foreach bin,$(wildcard device/mediatek/$(MTK_REL_PLATFORM)/smartpa_param/*.bin), \
        $(eval PRODUCT_COPY_FILES += $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/$(notdir $(bin)):mtk) \
    )

    $(foreach bin,$(wildcard vendor/mediatek/proprietary/external/aurisys/libnxp/libnxpsmartpa/bypass_lib_param/*.bin), \
        $(eval PRODUCT_COPY_FILES += $(bin):$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/nxp_bypass_lib_param/$(notdir $(bin)):mtk) \
    )

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/tfa98xx.cnt:$(TARGET_COPY_OUT_VENDOR)/firmware/tfa98xx.cnt:mtk) \
        $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/tfa98xx.cnt:$(TARGET_COPY_OUT_VENDOR)/firmware/tfa98xx.cnt:mtk) \
        device/mediatek/$(MTK_REL_PLATFORM)/smartpa_param/tfa98xx.cnt:$(TARGET_COPY_OUT_VENDOR)/firmware/tfa98xx.cnt:mtk
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),smartpa_mtk_mt6660)
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/calib.dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/calib.dat:mtk
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/calib.dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/calib.dat.sig:mtk
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/custom/common/factory/res/sound/CalibrationPatternOut.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/CalibrationPatternOut.wav:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/rt_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk)
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_REL_PLATFORM)/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        vendor/mediatek/proprietary/hardware/smartpa/mediatek/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/SmartPaVendor1_AudioParam.dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat:mtk)
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/SmartPaVendor1_AudioParam.dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/SmartPaVendor1_AudioParam.dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat.sig:mtk)
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/SmartPaVendor1_AudioParam.dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat.sig:mtk
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),smartpa_richtek_rt5512)
    RTK_DEVICE_XML=rt_mono_device
    RTK_PARAM=SmartPaVendor2_AudioParam
    ifeq ($(MTK_AUDIO_NUMBER_OF_SPEAKER), 2)
        RTK_DEVICE_XML=rt_stereo_device
        RTK_PARAM=stereo
    endif

    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/calib.dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/calib.dat:mtk
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/calib.dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/calib.dat.sig:mtk
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/custom/common/factory/res/sound/CalibrationPatternOut.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/CalibrationPatternOut.wav:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/rt_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk)
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/$(RTK_DEVICE_XML).xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        $(call add-to-product-copy-files-if-exists, $(VEXT_PROJECT_FOLDER)/$(RTK_DEVICE_XML).xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_REL_PLATFORM)/$(RTK_DEVICE_XML).xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk) \
        vendor/mediatek/proprietary/hardware/smartpa/mediatek/$(RTK_DEVICE_XML).xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/$(RTK_PARAM).dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat:mtk)
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/$(RTK_PARAM).dat:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat:mtk

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/$(RTK_PARAM).dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat.sig:mtk)
    PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/mediatek/$(RTK_PARAM).dat.sig:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/SmartPaVendor1_AudioParam.dat.sig:mtk
else ifeq ($(strip $(MTK_AUDIO_SPEAKER_PATH)),smartpa_richtek_rt5509)
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/rt_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk)
    ifeq ($(MTK_AUDIO_NUMBER_OF_SPEAKER),)
        PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/richtek/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk
    else ifeq ($(MTK_AUDIO_NUMBER_OF_SPEAKER),$(filter $(MTK_AUDIO_NUMBER_OF_SPEAKER),1))
        PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/richtek/rt_mono_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk
    else ifeq ($(MTK_AUDIO_NUMBER_OF_SPEAKER),$(filter $(MTK_AUDIO_NUMBER_OF_SPEAKER),2))
        PRODUCT_COPY_FILES += \
            vendor/mediatek/proprietary/hardware/smartpa/richtek/rt_multi_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt_device.xml:mtk
    endif

    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, $(VEXT_TARGET_PROJECT_FOLDER)/rt5509_param:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt5509_param:mtk)
    PRODUCT_COPY_FILES += \
        device/mediatek/$(MTK_REL_PLATFORM)/smartpa_param/rt5509_param:$(TARGET_COPY_OUT_VENDOR)/etc/smartpa_param/rt5509_param:mtk
endif

#Widevine DRM
ifeq ($(strip $(MTK_WVDRM_SUPPORT)), yes)
  ifeq ($(strip $(MTK_WVDRM_L1_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_widevine_drm_l1_support=1
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_widevine_drm_l3_support=1
  endif
endif

RAT_CONFIG := $(strip $(MTK_PROTOCOL1_RAT_CONFIG))
ifneq (,$(RAT_CONFIG))
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_protocol1_rat_config=$(RAT_CONFIG)
  ifneq (,$(findstring C,$(RAT_CONFIG)))
    # C2K is supported
    RAT_CONFIG_C2K_SUPPORT=yes
  endif
  ifneq (,$(findstring L,$(RAT_CONFIG)))
    # LTE is supported
    RAT_CONFIG_LTE_SUPPORT=yes
  endif
  ifneq (,$(findstring N,$(RAT_CONFIG)))
    # NR is supported
    RAT_CONFIG_NR_SUPPORT=yes
  endif
  ifneq (,$(findstring W,$(RAT_CONFIG)))
    # W is supported
    RAT_CONFIG_WCDMA_SUPPORT=yes
  endif
  ifneq (,$(findstring T,$(RAT_CONFIG)))
    # T is supported
    RAT_CONFIG_WCDMA_SUPPORT=yes
  endif
endif

####################################################################################################
##
## MTK Diagnostic Monitoring Framework
##
## 1. Diagnostic Monitoring Collector (DMC)
##    - MTK_DMC_SUPPORT: Core implementation of DMC in vendor partition.
##    - MSSI_MTK_DMC_SUPPORT: The APM service in system partition, to collect KPI from Android FWK
##
## 2. DMC Application: Modem Analysis Public Interface (MAPI)
##    - MTK_MAPI_SUPPORT: Provide vendor executables for PC diagnostic tool.
##
## 3. DMC Application: Modem Diagnostic Monitoring Interface (MDMI)
##    - MTK_MDMI_SUPPORT: Defines diagnostic translator for MDMI in vendor partition.
##    - MSSI_MDMI_SUPPORT: MDMI libraries defined in GSMA TS.31 in system partition.
##
####################################################################################################
# DMC Framework
# Static JAVA library for ApmService interface,
# which may be linked with common module, built it w/o FO check.

ifeq ($(strip $(MTK_DMC_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dmc_support=1
endif

# DMC Application: MDMI
ifeq ($(strip $(MTK_MDMI_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mdmi_support=1
endif

# DMC Application: MAPI
ifeq ($(strip $(MTK_MAPI_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mapi_support=1
endif

# Diagnostic Monitoring Log Setting
# Set debug level to [I] in default, enable it in EM APP manually
ifeq ($(strip $(MTK_DMC_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-Core=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-TranslatorLoader=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-TranslatorUtils=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-ReqQManager=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-DmcService=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-ApmService=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-SessionManager=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.DMC-EventsSubscriber=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.LCM-Subscriber=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.APM-Subscriber=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDM-Subscriber=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.APM-SessionJ=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.APM-SessionN=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.APM-ServiceJ=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.APM-KpiMonitor=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PKM-MDM=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PKM-Lib=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PKM-Monitor=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PKM-SA=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PKM-Service=I
endif
ifeq ($(strip $(MTK_MAPI_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-TranslatorManager=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-MdiRedirectorCtrl=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-MdiRedirector=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-NetworkSocketConnection=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-SocketConnection=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-SocketListener=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MAPI-CommandProcessor=I
endif
ifeq ($(strip $(MTK_MDMI_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-TranslatorManager=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-MdmiRedirectorCtrl=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-MdmiRedirector=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-Permission=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-CoreSession=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-NetworkSocketConnection=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-SocketConnection=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-SocketListener=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-CommandProcessor=I
    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MDMI-Provider=I
endif

####################################################################################################
## MTK Diagnostic Monitoring Framework End
####################################################################################################

# Add for opt_c2k_lte_mode
ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES +=ro.vendor.mtk_c2k_lte_mode=2
else
  PRODUCT_PROPERTY_OVERRIDES +=ro.vendor.mtk_c2k_lte_mode=0
endif

## For C2K CDMA feature file
ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml
endif

ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_c2k_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.flashless.fsm=0
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.flashless.fsm_cst=0
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.flashless.fsm_rw=0

  # network property
   ifeq ($(strip $(RAT_CONFIG_LTE_SUPPORT)),yes)
      PRODUCT_PROPERTY_OVERRIDES += telephony.lteOnCdmaDevice=1
   endif
endif

ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
    ifeq ($(strip $(RAT_CONFIG_LTE_SUPPORT)),yes)
        ifeq ($(strip $(RAT_CONFIG_WCDMA_SUPPORT)),yes)
            ifeq ($(strip $(RAT_CONFIG_NR_SUPPORT)),yes)
                # PREF_NET_TYPE_NR_LTE_TDSCDMA_CDMA_EVDO_GSM_WCDMA (33)
                PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=33,33,33,33
            else
                # NETWORK_MODE_LTE_CDMA_EVDO_GSM_WCDMA (10)
                PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=10,10,10,10
            endif
        else
            ifeq ($(strip $(RAT_CONFIG_NR_SUPPORT)),yes)
                # PREF_NET_TYPE_NR_LTE_CDMA_EVDO (25)
                PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=25,25,25,25
            else
                # NETWORK_MODE_LTE_CDMA_EVDO (8)
                PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=8,8,8,8
            endif
        endif
    else
        # NETWORK_MODE_GLOBAL (7)
        PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=7,7,7,7
    endif
else
    ifeq ($(strip $(RAT_CONFIG_LTE_SUPPORT)),yes)
        ifeq ($(strip $(RAT_CONFIG_NR_SUPPORT)),yes)
            # PREF_NET_TYPE_NR_LTE_TDSCDMA_GSM_WCDMA (32)
            PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=32,32,32,32
        else
            # NETWORK_MODE_LTE_GSM_WCDMA (9)
            PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=9,9,9,9
        endif
    else
        # NETWORK_MODE_WCDMA_PREF (0)
        PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=0,0,0,0
    endif
endif

# Add for opt_lte_support, opt_c2k_support, opt_ps1_rat
ifneq ($(strip $(MTK_PROTOCOL1_RAT_CONFIG)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ps1_rat=$(strip $(MTK_PROTOCOL1_RAT_CONFIG))

  ifneq ($(findstring L,$(strip $(MTK_PROTOCOL1_RAT_CONFIG))),)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_lte_support=1
  endif

  ifneq ($(findstring C,$(strip $(MTK_PROTOCOL1_RAT_CONFIG))),)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_c2k_support=1
  endif
endif

# Add for opt_c2k_support
ifneq ($(strip $(MTK_PROTOCOL1_RAT_CONFIG)),)
ifneq ($(findstring C,$(strip $(MTK_PROTOCOL1_RAT_CONFIG))),)
ifneq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.C2K_AT=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.C2K_RILC=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.C2K_ATConfig=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.LIBC2K_RIL=I
endif
endif
endif

# Add for Modem protocol2 capability setting
ifneq ($(strip $(MTK_PROTOCOL2_RAT_CONFIG)),)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.mtk_ps2_rat=$(strip $(MTK_PROTOCOL2_RAT_CONFIG))
endif

# Add for Modem protocol3 capability setting
ifneq ($(strip $(MTK_PROTOCOL3_RAT_CONFIG)),)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.mtk_ps3_rat=$(strip $(MTK_PROTOCOL3_RAT_CONFIG))
endif

# mtk sim switch policy
ifneq ($(strip $(MTK_DISABLE_CAPABILITY_SWITCH)),yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_sim_switch_policy=2
endif
ifeq ($(strip $(MTK_DISABLE_CAPABILITY_SWITCH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_disable_cap_switch=1
endif

ifeq ($(strip $(MTK_FLIGHT_MODE_POWER_OFF_MD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_flight_mode_power_off_md=1
endif

ifeq ($(strip $(MTK_WORLD_PHONE_POLICY)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_world_phone_policy=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_world_phone_policy=0
endif

ifeq ($(strip $(MTK_RILD_READ_IMSI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_rild_read_imsi=1
endif

# SMB: Remote SIM unlock
ifeq ($(strip $(SIM_ME_LOCK_MODE)), 3)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_sim_switch_policy=2
endif

ifneq ($(strip $(SIM_ME_LOCK_MODE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.sim_me_lock_mode=$(strip $(SIM_ME_LOCK_MODE))
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.sim_me_lock_mode=0
endif

ifeq ($(strip $(MTK_SUBSIDY_LOCK_SUPPORT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_subsidy_lock_support=1
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_sim_switch_policy=2
endif

# App Resolution Tuner
ifeq ($(strip $(MTK_APP_RESOLUTION_TUNER_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.app_resolution_tuner=1
else ifeq ($(strip $(MTK_GAME_AISR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.app_resolution_tuner=1
endif

# GiFT
ifeq ($(strip $(MTK_ARC_GIFT_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=meow
    PRODUCT_PACKAGES += libMEOW_data
endif

# AIVRS
ifeq ($(strip $(MTK_GPU_AIVRS_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk.gpu.aivrs=1
endif

#QT
ifeq ($(strip $(MTK_GPU_TUNER)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=meow
    PRODUCT_PACKAGES += libMEOW_data
endif

# GLT
ifeq ($(strip $(MTK_GLT_SUPPORT)), 1)
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=meow
    PRODUCT_PACKAGES += libMEOW_data
endif

# GLT FU
ifeq ($(strip $(MTK_GLT_FU_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk.gpu.glt=1
endif

# WifiResOverlay
PRODUCT_PACKAGES += WifiResOverlay
PRODUCT_PACKAGES += WifiResMainlineOverlay
ifneq ($(filter tablet ai_vision, $(MTK_PRODUCT_LINE)),)
    PRODUCT_PACKAGES += WifiResGoogleOverlay
endif

# add Framework Res Overlay for tablet, ai_vision
ifneq ($(filter tablet ai_vision, $(MTK_PRODUCT_LINE)),)
    PRODUCT_PACKAGES += TabletFrameworkResOverlay
endif

ifneq ($(strip $(MTK_MD_SBP_CUSTOM_VALUE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_md_sbp_custom_value=$(strip $(MTK_MD_SBP_CUSTOM_VALUE))
endif

# Add for Dynamic-SBP
ifeq ($(strip $(MTK_DYNAMIC_SBP_SUPPORT)), yes)
    ifneq ($(strip $(MTK_DYNAMIC_SBP_LEVEL)), )
          PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.mtk_dsbp_support= $(MTK_DYNAMIC_SBP_LEVEL)
    else
          PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.mtk_dsbp_support=1
    endif
endif

ifeq ($(strip $(MTK_EXTERNAL_SIM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_external_sim_support=1
endif

ifeq ($(strip $(MTK_DISABLE_PERSIST_VSIM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_persist_vsim_disabled=1
endif

ifneq ($(strip $(MTK_EXTERNAL_SIM_ONLY_SLOTS)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_external_sim_only_slots=$(strip $(MTK_EXTERNAL_SIM_ONLY_SLOTS))
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_external_sim_only_slots=0
endif

ifeq ($(strip $(MTK_EXTERNAL_SIM_RSIM_ENHANCEMENT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_non_dsda_rsim_support=1
endif

ifneq ($(strip $(MTK_RIL_SET_SBP_PLACE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.ril.set_sbp_place=$(strip $(MTK_RIL_SET_SBP_PLACE))
endif

# NeuroPilot
ifeq ($(strip $(MTK_NN_AI_CAM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_support=1
endif
ifeq ($(strip $(MTK_NN_SDK_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_baseline_support=1
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/ncc/ncc_lib/nhw/$(MTK_REL_PLATFORM)/arm/nhw:$(TARGET_COPY_OUT_VENDOR)/etc/nhw:mtk)
endif

# NeuroPilot
ifeq ($(strip $(MTK_NN_SDK_LAZY_HAL_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_lazyhal_support=1
endif

# CTA
ifeq ($(strip $(MTK_MOBILE_MANAGEMENT)), yes)
  ifneq ($(strip $(BUILD_GMS)), yes)
    ifneq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
     PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mobile_management=1
    endif
  endif
endif

# DuraSpeed
ifeq (yes,$(strip $(MTK_DURASPEED_SUPPORT)))
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.duraspeed.support=1
    PRODUCT_PROPERTY_OVERRIDES += ro.lmk.downgrade_pressure=60
    ifeq (yes,$(strip $(MTK_DURASPEED_DEFAULT_ON)))
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.duraspeed.app.on=1
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.duraspeed.lowmemory.enable=1
    endif
endif

# Add for Capability Test
ifneq ($(wildcard device/mediatek/vendor/capability_config/$(MTK_REL_PLATFORM)),)
    CAPABILITY_TEST_PLATFORM := $(MTK_REL_PLATFORM)
else
    CAPABILITY_TEST_PLATFORM := $(MTK_PLATFORM_DIR)
endif
ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-5.10)
  ifneq ($(wildcard device/mediatek/vendor/capability_config/$(CAPABILITY_TEST_PLATFORM)/capability_test_k510),)
    CAPABILITY_TEST_CONFIG := capability_test_k510
  endif
else ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-4.19)
  ifneq ($(wildcard device/mediatek/vendor/capability_config/$(CAPABILITY_TEST_PLATFORM)/capability_test_k419),)
    CAPABILITY_TEST_CONFIG := capability_test_k419
  endif
endif
CAPABILITY_TEST_CONFIG ?= capability_test

PRODUCT_COPY_FILES += \
      $(call add-to-product-copy-files-if-exists, device/mediatek/vendor/capability_config/$(CAPABILITY_TEST_PLATFORM)/$(CAPABILITY_TEST_CONFIG):$(TARGET_COPY_OUT_VENDOR)/etc/capability_test:mtk)

ifeq ($(strip $(MTK_VZW_CLIENT_API)),yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.clientapi_support=1
  PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_clientapi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_clientapi.xml
endif

ifeq ($(strip $(MTK_FACTORY_MODE_IN_GB2312)), yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.factory.GB2312=yes
    PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/factory.chn.ini:$(TARGET_COPY_OUT_VENDOR)/etc/factory.ini
else
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.factory.GB2312=no
    PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/factory.ini:$(TARGET_COPY_OUT_VENDOR)/etc/factory.ini
endif

# Audio Related Resource
PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/res/sound/testpattern1.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/testpattern1.wav:mtk
PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/res/sound/ringtone.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/ringtone.wav:mtk

#Images for LCD test in factory mode
PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/res/images/lcd_test_00.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_00.png:mtk
PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/res/images/lcd_test_01.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_01.png:mtk
PRODUCT_COPY_FILES += $(MTK_PATH_CUSTOM)/factory/res/images/lcd_test_02.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_02.png:mtk

ifeq ($(strip $(MTK_RCS_UA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_rcs_ua_support=1
  PRODUCT_COPY_FILES += \
          vendor/mediatek/proprietary/operator/external/volte_rcs_stack_lib/rcs_volte_stack.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/rcs_volte_stack.rc
  PRODUCT_COPY_FILES += \
          vendor/mediatek/proprietary/operator/external/volte_rcs/Common/volte_rcs_ua.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/volte_rcs_ua.rc
  PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_rcs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_rcs.xml
endif

ifeq ($(strip $(MTK_ANDROID_WIDE_GAMUT_DISPLAY)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.has_wide_color_display=true
endif

#Set MTK fast charging support config
ifeq ($(strip $(MTK_FAST_CHARGER_TECH)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fast_charging_support=1
endif

# Always On Display
ifeq ($(strip $(MTK_AOD_SUPPORT)), yes)
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.mtk_aod_support=1
endif


ifeq ($(strip $(MTK_SENSOR_SUPPORT)),yes)

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk.sensor.support=yes

ifeq ($(strip $(TARGET_SUPPORTS_64_BIT_APPS)),true)
  VEXT_PRODUCT_SYMLINK_FILES += sensors.mediatek.V2.0.so:vendor/lib64/hw/sensors.$(TARGET_BOARD_PLATFORM).so
else
  VEXT_PRODUCT_SYMLINK_FILES += sensors.mediatek.V2.0.so:vendor/lib/hw/sensors.$(TARGET_BOARD_PLATFORM).so
endif

ifeq ($(strip $(CUSTOM_KERNEL_ACCELEROMETER)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_MAGNETOMETER)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.compass.xml:vendor/etc/permissions/android.hardware.sensor.compass.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_ALSPS)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml
else
  ifeq ($(strip $(CUSTOM_KERNEL_PS)),yes)
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml
  endif
  ifeq ($(strip $(CUSTOM_KERNEL_ALS)),yes)
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml
  endif
endif

ifeq ($(strip $(CUSTOM_KERNEL_GYROSCOPE)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_BAROMETER)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_HUMIDITY)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_STEP_COUNTER)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml
endif

ifeq ($(strip $(CUSTOM_KERNEL_STEP_DETECTOR)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml
endif

# for hifi sensors feature
ifeq ($(strip $(CUSTOM_HIFI_SENSORS)), yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml
endif
endif


# ART vm heap default settings
ifeq (yes,$(strip $(MTK_GMO_RAM_OPTIMIZE)))
# ART vm heap parameter for ago
  $(warning AGO need to set dalvik.vm.heapxxx parameter)
#  PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=
#  PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=
else
# ART vm heap parameter for non-ago
# Add for Automatic Setting for heapgrowthlimit & heapsize
  RESOLUTION_HXW := $(shell expr $(LCM_HEIGHT) \* $(LCM_WIDTH))
  ifeq ($(shell test $(RESOLUTION_HXW) -ge 0 && test $(RESOLUTION_HXW) -lt 3500000 && echo true), true)
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=256m
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=512m
  else ifeq ($(shell test $(RESOLUTION_HXW) -ge 3500000 && echo true), true)
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=384m
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=768m
  else
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=256m
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=512m
  endif
endif

# Wide Gamut Capture
ifeq ($(strip $(MTK_ISP_SUPPORT_COLOR_SPACE)), 2)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.isp.support.colorspace=2
else ifeq ($(strip $(MTK_ISP_SUPPORT_COLOR_SPACE)), 1)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.isp.support.colorspace=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.isp.support.colorspace=0
endif

# Meta tool data
PRODUCT_PACKAGES += meta_wifi_data

VEXT_PRODUCT_SYMLINK_FILES += audio.r_submix.mediatek.so:vendor/lib/hw/audio.r_submix.$(TARGET_BOARD_PLATFORM).so
VEXT_PRODUCT_SYMLINK_FILES += audio.r_submix.mediatek.so:vendor/lib64/hw/audio.r_submix.$(TARGET_BOARD_PLATFORM).so

ifeq ($(strip $(MTK_SEC_VIDEO_PATH_SUPPORT)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_sec_video_path_support=1
endif
ifeq ($(strip $(MTK_TEE_GP_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tee_gp_support=1
endif
ifeq ($(strip $(MTK_WFD_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_wfd_support=1
  PRODUCT_COPY_FILES += \
    $(call add-to-product-copy-files-if-exists, $(MTK_TARGET_PROJECT_FOLDER)/wfd_source_capability.csv:$(TARGET_COPY_OUT_VENDOR)/etc/wfd_source_capability.csv:mtk) \
    $(call add-to-product-copy-files-if-exists, $(MTK_PROJECT_FOLDER)/wfd_source_capability.csv:$(TARGET_COPY_OUT_VENDOR)/etc/wfd_source_capability.csv:mtk) \
    $(call add-to-product-copy-files-if-exists, device/mediatek/$(MTK_REL_PLATFORM)/wfd_source_capability.csv:$(TARGET_COPY_OUT_VENDOR)/etc/wfd_source_capability.csv:mtk) \
    $(LOCAL_PATH)/wfd_source_capability.csv:$(TARGET_COPY_OUT_VENDOR)/etc/wfd_source_capability.csv:mtk
endif

#apdb
include $(wildcard vendor/mediatek/proprietary/buildinfo_vnd/label.ini)
PRODUCT_PACKAGES += apdb

# MPE
ifeq ($(strip $(MTK_MPE_SUPPORT)),yes)
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/connectivity/gps/mtk_mnld/etc/mpe.conf:$(TARGET_COPY_OUT_VENDOR)/etc/mpe.conf:mtk
endif

ifeq ($(strip $(MTK_RCS_SINGLE_REG)),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.telephony.ims.singlereg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.singlereg.xml
endif

ifdef MTK_GENERIC_HAL
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_thermal_2_0=1
else
  ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-5.10)
     ifeq ($(strip $(MTK_REL_PLATFORM)),mt6893)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_thermal_2_0=0
     else
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_thermal_2_0=1
     endif
  endif
endif

#CCU dependencies
PRODUCT_PACKAGES += lib3a.ccu

#CCD firmware
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/mtkcam-hwcore/camsys/ccd/bin/remoteproc_scp:$(TARGET_COPY_OUT_VENDOR)/firmware/remoteproc_scp

# Enable Scoped Storage for the kernel version without CONFIG_SDCARD_FS
# CONFIG_SDCARD_FS enable only in OTA to S.
ifeq (true,$(call math_gt_or_eq,$(VEXT_PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),31))
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
endif

# C2 HAL
ifneq ($(MTK_BASIC_PACKAGE), yes)
ifneq ($(MTK_C2_SERVICE_DISABLED), yes)
ifeq ($(strip $(MTK_C2_SERVICE_64_BIT)), yes)
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/libc2/service/android.hardware.media.c2@1.2-mediatek-64b.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.media.c2@1.2-mediatek-64b.rc
else
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/libc2/service/android.hardware.media.c2@1.2-mediatek.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.media.c2@1.2-mediatek.rc
endif
endif
endif

ifeq (yes, $(strip $(MTK_EFUSE_WRITER_SUPPORT)))
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.efuse_writer_enable=1
endif

ifneq (,$(wildcard vendor/mediatek/kernel_modules/fpsgo_int/init.fpsgo.rc))
PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/fpsgo_int/init.fpsgo.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.fpsgo.rc
else
PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/fpsgo_cus/init.fpsgo.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.fpsgo.rc
endif

ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/mtk_irq_mon/mtk_irq_mon.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/mtk_irq_mon.rc
endif

# dynamic log configuration
ifeq ($(MTK_PRODUCT_LINE), smart_phone)
  ifneq ($(strip $(MTK_V4L2_INTERFACE)), yes)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/VideoLog_legacy_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/VideoLog_dynamic.xml:mtk
  else
    ifeq ($(strip $(MTK_REL_PLATFORM)),mt6855)
      PRODUCT_COPY_FILES += $(LOCAL_PATH)/VideoLog_vdec_vcp_venc_vcu_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/VideoLog_dynamic.xml:mtk
    else
      ifneq ($(strip $(MTK_TINYSYS_VCP_SUPPORT)), yes)
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/VideoLog_v4l2_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/VideoLog_dynamic.xml:mtk
      else
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/VideoLog_vcp_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/VideoLog_dynamic.xml:mtk
      endif
    endif
  endif
endif

# secure camera
ifeq ($(strip $(MTK_CAM_SECURITY_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_cam_security_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_cam_security_support=0
endif

# MAGT feature
ifeq ($(strip $(MTK_MAGT_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.magt.mtk_magt_support=1
endif

# support kpoc adb mode
ifeq ($(strip $(MTK_USB_KPOC_ADB)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.usb.kpoc_adb=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.usb.kpoc_adb=0
endif

#Dummy Speech Driver
ifeq ($(MTK_TB_WIFI_3G_MODE),WIFI_ONLY)
  AUDIO_PARAM_OPTIONS_LIST += MTK_SPEECH_DUMMY=yes
endif

#################################################
# device/mediatek/vendor/common/device.mk end   #
#################################################

# Do NOT modify below this line
_my_whitelist := \
  %.img \
  MDDB.MCF.ODB.tar.gz \
  $(TARGET_COPY_OUT_SYSTEM)/bin/snapuserd \
  $(TARGET_COPY_OUT_SYSTEM)/etc/init/snapuserd.rc \
  $(TARGET_COPY_OUT_RAMDISK)/system/bin/e2fsck \
  $(TARGET_COPY_OUT_VENDOR)/ro.prop \
  $(TARGET_COPY_OUT_VENDOR)/rw.prop \

_my_paths := \
  $(TARGET_COPY_OUT_VENDOR)/bin/ \
  $(TARGET_COPY_OUT_VENDOR)/etc/ \
  $(TARGET_COPY_OUT_VENDOR)/firmware/ \
  $(TARGET_COPY_OUT_VENDOR)/lib/ \
  $(TARGET_COPY_OUT_VENDOR)/lib64/ \
  $(TARGET_COPY_OUT_VENDOR)/overlay/ \
  $(TARGET_COPY_OUT_VENDOR)/res/ \
  $(TARGET_COPY_OUT_ODM)/etc/ \
  testcases/sigma/ \

-include vendor/mediatek/build/core/releaseBRM_vext.mk

ifneq ($(wildcard vendor/mediatek/internal/build),)
MTK_SPLIT_BUILD_CHECKER ?= yes
endif
ifeq ($(MTK_SPLIT_BUILD_CHECKER),yes)
ifdef VEXT_TARGET_PROJECT
$(call require-artifacts-in-path-relaxed, $(_my_paths), $(_my_whitelist))
endif
endif
