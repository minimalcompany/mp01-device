ifdef SYS_TARGET_PROJECT
#$(call inherit-product-if-exists,device/mediatek/system/common/device.mk)
else ifdef HAL_TARGET_PROJECT
else ifneq ($(filter full_%,$(TARGET_PRODUCT)),)
$(call inherit-product-if-exists,device/mediatek/system/common/device.mk)
else ifeq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/vnd_*.mk),)
$(call inherit-product-if-exists,device/mediatek/system/common/device.mk)
endif
ifndef HAL_TARGET_PROJECT
#$(call inherit-product-if-exists,$(LOCAL_PATH)/device-kernel.mk)
$(call inherit-product-if-exists,$(LOCAL_PATH)/device-vext.mk)
endif

ifndef MTK_PLATFORM_DIR
  ifneq ($(wildcard device/mediatek/$(MTK_PLATFORM)),)
    MTK_PLATFORM_DIR := $(MTK_PLATFORM)
  else
    MTK_PLATFORM_DIR := $(call to-lower,$(MTK_PLATFORM))
  endif
endif

ifdef HAL_TARGET_PROJECT
DEVICE_MANIFEST_FILE :=
else
DEVICE_MANIFEST_FILE := $(strip $(DEVICE_MANIFEST_FILE))
endif

# Full Treble, new in O
PRODUCT_SHIPPING_API_LEVEL_OVERRIDE ?= 31
.KATI_READONLY := PRODUCT_SHIPPING_API_LEVEL_OVERRIDE

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
    PRODUCT_SET_DEBUGFS_RESTRICTIONS := false
endif

ifeq ($(MTK_DYNAMIC_PARTITION_SUPPORT), yes)
PRODUCT_USE_DYNAMIC_PARTITIONS := true
endif

ifneq ($(wildcard device/mediatek/$(TARGET_BOARD_PLATFORM)),)
  MTK_REL_PLATFORM := $(TARGET_BOARD_PLATFORM)
else
  MTK_REL_PLATFORM := $(MTK_PLATFORM_DIR)
#  $(error the platform dir changed, expected: device/mediatek/$(MTK_PLATFORM_DIR), please check manually)
endif

PRODUCT_PACKAGES += mgvi_platform_package

# HDR Video Library
PRODUCT_PACKAGES += libhdrvideo

# sensor HAL HIDL
PRODUCT_COPY_FILES += $(LOCAL_PATH)/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service.multihal-mediatek
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.X-subhal-mediatek
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_sensor_hidl_v2.xml

ifdef MTK_GENERIC_HAL
    INIT_SENSOR_RC = init.sensor_2_0.rc
else
    INIT_SENSOR_RC = init.sensor_$(subst .,_,$(strip $(MTK_SENSOR_ARCHITECTURE))).rc
    $(foreach custom_hal_msensorlib,$(CUSTOM_HAL_MSENSORLIB),$(eval PRODUCT_PACKAGES += lib$(custom_hal_msensorlib)))
    ifeq ($(strip $(MTK_SENSOR_ARCHITECTURE)), 1.0)
        PRODUCT_PACKAGES += libhwm
    endif
endif
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.init.sensor.rc=$(INIT_SENSOR_RC)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/$(INIT_SENSOR_RC):$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/$(INIT_SENSOR_RC)

# AOSP libmeminfo/libdmabufinfo tool
PRODUCT_PACKAGES += dmabuf_dump.vendor

#GMS requirement
PRODUCT_COPY_FILES += $(LOCAL_PATH)/chipinfo:$(TARGET_COPY_OUT_VENDOR)/bin/chipinfo

#MtkLatinIME

#ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
#    PRODUCT_PACKAGES += MtkLatinIME
#endif

##fbconfig for display
ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
    PRODUCT_PACKAGES += fbconfig
endif

# MediaTek framework base modules
#PRODUCT_PACKAGES += \
#    mediatek-common \
#    mediatek-framework \
#    CustomPropInterface \
#    mediatek-telephony-common \
#    mediatek-telephony-base

# Mediatek default Fwk plugin always compile as per MPlugin new design
#PRODUCT_PACKAGES += \
#    FwkPlugin

#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
## Override the PRODUCT_BOOT_JARS to include the MediaTek system base modules for global access
#PRODUCT_BOOT_JARS += \
#    mediatek-common \
#    mediatek-framework \
#    mediatek-telephony-base \
#    mediatek-telephony-common
#endif

# Telephony
#PRODUCT_COPY_FILES += device/mediatek/config/apns-conf.xml:system/etc/apns-conf.xml:mtk
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/ril/fusion/mtk-ril/mdcomm/data/vendor-apns-conf.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vendor-apns-conf.xml:mtk
#PRODUCT_COPY_FILES += $(LOCAL_PATH)/spn-conf.xml:system/etc/spn-conf.xml:mtk

# Graphic Extension Deployment
#PRODUCT_PACKAGES += libged_sys
#PRODUCT_PACKAGES += libged_kpi

#FP
ifeq ($(MTK_GENERIC_HAL), yes)
ifeq ($(MGVI_MTK_FINGERPRINT_SUPPORT), yes)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1-impl \
    android.hardware.biometrics.fingerprint@2.1-service

PRODUCT_PACKAGES += \
    libgf_ca \
    libgf_hal \
    libvendor.goodix.hardware.biometrics.fingerprint@2.1 \
    fingerprint.mediatek \
    com.goodix.fingerprint \
    GFManager
endif
endif

# DRVB
PRODUCT_PACKAGES += libmtk_drvb

# Common overlay moved from project device.mk
#DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/sd_in_ex_otg
#ifdef OPTR_SPEC_SEG_DEF
#  ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
#    OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
#    SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
#    SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/$(OPTR)/$(SPEC)/$(SEG)
#  endif
#endif
#ifneq (yes,$(strip $(MTK_TABLET_PLATFORM)))
#  ifeq (480,$(strip $(LCM_WIDTH)))
#    ifeq (854,$(strip $(LCM_HEIGHT)))
#      DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/FWVGA
#    endif
#  endif
#  ifeq (540,$(strip $(LCM_WIDTH)))
#    ifeq (960,$(strip $(LCM_HEIGHT)))
#      DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/qHD
#    endif
#  endif
#endif
#DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/navbar

# AGO
$(call inherit-product-if-exists, $(LOCAL_PATH)/ago/device.mk)

# Audio HAL
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_audio.xml

PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl-mediatek \
    android.hardware.audio@7.0-impl-mediatek \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio.effect@7.0-impl \
    vendor.mediatek.hardware.bluetooth.audio@2.1-impl \
    vendor.mediatek.hardware.bluetooth.audio@2.2-impl \
    android.hardware.bluetooth.audio@2.0-impl \
    android.hardware.bluetooth.audio@2.1-impl

PRODUCT_PACKAGES += \
   android.hardware.audio.service.mediatek

# Bluetooth Audio A2DP HW module
PRODUCT_PACKAGES += \
   audio.bluetooth.default

# MTK effects
PRODUCT_PACKAGES += \
   libaudiopreprocessing_mtk

PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio_em.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_em.xml:mtk
PRODUCT_COPY_FILES += $(LOCAL_PATH)/AbnormalDisplayLog_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/AbnormalDisplayLog_dynamic.xml:mtk
PRODUCT_COPY_FILES += $(LOCAL_PATH)/AudioLog_dynamic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/AudioLog_dynamic.xml:mtk

RAT_CONFIG := $(strip $(MTK_PROTOCOL1_RAT_CONFIG))
ifneq (,$(RAT_CONFIG))
  ifneq (,$(findstring C,$(RAT_CONFIG)))
    # C2K is supported
    RAT_CONFIG_CDMA_SUPPORT=yes
  endif
endif

ifeq ($(strip $(MTK_TELEPHONY_FEATURE_SWITCH_DYNAMICALLY)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_telephony_switch=1
endif

ifeq ($(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF))),OP18)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_sos_quick_dial=1
endif

# Tablet Wifi only & Data Only & Data + SMS mode

ifndef MTK_TB_WIFI_3G_MODE
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tb_wifi_3g_mode=0
else
ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), WIFI_ONLY)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tb_wifi_3g_mode=1
endif
ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tb_wifi_3g_mode=2
endif
ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_ONLY)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tb_wifi_3g_mode=3
endif
endif

# Rat switch related properties for telephnoy

# Add for opt_md1_support
ifneq ($(strip $(MTK_MD1_SUPPORT)),)
  ifneq ($(strip $(MTK_MD1_SUPPORT)), 0)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_md1_support=$(strip $(MTK_MD1_SUPPORT))
  endif
endif

# Add for opt_md3_support
ifneq ($(strip $(MTK_MD3_SUPPORT)),)
  ifneq ($(strip $(MTK_MD3_SUPPORT)), 0)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_md3_support=$(strip $(MTK_MD3_SUPPORT))
  endif
endif

# Add for opt_eccci_c2k
ifeq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_eccci_c2k=1
endif

ifeq ($(strip $(MTK_MP2_PLAYBACK_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_support_mp2_playback=1
endif

ifeq ($(strip $(MTK_AUDIO_ALAC_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_audio_alac_support=1
endif

#MTB
#PRODUCT_PACKAGES += mtk_setprop

#MMS
#ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#    ifndef MTK_TB_WIFI_3G_MODE
#        PRODUCT_PACKAGES += messaging
#    else
#        ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
#            PRODUCT_PACKAGES += messaging
#        endif
#    endif
#endif
#
#ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
#    ifndef MTK_TB_WIFI_3G_MODE
#        PRODUCT_PACKAGES += messaging
#    else
#        ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
#            PRODUCT_PACKAGES += messaging
#        endif
#    endif
#endif
#
#ifdef MTK_OVERRIDES_APKS
#    ifeq ($(strip $(MTK_OVERRIDES_APKS)), yes)
#        ifndef MTK_TB_WIFI_3G_MODE
#            PRODUCT_PACKAGES += MtkMms
#            PRODUCT_PACKAGES += SoundRecorder
#            PRODUCT_PACKAGES += MtkMmsAppService
#        else
#            ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
#                PRODUCT_PACKAGES += MtkMms
#                PRODUCT_PACKAGES += SoundRecorder
#                PRODUCT_PACKAGES += MtkMmsAppService
#            endif
#        endif
#    else
#       ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
#           ifndef MTK_TB_WIFI_3G_MODE
#               PRODUCT_PACKAGES += messaging
#           else
#               ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
#                   PRODUCT_PACKAGES += messaging
#               endif
#           endif
#      endif
#    endif
#else
#    ifndef MTK_TB_WIFI_3G_MODE
#        PRODUCT_PACKAGES += MtkMms
#        PRODUCT_PACKAGES += SoundRecorder
#        PRODUCT_PACKAGES += MtkMmsAppService
#    else
#        ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
#            PRODUCT_PACKAGES += MtkMms
#            PRODUCT_PACKAGES += SoundRecorder
#            PRODUCT_PACKAGES += MtkMmsAppService
#        endif
#    endif
#endif

#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#    PRODUCT_PACKAGES += MtkBrowser
#    PRODUCT_PACKAGES += SoundRecorder
#endif

# Telephony Setting Service AOSP code will be replaced by MTK
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/services/Telephony/Android.mk),)
#PRODUCT_PACKAGES += MtkTeleService
#endif
#endif

# Telephony begin
ifeq ($(strip $(MTK_TC1_COMMON_SERVICE)), yes)
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), ss)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_ss.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsds)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_dsds.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsda)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_dsds.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), tsts)
        ifeq ($(strip $(MTK_EXTERNAL_SIM_RSIM_ENHANCEMENT)), yes)
            DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_dsds.xml
        else
            DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_tsts.xml
        endif
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), qsqs)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tc1_qsqs.xml
    endif
else
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), ss)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_ss.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsds)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_dsds.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsda)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_dsds.xml
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), tsts)
        ifeq ($(strip $(MTK_EXTERNAL_SIM_RSIM_ENHANCEMENT)), yes)
            DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_dsds.xml
        else
            DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tsts.xml
        endif
    endif
    ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), qsqs)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_qsqs.xml
    endif
endif

# add radioconfig
ifneq ($(strip $(MTK_TB_WIFI_3G_MODE)),WIFI_ONLY)
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_radioconfig.xml
endif

#for dynamic MSIM switch
ODM_MANIFEST_SKUS := ss dsds tsts qsqs

ODM_MANIFEST_SS_FILES := $(LOCAL_PATH)/project_manifest/odm_manifest_ss.xml
ODM_MANIFEST_DSDS_FILES := $(LOCAL_PATH)/project_manifest/odm_manifest_dsds.xml
ODM_MANIFEST_TSTS_FILES := $(LOCAL_PATH)/project_manifest/odm_manifest_tsts.xml
ODM_MANIFEST_QSQS_FILES := $(LOCAL_PATH)/project_manifest/odm_manifest_qsqs.xml

#for operator manifests
ODM_MANIFEST_SS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_op_ss.xml
ODM_MANIFEST_DSDS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_op_dsds.xml
ODM_MANIFEST_TSTS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_op_tsts.xml
ODM_MANIFEST_QSQS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_op_qsqs.xml

## Platform libs
PRODUCT_PACKAGES += libmtkcutils
PRODUCT_PACKAGES += libmtkutils
PRODUCT_PACKAGES += libmtkproperty
PRODUCT_PACKAGES += libmtkrillog
PRODUCT_PACKAGES += libmtkares
PRODUCT_PACKAGES += libmtkhardware_legacy
PRODUCT_PACKAGES += libmtksysutils
PRODUCT_PACKAGES += libmtknetutils

PRODUCT_PACKAGES += muxreport
PRODUCT_PACKAGES += mtkrild
PRODUCT_PACKAGES += mtk-ril
PRODUCT_PACKAGES += libmtkutilril
PRODUCT_PACKAGES += gsm0710muxd

ifeq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
    PRODUCT_PACKAGES += libmtk-ril
    PRODUCT_PACKAGES += libmtkmipc-ril
    PRODUCT_PACKAGES += mtkfusionrild
    PRODUCT_PACKAGES += librilfusion
    PRODUCT_PACKAGES += libmnetlink_v104
    PRODUCT_PACKAGES += libvia-ril
    PRODUCT_PACKAGES += libviamipc-ril
    PRODUCT_PACKAGES += libcarrierconfig
    PRODUCT_PACKAGES += libmtk-fusion-ril-prop-vsim
    PRODUCT_PACKAGES += libmtk-fusion-ril-mipc-vsim
endif

ifeq ($(strip $(MTK_CAPABILITY_CONTROL_SUPPORT)), yes)
    PRODUCT_PACKAGES += libcapctrl
endif

#PRODUCT_PACKAGES += md_minilog_util
#ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
#    PRODUCT_PACKAGES += SimRecoveryTestTool
#endif
PRODUCT_PACKAGES += libratconfig

# For NA sim lock
PRODUCT_PACKAGES += libsimmelock
PRODUCT_PACKAGES += libsimlock

ifeq ($(strip $(RAT_CONFIG_CDMA_SUPPORT)),yes)
#For C2K RIL
PRODUCT_PACKAGES += \
          viarild \
          libc2kril \
          libviatelecom-withuim-ril \
          viaradiooptions \
          librpcril \
          ctclient

##Set CT6M_SUPPORT
#ifeq ($(strip $(CT6M_SUPPORT)), yes)
#PRODUCT_PACKAGES += CdmaSystemInfo
#PRODUCT_PROPERTY_OVERRIDES += ro.ct6m_support=1
#endif

##For PPPD
#PRODUCT_PACKAGES += \
#          ip-up-cdma \
#          ipv6-up-cdma \
#          link-down-cdma \
#          pppd_via

#For C2K control modules
PRODUCT_PACKAGES += \
          libc2kutils \
          flashlessd \
          statusd
endif

# MAL shared library
#PRODUCT_PACKAGES += libmdfx
#PRODUCT_PACKAGES += libmal_mdmngr
#PRODUCT_PACKAGES += libmal_nwmngr
#PRODUCT_PACKAGES += libmal_rilproxy
#PRODUCT_PACKAGES += libmal_simmngr
#PRODUCT_PACKAGES += libmal_datamngr
#PRODUCT_PACKAGES += libmal_rds
#PRODUCT_PACKAGES += libmal_epdga
#PRODUCT_PACKAGES += libmal_imsmngr
#PRODUCT_PACKAGES += libmal
#
#PRODUCT_PACKAGES += volte_imsm
#PRODUCT_PACKAGES += volte_imspa

# MAL-Dongle shared library
#PRODUCT_PACKAGES += libmd_mdmngr
#PRODUCT_PACKAGES += libmd_rilproxy
#PRODUCT_PACKAGES += libmd_simmngr
#PRODUCT_PACKAGES += libmd_datamngr
#PRODUCT_PACKAGES += libmd_nwmngr
#PRODUCT_PACKAGES += libmd

# # Volte IMS shared library
#PRODUCT_PACKAGES += volte_imspa_md

# Add for (VzW) chipset test
#ifneq ($(strip $(MTK_VZW_CHIPTEST_MODE_SUPPORT)), 0)
#PRODUCT_PACKAGES += libatch
#PRODUCT_PACKAGES += libatcputil
#PRODUCT_PACKAGES += atcp
#PRODUCT_PACKAGES += libswext_plugin
#PRODUCT_PACKAGES += libnetmngr_plugin
#
#PRODUCT_PACKAGES += liblannetmngr_core
#PRODUCT_PACKAGES += liblannetmngr_api
#PRODUCT_PACKAGES += lannetmngrd
#PRODUCT_PACKAGES += lannetmngr_test
#endif

# VoLTE Process
#ifneq ($(strip $(MTK_BUILD_IGNORE_IMS_REPO)),yes)
#    ifeq ($(strip $(MSSI_MTK_IMS_SUPPORT)),yes)
#        PRODUCT_PACKAGES += volte_xdmc
#        PRODUCT_PACKAGES += volte_core
#        PRODUCT_PACKAGES += volte_ua
#        PRODUCT_PACKAGES += volte_stack
#        PRODUCT_PACKAGES += volte_imcb
#        PRODUCT_PACKAGES += libipsec_ims_shr
#
#        # MAL Process
#        PRODUCT_PACKAGES += mtkmal
#
#        # # Volte IMS Dongle Process
#        PRODUCT_PACKAGES += volte_imsm_md
#
#    else
#        ifeq ($(strip $(MTK_EPDG_SUPPORT)),yes) # EPDG without IMS
#
#            # MAL Process
#            PRODUCT_PACKAGES += mtkmal
#
#            # # Volte IMS Dongle Process
#            #    PRODUCT_PACKAGES += volte_imsm_md
#        endif
#    endif
#endif

# VoLTE Process
ifneq ($(strip $(MTK_BUILD_IGNORE_IMS_REPO)),yes)
    ifeq ($(strip $(MTK_IMS_SUPPORT)),yes)
        PRODUCT_PACKAGES += libipsec_ims_shr
    endif
endif

 # include init.volte.rc
 #ifeq ($(MTK_IMS_SUPPORT),yes)
 #    ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/init.volte.rc),)
 #        PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/init.volte.rc:root/init.volte.rc
 #    else
 #        ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/init.volte.rc),)
 #            PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/init.volte.rc:root/init.volte.rc
 #        else
 #            PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.volte.rc:root/init.volte.rc
 #        endif
 #    endif
 #endif

#include multi_init.rc in meta mode and factory mode.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/multi_init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/multi_init.rc

#include meta_init.vendor.rc in meta mode and factory mode.
PRODUCT_COPY_FILES += $(LOCAL_PATH)/meta_init.vendor.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.vendor.rc

# WFCA Process
ifneq ($(strip $(MTK_BUILD_IGNORE_IMS_REPO)),yes)
    ifeq ($(strip $(MTK_WFC_SUPPORT)),yes)
      PRODUCT_PACKAGES += wfca
    endif
endif


## Hwui program binary service
#PRODUCT_PACKAGES += program_binary_service
#PRODUCT_PACKAGES += program_binary_builder
## Hwui extension
#PRODUCT_PACKAGES += libhwuiext
#

# PPL only enalbed in internal + NON GMS + Non Low memory
ifneq ($(wildcard vendor/mediatek/internal/mtkcta_enable),)
ifeq ($(strip $(MTK_TELEPHONY_ADD_ON_POLICY)), 0)
ifeq ($(strip $(MTK_PRIVACY_PROTECTION_LOCK)),yes)
    ifneq ($(strip $(BUILD_GMS)), yes)
        ifneq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
#           PRODUCT_PACKAGES += PrivacyProtectionLock
            PRODUCT_PACKAGES += ppl_agent
            DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_pplagent.xml
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_privacy_protection_lock=1
        endif
    endif
endif
endif
endif

ifeq ($(strip $(MTK_ENGINEERMODE_APP)),yes)
  ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
    ifneq ($(wildcard vendor/mediatek/internal/em_enable),)
      DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_em.xml
      PRODUCT_PACKAGES += em_hidl
    else
      ifneq ($(filter $(TARGET_BUILD_VARIANT),eng userdebug),)
        DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_em.xml
        PRODUCT_PACKAGES += em_hidl
      endif
    endif
  endif
endif

ifeq ($(strip $(GOOGLE_RELEASE_RIL)), yes)
    PRODUCT_PACKAGES += libril
else
    PRODUCT_PACKAGES += librilmtk
endif

#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#    PRODUCT_PACKAGES += mediatek-packages-teleservice
#    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/opt/teleservice/mediatek-packages-teleservice.xml:system/etc/permissions/mediatek-packages-teleservice.xml:mtk)
#endif
#
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/services/Telecomm/Android.bp),)
#    PRODUCT_PACKAGES += MtkTelecom
#    PRODUCT_PACKAGES += CallRecorderService
#    PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.Telecom=I
#endif
#endif
## Telephony end

# For MTK MediaProvider
# PRODUCT_PACKAGES += MtkMediaProvider

#PRODUCT_PACKAGES += Camera
PRODUCT_PACKAGES += Panorama
PRODUCT_PACKAGES += NativePip
PRODUCT_PACKAGES += SlowMotion
PRODUCT_PACKAGES += CameraRoot
# for Advanced Camera Service
#PRODUCT_PACKAGES += mtk_advcamserver

# MediaTek Camera Hal
PRODUCT_PACKAGES_DEBUG += mtkcam-debug
PRODUCT_PACKAGES_DEBUG += securecamera_test
PRODUCT_PACKAGES_DEBUG += mmshal_test
PRODUCT_PACKAGES_DEBUG += isphal_test

# MediaTek Camera stream info plugin
PRODUCT_PACKAGES += libmtkcam_streaminfo_plugin-p1stt

# for HIDLLomoHal
PRODUCT_PACKAGES += vendor.mediatek.hardware.camera.lomoeffect@1.0-impl

# for HIDLCCAPHal
PRODUCT_PACKAGES += vendor.mediatek.hardware.camera.ccap@1.0-impl


# for HIDL BGService
ifeq ($(strip $(MTK_CAM_BGSERVICE_SUPPORT)), yes)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_bgservice.xml
    PRODUCT_PACKAGES += vendor.mediatek.hardware.camera.bgservice@1.0-impl
    PRODUCT_PACKAGES += vendor.mediatek.hardware.camera.bgservice@1.1-impl
endif


PRODUCT_DEFAULT_PROPERTY_OVERRIDES += camera.disable_zsl_mode=1
PRODUCT_PROPERTY_OVERRIDES += vendor.camera.mdp.dre.enable?=0
PRODUCT_PROPERTY_OVERRIDES += vendor.camera.mdp.cz.enable?=0

# camera hal3 default buffer count for imgo.
# (overridable in platform-/project-level device.mk)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.imgo=7
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.imgo=6
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.base.imgo=4

# camera hal3 default buffer count for rrzo.
# (overridable in platform-/project-level device.mk)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.rrzo=7
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.rrzo=6
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.base.rrzo=4

# camera hal3 default buffer count for lcso.
# (overridable in platform-/project-level device.mk)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.lcso=7
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.lcso=6
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.base.lcso=4

# camera hal3 default buffer count for rsso.
# (overridable in platform-/project-level device.mk)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.rsso=7
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.rsso=6
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.base.rsso=5

# camera hal3 default buffer count for fd yuv.
# (overridable in platform-/project-level device.mk)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.fdyuv?=5
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.fdyuv?=5

PRODUCT_PACKAGES += autokd
RODUCT_PACKAGES += \
    dhcp6c \
    dhcp6ctl \
    dhcp6c.conf \
    dhcp6cDNS.conf \
    dhcp6s \
    dhcp6s.conf \
    dhcp6c.script \
    dhcp6cctlkey \
    libifaddrs

# meta tool
include $(wildcard vendor/mediatek/proprietary/buildinfo_vnd/label.ini)
$(call inherit-product-if-exists, vendor/mediatek/proprietary/buildinfo_vnd/branch.mk)
#PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.mediatek.version.release=$(strip $(MTK_INTERNAL_BUILD_VERNO))
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mediatek.version.release=$(strip $(MTK_INTERNAL_BUILD_VERNO))

# VENDOR_SECURITY_PATCH
$(call inherit-product-if-exists, vendor/mediatek/proprietary/buildinfo_vnd/device.mk)

## To specify customer's releasekey
ifdef MTK_TARGET_PROJECT
ifneq ($(wildcard $(strip $(MTK_TARGET_PROJECT_FOLDER))/security),)
  PRODUCT_DEFAULT_DEV_CERTIFICATE := $(strip $(MTK_TARGET_PROJECT_FOLDER))/security/releasekey
else ifneq ($(wildcard device/mediatek/security),)
  PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/security/releasekey
else
  ifeq ($(MTK_SIGNATURE_CUSTOMIZATION),yes)
    ifeq ($(wildcard device/mediatek/security/$(strip $(MTK_TARGET_PROJECT))),)
      $(error Please create device/mediatek/security/$(strip $(MTK_TARGET_PROJECT))/ and put your releasekey there!!)
    else
      PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/security/$(strip $(MTK_TARGET_PROJECT))/releasekey
    endif
  else
#   Not specify PRODUCT_DEFAULT_DEV_CERTIFICATE and the default testkey will be used.
  endif
endif
endif

# Bluetooth Low Energy Capability
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

## Bluetooth DUN profile
#ifeq ($(MTK_BT_BLUEDROID_DUN_GW_12),yes)
#PRODUCT_PROPERTY_OVERRIDES += bt.profiles.dun.enabled=1
#PRODUCT_PACKAGES += pppd_btdun libpppbtdun.so
#endif

## Bluetooth BIP profile cover art feature
#ifeq ($(MTK_BT_BLUEDROID_AVRCP_TG_16),yes)
#  PRODUCT_PROPERTY_OVERRIDES += bt.profiles.bip.coverart.enable=1
#endif

## Bluetooth AVRCP Support Multi Player feature
#ifeq ($(MTK_BT_AVRCP_TG_MULTI_PLAYER_SUPPORT), yes)
#  PRODUCT_PROPERTY_OVERRIDES += bt.profiles.avrcp.multiPlayer.enable=1
#else
#  PRODUCT_PROPERTY_OVERRIDES += bt.profiles.avrcp.multiPlayer.enable=0
#endif

# Bluetooth FW log switch
ifneq ($(MTK_PRODUCT_LINE), smart_phone)
  ifneq ($(filter MTK_MT7%, $(MTK_BT_CHIP)), )
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.bluetooth.fw_log_switch=true
  endif
endif

## Customer configurations
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,$(MTK_TARGET_PROJECT_FOLDER)/custom.conf:system/etc/custom.conf)
#PRODUCT_COPY_FILES += $(LOCAL_PATH)/custom.conf:system/etc/custom.conf

# prebuilt interface
$(call inherit-product-if-exists, vendor/mediatek/common/device-vendor.mk)

# ECC List Customization
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/EccList/EccList.mk)

## fonts
#$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
#$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
#$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
#$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
#$(call inherit-product-if-exists, frameworks/base/data/fonts/openfont/fonts.mk)
#
## 3Dwidget
#$(call inherit-product-if-exists, vendor/mediatek/proprietary/frameworks/base/3dwidget/appwidget.mk)
#
## AAPT Config
#$(call inherit-product-if-exists, $(LOCAL_PATH)/aapt/aapt_config.mk)

#
# MediaTek Operator features configuration
#
ifdef OPTR_SPEC_SEG_DEF
  ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    include device/mediatek/vendor/common/OpBase.mk

    # To compatible with RSC deactivated project
    ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),KIT)
      OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
      SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
      SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))

      #$(call inherit-product-if-exists, vendor/mediatek/proprietary/operator/SPEC/$(OPTR)/$(SPEC)/$(SEG)/optr_package_config.mk)

      PRODUCT_PROPERTY_OVERRIDES += ro.vendor.operator.optr=$(OPTR)
      PRODUCT_PROPERTY_OVERRIDES += ro.vendor.operator.spec=$(SPEC)
      PRODUCT_PROPERTY_OVERRIDES += ro.vendor.operator.seg=$(SEG)
      PRODUCT_PROPERTY_OVERRIDES += persist.vendor.operator.optr=$(OPTR)
      PRODUCT_PROPERTY_OVERRIDES += persist.vendor.operator.spec=$(SPEC)
      PRODUCT_PROPERTY_OVERRIDES += persist.vendor.operator.seg=$(SEG)
    endif
  endif
endif

# Here we initializes variable MTK_REGIONAL_OP_PACK based on Carrier express pack
ifdef MTK_CARRIEREXPRESS_PACK
  ifneq ($(strip $(MTK_CARRIEREXPRESS_PACK)),no)
  ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    include device/mediatek/vendor/common/OpBase.mk
  endif
  endif #ifneq ($(strip $(MTK_CARRIEREXPRESS_PACK)),no)
endif #ifdef MTK_CARRIEREXPRESS_PACK

#PRODUCT_PACKAGES += DataTransfer

## MediatekDM package & lib
#ifeq ($(strip $(MTK_MDM_APP)),yes)
#    PRODUCT_PACKAGES += MediatekDM
#endif

## CTM
#ifeq ($(strip $(MTK_CTM_SUPPORT)),yes)
#PRODUCT_PACKAGES += ctm
#endif

## SmsReg package
#ifeq ($(strip $(MTK_SMSREG_APP)),yes)
#    PRODUCT_PACKAGES += SmsReg
#endif

# VoW
ifneq ($(wildcard vendor/mediatek/proprietary/external/voiceunlock2),)
  ifeq ($(strip $(MTK_VOW_SUPPORT)),yes)
    PRODUCT_PACKAGES += libvow_ap_test_hh
    PRODUCT_PACKAGES += libvow_ap_test_ha
    PRODUCT_PACKAGES += libvow_ap_test_aa
    PRODUCT_PACKAGES += libvow_ap_test_dd
    PRODUCT_PACKAGES += libvow_ap_test_nn
  endif
endif

#ifeq ($(strip $(RAT_CONFIG_CDMA_SUPPORT)),yes)
#    PRODUCT_PACKAGES += via-plugin
#endif

ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), ss)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=ss
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.msimmode=ss
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.radio.max.multisim=ss
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.sim.count=1
  PRODUCT_PROPERTY_OVERRIDES += telephony.active_modems.max_count=1
endif
ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsds)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=dsds
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.msimmode=dsds
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.radio.max.multisim=dsds
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.sim.count=2
  PRODUCT_PROPERTY_OVERRIDES += telephony.active_modems.max_count=2
endif
ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsda)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=dsda
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.msimmode=dsda
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.radio.max.multisim=dsda
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.sim.count=2
  PRODUCT_PROPERTY_OVERRIDES += telephony.active_modems.max_count=2
endif
ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), tsts)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=tsts
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.msimmode=tsts
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.radio.max.multisim=tsts
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.sim.count=3
  PRODUCT_PROPERTY_OVERRIDES += telephony.active_modems.max_count=3
endif
ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), qsqs)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=qsqs
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.msimmode=qsqs
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.radio.max.multisim=qsqs
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.sim.count=4
  PRODUCT_PROPERTY_OVERRIDES += telephony.active_modems.max_count=4
endif

ifeq ($(strip $(MTK_AUDIO_PROFILES)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_profiles=1
endif

ifeq ($(strip $(MTK_AUDENH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audenh_support=1
endif

# MTK_LOSSLESS_BT
ifeq ($(strip $(MTK_LOSSLESS_BT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_lossless_bt_audio=1
endif

# MTK_LOUNDNESS
ifeq ($(strip $(MTK_BESLOUDNESS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_besloudness_support=1
endif

# MTK_HIFIAUDIO_SUPPORT
ifeq ($(strip $(MTK_HIFIAUDIO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_hifiaudio_support=1
endif

# MTK_BESSURROUND
ifeq ($(strip $(MTK_BESSURROUND_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bessurround_support=1
endif

# MTK_ANC
ifeq ($(strip $(MTK_HEADSET_ACTIVE_NOISE_CANCELLATION)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_active_noise_cancel=1
endif

# SCLTM Library
ifeq ($(strip $(MTK_SCLTM_SUPPORT)), yes)
    PRODUCT_PACKAGES += libscltm
endif

#ifeq ($(strip $(MTK_MEMORY_COMPRESSION_SUPPORT)), yes)
#  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mem_comp_support=1
#endif

#WAPI
PRODUCT_PACKAGES += libwapi

ifeq ($(strip $(MTK_WAPPUSH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_wappush_support=1
endif

ifeq ($(strip $(MTK_AGPS_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_agps_app=1
endif

ifeq ($(strip $(MTK_FM_TX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fm_tx_support=1
endif

ifeq ($(strip $(MTK_VOICE_UI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_voice_ui_support=1
endif

ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_audio_tuning_tool_ver=$(strip $(MTK_AUDIO_TUNING_TOOL_VERSION))
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_audio_tuning_tool_ver=V1
endif

#ifeq ($(strip $(MTK_DM_APP)), yes)
#  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dm_app=1
#endif

ifeq ($(strip $(MTK_MATV_ANALOG_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_matv_analog_support=1
endif

ifeq ($(strip $(MTK_WLAN_SUPPORT)), yes)
  #PRODUCT_PACKAGES += halutil
  #PRODUCT_PACKAGES += wificond
  PRODUCT_PACKAGES += libwpa_client

  PRODUCT_PACKAGES += android.hardware.wifi@1.0-service-lazy
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wifi.sap.interface=ap0
else
  PRODUCT_PACKAGES += android.hardware.wifi@1.0-service
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gps_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gps_support=0
endif

ifeq ($(strip $(HAVE_MATV_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.have_matv_feature=1
endif

ifeq ($(strip $(MTK_BT_FM_OVER_BT_VIA_CONTROLLER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bt_fm_over_bt=1
endif

#ifeq ($(strip $(MTK_DHCPV6C_WIFI)), yes)
#  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dhcpv6c_wifi=1
#endif

ifeq ($(strip $(MTK_FM_SHORT_ANTENNA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fm_short_antenna_support=1
endif

ifeq ($(strip $(HAVE_AACENCODE_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.have_aacencode_feature=1
endif

#ifeq ($(strip $(MTK_CLEARMOTION_SUPPORT)),yes)
#  PRODUCT_PACKAGES += libMJCjni
#  PRODUCT_PROPERTY_OVERRIDES += \
#    persist.sys.display.clearMotion=0
#  PRODUCT_PROPERTY_OVERRIDES += \
#    persist.clearMotion.fblevel.nrm=255
#  PRODUCT_PROPERTY_OVERRIDES += \
#    persist.clearMotion.fblevel.bdr=255
#endif

ifeq ($(strip $(MTK_PHONE_VT_VOICE_ANSWER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_vt_voice_answer=1
endif

ifeq ($(strip $(MTK_PHONE_VOICE_RECORDING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_voice_recording=1
endif

ifeq ($(strip $(MTK_POWER_SAVING_SWITCH_UI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_pwr_save_switch=1
endif

#DRM part
#OMA DRM
#ifeq ($(strip $(MTK_OMADRM_SUPPORT)), yes)
#    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_oma_drm_support=1
#endif

#AOSP OMA DRM implementation
#PRODUCT_PACKAGES += libfwdlockengine
PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true
#PRODUCT_PACKAGES += libdcfdecoderjni
#PRODUCT_PACKAGES += libdrmmtkutil

#Playready DRM
ifeq ($(strip $(MTK_PLAYREADY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_playready_drm_support=1
endif

########
ifeq ($(strip $(MTK_LOG2SERVER_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_log2server_app=1
endif

ifeq ($(strip $(MTK_FM_RECORDING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fm_recording_support=1
endif

ifeq ($(strip $(MTK_AUDIO_APE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_audio_ape_support=1
endif
ifneq ($(MTK_BASIC_PACKAGE), yes)
    PRODUCT_PACKAGES += libcodec2_soft_mtk_msadpcmdec
    PRODUCT_PACKAGES += libcodec2_soft_mtk_imaadpcmdec
    PRODUCT_PACKAGES += libcodec2_soft_mtk_apedec
    PRODUCT_PACKAGES += libcodec2_soft_mtk_alacdec
    PRODUCT_PACKAGES += libcodec2_soft_mtk_wmadec
    PRODUCT_PACKAGES += libcodec2_soft_mtk_mp3dec
endif

ifeq ($(strip $(MTK_FD_FORCE_REL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fd_force_rel_support=1
endif

ifeq ($(strip $(MTK_BRAZIL_CUSTOMIZATION_CLARO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.brazil_cust_claro=1
endif

ifeq ($(strip $(MTK_BRAZIL_CUSTOMIZATION_VIVO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.brazil_cust_vivo=1
endif

ifeq ($(strip $(MTK_MTKPS_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mtkps_playback_support=1
endif

ifeq ($(strip $(MTK_RAT_WCDMA_PREFERRED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_rat_wcdma_preferred=1
endif

ifeq ($(strip $(MTK_SMSREG_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_smsreg_app=1
endif

ifeq ($(strip $(MTK_TB_APP_CALL_FORCE_SPEAKER_ON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tb_call_speaker_on=1
endif

ifeq ($(strip $(MTK_EMMC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_emmc_support=1
endif

ifeq ($(strip $(MTK_UFS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ufs_support=1
endif

ifeq ($(strip $(MTK_FM_50KHZ_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fm_50khz_support=1
endif

ifeq ($(strip $(MTK_DEFAULT_WRITE_DISK)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_default_write_disk=1
endif

ifeq ($(strip $(MTK_TETHERINGIPV6_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tetheringipv6_support=1
endif

ifeq ($(strip $(MTK_PHONE_NUMBER_GEODESCRIPTION)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_number_geo=1
endif

ifeq ($(strip $(EVDO_DT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.evdo_dt_support=1
endif

ifeq ($(strip $(EVDO_DT_VIA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.evdo_dt_via_support=1
endif

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ril_mode=$(strip $(MTK_RIL_MODE))
ifneq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
    PRODUCT_PACKAGES += rilproxy
    PRODUCT_PACKAGES += mtk-rilproxy
    PRODUCT_PACKAGES += lib-rilproxy
endif

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.md_prop_ver=1

ifeq ($(strip $(MTK_RAT_BALANCING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_rat_balancing=1
endif

ifeq ($(strip $(MTK_ENABLE_MD1)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md1=1
endif

ifeq ($(strip $(MTK_ENABLE_MD2)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md2=1
endif

ifeq ($(strip $(MTK_ENABLE_MD3)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md3=1
endif

#For SOTER
ifeq ($(strip $(MTK_SOTER_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_soter_support=1
endif

ifeq ($(strip $(MTK_BENCHMARK_BOOST_TP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_benchmark_boost_tp=1
endif

ifeq ($(strip $(MTK_DRE30_SUPPORT)), yes)
    PRODUCT_PACKAGES += libdre
endif

#ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), 2)
ifeq ($(MTK_PRODUCT_LINE), smart_phone)
    PRODUCT_PACKAGES += libappgamepq
endif
#endif

ifeq ($(MTK_PRODUCT_LINE), smart_phone)
    PRODUCT_PACKAGES += libgamehdr
endif

#ifeq ($(strip $(MTK_BT_BLE_MANAGER_SUPPORT)), yes)
#  PRODUCT_PACKAGES += BluetoothLe \
#                      BLEManager
#endif

#For GattProfile
#PRODUCT_PACKAGES += GattProfile

#For BtAutoTest
#PRODUCT_PACKAGES += BtAutoTest

#ifeq ($(strip $(MTK_AAL_SUPPORT)), yes)
  PRODUCT_PACKAGES += libaal_key
#endif

ifeq ($(strip $(MTK_ULTRA_DIMMING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ultra_dimming_support=1
endif

#ifeq ($(strip $(MTK_DRE30_SUPPORT)), yes)
  PRODUCT_PACKAGES += libdre
#endif

ifneq ($(strip $(MTK_PQ_SUPPORT)), no)
    ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_OFF)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=0
    else
        ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_2)
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=2
        else
            ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_3)
                PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=3
            else
                PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_pq_support=0
            endif
        endif
    endif
endif

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

ifeq ($(strip $(MTK_MIRAVISION_SETTING_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_miravision_support=1
endif

ifeq ($(strip $(MTK_MIRAVISION_IMAGE_DC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_miravision_image_dc=1
endif

ifeq ($(strip $(MTK_BLULIGHT_DEFENDER_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_blulight_def_support=1
  PRODUCT_PACKAGES += libblulight_defender
endif

ifeq ($(strip $(MTK_CHAMELEON_DISPLAY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_chameleon_support=1
endif

ifeq ($(strip $(MTK_TETHERING_EEM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tethering_eem_support=1
endif

ifeq ($(strip $(MTK_WFD_SINK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_sink_support=1
endif

ifeq ($(strip $(MTK_WFD_SINK_UIBC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_sink_uibc_support=1
endif

ifeq ($(strip $(MTK_CROSSMOUNT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_crossmount_support=1
endif

ifeq ($(strip $(MTK_MULTIPLE_TDLS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multiple_tdls_support=1
endif

ifeq ($(strip $(MTK_IPV6_TETHER_PD_MODE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ipv6_tether_pd_mode=1
endif

ifeq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.gmo.rom_optimize=1
  ifeq ($(TARGET_BUILD_VARIANT), eng)
    PRODUCT_PROPERTY_OVERRIDES += ro.lmk.debug=true
  endif
endif

ifeq ($(strip $(MTK_MDM_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_app=1
endif

ifeq ($(strip $(MTK_MDM_LAWMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_lawmo=1
endif

ifeq ($(strip $(MTK_MDM_FUMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mdm_fumo=1
endif

ifeq ($(strip $(MTK_MDM_SCOMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mdm_scomo=1
endif

ifeq ($(strip $(MTK_MULTISIM_RINGTONE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multisim_ringtone=1
endif

ifeq ($(strip $(MTK_MT8193_HDCP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mt8193_hdcp_support=1
endif

ifeq ($(strip $(PURE_AP_USE_EXTERNAL_MODEM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.pure_ap_use_external_modem=1
endif

ifeq ($(strip $(MTK_WFD_HDCP_TX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_hdcp_tx_support=1
endif

ifeq ($(strip $(MTK_WFD_HDCP_RX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_hdcp_rx_support=1
endif

ifeq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_md_world_mode_support=1
endif

ifeq ($(strip $(MTK_AUDIO_CHANGE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_change_support=1
endif

ifeq ($(strip $(MTK_MULTI_PARTITION_MOUNT_ONLY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multi_patition=1
endif

ifeq ($(strip $(MTK_WIFI_CALLING_RIL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wifi_calling_ril_support=1
endif

ifeq ($(strip $(MTK_DRM_KEY_MNG_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_key_manager_support=1
endif

ifeq ($(strip $(MTK_RUNTIME_PERMISSION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_runtime_permission=1
endif

# enable zsd+hdr
ifeq ($(strip $(MTK_CAM_ZSDHDR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_zsdhdr_support=1
endif

ifeq ($(strip $(MTK_CAM_DUAL_ZOOM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_dualzoom_support=1
endif

ifeq ($(strip $(MTK_CAM_STEREO_DENOISE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_dualdenoise_support=1
endif

ifeq ($(strip $(MTK_CLEARMOTION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_clearmotion_support=1
endif

ifeq ($(strip $(MTK_DISPLAY_120HZ_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_display_120hz_support=1
endif

# default setting for display all project
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.mtk_ovl_bringup?=0

ifeq ($(strip $(MTK_SLOW_MOTION_VIDEO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_slow_motion_support=1
endif

ifeq ($(strip $(MTK_CAM_STEREO_CAMERA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_stereo_camera_support=1
endif

ifeq ($(strip $(MTK_LTE_DC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_lte_dc_support=1
endif

ifeq ($(strip $(MTK_ENABLE_MD5)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md5=1
endif

ifeq ($(strip $(MTK_SAFEMEDIA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_safemedia_support=1
endif

ifeq ($(strip $(MTK_UMTS_TDD128_MODE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_umts_tdd128_mode=1
endif

ifeq ($(strip $(MTK_SINGLE_IMEI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_single_imei=1
endif

ifeq ($(strip $(MTK_SINGLE_3DSHOT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_single_3Dshot_support=1
endif

ifeq ($(strip $(MTK_CAM_MAV_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mav_support=1
endif

ifeq ($(strip $(MTK_CAM_FACEBEAUTY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_cfb=1
endif

ifeq ($(strip $(MTK_CAM_VIDEO_FACEBEAUTY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_vfb=1
endif

ifeq ($(strip $(SIM_REFRESH_RESET_BY_MODEM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.sim_refresh_reset_by_modem=1
endif

#ifeq ($(strip $(MTK_SUBTITLE_SUPPORT)), yes)
#  PRODUCT_PACKAGES += libvobsub_jni
#  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_subtitle_support=1
#endif

ifeq ($(strip $(MTK_DFO_RESOLUTION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dfo_resolution_support=1
endif

ifeq ($(strip $(MTK_SMARTBOOK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_smartbook_support=1
endif

ifeq ($(strip $(MTK_DX_HDCP_SUPPORT)), yes)
  PRODUCT_PACKAGES += \
    ffffffff000000000000000000000003.tabin \
    6b3f5fa0f8cf55a7be2582587d62d63a.drbin \
    libDxHdcp \
    ArmHDCP_MediatekGP.cfg

  PRODUCT_PACKAGES += \
    vendor.tesiai.hardware.hdcpconnection@1.0-impl \
    vendor.tesiai.hardware.hdcpconnection@1.0-service

  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_hdcpconnection.xml
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_dx_hdcp_support=1
endif

ifeq ($(strip $(MTK_LIVE_PHOTO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_live_photo_support=1
endif

ifeq ($(strip $(MTK_MOTION_TRACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_motion_track_support=1
endif

ifeq ($(strip $(MTK_PASSPOINT_R2_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_passpoint_r2_support=1
endif

ifeq ($(strip $(MTK_WIFIWPSP2P_NFC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wifiwpsp2p_nfc_support=1
endif

ifeq ($(strip $(MTK_TC1_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tc1_feature=1
endif

ifneq ($(strip $(MTK_AP_INFO_COLLECT)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.ap_info_monitor=$(strip $(MTK_AP_INFO_COLLECT))
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.ap_info_monitor=0
endif

ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)), 1)
endif
ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)), 2)
endif

# Data usage overview
ifeq ($(strip $(MTK_DATAUSAGE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_datausage_support=1
endif

## VzW Device Type
#ifeq ($(strip $(MTK_VZW_DEVICE_TYPE)), 0)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.vzw_device_type=0
#endif
#ifeq ($(strip $(MTK_VZW_DEVICE_TYPE)), 1)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.vzw_device_type=1
#endif
#ifeq ($(strip $(MTK_VZW_DEVICE_TYPE)), 2)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.vzw_device_type=2
#endif
#ifeq ($(strip $(MTK_VZW_DEVICE_TYPE)), 3)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.vzw_device_type=3
#endif
#ifeq ($(strip $(MTK_VZW_DEVICE_TYPE)), 4)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.vzw_device_type=4
#endif

# wifi offload service common library
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    #PRODUCT_PACKAGES += wfo-common
    ifeq ($(strip $(MTK_WFC_SUPPORT)), yes)
        # PRODUCT_PACKAGES += WfoService
        #Define 93 MD and fusion ril
        ifneq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
            PRODUCT_PACKAGES += vendor.mediatek.hardware.wfo@1.0-service
            #PRODUCT_PACKAGES += mediatek-wfo-legacy
            #PRODUCT_PACKAGES += com.mediatek.wfo.legacy.xml
        endif
    endif
endif

ifeq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
  #Define MD has the capability to setup IMS PDN
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.md_auto_setup_ims=1
  #For Smart Data Switch Support
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.smart.data.switch=1
  #Add for Multi Ps Attach
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_data_config=1
endif

# IMS and VoLTE feature
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    ifneq ($(wildcard vendor/mediatek/proprietary/frameworks/opt/net/ims/Android.bp),)
        #PRODUCT_PACKAGES += mediatek-ims-common
        #PRODUCT_BOOT_JARS += mediatek-ims-common
    endif
endif
ifeq ($(strip $(MTK_IMS_SUPPORT)), yes)
    ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
        #PRODUCT_PACKAGES += ImsService
        #PRODUCT_PACKAGES += mediatek-ims-oem-plugin
        #ifeq ($(strip $(MTK_TELEPHONY_ADD_ON_POLICY)), 0)
            #PRODUCT_PACKAGES += mediatek-ims-extension-plugin
            #PRODUCT_PACKAGES += mediatek-ims-legacy
        #endif
        ifneq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
            PRODUCT_PACKAGES += vendor.mediatek.hardware.imsa@1.0-service
        endif
    endif
  # Put IMS permission for the device
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.ims_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_dynamic_ims_switch=1
endif

#WFC feature
ifeq ($(strip $(MTK_WFC_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_wfc_support=1
  PRODUCT_PACKAGES += ipsec_mon
endif

ifeq ($(strip $(MTK_VOLTE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.volte_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk.volte.enable=1
endif

build_vilte_package :=
ifeq ($(strip $(MTK_VILTE_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.vilte_support=1
  build_vilte_package := yes
else
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.vilte_support=0
endif

ifeq ($(strip $(MTK_VIWIFI_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.viwifi_support=1
  build_vilte_package := yes
else
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.viwifi_support=0
endif

ifdef build_vilte_package
  #PRODUCT_PACKAGES += libmtk_vt_wrapper
  #PRODUCT_PACKAGES += libmtk_vt_service
  PRODUCT_PACKAGES += vendor.mediatek.hardware.videotelephony@1.0-impl
  #PRODUCT_PACKAGES += vtservice
  PRODUCT_PACKAGES += vtservice_hidl
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_videotelephony.xml
endif

ifeq ($(strip $(MTK_DIGITS_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_digits_support=1
endif

# DTAG DUAL APN
ifeq ($(strip $(MTK_DTAG_DUAL_APN_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dtag_dual_apn_support=1
endif

# Telstra PDP retry
ifeq ($(strip $(MTK_TELSTRA_PDP_RETRY_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_fallback_retry_support=1
endif

## RTT support
#ifeq ($(strip $(MTK_RTT_SUPPORT)),yes)
#  PRODUCT_SYSTEM_DEFAULT_PROPERTIES +=  persist.vendor.mtk_rtt_support=1
#endif

## sbc security
#ifeq ($(strip $(MTK_SECURITY_SW_SUPPORT)), yes)
#  PRODUCT_PACKAGES += libsec
#  PRODUCT_PACKAGES += sbchk
#  PRODUCT_PACKAGES += S_ANDRO_SFL.ini
#  PRODUCT_PACKAGES += S_SECRO_SFL.ini
#  PRODUCT_PACKAGES += sec_chk.sh
#  PRODUCT_PACKAGES += AC_REGION
#endif

ifneq ($(wildcard $(LOCAL_PATH)/audio_effects_config/audio_effects.xml),)
  PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio_effects_config/audio_effects.xml:vendor/etc/audio_effects.xml
else
  PRODUCT_COPY_FILES += frameworks/av/media/libeffects/data/audio_effects.xml:vendor/etc/audio_effects.xml
endif

#PRODUCT_PACKAGES += NwMonitor

ifeq ($(strip $(MTK_NFC_ADDON_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nfc_addon_support=1
endif

## ST NFC
ifeq ($(strip $(NFC_CHIP_SUPPORT)), yes)
  # Set SIM terminal capability TAG 82 to UICC-CLF
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_uicc_clf=1

  ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/script_DB10mtk*),)
    NFC_RF_CONFIG_PATH := $(MTK_TARGET_PROJECT_FOLDER)
  else
    NFC_RF_CONFIG_PATH := device/mediatek/vendor/common
  endif
  include vendor/mediatek/proprietary/external/stnfctools-vendor/NfcDeviceConfigVendor.mk
  ifneq ($(strip $(ST_NFC_CHIP_VERSION)), ST21NFCD)
    ESE_MANIFEST:=_ese
  else
    ESE_MANIFEST:=
  endif
else
  ifeq ($(strip $(MTK_NFC_GSMA_SUPPORT)), yes)
     # Set SIM terminal capability TAG 82 to UICC-CLF
     PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_uicc_clf=1
  endif
endif

ifeq ($(strip $(MTK_OMAPI_SUPPORT)), yes)
  ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), ss)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_ss$(ESE_MANIFEST).xml
  endif
  ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsds)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_dsds$(ESE_MANIFEST).xml
  endif
  ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsda)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_dsds$(ESE_MANIFEST).xml
  endif
  ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), tsts)
    ifeq ($(strip $(MTK_EXTERNAL_SIM_RSIM_ENHANCEMENT)), yes)
      DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_dsds$(ESE_MANIFEST).xml
    else
      DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_tsts$(ESE_MANIFEST).xml
    endif
  endif
  ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), qsqs)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_secure_element_qsqs$(ESE_MANIFEST).xml
  endif

  # for dynamic MSIM Switch
  ODM_MANIFEST_SS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_secure_element_ss$(ESE_MANIFEST).xml
  ODM_MANIFEST_DSDS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_secure_element_dsds$(ESE_MANIFEST).xml
  ODM_MANIFEST_TSTS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_secure_element_tsts$(ESE_MANIFEST).xml
  ODM_MANIFEST_QSQS_FILES += $(LOCAL_PATH)/project_manifest/odm_manifest_secure_element_qsqs$(ESE_MANIFEST).xml

  # for MTK UICC
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml
  PRODUCT_PACKAGES += android.hardware.secure_element@1.2-service-mediatek

  # for ST eSE
  ifeq ($(strip $(ESE_MANIFEST)), _ese)
      PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml
  endif
endif

# IRTX HAL CORE
ifeq (yes,$(strip $(MTK_IRTX_PWM_SUPPORT)))
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_ir.xml
    PRODUCT_PACKAGES += android.hardware.ir@1.0-service
    PRODUCT_PACKAGES += android.hardware.ir@1.0-impl
endif

#ifeq ($(strip $(MTK_CROSSMOUNT_SUPPORT)),yes)
#  PRODUCT_PACKAGES += com.mediatek.crossmount.discovery
#  PRODUCT_PACKAGES += com.mediatek.crossmount.discovery.xml
#  PRODUCT_PACKAGES += CrossMount
#  PRODUCT_PACKAGES += com.mediatek.crossmount.adapter
#  PRODUCT_PACKAGES += com.mediatek.crossmount.adapter.xml
#  PRODUCT_PACKAGES += CrossMountSettings
#  PRODUCT_PACKAGES += CrossMountSourceCamera
#  PRODUCT_PACKAGES += CrossMountStereoSound
#  PRODUCT_PACKAGES += libcrossmount
#  PRODUCT_PACKAGES += libcrossmount_jni
#  PRODUCT_PACKAGES += sensors.virtual
#  PRODUCT_PACKAGES += SWMountViewer
#endif

#$(call inherit-product-if-exists, frameworks/base/data/videos/FrameworkResource.mk)
#ifeq ($(strip $(MTK_LIVE_PHOTO_SUPPORT)), yes)
#  PRODUCT_PACKAGES += com.mediatek.effect
#  PRODUCT_PACKAGES += com.mediatek.effect.xml
#endif

#ifeq ($(strip $(MTK_MULTICORE_OBSERVER_APP)), yes)
#  PRODUCT_PACKAGES += MultiCoreObserver
#endif

## for Search, ApplicationsProvider provides apps search
#PRODUCT_PACKAGES += ApplicationsProvider

#ifneq ($(strip $(MTK_REL_PLATFORM)),)
#  PRODUCT_PACKAGES += libnativecheck-jni
#endif


# for mediatek-res
#PRODUCT_PACKAGES += mediatek-res

# for TER service
#PRODUCT_PACKAGES += terservice
#PRODUCT_PACKAGES_ENG += tertestclient
ifeq ($(strip $(MTK_TER_SERVICE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += vendor.ter.service.enable=1
endif

## for IoctlFuzzer (MediaTek internal-use)
PRODUCT_PACKAGES_ENG += ioctl_fuzzer
PRODUCT_PACKAGES += ioctl_camera_isp

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wfd.dummy.enable=0
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wfd.iframesize.level=0

ifeq ($(strip $(EVDO_DT_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += \
    ril.evdo.dtsupport=1
endif

# for libudf
ifeq ($(strip $(MTK_USER_SPACE_DEBUG_FW)),yes)
#PRODUCT_PACKAGES += libudf
PRODUCT_PACKAGES += libudf.vendor
endif

#PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk:$(TARGET_COPY_OUT_VENDOR)/data/misc/ProjectConfig.mk:mtk

ifeq ($(strip $(MTK_BICR_SUPPORT)), yes)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/iAmCdRom.iso:$(TARGET_COPY_OUT_VENDOR)/etc/iAmCdRom.iso:mtk
endif

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/smsdbvisitor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smsdbvisitor.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/special_pws_channel.xml:$(TARGET_COPY_OUT_VENDOR)/etc/special_pws_channel.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/virtual-spn-conf-by-efgid1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/virtual-spn-conf-by-efgid1.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/virtual-spn-conf-by-efpnn.xml:$(TARGET_COPY_OUT_VENDOR)/etc/virtual-spn-conf-by-efpnn.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/virtual-spn-conf-by-efspn.xml:$(TARGET_COPY_OUT_VENDOR)/etc/virtual-spn-conf-by-efspn.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/virtual-spn-conf-by-imsi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/virtual-spn-conf-by-imsi.xml:mtk)
  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,device/mediatek/vendor/common/telephony/etc/spn-conf-op09.xml:$(TARGET_COPY_OUT_VENDOR)/etc/spn-conf-op09.xml:mtk)
endif

ifeq ($(strip $(MTK_AUDIO_ALAC_SUPPORT)), yes)
  PRODUCT_PACKAGES += libMtkOmxAlacDec
endif

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
PRODUCT_PACKAGES += libMtkOmxMp3Dec
PRODUCT_PACKAGES += libMtkOmxGsmDec
PRODUCT_PACKAGES += libMtkOmxAudioDecBase
endif

ifeq ($(strip $(MTK_AUDIO_ADPCM_SUPPORT)), yes)
    PRODUCT_PACKAGES += libMtkOmxAdpcmDec
endif

ifeq ($(strip $(MTK_AUDIO_APE_SUPPORT)), yes)
    PRODUCT_PACKAGES += libMtkOmxApeDec
endif

# Keymaster HIDL

KEYMASTER_VERSION ?= 4.1

ifeq ($(strip $(KEYMASTER_VERSION)), 5.0) ### Keymint 1.0
ifeq ($(strip $(MTK_TEE_SUPPORT)), yes)
ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes) # list of all TEEs
    PRODUCT_PACKAGES += android.hardware.security.keymint-service.trustonic
else ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.security.keymint@1.0-service.beanpod
else ifeq ($(strip $(TRUSTKERNEL_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.security.keymint-service.trustkernel
endif
else #MTK_TEE_SUPPORT
    PRODUCT_PACKAGES += android.hardware.security.keymint-service
endif #MTK_TEE_SUPPORT
else ifeq ($(strip $(KEYMASTER_VERSION)), 4.1)
ifeq ($(strip $(MTK_TEE_SUPPORT)), yes)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_km41.xml
    PRODUCT_COPY_FILES += hardware/interfaces/keymaster/4.1/default/android.hardware.hardware_keystore.km41.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hardware_keystore.km41.xml
# list of all TEEs
ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.trustonic
else ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.beanpod
else ifeq ($(strip $(MICROTRUST_TEE_LITE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.beanpod.lite
else ifeq ($(strip $(TRUSTKERNEL_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.trustkernel
else ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.mtee
else
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service
endif #end of list of TEEs
else #MTK_TEE_SUPPORT
ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.mtee
else
    #non-tee project
    PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service
endif
endif #MTK_TEE_SUPPORT
else ifeq ($(strip $(KEYMASTER_VERSION)), 4.0)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_km4.xml
ifeq ($(strip $(MTK_TEE_SUPPORT)), yes)
# list of all TEEs
ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.trustonic
else ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.beanpod
else ifeq ($(strip $(MICROTRUST_TEE_LITE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.beanpod.lite
else ifeq ($(strip $(TRUSTKERNEL_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.trustkernel
else ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.mtee
else
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service
endif #end of list of TEEs
else #MTK_TEE_SUPPORT
ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.mtee
else
    #non-tee project
    PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service
endif
endif #MTK_TEE_SUPPORT
else ifeq ($(strip $(KEYMASTER_VERSION)), 3.0)
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_km3.xml
    PRODUCT_PACKAGES += android.hardware.keymaster@3.0-impl
ifeq ($(strip $(MTK_TEE_SUPPORT)), yes)
# list of all TEEs
ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.keymaster@3.0-service.trustonic
else
    PRODUCT_PACKAGES += android.hardware.keymaster@3.0-service
endif #end of list of TEEs
else #MTK_TEE_SUPPORT
    #non-tee project
    PRODUCT_PACKAGES += android.hardware.keymaster@3.0-service
endif #MTK_TEE_SUPPORT
else #KEYMASTER_VERSION
    $(error invalid keymaster version = $(KEYMASTER_VERSION))
endif #KEYMASTER_VERSION

# add app_attest_key
ifeq ($(strip $(KEYMASTER_VERSION)), 4.1)
else ifeq ($(strip $(KEYMASTER_VERSION)), 4.0)
else ifeq ($(strip $(KEYMASTER_VERSION)), 3.0)
else # Indicate that this KeyMint includes support for the ATTEST_KEY key purpose.
    PRODUCT_COPY_FILES += \
 frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml
endif
#app_attest_key end 

# Gatekeeper HIDL
ifeq ($(strip $(MICROTRUST_TEE_LITE_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-service.beanpod.lite
else
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service
endif

# SoftGatekeeper HAL
PRODUCT_PACKAGES += \
    libSoftGatekeeper

ifneq (,$(filter yes,$(strip $(MTK_TEE_SUPPORT)) $(strip $(MTK_IN_HOUSE_TEE_SUPPORT))))
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_tee.xml

  # Keymaster Attestation HIDL
  PRODUCT_PACKAGES += \
      vendor.mediatek.hardware.keymaster_attestation@1.1-impl \
      vendor.mediatek.hardware.keymaster_attestation@1.1-service

  ifeq (yes, $(filter yes, $(strip $(TRUSTONIC_TEE_SUPPORT)) $(strip $(MICROTRUST_TEE_SUPPORT))))
    PRODUCT_PACKAGES_DEBUG += tlcsec
    PRODUCT_PACKAGES_DEBUG += devapc_test
    PRODUCT_PACKAGES_DEBUG += tee_sanity
    PRODUCT_PACKAGES_DEBUG += tee_sanity_smem
  endif

   ifeq ($(strip $(MTK_CAM_SECURITY_SUPPORT)), yes)
       # ISP CA
       PRODUCT_PACKAGES += libispcameraca
       PRODUCT_PACKAGES += libimgsensorca
   endif

endif

ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
  PRODUCT_PACKAGES += libispcameraca
  PRODUCT_PACKAGES += libimgsensorca
endif

ifeq ($(strip $(MTK_TEE_GP_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_tee_gp_support=1
endif

ifneq (,$(filter $(MTK_SVP_ON_MTEE_SUPPORT), yes))
  ifeq ($(filter $(strip $(LINUX_KERNEL_VERSION)),kernel-4.14 kernel-4.19),)
    PRODUCT_PACKAGES += AVCSecureVdecCA_510
    PRODUCT_PACKAGES += HEVCSecureVdecCA_510
    PRODUCT_PACKAGES += VP9SecureVdecCA_510
    PRODUCT_PACKAGES += libAVCSecureVencCA_510
  else
    PRODUCT_PACKAGES += AVCSecureVdecCA
    PRODUCT_PACKAGES += HEVCSecureVdecCA
    PRODUCT_PACKAGES += VP9SecureVdecCA
    PRODUCT_PACKAGES += libAVCSecureVencCA
  endif
endif

ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
ifeq ($(filter mt6580,$(call to-lower,$(MTK_REL_PLATFORM))),)
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_trustonic.xml
endif
  PRODUCT_PACKAGES += libMcClient
  PRODUCT_PACKAGES += libTEECommon
  PRODUCT_PACKAGES += mcDriverDaemon
  PRODUCT_PACKAGES += libMcTeeKeymaster
  PRODUCT_PACKAGES += libMcGatekeeper
  PRODUCT_PACKAGES += kmsetkey.trustonic
ifeq ($(filter mt6580,$(call to-lower,$(MTK_REL_PLATFORM))),)
  PRODUCT_PACKAGES += vendor.trustonic.tee@1.1-service
endif

  PRODUCT_PROPERTY_OVERRIDES += ro.hardware.kmsetkey=trustonic
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_trustonic_tee_support=1
  PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gatekeeper=trustonic

  ifeq ($(strip $(MTK_SEC_VIDEO_PATH_SUPPORT)), yes)
    ifeq ($(strip $(MTK_TEE_GP_SUPPORT)),yes)
      PRODUCT_PACKAGES += AVCSecureVencCA
      PRODUCT_PACKAGES += AVCSecureVdecCA
      PRODUCT_PACKAGES += HEVCSecureVdecCA
    else
      PRODUCT_PACKAGES += libMtkH264SecVdecTLCLib
      PRODUCT_PACKAGES += libMtkH264SecVencTLCLib
      PRODUCT_PACKAGES += libMtkH265SecVdecTLCLib
    endif
    PRODUCT_PACKAGES += libMtkVP9SecVdecTLCLib
    PRODUCT_PACKAGES += libtlcWidevineModularDrm
    PRODUCT_PACKAGES += libtplay
  endif
  ifeq ($(strip $(MTK_TEE_TRUSTED_UI_SUPPORT)), yes)
    PRODUCT_PACKAGES += libTui
    PRODUCT_PACKAGES += TuiService
    PRODUCT_PACKAGES += libTlcPinpad
  endif
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/public.libraries.vendor.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt:mtk

ifeq ($(strip $(MICROTRUST_TEE_LITE_SUPPORT)), yes)
  include device/mediatek/vendor/common/microtrust/device.microtrust.lite.mk
endif #MICROTRUST_TEE_LITE_SUPPORT

ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
  include device/mediatek/vendor/common/microtrust/device.microtrust.isee.mk

  ifeq ($(strip $(MTK_SEC_VIDEO_PATH_SUPPORT)), yes)
    ifeq ($(strip $(MTK_TEE_GP_SUPPORT)),yes)
      PRODUCT_PACKAGES += AVCSecureVdecCA
      PRODUCT_PACKAGES += HEVCSecureVdecCA
    endif
  endif

endif #MICROTRUST_TEE_SUPPORT

ifeq ($(strip $(TRUSTKERNEL_TEE_SUPPORT)), yes)
  PRODUCT_PACKAGES += teed
  PRODUCT_PACKAGES += pld
  PRODUCT_PACKAGES += kph
  # install keybox
  PRODUCT_PACKAGES += 6B6579626F785F6372797074
  PRODUCT_PACKAGES += tee_check_keybox
  # PRODUCT_PACKAGES += tlcrpmb_gp

  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_trustkernel_tee_support=1

  PRODUCT_PACKAGES += kmsetkey.trustkernel
  PRODUCT_PROPERTY_OVERRIDES += ro.hardware.kmsetkey=trustkernel

  PRODUCT_PACKAGES += gatekeeper.trustkernel
  PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gatekeeper=trustkernel

  PRODUCT_COPY_FILES += \
      vendor/mediatek/proprietary/trustzone/trustkernel/source/ta/02662e8e-e126-11e5-b86d9a79f06e9478.ta:vendor/app/t6/02662e8e-e126-11e5-b86d9a79f06e9478.ta

  ifneq ($(filter $(strip $(KEYMASTER_VERSION)), 3.0 4.0 4.1),)
    # install keymaster ta for keymaster-3.0/4.0/4.1
    PRODUCT_COPY_FILES += \
        vendor/mediatek/proprietary/trustzone/trustkernel/source/ta/9ef77781-7bd5-4e39-965f20f6f211f46b.ta:vendor/app/t6/9ef77781-7bd5-4e39-965f20f6f211f46b.ta
  else ifeq ($(strip $(KEYMASTER_VERSION)), 5.0)
    # install keymint ta keymint-1.0
    PRODUCT_COPY_FILES += \
        vendor/mediatek/proprietary/trustzone/trustkernel/source/ta/9ef77781-7bd5-4e39-965f20f6f211f400.ta:vendor/app/t6/9ef77781-7bd5-4e39-965f20f6f211f400.ta
  endif

  PRODUCT_COPY_FILES += \
      vendor/mediatek/proprietary/trustzone/trustkernel/source/ta/b46325e6-5c90-8252-2eada8e32e5180d6.ta:vendor/app/t6/b46325e6-5c90-8252-2eada8e32e5180d6.ta

  PRODUCT_COPY_FILES += \
      vendor/mediatek/proprietary/trustzone/trustkernel/source/bsp/platform/common/scripts/kph_cfg/cfg.ini:vendor/app/t6/cfg.ini
endif

ifeq ($(strip $(MTK_SEC_VIDEO_PATH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_sec_video_path_support=1
  ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += lib_uree_mtk_video_secure_al
  endif
endif

# DRM key installation
ifeq ($(strip $(MTK_DRM_KEY_MNG_SUPPORT)), yes)
  # Since HIDL is not necessary for tablet projects and only tablet keyinstall
  # supports MTK in-house tee, use MTK_IN_HOUSE_TEE_SUPPORT to separate tablet
  # and phone projects.
  ifneq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT)), yes)
    PRODUCT_PACKAGES += liburee_meta_drmkeyinstall
    # HIDL
#    PRODUCT_PACKAGES += vendor.mediatek.hardware.keyinstall@1.0-service
#    PRODUCT_PACKAGES += vendor.mediatek.hardware.keyinstall@1.0-impl
#    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_keyinstall.xml
  else
    # Keymanage HIDL for tablet
    PRODUCT_PACKAGES += vendor.mediatek.hardware.keymanage@1.0-impl
    PRODUCT_PACKAGES += vendor.mediatek.hardware.keymanage@1.0-service
  endif
endif

# MTK GENIEZONE SUPPORT
ifeq ($(strip $(MTK_ENABLE_GENIEZONE)), yes)
  PRODUCT_PACKAGES += libgz_uree
#  PRODUCT_PACKAGES += storageproxyd
  PRODUCT_PACKAGES += libgz_gp_client
  PRODUCT_PACKAGES_DEBUG += uree_test
ifneq ($(filter yes,$(TRUSTONIC_TEE_SUPPORT) $(MICROTRUST_TEE_SUPPORT)),)
ifeq ($(strip $(MTK_TEE_GP_SUPPORT)), yes)
ifeq ($(strip $(MTK_GZ_SUPPORT_SDSP)), yes)
  PRODUCT_PACKAGES_DEBUG += fod_ca
endif
  PRODUCT_PACKAGES_DEBUG += pmem_share_ns
  PRODUCT_PACKAGES_DEBUG += pmem_share_s
  PRODUCT_PACKAGES_DEBUG += pmem_ion_fast
  PRODUCT_PACKAGES_DEBUG += pmem_ion
  PRODUCT_PACKAGES_DEBUG += pmem_perf
endif
endif
endif

#################################################
################### Widevine DRM ####################
#Hidl impl and service, enable lazy hal on A-GO project to save memory
ifeq ($(strip $(MTK_GMO_RAM_OPTIMIZE)),yes)
  PRODUCT_PACKAGES += android.hardware.drm@1.4-service-lazy.clearkey
  ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
    PRODUCT_PACKAGES += android.hardware.drm@1.4-service-lazy.widevine
  endif
else
  PRODUCT_PACKAGES += android.hardware.drm@1.4-service.clearkey
  ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
    PRODUCT_PACKAGES += android.hardware.drm@1.4-service.widevine
  endif
endif

# Widevine relate libraries
ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
  #Mock modular drm plugin for cts
  PRODUCT_PACKAGES += libmockdrmcryptoplugin
  #both L1 and L3 library
  PRODUCT_PACKAGES += libwvhidl
  PRODUCT_PACKAGES += libwvdrmengine
  #PRODUCT_PACKAGES += move_widevine_data.sh
  ifeq ($(strip $(MTK_WVDRM_L1_SUPPORT)),yes)
    PRODUCT_PACKAGES += lib_uree_mtk_modular_drm
    PRODUCT_PACKAGES += liboemcrypto
    PRODUCT_PACKAGES += libtlcWidevineModularDrm
  endif
endif
#################################################

ifdef MTK_GENERIC_HAL
ifeq ($(strip $(MTK_COMBO_SUPPORT)), yes)
  $(call inherit-product-if-exists, $(LOCAL_PATH)/connectivity/product_package/product_package-hal.mk)
endif
else
ifeq ($(strip $(MTK_COMBO_SUPPORT)), yes)
  $(call inherit-product-if-exists, $(LOCAL_PATH)/connectivity/product_package/product_package.mk)
endif
endif

SPMFW_ROOT_DIR := vendor/mediatek/proprietary/hardware/spmfw

ifeq ($(strip $(MTK_TC7_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tc7_feature=1
endif

#Add for CCCI Lib
PRODUCT_PACKAGES += libccci_util

#Add for C2Kutils
#PRODUCT_PACKAGES += libc2kutils_sys

ifeq ($(strip $(MTK_WMA_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PACKAGES += libMtkOmxWmaDec
endif

ifeq ($(strip $(MTK_WMA_PLAYBACK_SUPPORT))_$(strip $(MTK_SWIP_WMAPRO)), yes_yes)
  PRODUCT_PACKAGES += libMtkOmxWmaProDec
endif

#$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/strongswan/copy_files.mk)

# Speaker lib
PRODUCT_PACKAGES += libnxp_extamp_intf libnxpsmartpaparser \
                    librt_extamp_intf libaudiosmartpamtk smartpa_nvtest \
                    mt6660_calibration libaudiosmartpartk rt5512_calibration \
                    libcs_cs35l45_intf

# AudioParamParser
PRODUCT_PACKAGES += libaudio_param_parser-vnd
PRODUCT_PACKAGES_DEBUG += audio_param_test-vnd

ifdef MTK_GENERIC_HAL
PRODUCT_PACKAGES += AudioParamOptions_mgvi.xml
else
PRODUCT_PACKAGES += AudioParamOptions.xml
endif

#Audio LD2.0
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
  PRODUCT_PACKAGES += audio.primary.default libaudiocustparam libaudiocomponentengine_vendor \
                      audiocmdservice_atci audio.r_submix.default audio.usb.default libaudiodcrflt \
                      audio.primary.mediatek
  PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
  PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml
  PRODUCT_PACKAGES += audio.r_submix.mediatek
endif

XML_CUS_FOLDER_ON_DEVICE := /data/vendor/audiohal/audio_param/
AUDIO_PARAM_OPTIONS_LIST += CUST_XML_DIR=$(XML_CUS_FOLDER_ON_DEVICE)
MTK_AUDIO_PARAM_DIR_LIST := $(strip $(MTK_AUDIO_PARAM_DIR_LIST))
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
    PRODUCT_PACKAGES += libspeechparser_vendor
else
    ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
      ifneq ($(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)),V1)
        PRODUCT_PACKAGES += libspeechparser_vendor
        AUDIO_PARAM_OPTIONS_LIST += 5_POLE_HS_SUPPORT=$(MTK_HEADSET_ACTIVE_NOISE_CANCELLATION)
        MTK_AUDIO_PARAM_DIR_LIST += $(LOCAL_PATH)/audio_param
        MTK_AUDIO_PARAM_DIR_LIST += $(LOCAL_PATH)/audio_param_smartpa
        #MTK_AUDIO_PARAM_FILE_LIST += SOME_ZIP_FILE
        ifeq ($(strip $(MTK_USB_PHONECALL)),AP)
          AUDIO_PARAM_OPTIONS_LIST += VIR_MTK_USB_PHONECALL=yes
        endif

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
        # ASHA Tuning
        ifeq ($(strip $(MTK_BT_HEARING_AID_SUPPORT)), yes)
          AUDIO_PARAM_OPTIONS_LIST += MTK_BT_HEARING_AID_SUPPORT=yes
        endif
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
endif
ifeq ($(strip $(MTK_SPEECH_ENCRYPTION_SUPPORT)), yes)
  PRODUCT_PACKAGES += libaudiocustencrypt
endif


# aurisys framework
ifeq ($(MTK_AURISYS_FRAMEWORK_SUPPORT),yes)
  # configurations
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aurisys/aurisys_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config.xml:mtk
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aurisys/aurisys_config_rv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/aurisys_config_rv.xml:mtk

  # aurisys demo library
  PRODUCT_PACKAGES   += libaurisysdemo

  # HiFi3 phone call + VoIP + Record
  PRODUCT_PACKAGES   += libgoodixspeech
  PRODUCT_PACKAGES   += libnxpspeech
  PRODUCT_PACKAGES   += libnxprecord
  PRODUCT_PACKAGES   += libfvaudio
  PRODUCT_PACKAGES   += libmtkspparser
  PRODUCT_PACKAGES   += libmtkspparser_swb

  # HiFi3 Game Voice
  PRODUCT_PACKAGES   += lib_aurisys_gv_enh

  # mediatek IIR
  PRODUCT_PACKAGES   += lib_iir
  PRODUCT_PACKAGES   += lib_tmd_cnm
  # mediatek BESSOUND
  PRODUCT_PACKAGES   += libaudioloudc

  # mediatek record/VoIP
  PRODUCT_PACKAGES   += lib_speech_enh

  # BliSRC & Bit Converter
  PRODUCT_PACKAGES += libaudiocomponentenginec
endif

# sample rate converter and bit converter
PRODUCT_PACKAGES += libaudiofmtconv

# Audio speech enhancement library
PRODUCT_PACKAGES += libspeech_enh_lib

# Audio speech custom parameter
PRODUCT_PACKAGES += libaudiocustparam_vendor

# Audio BTCVSD Lib
PRODUCT_PACKAGES += libcvsd_mtk
PRODUCT_PACKAGES += libmsbc_mtk


#ifeq ($(strip $(MTK_NTFS_OPENSOURCE_SUPPORT)), yes)
#  PRODUCT_PACKAGES += ntfs-3g
#  PRODUCT_PACKAGES += ntfsfix
#endif

## Add for HetComm feature
#ifeq ($(strip $(MTK_HETCOMM_SUPPORT)), yes)
#  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hetcomm_support=1
#  PRODUCT_PACKAGES += HetComm
#endif

#ifeq ($(strip $(MTK_DEINTERLACE_SUPPORT)), yes)
#  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_deinterlace_support=1
#endif

ifeq ($(strip $(MTK_MD_DIRECT_TETHERING_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_md_direct_tethering=1
    PRODUCT_PROPERTY_OVERRIDES += ro.tethering.bridge.interface=mdbr0
    PRODUCT_PROPERTY_OVERRIDES += sys.mtk_md_direct_tether_enable=true
    PRODUCT_PACKAGES += brctl
endif

#PRODUCT_PACKAGES += CarrierConfig

# Add for EngineerMode SensorHub apk
ifeq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
    PRODUCT_PACKAGES += SensorHub
else
    PRODUCT_PACKAGES += SensorHub
endif

# Add for EngineerMode EmCamera apk
ifeq ($(strip $(MTK_EMCAMERA_APP)), yes)
    ifeq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
        PRODUCT_PACKAGES_ENG += EmCamera
    else
        PRODUCT_PACKAGES_DEBUG += EmCamera
    endif
endif


# Add for MTK_CT_VOLTE_SUPPORT
ifeq ($(strip $(MTK_IMS_SUPPORT)), yes)
    ifeq ($(strip $(MTK_RIL_MODE)), c6m_1rild)
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_ct_volte_support=3
    else
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mtk_ct_volte_support=1
    endif
endif

ifeq ($(strip $(MTK_VIBSPK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_vibspk_support=1
endif


#Add for video codec customization
PRODUCT_PROPERTY_OVERRIDES += vendor.mtk.vdec.waitkeyframeforplay=9
PRODUCT_PACKAGES_ENG  += osal_ut
PRODUCT_PACKAGES_ENG  += omx_ut

# Add for USB MIDI
PRODUCT_COPY_FILES += \
frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Add for verified boot
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Add for IpSec tunnel
ifneq (yes,$(strip $(MTK_IPSEC_TUNNELS_NO_SUPPORT)))
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml
endif

ifndef ENABLE_DEX_PREOPT_VERIFIER
PRODUCT_DEX_PREOPT_BOOT_FLAGS += --no-abort-on-soft-verifier-error
endif

# Add for Resolution Switch feature
ifeq ($(strip $(MTK_RESOLUTION_SWITCH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_res_switch=1
endif

## Add for graphics debug
#PRODUCT_PACKAGES += libgui_debug
#
## Add for guiext with BQ monitor
#PRODUCT_PACKAGES += libgui_ext
#
## Add for sf debug
#PRODUCT_PACKAGES += libsf_debug
#
## Add for vsync hint
#PRODUCT_PACKAGES += libvsync_hint
#
## Add for vsync enhance
#PRODUCT_PACKAGES += libvsync_enhance
#
## Add for display dejitter
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#PRODUCT_PACKAGES += libdisp_dejitter
#endif

## Add for Global PQ feature
#ifeq ($(strip $(MTK_GLOBAL_PQ_SUPPORT)), yes)
#  PRODUCT_PACKAGES += libsurfaceflingerpq
#endif

# Add for surfaceflinger default value
PRODUCT_PROPERTY_OVERRIDES += debug.sf.disable_backpressure=1

ifeq ($(strip $(MTK_MLC_NAND_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mlc_nand_support=1
endif
ifeq ($(strip $(MTK_TLC_NAND_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tlc_nand_support=1
endif

# for VR high performane feature
ifeq ($(MTK_VR_HIGH_PERFORMANCE_SUPPORT),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vr.high_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vr.high_performance.xml
  PRODUCT_PACKAGES += vr.$(MTK_PLATFORM_DIR)
endif

# Euicc feature
#  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.euicc.xml

## Add EmergencyInfo apk to TK load
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#  PRODUCT_PACKAGES += EmergencyInfo
#  ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#    PRODUCT_PACKAGES += MtkEmergencyInfo
#  endif
#endif

# Add for SKT customization
ifeq ($(strip $(MTK_KOR_CUSTOMIZATION_SKT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_kor_customization_skt=1
  PRODUCT_PROPERTY_OVERRIDES += persist.ril.sim.regmode=0
endif

# Log control for PowerHal
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.libPowerHal=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.mtkpower@impl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.mtkpower_client=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.UxUtility=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PowerHalAddressUitls=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PowerHalMgrImpl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PowerHalMgrServiceImpl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.PowerHalWifiMonitor=I

# Add for LWA feature support
ifeq ($(strip $(MTK_LWA_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_lwa_support=1
endif

# Add for LWI feature support
ifeq ($(strip $(MTK_LWI_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_lwi_support=1
endif

## Add for LWA/LWI feature support
#ifneq (,$(filter yes,$(strip $(MTK_LWA_SUPPORT)) $(strip $(MTK_LWI_SUPPORT))))
#    PRODUCT_PACKAGES += liblwxnative
#endif

# Add for FTL feature support
ifeq ($(strip $(MTK_NAND_MTK_FTL_SUPPORT)), yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nand_ftl_support=1
endif

# Add for MNTL feature support
ifeq ($(strip $(MNTL_SUPPORT)), yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mntl_support=1
endif

# whether logd reads kmsg
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.logd.kernel=false

# eng/userdebug load config fdsan level = fatal
ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.fdsan=fatal
endif

# mtklog config
PRODUCT_COPY_FILES += $(LOCAL_PATH)/mtklog/mtklog.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/mtklog.rc

# GMS requirement
PRODUCT_COPY_FILES += $(LOCAL_PATH)/chipinfo_init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/chipinfo_init.rc

# MTK internal load or customer eng/userdebug load will buildin log daemon.
# Customer user load default not have MTK log daemon.
# If customer user load want buildin the log daemon, You need set
# MTK_LOG_CUSTOMER_SUPPORT to yes, it will buildin log daemon as internal load.
# Each log daemon is decided by its feature option.
# Case: MTK internal load
ifneq ($(wildcard vendor/mediatek/internal/mtklog_enable),)
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_log.xml
  #PRODUCT_PACKAGES += log-handler
  PRODUCT_PACKAGES += loghidlvendorservice
  HAVE_MTK_DEBUG_SEPOLICY := yes
  ifeq ($(strip $(MTK_LOG_SUPPORT_GPS)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=0
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=1
  endif
# Add for ModemMonitor(MDM) framework
  ifeq ($(strip $(MTK_MODEM_MONITOR_SUPPORT)),yes)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_mdmonitor.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_modem_monitor_support=1
    PRODUCT_PACKAGES += \
      md_monitor \
      md_monitor_ctrl
    #ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
    #    PRODUCT_PACKAGES += MDMLSample \
    #                        MDMConfig \
    #                        com.mediatek.mdml
    #endif
  endif
  ifeq ($(strip $(MTK_AEE_SUPPORT)),yes)
    HAVE_AEE_FEATURE := yes
  else
    HAVE_AEE_FEATURE := no
  endif
# Case: Customer eng/userdebug load
else ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_log.xml
  #PRODUCT_PACKAGES += log-handler
  PRODUCT_PACKAGES += loghidlvendorservice
  HAVE_MTK_DEBUG_SEPOLICY := yes
  ifeq ($(strip $(MTK_LOG_SUPPORT_GPS)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=0
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=1
  endif
# Add for ModemMonitor(MDM) framework
  ifeq ($(strip $(MTK_MODEM_MONITOR_SUPPORT)),yes)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_mdmonitor.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_modem_monitor_support=1
    PRODUCT_PACKAGES += \
      md_monitor \
      md_monitor_ctrl
    #ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
    #    PRODUCT_PACKAGES += MDMLSample \
    #                        MDMConfig \
    #                        com.mediatek.mdml
    #endif
  endif
  ifeq ($(strip $(MTK_AEE_SUPPORT)),yes)
    HAVE_AEE_FEATURE := yes
  else
    HAVE_AEE_FEATURE := no
  endif
# Case: Customer user load and MTK_LOG_CUSTOMER_SUPPORT = yes
else ifeq ($(strip $(MTK_LOG_CUSTOMER_SUPPORT)),yes)
  DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_log.xml
  #PRODUCT_PACKAGES += log-handler
  PRODUCT_PACKAGES += loghidlvendorservice
  HAVE_MTK_DEBUG_SEPOLICY := yes

  ifeq ($(strip $(MTK_LOG_SUPPORT_GPS)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=0
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=1
  endif
# Add for ModemMonitor(MDM) framework
  ifeq ($(strip $(MTK_MODEM_MONITOR_SUPPORT)),yes)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_mdmonitor.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_modem_monitor_support=1
    PRODUCT_PACKAGES += \
      md_monitor \
      md_monitor_ctrl
    #ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
    #    PRODUCT_PACKAGES += MDMLSample \
    #                        MDMConfig \
    #                        com.mediatek.mdml
    #endif
  endif
  ifeq ($(strip $(MTK_AEE_SUPPORT)),yes)
    HAVE_AEE_FEATURE := yes
  else
    HAVE_AEE_FEATURE := no
  endif
# Other Case: Customer user load and MTK_LOG_CUSTOMER_SUPPORT = no
else
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_log_hide_gps=1
  HAVE_AEE_FEATURE := no
  HAVE_MTK_DEBUG_SEPOLICY := no
endif

# AEE Config
ifeq ($(HAVE_AEE_FEATURE),yes)
  ifneq ($(wildcard vendor/mediatek/proprietary/external/aee_config_internal/init.aee.mtk.vendor.rc),)
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/aee_config_internal/aee_vendor.mk)
  else
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/aee/config_external/aee_vendor.mk)
  endif
#PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/binary/aee-config:system/etc/aee-config:mtk
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/binary/aee-config:$(TARGET_COPY_OUT_VENDOR)/etc/aee-config:mtk
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/binary/aee-commit:$(TARGET_COPY_OUT_VENDOR)/etc/aee-commit:mtk

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.have_aeev_feature=1
# MRDUMP
PRODUCT_PACKAGES += \
    mrdump_tool

PRODUCT_PACKAGES += \
    dconfig \
    dtc_vendor
PRODUCT_HOST_PACKAGES += \
    dconfig_host

# DPlanner
ifneq ($(TARGET_BUILD_VARIANT), user)
PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.dplanner@2.0-service
endif

# DExecutor
PRODUCT_PACKAGES += \
    dexecutor \
    doeapp-memtester \
    doeapp-sat

#vendor bins
ifdef MTK_GENERIC_HAL
PRODUCT_PACKAGES += aeev_v2
PRODUCT_PACKAGES += aee_aedv64_v2
PRODUCT_PACKAGES += aee_dumpstatev_v2
PRODUCT_PACKAGES += rttv_v2
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.aee.convert64=1
else
PRODUCT_PACKAGES += aeev
PRODUCT_PACKAGES += aee_aedv
PRODUCT_PACKAGES += aee_aedv64
PRODUCT_PACKAGES += aee_dumpstatev
PRODUCT_PACKAGES += rttv
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.aee.convert64=0
endif
PRODUCT_PACKAGES += libaedv
#PRODUCT_PACKAGES += aee
#PRODUCT_PACKAGES += aee_aed
#PRODUCT_PACKAGES += aee_aed64
#PRODUCT_PACKAGES += aee_core_forwarder
#PRODUCT_PACKAGES += aee_dumpstate
#PRODUCT_PACKAGES += aee_archive
#PRODUCT_PACKAGES += rtt
#PRODUCT_PACKAGES += libaed
PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.aee@1.1-service
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_aee.xml
else # HAVE_AEE_FEATURE=no
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/aee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.aee.rc:mtk
endif # HAVE_AEE_FEATURE
#PRODUCT_PACKAGES += libmediatek_exceptionlog


#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#    PRODUCT_PACKAGES += MtkEmail
#endif

ifeq ($(strip $(MTK_EXCHANGE_SUPPORT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_exchange_support=1
endif

# Modem log daemon built in according to feature option flow.
ifneq ($(wildcard vendor/mediatek/internal/mtklog_enable),)
  HAVE_MTK_DEBUG_SEPOLICY := yes
  ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
    ifneq ($(strip $(MTK_MD1_SUPPORT)),)
      ifneq ($(strip $(MTK_MD1_SUPPORT)),0)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.md_log_memdump_wait=15
      endif
    endif
  endif
else ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
  HAVE_MTK_DEBUG_SEPOLICY := yes
  ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
    ifneq ($(strip $(MTK_MD1_SUPPORT)),)
      ifneq ($(strip $(MTK_MD1_SUPPORT)),0)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.md_log_memdump_wait=15
      endif
    endif
  endif
else ifeq ($(strip $(MTK_LOG_CUSTOMER_SUPPORT)),yes)
  HAVE_MTK_DEBUG_SEPOLICY := yes
  ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
    ifneq ($(strip $(MTK_MD1_SUPPORT)),)
      ifneq ($(strip $(MTK_MD1_SUPPORT)),0)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.md_log_memdump_wait=15
      endif
    endif
  endif
# Other Case: Customer user load and MTK_LOG_CUSTOMER_SUPPORT = no
else
  HAVE_MTK_DEBUG_SEPOLICY := no
endif

## Add for RRO
#DEVICE_PACKAGE_OVERLAYS += \
#                           $(LOCAL_PATH)/overlay/swphone \
#                           $(LOCAL_PATH)/overlay/accdet \
#                           $(LOCAL_PATH)/overlay/tether \
#                           $(LOCAL_PATH)/overlay/multiuser \
#                           $(LOCAL_PATH)/overlay/power \
#                           $(LOCAL_PATH)/overlay/pno \
#                           $(LOCAL_PATH)/overlay/wifitethering \
#                           $(LOCAL_PATH)/overlay/wallpaper \
#                           $(LOCAL_PATH)/overlay/sensor \
#                           $(LOCAL_PATH)/overlay/cta \
#                           $(LOCAL_PATH)/overlay/pq \
#                           $(LOCAL_PATH)/overlay/wifiscan

#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#  DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/wifitethering_channel
#endif

#PRODUCT_ENFORCE_RRO_TARGETS += framework-res

# Add vendor minijail policy for mediacodec service for Android O
PRODUCT_COPY_FILES += $(LOCAL_PATH)/seccomp_policy/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy:mtk

# Add vendor minijail policy for mediaextractor service for Android O
PRODUCT_COPY_FILES += $(LOCAL_PATH)/seccomp_policy/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy:mtk

# Add vendor minijail policy for mediaswcodec service for Android Q
PRODUCT_COPY_FILES += $(LOCAL_PATH)/seccomp_policy/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy:mtk

## Add for mediatek-telecom-common.jar
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#  ifneq ($(wildcard vendor/mediatek/proprietary/frameworks/opt/telecomm/Android.bp),)
#    PRODUCT_PACKAGES += mediatek-telecom-common
#    PRODUCT_BOOT_JARS += mediatek-telecom-common
#  endif
#endif

## Add for MtkCarrierConfig
#ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
#  ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/CarrierConfig/Android.bp),)
#    PRODUCT_PACKAGES += MtkCarrierConfig
#  endif
#endif

## Add WallpaperPicker or MtkWallpaperPicker based on available source code
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/WallpaperPicker/Android.mk),)
#    PRODUCT_PACKAGES += MtkWallpaperPicker
#else
#    PRODUCT_PACKAGES += WallpaperPicker
#endif

#PRODUCT_PACKAGES += libandroid_net

PRODUCT_PACKAGES += make_f2fs.recovery

# for boot.img
PRODUCT_PACKAGES += init.environ.rc
PRODUCT_PACKAGES += selinux_policy_nonsystem

# A/B System updates
ifeq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
PRODUCT_PACKAGES += \
  update_engine_sideload

ifneq ($(strip $(LINUX_KERNEL_VERSION)),kernel-4.14)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
  PRODUCT_PROPERTY_OVERRIDES += ro.virtual_ab.userspace.snapshots.enabled=true
else
  $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
endif

# Dont use Virtual AB Compression OTA for kernel-4.14
ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-4.14)
  BOARD_DONT_USE_VABC_OTA := true
endif

PRODUCT_HOST_PACKAGES += \
delta_generator \
shflags \
brillo_update_payload \
bsdiff \
simg2img

#PRODUCT_PACKAGES += mtk_plpath_utils
PRODUCT_PACKAGES += mtk_plpath_utils_ota
PRODUCT_PACKAGES += mtk_plpath_utils.recovery
PRODUCT_PACKAGES += mtk_plpath_utils_ota.vendor


# UFS BSG library to control UFS HW
PRODUCT_PACKAGES += \
        libmtk_bsg \
        libmtk_bsg.recovery

#PRODUCT_PACKAGES_DEBUG += \
#update_engine_client \
#bootctl

# bootctrl HAL and HIDL
PRODUCT_PACKAGES += \
        android.hardware.boot@1.2-mtkimpl \
        android.hardware.boot@1.2-mtkimpl.recovery \
        android.hardware.boot@1.2-service

## A/B OTA dexopt package
#PRODUCT_PACKAGES += otapreopt_script

## Tell the system to enable copying odexes from other partition.
#PRODUCT_PACKAGES += \
#        cppreopts.sh

PRODUCT_PROPERTY_OVERRIDES += \
    ro.cp_system_other_odex=1

DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_boot.xml
endif

# Enable Scoped Storage for the kernel version without CONFIG_SDCARD_FS
# CONFIG_SDCARD_FS enable only in OTA to S.
ifeq (true,$(call math_gt_or_eq,$(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),31))
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
endif

#ifneq ($(strip $(SYSTEM_AS_ROOT)), no)
#BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
#endif

-include vendor/mediatek/build/core/releaseBRM_vnd.mk

## Add for telephony resource overlay
#DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/telephony
#
#
##Add for OP03 resource overlay
#ifeq (OP03,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/OP03/CMAS/
#endif
#
##Add for OP07 resource overlay
#ifeq (OP07,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/OP07/CMAS/
#endif
#
##Add for OP08 resource overlay
#ifeq (OP08,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/OP08/CMAS/
#endif
#
##Add for OP12 resource overlay
#ifeq (OP12,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/OP12/CMAS/
#endif
#
##Add for OP20 resource overlay
#ifeq (OP20,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
#    DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/operator/OP20/CMAS/
#endif
#
##TelephonyProvider AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/Telephony/TelephonyProvider/Android.bp),)
#  PRODUCT_PACKAGES += MtkTelephonyProvider
#endif
#
## ContactsProvider AOSP code will be replaced by MTK
#ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/ContactsProvider/Android.mk),)
#PRODUCT_PACKAGES += MtkContactsProvider
#endif
#endif

#netdagent
PRODUCT_PACKAGES += netdagent
PRODUCT_PACKAGES += netdc
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_netdagent.xml

#getgameserver
ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
PRODUCT_PACKAGES += getgameserver
PRODUCT_PACKAGES += testgameserver
endif

## Contacts AOSP code will be replaced by MTK
#ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/Contacts/Android.mk),)
#  PRODUCT_PACKAGES += \
#    MtkContacts \
#    MtkSimProcessor
#endif
#endif

##netutils-wrapper
#PRODUCT_PACKAGES += netutils-wrapper-1.0

## Dialer AOSP code will be replaced by MTK
#ifndef MTK_TB_WIFI_3G_MODE
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/Dialer/Android.mk),)
#  PRODUCT_PACKAGES += MtkDialer
#endif
#endif
#
## CalendarProvider AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/CalendarProvider/Android.mk),)
#  PRODUCT_PACKAGES += MtkCalendarProvider
#endif
#
## Calendar AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/Calendar/Android.mk),)
#  PRODUCT_PACKAGES += MtkCalendar
#endif
#
## AOSP DeskClock code will be replaced with MtkDeskClock when vendor code is available
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/DeskClock/Android.mk),)
#  PRODUCT_PACKAGES += MtkDeskClock
#endif
#
## SystemUI AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/SystemUI/Android.bp),)
#  PRODUCT_PACKAGES += MtkSystemUI
#endif

# SettingsProviderResOverlay
PRODUCT_PACKAGES += SettingsProviderResOverlay

# FrameworkResOverlay
PRODUCT_PACKAGES += FrameworkResOverlay

# CellbroadcastUIResOverlay
ifneq ($(strip $(BUILD_GMS)), yes)
    PRODUCT_PACKAGES += CellbroadcastUIResOverlay
else
    PRODUCT_PACKAGES += CellbroadcastGoogleUIResOverlay
endif

# HotwordEnrollmentOKGoogleCOMMONOverlay HotwordEnrollmentOKGoogleCOMMONOverlay
ifeq ($(strip $(MSSI_MTK_VOW_SUPPORT)),yes)
  ifeq ($(strip $(MSSI_MTK_VOW_GVA_SUPPORT)),yes)
    ifeq ($(strip $(BUILD_GMS)), yes)
      PRODUCT_PACKAGES += HotwordEnrollmentOKGoogleCOMMONOverlay
      PRODUCT_PACKAGES += HotwordEnrollmentXGoogleCOMMONOverlay
    endif
  endif
endif

#NetworkStack RRO
PRODUCT_PACKAGES += NetworkStackResOverlay
PRODUCT_PACKAGES += NetworkStackInProcessResOverlay
PRODUCT_PACKAGES += NetworkStackGoogleGoResOverlay
PRODUCT_PACKAGES += NetworkStackGoogleResOverlay

# Tethering RRO
PRODUCT_PACKAGES += TetheringResOverlay
PRODUCT_PACKAGES += InProcessTetheringResOverlay
PRODUCT_PACKAGES += GoogleTetheringResOverlay

# Telephony Service
PRODUCT_PACKAGES += MtkTelephonyServiceResOverlay

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
  # privapp-permissions whitelisting
  PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce
  # Configuration files for mediatek apps
  #PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/data/etc/privapp-permissions-mediatek.xml:system/etc/permissions/privapp-permissions-mediatek.xml)
endif

## MMSService AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/services/Mms/Android.bp),)
#  PRODUCT_PACKAGES += MtkMmsService
#endif
#
## TelephonyProvider AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/TelephonyProvider/Android.bp),)
#  PRODUCT_PACKAGES += MtkTelephonyProvider
#endif

## Use Mtk Gallery to override AOSP Gallery
#    PRODUCT_PACKAGES += Gallery2
#    PRODUCT_PACKAGES += MtkGallery2
#    PRODUCT_PACKAGES += Gallery2Root
#    PRODUCT_PACKAGES += Gallery2Drm
#    PRODUCT_PACKAGES += Gallery2Gif
#    PRODUCT_PACKAGES += Gallery2Pq
#    PRODUCT_PACKAGES += Gallery2PqTool
#    PRODUCT_PACKAGES += Gallery2Raw
#    PRODUCT_PACKAGES += libjni_stereoinfoaccessor
#    PRODUCT_PACKAGES += libstereoinfoaccessor
#
#ifeq ($(strip $(MTK_CAM_IMAGE_REFOCUS_SUPPORT)),yes)
#    PRODUCT_PACKAGES += Gallery2StereoEntry
#    PRODUCT_PACKAGES += Gallery2StereoCopyPaste
#    PRODUCT_PACKAGES += Gallery2StereoBackground
#    PRODUCT_PACKAGES += Gallery2StereoFancyColor
#    PRODUCT_PACKAGES += Gallery2StereoRefocus
#    PRODUCT_PACKAGES += Gallery2PhotoPicker
#    PRODUCT_PACKAGES += Gallery2StereoFreeview3D
#    PRODUCT_PACKAGES += libjni_stereoapplication
#    PRODUCT_PACKAGES += libjni_depthgenerator
#    PRODUCT_PACKAGES += libjni_fancycolor
#    PRODUCT_PACKAGES += libjni_freeview
#    PRODUCT_PACKAGES += libjni_imagerefocus
#    PRODUCT_PACKAGES += libjni_imagesegment
#endif
#
## Support stereo thumbnail feature
#ifeq ($(strip $(MTK_CAM_STEREO_CAMERA_SUPPORT)),yes)
#    PRODUCT_PACKAGES += Gallery2StereoThumbnail
#endif
#
## DownloadProvider AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/DownloadProvider/Android.mk),)
#  PRODUCT_PACKAGES += MtkDownloadProvider
#endif
#
## DownloadProviderUi AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/DownloadProvider/ui/Android.mk),)
#  PRODUCT_PACKAGES += MtkDownloadProviderUi
#endif
#
## DownloadProviderTests AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/providers/DownloadProvider/tests/Android.mk),)
#  PRODUCT_PACKAGES += MtkDownloadProviderTests
#endif
#
## DocumentsUI AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/DocumentsUI/Android.mk),)
#  PRODUCT_PACKAGES += MtkDocumentsUI
#endif
#
## DocumentsUIAppPerfTests AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/DocumentsUI/app-perf-tests/Android.mk),)
#  PRODUCT_PACKAGES += MtkDocumentsUIAppPerfTests
#endif
#
## DocumentsUIPerfTests AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/DocumentsUI/perf-tests/Android.mk),)
#  PRODUCT_PACKAGES += MtkDocumentsUIPerfTests
#endif
#
## DocumentsUITests AOSP code will be replaced by MTK
#ifneq ($(wildcard vendor/mediatek/proprietary/packages/apps/DocumentsUI/tests/Android.mk),)
#  PRODUCT_PACKAGES += MtkDocumentsUITests
#endif
#
##MtkSettings override AOSP Settings
#ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#  PRODUCT_PACKAGES += MtkSettings
#endif
#
##MtkSettingsProvider override AOSP SettingsProvider
#ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#  PRODUCT_PACKAGES += MtkSettingsProvider
#endif
#
##MtkBluetooth override AOSP Bluetooth
#ifneq ($(strip $(MTK_OVERRIDES_APKS)), no)
#  PRODUCT_PACKAGES += MtkBluetooth
#endif

# vibrator HAL
ifneq ($(strip $(CUSTOM_KERNEL_VIBRATOR)), no)
PRODUCT_PACKAGES += \
    libvibratormediatekimpl \
    android.hardware.vibrator-service.mediatek
endif

# Light HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.mediatek

## MtkSystemServices for decouple AOSP systemserver
#PRODUCT_PACKAGES += mediatek-services

## Framework add on for net modules
#ifneq ($(wildcard vendor/mediatek/proprietary/frameworks/opt/net/services/Android.mk),)
#    PRODUCT_PACKAGES += mediatek-framework-net
#endif

## move proprietary mount point to vendor
#PRODUCT_PACKAGES += gen_mount_point_for_ab

#PRODUCT_PACKAGES += MusicBspPlus

# Rcs UA
  PRODUCT_PACKAGES += \
    volte_rcs_ua \
    vendor.mediatek.hardware.rcs@1.0.so \
    rcs_volte_stack \
    librcs_volte_core  \
    librcs_interface

#Client API feature
  PRODUCT_PACKAGES += volte_clientapi_ua
  PRODUCT_PACKAGES += vendor.mediatek.hardware.clientapi@1.0.so

## adb_r
#ifeq ($(strip $(MTK_BUILD_ROOT)), yes)
#  PRODUCT_PACKAGES += adbd_r
#endif

ifeq ($(strip $(MTK_HIDL_PROCESS_CONSOLIDATION_ENABLED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_hidl_consolidation=1
endif

# For IWLAN operation mode
PRODUCT_PROPERTY_OVERRIDES += ro.telephony.iwlan_operation_mode=AP-assisted

PRODUCT_PACKAGES += check-mtk-hidl

## For Full Screen Switch
#ifeq ($(strip $(MTK_FULLSCREEN_SWITCH_SUPPORT)), yes)
#    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.fullscreen_switch=1
#    PRODUCT_PACKAGES += FullscreenSwitchService
#    PRODUCT_PACKAGES += FullscreenMode
#    PRODUCT_PACKAGES += FullscreenSwitchProvider
#endif

# Add Identity
TARGET_BOOTLOADER_BOARD_NAME := $(MTK_BASE_PROJECT)

# CONNSYS Log Feature Support
ifeq ($(strip $(MTK_CONNSYS_DEDICATED_LOG_PATH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.connsys.dedicated.log=1
endif

# Only build ATCI when it's eng/userdebug load, internal user load, or EM ATCI forcely enabled
# Except for atcid which is needed by ATM
PRODUCT_PACKAGES += atcid
PRODUCT_PACKAGES += vendor.mediatek.hardware.atci@1.0.so
ifneq ($(TARGET_BUILD_VARIANT),user)
    PRODUCT_PACKAGES += atci_service
    #PRODUCT_PACKAGES += atci_service_sys
    PRODUCT_PACKAGES += libatciserv_jni
    #PRODUCT_PACKAGES += AtciService
else
    ifneq ($(wildcard vendor/mediatek/proprietary/frameworks/opt/atci_config/atci_enable),)
        PRODUCT_PACKAGES += atci_service
        #PRODUCT_PACKAGES += atci_service_sys
        PRODUCT_PACKAGES += libatciserv_jni
        #PRODUCT_PACKAGES += AtciService
    endif
endif

#MTK_AVB_IMG_RELEASE_AUTH = yes

## setup dm-verity configs.
     PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/by-name/vendor

#settings for main vbmeta
BOARD_AVB_ENABLE ?= true

ifneq ($(strip $(BOARD_AVB_ENABLE)), true)
    # if avb2.0 is not enabled
    $(call inherit-product, build/target/product/verity.mk)
endif
#else
#    # if avb2.0 is enabled
#    # BOARD_BOOTIMAGE_PARTITION_SIZE and BOARD_RECOVERYIMAGE_PARTITION_SIZE
#    # are essential to avb2.0 and must be set correctly.
#
#    #settings for main vbmeta
#    BOARD_AVB_ALGORITHM := SHA256_RSA2048
#    BOARD_AVB_KEY_PATH := $(LOCAL_PATH)/oem_prvk.pem
#
#ifeq ($(strip $(MAIN_VBMETA_IN_BOOT)),no)
#    #settings for recovery, which is configured as chain partition
#    BOARD_AVB_RECOVERY_KEY_PATH := $(LOCAL_PATH)/recovery_prvk.pem
#    BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
#    BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 0
#    # Always assign "1" to BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION
#    # if MTK_OTP_FRAMEWORK_V2 is turned on in LK. In other words,
#    # rollback_index_location "1" can only be assigned to
#    # recovery partition.
#    BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
#endif
#
#    #settings for system, which is configured as chain partition
#    BOARD_AVB_SYSTEM_KEY_PATH := $(LOCAL_PATH)/system_prvk.pem
#    BOARD_AVB_SYSTEM_ALGORITHM := SHA256_RSA2048
#    BOARD_AVB_SYSTEM_ROLLBACK_INDEX := 0
#    BOARD_AVB_SYSTEM_ROLLBACK_INDEX_LOCATION := 2
#endif

# MTK Single Image
PRODUCT_MTK_RSC_ROOT_PATH ?= etc/rsc
ifeq ($(wildcard vendor/mediatek/internal/build vendor/mediatek/libs_internal),vendor/mediatek/internal/build vendor/mediatek/libs_internal)
CURRENT_RSC_NAMES := $(PRODUCT_MTK_RSC_NAMES)
else
CURRENT_RSC_NAMES := $(PRODUCT_CUSTOMER_RSC_NAMES)
endif
$(foreach mk,$(CURRENT_RSC_NAMES),\
  $(eval mtk_rsc_name := $(mk))\
  $(eval include device/mediatek/build/tasks/tools/config_mtk_rsc.mk))

# Load parameters of BesLoudness and ACF
PRODUCT_PACKAGES += libaudiocompensationfilter_vendor

# NeuroPilot NN SDK
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
PRODUCT_PACKAGES += libtflite_mtk.vendor
PRODUCT_PACKAGES += libtflite_mtk_static_R.vendor
PRODUCT_PACKAGES += libneuropilot_jni_R.vendor
PRODUCT_PACKAGES += libneuroeara
PRODUCT_PACKAGES += nhw
PRODUCT_PACKAGES += libarmnn
PRODUCT_PACKAGES += libarmnn_ndk.mtk.vndk
PRODUCT_PACKAGES += libcmdl_ndk.mtk.vndk
PRODUCT_PACKAGES += libnir_neon_driver
PRODUCT_PACKAGES += libnir_neon_driver_ndk.mtk.vndk
PRODUCT_PACKAGES += TFLiteRunner.vendor
PRODUCT_PACKAGES += tflite_np_c_api_test.vendor
PRODUCT_PACKAGES += APUWareApusysServer
PRODUCT_PACKAGES += APUWareUtilsServer
PRODUCT_PACKAGES += APUWareHmpServer
PRODUCT_PACKAGES += libneuron_graph_delegate.mtk.vendor
PRODUCT_PACKAGES += libnpagent
PRODUCT_PACKAGES += libnpagent_server
PRODUCT_PACKAGES += android.hardware.neuralnetworks-shim-service-mtk
PRODUCT_PROPERTY_OVERRIDES += debug.mtk_tflite.target_nnapi=29
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn.option?=A,B,C,D,E,F,G,Z
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_quant_preferred=1
# HMP
#ifeq ($(MTK_HMP_CUSTOM_SUPPORT),yes)
    PRODUCT_PACKAGES += libhmp_custom
    PRODUCT_PACKAGES += libhmpconfig
#endif
else
ifeq ($(strip $(MTK_NN_SDK_SUPPORT)), yes)
PRODUCT_PACKAGES += libtflite_mtk.vendor
PRODUCT_PACKAGES += libtflite_mtk_static_R.vendor
PRODUCT_PACKAGES += libneuropilot_jni_R.vendor
PRODUCT_PACKAGES += libneuroeara
PRODUCT_PACKAGES += nhw
PRODUCT_PACKAGES += libarmnn_ndk.mtk.vndk
PRODUCT_PACKAGES += libcmdl_ndk.mtk.vndk
PRODUCT_PACKAGES += libnir_neon_driver_ndk.mtk.vndk
PRODUCT_PROPERTY_OVERRIDES += debug.mtk_tflite.target_nnapi=29
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn.option?=A,B,C,D,E,F,G,Z
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_quant_preferred=1
PRODUCT_PACKAGES += TFLiteRunner.vendor
PRODUCT_PACKAGES += tflite_np_c_api_test.vendor
endif
endif

# APUSYS middleware user space lib and UT program
PRODUCT_PACKAGES += libapu_mdw
PRODUCT_PACKAGES += libapu_mdw_batch
PRODUCT_PACKAGES += apu_mdw_test
PRODUCT_PACKAGES += libapusys
PRODUCT_PACKAGES += apusys_test
PRODUCT_PACKAGES += libapusys_edma
PRODUCT_PACKAGES_DEBUG += edma_test
PRODUCT_PACKAGES_DEBUG += reviser_test

# VPU user space lib and UT program
PRODUCT_PACKAGES += libvpu5
PRODUCT_PACKAGES_DEBUG += vpu5_test
PRODUCT_PACKAGES += libneuron_platform.vpu
ifeq ($(strip $(MTK_VPU_SUPPORT)), yes)
PRODUCT_PACKAGES += libvpu
PRODUCT_PACKAGES_DEBUG += vpu_test
PRODUCT_PACKAGES += libmcv_runtime.mtk
endif

# MDLA user space lib and UT program
PRODUCT_PACKAGES += libmdla_ut
PRODUCT_PACKAGES_DEBUG += mdla_player

# NeuroPilot Hal Util
#PRODUCT_PACKAGES += libneuropilot_hal_utils
PRODUCT_PACKAGES += libneuropilot_hal_utils.vendor

# GiFT
ifeq ($(MTK_PRODUCT_LINE), smart_phone)
PRODUCT_PACKAGES += libMEOW_gift
endif

# QT
PRODUCT_PACKAGES += libMEOW_qt

# GLT
PRODUCT_PACKAGES += libGLES_meow


##Boot performance
PRODUCT_COPY_FILES += $(LOCAL_PATH)/bootperf.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/bootperf.rc

# kernel doesn't have HEH filename encryption
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode=aes-256-cts

# Imgsensor
PRODUCT_PACKAGES_DEBUG += sentest
PRODUCT_PACKAGES_DEBUG += sentest_v4l2
PRODUCT_PACKAGES_DEBUG += eeprom_test

## camera meta
#PRODUCT_PACKAGES_ENG += camtest_metadataconverter
#PRODUCT_PACKAGES_ENG += camtest_metadata

#for gralloc test
PRODUCT_PACKAGES_ENG += test_grallocutils

## netlog compress so
#PRODUCT_PACKAGES += libcompress_copy

## For Telepony Assist
#PRODUCT_PACKAGES += MtkTelephonyAssist

#PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.base_build=noah

##Gaming with smooth lte mobile data
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
    PRODUCT_PACKAGES += libgwsd-ril
    PRODUCT_PACKAGES += libgwsdv2-ril
    PRODUCT_PACKAGES += libgwsdv3-ril
else
    ifeq ($(strip $(MTK_GWSD_V2_SUPPORT)), yes)
        PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gwsd_capability=2
        PRODUCT_PACKAGES += libgwsdv2-ril
    else
        ifeq ($(strip $(MTK_GWSD_SUPPORT)), yes)
            PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_gwsd_capability=1
            PRODUCT_PACKAGES += libgwsd-ril
        endif
    endif
endif

#tetheroffload
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
PRODUCT_PACKAGES += tetheroffloadservice
PRODUCT_PACKAGES += tetheroffloadtest
PRODUCT_PACKAGES += brctl
DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_tetheroffloadservice.xml
endif
endif

## CdsInfo
#PRODUCT_PACKAGES_DEBUG += CDS_INFO

PRODUCT_HOST_PACKAGES += ksyms-query

# Ambient Light Adaptive Luma
ifeq ($(strip $(MTK_AAL_SUPPORT)), yes)
    PRODUCT_PACKAGES += libaalservice
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
    PRODUCT_PACKAGES += libaal_cust_func
else
    PRODUCT_PACKAGES += libaal_cust
endif
    PRODUCT_PACKAGES += libaal_mtk
endif

# PQ HIDL
ifeq (,$(filter $(strip $(MTK_PQ_SUPPORT)), no PQ_OFF))
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_pq.xml
endif

PRODUCT_PACKAGES += libpqpconfig
PRODUCT_PACKAGES += libpqparamparser

PRODUCT_PACKAGES += \
  vendor.mediatek.hardware.pq@2.2-service \
  vendor.mediatek.hardware.pq@2.15-impl

# MMS HIDL
DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_mmservice.xml
PRODUCT_PACKAGES += \
  vendor.mediatek.hardware.mms@1.6-service \
  vendor.mediatek.hardware.mms@1.6-impl

PRODUCT_PACKAGES += libnvram
PRODUCT_PACKAGES += libfile_op
PRODUCT_PACKAGES += nvram_daemon
#PRODUCT_PACKAGES += vendor.mediatek.hardware.nvram@1.1

# MMAGENT HIDL
DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/project_manifest/manifest_mmagent.xml
PRODUCT_PACKAGES += \
  vendor.mediatek.hardware.mmagent@1.1-service \
  AgentTest

# nvram hidl. enable lazy hal on A-GO project to save memory
PRODUCT_PACKAGES += vendor.mediatek.hardware.nvram@1.1-impl

ifeq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
  PRODUCT_PACKAGES += vendor.mediatek.hardware.nvram@1.1-service-lazy
else
  PRODUCT_PACKAGES += vendor.mediatek.hardware.nvram@1.1-service
endif

# Another copy of AOSP root certs for vendor modules like AGPS or XCAP for IMS
ifeq ($(strip $(MTK_AGPS_APP)), yes)
    PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,system/ca-certificates/files,$(TARGET_COPY_OUT_VENDOR)/etc/security/cacerts)
else ifeq ($(strip $(MTK_UT_XCAP_SUPPORT)), yes)
    PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,system/ca-certificates/files,$(TARGET_COPY_OUT_VENDOR)/etc/security/cacerts)
endif

ifeq ($(MTK_DYNAMIC_PARTITION_SUPPORT), yes)
PRODUCT_PACKAGES += \
      fastbootd \
      android.hardware.fastboot@1.0-impl-mtk
endif

# Always On Display
#ifeq ($(strip $(MTK_AOD_SUPPORT)), yes)
#    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.mtk_aod_support=1
#endif

# DM HIDL manifest
ifneq ($(findstring manifest_dmc.xml, $(DEVICE_MANIFEST_FILE)), manifest_dmc.xml)
    DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_dmc.xml
endif

ifneq ($(findstring manifest_apmonitor.xml, $(DEVICE_MANIFEST_FILE)), manifest_apmonitor.xml)
    DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_apmonitor.xml
endif

PRODUCT_PACKAGES += dmc_core
# Packet Monitor
PRODUCT_PACKAGES += mtk_pkm_service
PRODUCT_PACKAGES += libpkm
# Shared library which used by dlopen(), so build it explictly
PRODUCT_PACKAGES += libapmonitor_vendor
PRODUCT_PACKAGES += libpkm

# DMC AP:MDMI
PRODUCT_PACKAGES += libtranslator_mdmi_v2.8.2
# DMC AP:MAPI
PRODUCT_PACKAGES += libtranslator_mapi_v3.0

# CTA SUPPORT
# enable this option for cta lab test only.
ifeq ($(strip $(MTK_CTA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_cta_support=1
endif

#for ts_ufozip in libuvvf
ifeq ($(BUILD_MTK_LDVT), yes)
    PRODUCT_PACKAGES_ENG += ts_ufozip
endif

# lazy hal
ifeq ($(strip $(MTK_CAM_LAZY_HAL)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.camera.enableLazyHal=true
    PRODUCT_PACKAGES += android.hardware.camera.provider@2.6-service-lazy
endif


# R userspace reboot support
$(call inherit-product, $(SRC_TARGET_DIR)/product/userspace_reboot.mk)

ifneq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)),)
  ifeq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)), 90)
    PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_90
  else ifeq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)), 180)
    PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_180
  else ifeq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)), 270)
    PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_270
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_0
  endif
endif

#Network Optimization
ifeq ($(strip $(MTK_NWK_OPT_SUPPORT)), yes)
  ifneq ($(wildcard vendor/mediatek/proprietary/hardware/lib_nwk_opt),)
    PRODUCT_PACKAGES += vendor.mediatek.hardware.nwk_opt@1.0-service
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_nwk_opt.xml
    PRODUCT_PACKAGES += libnwk_opt_halwrap_vendor
  endif
endif
#Touch ll
ifneq ($(filter $(strip $(MTK_TOUCH_LOW_LATENCY)),up),)
  ifneq ($(wildcard vendor/mediatek/proprietary/hardware/tboost_v/tll),)
    PRODUCT_PACKAGES += libtouch_ll_wrap
    DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_touchll.xml
    PRODUCT_PACKAGES += vendor.mediatek.hardware.touchll@1.0-service
 endif
endif

ifneq ($(filter $(strip $(MTK_TOUCH_LOW_LATENCY)),down),)
  ifneq ($(wildcard vendor/mediatek/proprietary/hardware/tboost_v),)
      PRODUCT_PACKAGES += libthp_touchll
  endif
endif
ifneq ($(filter $(strip $(MTK_TOUCH_LOW_LATENCY)),predict),)
  ifneq ($(wildcard vendor/mediatek/proprietary/hardware/tboost_v),)
    PRODUCT_PACKAGES += libthp_predict
  endif
endif
#thp
ifeq (yes,$(strip $(MTK_THP_SUPPORT)))
  ifneq ($(wildcard vendor/mediatek/kernel_modules/mtk_input/mtk_thp),)
    PRODUCT_PACKAGES += libafehalP115930900
    PRODUCT_PACKAGES += libtsa_gdix
  endif
  ifneq ($(wildcard vendor/mediatek/kernel_modules/mtk_input/touchkey),)
    PRODUCT_PACKAGES += libthp_key_vendor
  endif

  ifneq ($(wildcard vendor/mediatek/proprietary/hardware/tboost_v),)
    DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_thp.xml
    PRODUCT_PACKAGES += vendor.mediatek.hardware.thp@1.0-service
    PRODUCT_PACKAGES += libthp_service
    PRODUCT_PACKAGES += libthp_gdix_wrap
    PRODUCT_PACKAGES += libthp_tsa_wrap
    PRODUCT_PACKAGES += libthp_touchll_wrap
    PRODUCT_PACKAGES += libthp_predict_wrap
  endif
endif

# Disable USAP pool
PRODUCT_PRODUCT_PROPERTIES += persist.device_config.runtime_native.usap_pool_enabled=false

# identity
PRODUCT_PRODUCT_PROPERTIES += \
    Build.BRAND=MTK

# Enable CFI for security-sensitive components
$(call inherit-product, $(SRC_TARGET_DIR)/product/cfi-common.mk)
$(call inherit-product-if-exists, vendor/google/products/cfi-vendor.mk)

# For VOW 2E2K feature file
# added dependency in relation to libvoicerecognition_jni
ifneq ($(wildcard vendor/mediatek/proprietary/external/voiceunlock2),)
    ifeq ($(strip $(MTK_VOW_AMAZON_SUPPORT)),yes)
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/com.mediatek.hardware.vow.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.mediatek.hardware.vow.xml:mtk
    endif
    ifneq ($(strip $(MTK_VOW_MAX_PDK_NUMBER)),0)
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/com.mediatek.hardware.vow.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.mediatek.hardware.vow.xml:mtk
    endif
endif

ifeq ($(strip $(MTK_VOW_SUPPORT)),yes)
    ifeq ($(strip $(MTK_VOW_DSP_VERSION)),ver01)
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/com.mediatek.hardware.vow_dsp.cm4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.mediatek.hardware.vow_dsp.xml:mtk
    else
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/com.mediatek.hardware.vow_dsp.riscv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.mediatek.hardware.vow_dsp.xml:mtk
    endif
endif

# Hevc encode support
ifeq ($(strip $(MTK_VIDEO_HEVC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_video_hevc_enc_support=1
endif

# surface flinger common configuration property
#     to overrides these in platform/project device.mk
#     must put before $(call inherit-product, device/mediatek/vendor/common/device.mk)
PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.force_hwc_copy_for_virtual_displays=true
PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Set API level to override inherited value
PRODUCT_SHIPPING_API_LEVEL := $(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE)

ifneq (,$(filter OP07_SPEC0200_SEGDEFAULT OP08_SPEC0200_SEGDEFAULT OP12_SPEC0200_SEGDEFAULT OP20_SPEC0200_SEGDEFAULT, $(strip $(OPTR_SPEC_SEG_DEF))))
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.md_c2k_cap_dep_check=1
else
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.md_c2k_cap_dep_check=0
endif

# Specifying the below for using vndservicemanager
PRODUCT_PACKAGES += \
    vndservicemanager

# Camera HDR10+ recording capability
ifeq ($(strip $(MTK_HDR10_PLUS_RECORDING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.hdr10plus.enable=1
endif

#add for bluetooth ldac abr
ifeq ($(strip $(MTK_BLUETOOTH_LDAC_ABR)), yes)
PRODUCT_PROPERTY_OVERRIDES += vendor.bluetooth.ldac.abr=true
endif

# Enable Incremental on the device via kernel driver
PRODUCT_PROPERTY_OVERRIDES += ro.incremental.enable=yes



#inherit test case
$(call inherit-product-if-exists, vendor/mediatek/tests/vendor/config/test_list.mk)
$(call inherit-product-if-exists, vendor/mediatek/tests/kernel/test_list_user.mk)
ifndef MTK_GENERIC_HAL
$(call inherit-product-if-exists, vendor/mediatek/tests/kernel/test_list_kernel.mk)
endif

#mtk powerhal
PRODUCT_PACKAGES += vendor.mediatek.hardware.mtkpower@1.2-impl
PRODUCT_PACKAGES += vendor.mediatek.hardware.mtkpower@1.0-service
PRODUCT_PACKAGES += libpowerhal
#PRODUCT_PACKAGES += libpowerhalctl
PRODUCT_PACKAGES += libpowerhalctl_vendor
#PRODUCT_PACKAGES += libpowerhalwrap
PRODUCT_PACKAGES += libpowerhalwrap_vendor
#PRODUCT_PACKAGES += libmtkperf_client
PRODUCT_PACKAGES += libmtkperf_client_vendor
#PRODUCT_PACKAGES += libperfctl
PRODUCT_PACKAGES += libperfctl_vendor
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += power_native_test_v_1_0
PRODUCT_PACKAGES += power_native_test_v_1_1
endif
endif

# Enable modprobe on second stage by shell script
PRODUCT_COPY_FILES += device/mediatek/vendor/common/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh

# Header libs for libvcodecdrv
PRODUCT_PACKAGES += libvcodecdrv_header_stub

# mtk simple hwcomposer
ifneq ($(wildcard vendor/mediatek/internal/hwcomposer_simple),)
PRODUCT_PACKAGES += libsimplehwc
endif
# mtk hwcomposer
PRODUCT_PACKAGES += hwcomposer.mtk_common
PRODUCT_PACKAGES += hwcomposer.mtk_fold
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.hardware.hwcomposer?=mtk_common
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.composer_version?=2.1

# IComposerExt
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_composer.xml

# mtk c2 hal service
ifneq ($(MTK_BASIC_PACKAGE), yes)
PRODUCT_PACKAGES += android.hardware.media.c2@1.2-mediatek
PRODUCT_PACKAGES += android.hardware.media.c2@1.2-mediatek-64b
endif

# IRTX over PWM
ifeq ($(strip $(MTK_IRTX_PWM_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.consumerir=common
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml
PRODUCT_PACKAGES += consumerir.common
endif

#FPSGO
PRODUCT_PACKAGES += fpsgo

############ Porting from mt6893/device.mk - BEGIN #################
ifdef MTK_GENERIC_HAL

# HDR Video Library
ifeq ($(strip $(MTK_HDR_VIDEO_SUPPORT)), yes)
    PRODUCT_PACKAGES += libhdrvideo
    PRODUCT_PACKAGES += libhdrvideo_mtk
endif

#GPU collection
PRODUCT_PACKAGES += libI420colorconvert
PRODUCT_PACKAGES += vpud
PRODUCT_PACKAGES += v3avpud
ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6855),)
      PRODUCT_PACKAGES += v3avpud.mt6855
      PRODUCT_PACKAGES += libvpudv3a_vcodec
endif
ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6789),)
      PRODUCT_PACKAGES += v3avpud.mt6789
      PRODUCT_PACKAGES += libvpudv3a_vcodec
endif
PRODUCT_PACKAGES += v4l2vcodec-ut
PRODUCT_PACKAGES += v4l2vcodecv3a-ut
PRODUCT_PACKAGES += libvcodecdrv
PRODUCT_PACKAGES += libvcodecdrv_v3a
PRODUCT_PACKAGES += libvcodec_utility
PRODUCT_PACKAGES += libvcodec_utility_v3a
PRODUCT_PACKAGES += libvcodec_oal
PRODUCT_PACKAGES += libh264enc_sa.ca7
PRODUCT_PACKAGES += libh264enc_sb.ca7
PRODUCT_PACKAGES += libhevce_sb.ca7.android
PRODUCT_PACKAGES += libHEVCdec_sa.ca7.android
PRODUCT_PACKAGES += libmp4enc_sa.ca7
PRODUCT_PACKAGES += libmp4enc_xa.ca7
PRODUCT_PACKAGES += libvc1dec_sa.ca7
PRODUCT_PACKAGES += libvp8dec_sa.ca7
PRODUCT_PACKAGES += libvp8enc_sa.ca7
PRODUCT_PACKAGES += libvp9dec_sa.ca7
PRODUCT_PACKAGES += libvideoeditorplayer
PRODUCT_PACKAGES += libvideoeditor_osal
PRODUCT_PACKAGES += libvideoeditor_3gpwriter
PRODUCT_PACKAGES += libvideoeditor_mcs
PRODUCT_PACKAGES += libvideoeditor_core
PRODUCT_PACKAGES += libvideoeditor_stagefrightshells
PRODUCT_PACKAGES += libvideoeditor_videofilters
PRODUCT_PACKAGES += libvideoeditor_jni
PRODUCT_PACKAGES += audio.primary.default
PRODUCT_PACKAGES += sound_trigger.primary.default
PRODUCT_PACKAGES += audio_policy.stub
PRODUCT_PACKAGES += local_time.default
PRODUCT_PACKAGES += libaudiocustparam
#PRODUCT_PACKAGES += libaudiocomponentengine
PRODUCT_PACKAGES += libaudiocomponentengine_vendor
PRODUCT_PACKAGES += libh264dec_xa.ca9
PRODUCT_PACKAGES += libh264dec_xb.ca9
PRODUCT_PACKAGES += libh264dec_sa.ca7
PRODUCT_PACKAGES += libh264dec_sd.ca7
PRODUCT_PACKAGES += libh264dec_se.ca7
PRODUCT_PACKAGES += libh264dec_customize
PRODUCT_PACKAGES += libmp4dec_sa.ca9
PRODUCT_PACKAGES += libmp4dec_sb.ca9
PRODUCT_PACKAGES += libmp4dec_customize
PRODUCT_PACKAGES += libvp8dec_xa.ca9
PRODUCT_PACKAGES += libmp4enc_xa.ca9
PRODUCT_PACKAGES += libmp4enc_xb.ca9
PRODUCT_PACKAGES += libh264enc_sa.ca9
PRODUCT_PACKAGES += libh264enc_sb.ca9
PRODUCT_PACKAGES += libvcodec_oal
PRODUCT_PACKAGES += libvc1dec_sa.ca9
PRODUCT_PACKAGES += liblic_s263
PRODUCT_PACKAGES += init.factory.rc
PRODUCT_PACKAGES += libaudio.primary.default
PRODUCT_PACKAGES += audio_policy.default
PRODUCT_PACKAGES += libaudio.a2dp.default
PRODUCT_PACKAGES += libMtkVideoTranscoder
PRODUCT_PACKAGES += libMtkOmxCore
PRODUCT_PACKAGES += libMtkOmxOsalUtils
PRODUCT_PACKAGES += libMtkOmxVdecEx
PRODUCT_PACKAGES += libMtkOmxVenc
PRODUCT_PACKAGES += libaudiodcrflt
PRODUCT_PACKAGES += libaudiosetting
#PRODUCT_PACKAGES += librtp_jni
PRODUCT_PACKAGES += mfv_ut
PRODUCT_PACKAGES += libstagefrighthw
PRODUCT_PACKAGES += libstagefright_memutil
PRODUCT_PACKAGES += factory.ini
PRODUCT_PACKAGES += libmtdutil
PRODUCT_PACKAGES += libminiui
PRODUCT_PACKAGES += factory
PRODUCT_PACKAGES += drvbd
PRODUCT_PACKAGES += libaudio.usb.default
PRODUCT_PACKAGES += audio.usb.default
PRODUCT_PACKAGES += AccountAndSyncSettings
#PRODUCT_PACKAGES += DeskClock
#PRODUCT_PACKAGES += AlarmProvider
#PRODUCT_PACKAGES += Bluetooth
#PRODUCT_PACKAGES += Calculator
#PRODUCT_PACKAGES += Calendar
#PRODUCT_PACKAGES += CertInstaller
ifeq ($(strip $(MTK_OMADRM_SUPPORT)), yes)
  PRODUCT_PACKAGES += DrmProvider
endif
#PRODUCT_PACKAGES += Email
#PRODUCT_PACKAGES += FusedLocation
#PRODUCT_PACKAGES += TelephonyProvider
#PRODUCT_PACKAGES += Exchange2
#PRODUCT_PACKAGES += LatinIME
#PRODUCT_PACKAGES += Music
#PRODUCT_PACKAGES += MusicFX
#PRODUCT_PACKAGES += Protips
#PRODUCT_PACKAGES += QuickSearchBox
#PRODUCT_PACKAGES += Settings
#PRODUCT_PACKAGES += Sync
#PRODUCT_PACKAGES += SystemUI
#PRODUCT_PACKAGES += Updater
#PRODUCT_PACKAGES += CalendarProvider
PRODUCT_PACKAGES += ccci_mdinit
PRODUCT_PACKAGES += ccci_fsd
PRODUCT_PACKAGES += ccci_rpcd
PRODUCT_PACKAGES += ccci_dpmaif_debug
#PRODUCT_PACKAGES += batterywarning
PRODUCT_PACKAGES += SyncProvider
#PRODUCT_PACKAGES += Launcher3
PRODUCT_PACKAGES += disableapplist.txt
PRODUCT_PACKAGES += resmonwhitelist.txt
PRODUCT_PACKAGES += thermal_hal
ifdef MTK_GENERIC_HAL
PRODUCT_PACKAGES += thermal_core
PRODUCT_PACKAGES += thermal_intf
PRODUCT_PACKAGES += ThermalCoreTest
else
PRODUCT_PACKAGES += MTKThermalManager
PRODUCT_PACKAGES += libmtcloader
PRODUCT_PACKAGES += thermal_manager
PRODUCT_PACKAGES += thermal
PRODUCT_PACKAGES += thermalloadalgod
PRODUCT_PACKAGES += libthermalalgo
endif
PRODUCT_PACKAGES += CellConnService
ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    PRODUCT_PACKAGES += MTKAndroidSuiteDaemon
endif
PRODUCT_PACKAGES += libthha
PRODUCT_PACKAGES += ami304d
PRODUCT_PACKAGES += akmd8963
PRODUCT_PACKAGES += akmd09911
PRODUCT_PACKAGES += akmd09912
PRODUCT_PACKAGES += akmd8975
PRODUCT_PACKAGES += istd8303
PRODUCT_PACKAGES += AcdApiDaemon
PRODUCT_PACKAGES += calib.dat
PRODUCT_PACKAGES += param.dat
PRODUCT_PACKAGES += geomagneticd
PRODUCT_PACKAGES += orientationd
PRODUCT_PACKAGES += memsicd
PRODUCT_PACKAGES += msensord
PRODUCT_PACKAGES += lsm303md
PRODUCT_PACKAGES += memsicd3416x
PRODUCT_PACKAGES += s62xd smartsensor
PRODUCT_PACKAGES += bmm050d
PRODUCT_PACKAGES += mc6420d
PRODUCT_PACKAGES += magd
PRODUCT_PACKAGES += meta_tst
PRODUCT_PACKAGES += dhcp6c
PRODUCT_PACKAGES += dhcp6ctl
PRODUCT_PACKAGES += dhcp6c.conf
PRODUCT_PACKAGES += dhcp6cDNS.conf
PRODUCT_PACKAGES += dhcp6s
PRODUCT_PACKAGES += dhcp6s.conf
PRODUCT_PACKAGES += dhcp6c.script
PRODUCT_PACKAGES += dhcp6cctlkey
#PRODUCT_PACKAGES += libblisrc
PRODUCT_PACKAGES += libifaddrs
PRODUCT_PACKAGES += libmobilelog_jni
PRODUCT_PACKAGES += audio.r_submix.default
PRODUCT_PACKAGES += libaudio.usb.default
#PRODUCT_PACKAGES += libnbaio
#PRODUCT_PACKAGES += libaudioflinger
PRODUCT_PACKAGES += libmeta_audio
PRODUCT_PACKAGES += liba3m
PRODUCT_PACKAGES += libja3m
PRODUCT_PACKAGES += libmmprofile
PRODUCT_PACKAGES += libmmprofile_jni
PRODUCT_PACKAGES += libtvoutjni
PRODUCT_PACKAGES += libtvoutpattern
PRODUCT_PACKAGES += libmtkhdmi_jni

PRODUCT_PACKAGES += liblog
PRODUCT_PACKAGES += shutdown
PRODUCT_PACKAGES += muxreport
PRODUCT_PACKAGES += mtkrild
PRODUCT_PACKAGES += mtk-ril
PRODUCT_PACKAGES += librilmtk
PRODUCT_PACKAGES += libutilrilmtk
PRODUCT_PACKAGES += gsm0710muxd
PRODUCT_PACKAGES += md_minilog_util
PRODUCT_PACKAGES += wbxml
PRODUCT_PACKAGES += wappush
PRODUCT_PACKAGES += thememap.xml
PRODUCT_PACKAGES += libBLPP.so
PRODUCT_PACKAGES += rc.fac
PRODUCT_PACKAGES += mtkGD
PRODUCT_PACKAGES += pvrsrvctl
PRODUCT_PACKAGES += libGLES_meow
PRODUCT_PACKAGES += libMEOW_trace
PRODUCT_PACKAGES += libEGL_mtk.so
PRODUCT_PACKAGES += libGLESv1_CM_mtk.so
PRODUCT_PACKAGES += libGLESv2_mtk.so
PRODUCT_PACKAGES += thermalindicator
PRODUCT_PACKAGES += libged.so
ifneq ($(MTK_BASIC_PACKAGE), yes)
  PRODUCT_PACKAGES += libgas.so
endif
PRODUCT_PACKAGES += libusc.so
PRODUCT_PACKAGES += libglslcompiler.so
PRODUCT_PACKAGES += libIMGegl.so
PRODUCT_PACKAGES += libpvr2d.so
PRODUCT_PACKAGES += libsrv_um.so
PRODUCT_PACKAGES += libsrv_init.so
PRODUCT_PACKAGES += libPVRScopeServices.so
PRODUCT_PACKAGES += libpvrANDROID_WSEGL.so
PRODUCT_PACKAGES += libFraunhoferAAC
PRODUCT_PACKAGES += audiocmdservice_atci
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
PRODUCT_PACKAGES += libMtkOmxAudioEncBase
PRODUCT_PACKAGES += libMtkOmxAmrEnc
PRODUCT_PACKAGES += libMtkOmxAwbEnc
PRODUCT_PACKAGES += libMtkOmxAacEnc
PRODUCT_PACKAGES += libMtkOmxVorbisEnc
PRODUCT_PACKAGES += libMtkOmxAdpcmEnc
PRODUCT_PACKAGES += libMtkOmxMp3Dec
PRODUCT_PACKAGES += libMtkOmxGsmDec
PRODUCT_PACKAGES += libMtkOmxAacDec
PRODUCT_PACKAGES += libMtkOmxG711Dec
PRODUCT_PACKAGES += libMtkOmxVorbisDec
PRODUCT_PACKAGES += libMtkOmxAudioDecBase
PRODUCT_PACKAGES += libMtkOmxAdpcmDec
PRODUCT_PACKAGES += libMtkOmxRawDec
PRODUCT_PACKAGES += libMtkOmxAMRNBDec
PRODUCT_PACKAGES += libMtkOmxAMRWBDec
endif
PRODUCT_PACKAGES += libphonemotiondetector_jni
PRODUCT_PACKAGES += libphonemotiondetector
PRODUCT_PACKAGES += libmotionrecognition
PRODUCT_PACKAGES += audio.primary.default
PRODUCT_PACKAGES += audio_policy.stub
PRODUCT_PACKAGES += audio_policy.default
PRODUCT_PACKAGES += libaudio.primary.default
PRODUCT_PACKAGES += libaudio.a2dp.default
#PRODUCT_PACKAGES += audio.a2dp.default
#PRODUCT_PACKAGES += libaudio-resampler
PRODUCT_PACKAGES += local_time.default
PRODUCT_PACKAGES += libaudiocustparam
PRODUCT_PACKAGES += libaudiodcrflt
PRODUCT_PACKAGES += libaudiosetting
#PRODUCT_PACKAGES += librtp_jni
PRODUCT_PACKAGES += libmatv_cust
PRODUCT_PACKAGES += libmtkplayer
PRODUCT_PACKAGES += libatvctrlservice
PRODUCT_PACKAGES += matv
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
PRODUCT_PACKAGES += libMtkOmxApeDec
PRODUCT_PACKAGES += libMtkOmxFlacDec
endif
PRODUCT_PACKAGES += ppp_dt
PRODUCT_PACKAGES += libdiagnose
#PRODUCT_PACKAGES += libsonivox
PRODUCT_PACKAGES += iAmCdRom.iso
PRODUCT_PACKAGES += libmemorydumper
PRODUCT_PACKAGES += memorydumper
PRODUCT_PACKAGES += libvt_custom
PRODUCT_PACKAGES += libamrvt
PRODUCT_PACKAGES += libvtmal
PRODUCT_PACKAGES += libipsec_ims
#PRODUCT_PACKAGES += racoon
PRODUCT_PACKAGES += libipsec
#PRODUCT_PACKAGES += libpcap
#PRODUCT_PACKAGES += mtpd
PRODUCT_PACKAGES += netcfg
#PRODUCT_PACKAGES += pppd
PRODUCT_PACKAGES += pppd_via
PRODUCT_PACKAGES += pppd_dt
PRODUCT_PACKAGES += dhcpcd
PRODUCT_PACKAGES += dhcpcd.conf
PRODUCT_PACKAGES += dhcpcd-run-hooks
PRODUCT_PACKAGES += 20-dns.conf
PRODUCT_PACKAGES += 95-configured
PRODUCT_PACKAGES += radvd
PRODUCT_PACKAGES += radvd.conf
#PRODUCT_PACKAGES += dnsmasq
#PRODUCT_PACKAGES += netd
#PRODUCT_PACKAGES += ndc
#PRODUCT_PACKAGES += libiprouteutil
#PRODUCT_PACKAGES += libnetlink
#PRODUCT_PACKAGES += tc
#PRODUCT_PACKAGES += e2fsck
#PRODUCT_PACKAGES += libext2_blkid
#PRODUCT_PACKAGES += libext2_e2p
#PRODUCT_PACKAGES += libext2_com_err
#PRODUCT_PACKAGES += libext2fs
#PRODUCT_PACKAGES += libext2_uuid
#PRODUCT_PACKAGES += mke2fs
#PRODUCT_PACKAGES += tune2fs
#PRODUCT_PACKAGES += badblocks
#PRODUCT_PACKAGES += resize2fs
PRODUCT_PACKAGES += resize.f2fs
PRODUCT_PACKAGES += make_ext4fs
#PRODUCT_PACKAGES += sdcard
PRODUCT_PACKAGES += libext
PRODUCT_PACKAGES += libext4
PRODUCT_PACKAGES += libext6
PRODUCT_PACKAGES += libxtables
PRODUCT_PACKAGES += libip4tc
PRODUCT_PACKAGES += libip6tc
PRODUCT_PACKAGES += ipod
PRODUCT_PACKAGES += libipod
PRODUCT_PACKAGES += smartcharging
PRODUCT_PACKAGES += libsmartcharging
PRODUCT_PACKAGES += fuelgauged
PRODUCT_PACKAGES += fuelgauged_nvram
ifeq ($(MTK_GAUGE_VERSION), 30)
PRODUCT_PACKAGES += libfgauge_gm30
else
PRODUCT_PACKAGES += libfgauge
endif
PRODUCT_PACKAGES += android.hardware.health@2.1-service
PRODUCT_PACKAGES += android.hardware.health@2.1-impl
PRODUCT_PACKAGES += android.hardware.health@2.1-impl.recovery
PRODUCT_PACKAGES += gatord
#PRODUCT_PACKAGES += boot_logo_updater
PRODUCT_PACKAGES += boot_logo
#PRODUCT_PACKAGES += bootanimation
ifneq (,$(filter yes, $(MTK_KERNEL_POWER_OFF_CHARGING)))
#PRODUCT_PACKAGES += kpoc_charger
endif
PRODUCT_PACKAGES += libtvoutjni
PRODUCT_PACKAGES += libtvoutpattern
PRODUCT_PACKAGES += libmtkhdmi_jni
PRODUCT_PACKAGES += libhissage.so
PRODUCT_PACKAGES += libhpe.so
PRODUCT_PACKAGES += sdiotool
PRODUCT_PACKAGES += superumount
PRODUCT_PACKAGES += libsched
PRODUCT_PACKAGES += fsck_msdos_mtk
PRODUCT_PACKAGES += cmmbsp
PRODUCT_PACKAGES += libcmmb_jni
PRODUCT_PACKAGES += robotium
PRODUCT_PACKAGES += libc_malloc_debug_mtk
PRODUCT_PACKAGES += dpfd
PRODUCT_PACKAGES += SchedulePowerOnOff
#PRODUCT_PACKAGES += BatteryWarning
ifneq ($(strip $(MTK_GENERIC_HAL)), yes)
PRODUCT_PACKAGES += libpq_cust_base
endif
PRODUCT_PACKAGES += libpq_cust_base_mtk
PRODUCT_PACKAGES += libpq_cust
PRODUCT_PACKAGES += libpq_cust_mtk
PRODUCT_PACKAGES += librgbwlightsensor
#PRODUCT_PACKAGES += libPQjni
#PRODUCT_PACKAGES += libPQDCjni
#PRODUCT_PACKAGES += MiraVision
#PRODUCT_PACKAGES += libMiraVision_jni
PRODUCT_PACKAGES += hald
PRODUCT_PACKAGES += dmlog
PRODUCT_PACKAGES += mtk_msr.ko

PRODUCT_PACKAGES += cpu_stress_cache_miss.ko
PRODUCT_PACKAGES += cpu_stress_dhry.ko
PRODUCT_PACKAGES += cpu_stress_maxpower.ko
PRODUCT_PACKAGES += cpu_stress_maxpower_L2.ko
PRODUCT_PACKAGES += cpu_stress_maxpower_L3.ko
PRODUCT_PACKAGES += cpu_stress_maxtrans.ko
PRODUCT_PACKAGES += cpu_stress_saxpy.ko

PRODUCT_PACKAGES += send_bug
# PRODUCT_PACKAGES += met.ko
# PRODUCT_PACKAGES += met_plf.ko
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
PRODUCT_PACKAGES += libMtkOmxRawDec
endif
PRODUCT_PACKAGES += fteh.cfg
PRODUCT_PACKAGES += gbe
PRODUCT_PACKAGES += sn
#PRODUCT_PACKAGES += lcdc_screen_cap
PRODUCT_PACKAGES += libJniAtvService
PRODUCT_PACKAGES += GoogleKoreanIME
PRODUCT_PACKAGES += android.hardware.memtrack-service.mediatek
PRODUCT_PACKAGES += mbimd

ifndef MTK_TB_WIFI_3G_MODE
  PRODUCT_PACKAGES += Mms
else
  ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
    PRODUCT_PACKAGES += Mms
  endif
endif

PRODUCT_PACKAGES += libjni_koreanime.so
PRODUCT_PACKAGES += wpa_supplicant
PRODUCT_PACKAGES += wpa_cli
PRODUCT_PACKAGES += wpa_supplicant.conf
PRODUCT_PACKAGES += wpa_supplicant_overlay.conf
PRODUCT_PACKAGES += p2p_supplicant_overlay.conf
PRODUCT_PACKAGES += hostapd
PRODUCT_PACKAGES += hostapd_cli
PRODUCT_PACKAGES += lib_driver_cmd_mt66xx.a
#ifndef MTK_TB_WIFI_3G_MODE
#  PRODUCT_PACKAGES += Dialer
#endif
#PRODUCT_PACKAGES += CallLogBackup
PRODUCT_PACKAGES += libacdk

PRODUCT_PACKAGES += md_ctrl

# For per-platform composer version on layer decuple 2.0, the libraries will be packed into MGVI,
# and you can switch the composer version at device-vext.mk

PRODUCT_PACKAGES += \
                android.hardware.graphics.composer@2.1-impl \
                android.hardware.graphics.composer@2.1-service

#PRODUCT_PACKAGES += \
#                android.hardware.graphics.composer@2.2-impl \
#                android.hardware.graphics.composer@2.2-service

PRODUCT_PACKAGES += \
                android.hardware.graphics.composer@2.3-impl \
                android.hardware.graphics.composer@2.3-service

PRODUCT_PACKAGES += \
                android.hardware.graphics.composer@2.4-impl \
                android.hardware.graphics.composer@2.4-service

PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/android.hardware.graphics.composer@2.1-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.1-service.rc
#PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.2-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.2-service.rc
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.3-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.3-service.rc
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.4-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.4-service.rc

ifeq ($(strip $(MTK_CCCI_PERMISSION_CHECK_SUPPORT)),yes)
PRODUCT_PACKAGES += permission_check
PRODUCT_PROPERTY_OVERRIDES += persist.md.perm.checked=to_upgrade
endif

PRODUCT_PACKAGES += libGLES_android

ifneq ($(MTK_BASIC_PACKAGE), yes)
PRODUCT_PACKAGES += guiext-server
endif

ifeq ($(strip $(BUILD_MTK_LDVT)),yes)
  PRODUCT_PACKAGES += ts_uvvf
endif

ifeq ($(strip $(MTK_APP_GUIDE)),yes)
  PRODUCT_PACKAGES += ApplicationGuide
endif

ifneq ($(strip $(foreach value,$(DFO_NVRAM_SET),$(filter yes,$($(value))))),)
  PRODUCT_PACKAGES += featured
  PRODUCT_PACKAGES += libdfo
  PRODUCT_PACKAGES += libdfo_jni
endif

ifeq ($(strip $(MTK_EMULATOR_SUPPORT)),yes)
  #PRODUCT_PACKAGES += SDKGallery
else
  #PRODUCT_PACKAGES += Gallery2
  #PRODUCT_PACKAGES += Gallery2Root
  #PRODUCT_PACKAGES += Gallery2Drm
  #PRODUCT_PACKAGES += Gallery2Gif
  #PRODUCT_PACKAGES += Gallery2Pq
  #PRODUCT_PACKAGES += Gallery2PqTool
  PRODUCT_PACKAGES += Gallery2Raw
  PRODUCT_PACKAGES += Gallery2SlowMotion
  PRODUCT_PACKAGES += Gallery2StereoEntry
  PRODUCT_PACKAGES += Gallery2StereoCopyPaste
  PRODUCT_PACKAGES += Gallery2StereoBackground
  PRODUCT_PACKAGES += Gallery2StereoFancyColor
  PRODUCT_PACKAGES += Gallery2StereoRefocus
  PRODUCT_PACKAGES += Gallery2PhotoPicker
endif

ifneq ($(strip $(MTK_EMULATOR_SUPPORT)),yes)
  #PRODUCT_PACKAGES += Provision
endif

ifeq ($(strip $(HAVE_CMMB_FEATURE)), yes)
  PRODUCT_PACKAGES += CMMBPlayer
endif

ifeq ($(strip $(MTK_DATA_TRANSFER_APP)), yes)
  PRODUCT_PACKAGES += DataTransfer
endif

ifeq ($(strip $(MTK_MDM_APP)),yes)
  PRODUCT_PACKAGES += MediatekDM
endif

ifeq ($(strip $(MTK_VT3G324M_SUPPORT)),yes)
  PRODUCT_PACKAGES += libmtk_vt_client
  PRODUCT_PACKAGES += libmtk_vt_em
  PRODUCT_PACKAGES += libmtk_vt_utils
  PRODUCT_PACKAGES += libmtk_vt_service
  PRODUCT_PACKAGES += libmtk_vt_swip
  PRODUCT_PACKAGES += vtservice
endif

ifeq ($(strip $(MTK_OOBE_APP)),yes)
  PRODUCT_PACKAGES += OOBE
endif

ifdef MTK_WEATHER_PROVIDER_APP
  ifneq ($(strip $(MTK_WEATHER_PROVIDER_APP)), no)
    PRODUCT_PACKAGES += MtkWeatherProvider
  endif
endif

ifeq ($(strip $(MTK_ENABLE_VIDEO_EDITOR)),yes)
  PRODUCT_PACKAGES += VideoEditor
endif

ifeq ($(strip $(MTK_CALENDAR_IMPORTER_APP)), yes)
  PRODUCT_PACKAGES += CalendarImporter
endif

ifeq ($(strip $(MTK_LOG2SERVER_APP)), yes)
  PRODUCT_PACKAGES += Log2Server
  PRODUCT_PACKAGES += Excftpcommonlib
  PRODUCT_PACKAGES += Excactivationlib
  PRODUCT_PACKAGES += Excadditionnallib
  PRODUCT_PACKAGES += Excmaillib
endif

ifeq ($(strip $(MTK_CAMERA_APP)), yes)
  PRODUCT_PACKAGES += CameraOpen
else
  #PRODUCT_PACKAGES += Camera
  PRODUCT_PACKAGES += Panorama
  PRODUCT_PACKAGES += NativePip
  PRODUCT_PACKAGES += SlowMotion
  PRODUCT_PACKAGES += CameraRoot
endif

ifeq ($(strip $(MTK_VIDEO_FAVORITES_WIDGET_APP)), yes)
  ifneq ($(strip $(MTK_TABLET_PLATFORM)), yes)
    PRODUCT_PACKAGES += VideoFavorites
    PRODUCT_PACKAGES += libjtranscode
  endif
endif

ifeq ($(strip $(MTK_VIDEOWIDGET_APP)),yes)
  PRODUCT_PACKAGES += MtkVideoWidget
endif

ifeq ($(strip $(MTK_RCSE_SUPPORT)), yes)
  #PRODUCT_PACKAGES += Rcse
  PRODUCT_PACKAGES += Provisioning
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  PRODUCT_PACKAGES += BGW
endif

ifeq ($(strip $(MTK_NAND_UBIFS_SUPPORT)),yes)
  PRODUCT_PACKAGES += mkfs_ubifs
  PRODUCT_PACKAGES += ubinize
  PRODUCT_PACKAGES += mtdinfo
  PRODUCT_PACKAGES += ubiupdatevol
  PRODUCT_PACKAGES += ubirmvol
  PRODUCT_PACKAGES += ubimkvol
  PRODUCT_PACKAGES += ubidetach
  PRODUCT_PACKAGES += ubiattach
  PRODUCT_PACKAGES += ubinfo
  PRODUCT_PACKAGES += ubiformat
endif

ifeq ($(strip $(MTK_LIVEWALLPAPER_APP)), yes)
  PRODUCT_PACKAGES += LiveWallpapers
  #PRODUCT_PACKAGES += LiveWallpapersPicker
  PRODUCT_PACKAGES += MagicSmokeWallpapers
  PRODUCT_PACKAGES += VisualizationWallpapers
  PRODUCT_PACKAGES += Galaxy4
  PRODUCT_PACKAGES += HoloSpiralWallpaper
  PRODUCT_PACKAGES += NoiseField
  PRODUCT_PACKAGES += PhaseBeam
endif

ifeq ($(strip $(MTK_SNS_SUPPORT)), yes)
  PRODUCT_PACKAGES += SNSCommon
  PRODUCT_PACKAGES += SnsContentProvider
  PRODUCT_PACKAGES += SnsWidget
  PRODUCT_PACKAGES += SnsWidget24
  PRODUCT_PACKAGES += SocialStream
  ifeq ($(strip $(MTK_SNS_KAIXIN_APP)), yes)
    PRODUCT_PACKAGES += KaiXinAccountService
  endif
  ifeq ($(strip $(MTK_SNS_RENREN_APP)), yes)
    PRODUCT_PACKAGES += RenRenAccountService
  endif
  ifeq ($(strip $(MTK_SNS_FACEBOOK_APP)), yes)
    PRODUCT_PACKAGES += FacebookAccountService
  endif
  ifeq ($(strip $(MTK_SNS_FLICKR_APP)), yes)
    PRODUCT_PACKAGES += FlickrAccountService
  endif
  ifeq ($(strip $(MTK_SNS_TWITTER_APP)), yes)
    PRODUCT_PACKAGES += TwitterAccountService
  endif
  ifeq ($(strip $(MTK_SNS_SINAWEIBO_APP)), yes)
    PRODUCT_PACKAGES += WeiboAccountService
  endif
endif

ifeq ($(strip $(MTK_DATADIALOG_APP)), yes)
  PRODUCT_PACKAGES += DataDialog
endif

ifeq ($(strip $(MTK_DATA_TRANSFER_APP)), yes)
  PRODUCT_PACKAGES += DataTransfer
endif

ifeq ($(strip $(MTK_FM_SUPPORT)), yes)
  #PRODUCT_PACKAGES += FMRadio
endif

RAT_CONFIG = $(strip $(MTK_PROTOCOL1_RAT_CONFIG))
ifneq (, $(RAT_CONFIG))
  ifneq (,$(findstring C,$(RAT_CONFIG)))
    #C2K is supported
    RAT_CONFIG_C2K_SUPPORT=yes
  endif
endif



ifeq ($(strip $(MTK_DT_SUPPORT)),yes)
  ifneq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
    ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
      PRODUCT_PACKAGES += ExtModemLog
      PRODUCT_PACKAGES += libextmdlogger_ctrl_jni
      PRODUCT_PACKAGES += libextmdlogger_ctrl
      PRODUCT_PACKAGES += extmdlogger
    endif
  endif
endif

ifneq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)),)
endif

ifeq ($(strip $(MTK_FM_TX_SUPPORT)), yes)
  PRODUCT_PACKAGES += FMTransmitter
endif

ifeq ($(strip $(MTK_LOCKSCREEN_TYPE)),2)
  PRODUCT_PACKAGES += MtkWallPaper
endif

  PRODUCT_PACKAGES += Browser
  #PRODUCT_PACKAGES += DownloadProvider

ifeq ($(strip $(MTK_WIFI_P2P_SUPPORT)),yes)
  PRODUCT_PACKAGES += WifiContactSync
  PRODUCT_PACKAGES += WifiP2PWizardy
  PRODUCT_PACKAGES += FileSharingServer
  PRODUCT_PACKAGES += FileSharingClient
  PRODUCT_PACKAGES += UPnPAV
  PRODUCT_PACKAGES += WifiWsdsrv
  PRODUCT_PACKAGES += bonjourExplorer
endif

ifeq ($(strip $(CUSTOM_KERNEL_TOUCHPANEL)),generic)
  PRODUCT_PACKAGES += Calibrator
endif

ifneq ($(findstring OP03, $(strip $(OPTR_SPEC_SEG_DEF))),)
  PRODUCT_PACKAGES += SimCardAuthenticationService
endif

ifeq ($(strip $(MTK_NFC_OMAAC_SUPPORT)),yes)
  PRODUCT_PACKAGES += SmartcardService
  PRODUCT_PACKAGES += org.simalliance.openmobileapi
  PRODUCT_PACKAGES += org.simalliance.openmobileapi.xml
  PRODUCT_PACKAGES += libassd
endif

ifeq ($(strip $(MTK_APKINSTALLER_APP)), yes)
  PRODUCT_PACKAGES += APKInstaller
endif

ifeq ($(strip $(MTK_SMSREG_APP)), yes)
  PRODUCT_PACKAGES += SmsReg
endif

ifeq ($(MTK_BACKUPANDRESTORE_APP),yes)
  PRODUCT_PACKAGES += BackupAndRestore
endif

ifeq ($(strip $(MTK_BWC_SUPPORT)), yes)
  PRODUCT_PACKAGES += libbwc
endif

PRODUCT_PACKAGES += meow.cfg
ifeq ($(strip $(MTK_GLT_SUPPORT)), 1)
    PRODUCT_PACKAGES += libGLES_meow
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=meow
endif

ifeq ($(strip $(MTK_GPU_TUNER)), yes)
    PRODUCT_PACKAGES += libMEOW_qt
    PRODUCT_PACKAGES += qt.cfg
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=meow
endif

$(call inherit-product-if-exists,vendor/mediatek/proprietary/hardware/gpu_mali/gpu_mali_ddk.mk)

ifeq ($(strip $(MTK_GPU_VERSION)), r38p1)
    # r8_g8_b8_a8_32bit_fixed
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a8_32bit_fixed.hal_format=0x1
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a8_32bit_fixed.recordable=true
    # mtk: disable rgb888 fb buffer
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a8_32bit_fixed.framebuffer_target=false
    # r8_g8_b8_a0_32bit_fixed
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_32bit_fixed.hal_format=0x2
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_32bit_fixed.recordable=false
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_32bit_fixed.framebuffer_target=false
    # r8_g8_b8_a0_24bit_fixed
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_24bit_fixed.hal_format=0x2
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_24bit_fixed.recordable=false
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_24bit_fixed.framebuffer_target=false
    # r5_g6_b5_a0_16bit_fixed
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r5_g6_b5_a0_16bit_fixed.hal_format=0x4
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r5_g6_b5_a0_16bit_fixed.recordable=false
    # mtk: disable rgb565 fb buffer
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r5_g6_b5_a0_16bit_fixed.framebuffer_target=false
    # r10_g10_b10_a2_32bit_fixed
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r10_g10_b10_a2_32bit_fixed.hal_format=0x2b
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r10_g10_b10_a2_32bit_fixed.recordable=false
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r10_g10_b10_a2_32bit_fixed.framebuffer_target=false
    # r16_g16_b16_a16_64bit_float
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r16_g16_b16_a16_64bit_float.hal_format=0x16
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r16_g16_b16_a16_64bit_float.recordable=false
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r16_g16_b16_a16_64bit_float.framebuffer_target=false
    # r8_g8_b8_a0_24bit_yuv_special (implicitly recordable)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_24bit_yuv_special.hal_format=0x23
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.arm.egl.configs.r8_g8_b8_a0_24bit_yuv_special.framebuffer_target=false
endif

ifeq ($(strip $(MTK_GPU_SUPPORT)), yes)
    PRODUCT_PACKAGES += libOpenCL
    PRODUCT_PACKAGES += libGLES_mali
    PRODUCT_PACKAGES += dumpfaultd
    PRODUCT_PACKAGES += libgpu_aux
    PRODUCT_PACKAGES += libgpud
    PRODUCT_PACKAGES += libgralloc_metadata
    PRODUCT_PACKAGES += libgralloctypes_mtk
    PRODUCT_PACKAGES += libRSDriver_mtk
    PRODUCT_PACKAGES += rs2spir
    PRODUCT_PACKAGES += spir2cl
    PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-impl-mediatek
    PRODUCT_PACKAGES += android.hardware.graphics.mapper@4.0-impl-mediatek
    PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek
    PRODUCT_PACKAGES += android.hardware.renderscript@1.0-impl
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.opengles.version=196610
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=mali
    PRODUCT_PACKAGES += valhall-1691526.wa
    PRODUCT_PACKAGES += vulkan.mali
    PRODUCT_PACKAGES += libgpudataproducer
endif
ifdef MTK_GENERIC_HAL
    PRODUCT_PACKAGES += libOpenCL
    PRODUCT_PACKAGES += libgpu_aux
    PRODUCT_PACKAGES += libgpud
    PRODUCT_PACKAGES += libgralloc_metadata
    PRODUCT_PACKAGES += libgralloctypes_mtk
    PRODUCT_PACKAGES += libRSDriver_mtk
    PRODUCT_PACKAGES += rs2spir
    PRODUCT_PACKAGES += spir2cl
    PRODUCT_PACKAGES += android.hardware.renderscript@1.0-impl
    PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gralloc=common

    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6893),)
      PRODUCT_PACKAGES += dumpfaultd.mt6893
      PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6893
    endif
    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6983),)
      PRODUCT_PACKAGES += dumpfaultd.mt6983
      # read MTK GPU VERSION from mgvi VendorConfig.mk
      ifneq ($(filter $(MTK_GPU_VERSION),r38p1),)
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6983_r38p1
      else
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6983
      endif
    endif
    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6895),)
      PRODUCT_PACKAGES += dumpfaultd.mt6895
      # read MTK GPU VERSION from mgvi VendorConfig.mk
      ifneq ($(filter $(MTK_GPU_VERSION),r38p1),)
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6895_r38p1
      else
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6895
      endif
    endif
    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6879),)
      PRODUCT_PACKAGES += dumpfaultd.mt6879
      # read MTK GPU VERSION from mgvi VendorConfig.mk
      ifneq ($(filter $(MTK_GPU_VERSION),r38p1),)
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6879_r38p1
      else
        PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6879
      endif
    endif
    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6789),)
      PRODUCT_PACKAGES += dumpfaultd.mt6789
      PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6789
    endif
    ifneq ($(filter $(MGVI_PLATFORM_GROUP),mt6855),)
      ifneq ($(filter $(MTK_GPU_VERSION),m24.2ED6620798),)
		PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6855_m24.2ED6620798
      else
      PRODUCT_PACKAGES += android.hardware.graphics.allocator@4.0-service-mediatek.mt6855
    endif
    endif
endif

ifeq ($(strip $(MTK_DT_SUPPORT)),yes)
  PRODUCT_PACKAGES += ip-up
  PRODUCT_PACKAGES += ip-down
  PRODUCT_PACKAGES += ppp_options
  PRODUCT_PACKAGES += chap-secrets
  PRODUCT_PACKAGES += init.gprs-pppd
endif

#OMA DRM part
ifeq ($(strip $(MTK_OMADRM_SUPPORT)), yes)
  #PRODUCT_PACKAGES += libdrmmtkutil
  #Media framework reads this property
  PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true
  #PRODUCT_PACKAGES += libdcfdecoderjni
  PRODUCT_PACKAGES += libdrmmtkplugin
  PRODUCT_PACKAGES += drm_chmod
endif
ifeq ($(strip $(MTK_CTA_SET)), yes)
  #PRODUCT_PACKAGES += libdrmmtkutil
  #Media framework reads this property
  PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true
  #PRODUCT_PACKAGES += libdcfdecoderjni
endif

############find all modules under custom folder
#define find-all-my-module
all_sensor_modules := $(addsuffix _tuning,$(notdir $(foreach f,$(CUSTOM_HAL_IMGSENSOR),$(wildcard vendor/mediatek/proprietary/custom/mt6885/hal/imgsensor/ver1/$(f)*))))

PRODUCT_PACKAGES += $(all_sensor_modules)
###############################################

ifeq ($(strip $(MTK_WEATHER_WIDGET_APP)), yes)
  PRODUCT_PACKAGES += MtkWeatherWidget
endif

ifeq ($(strip $(MTK_WFD_SINK_SUPPORT)), yes)
  PRODUCT_PACKAGES += MtkFloatMenu
endif

PRODUCT_PACKAGES += libsec
PRODUCT_PACKAGES += sbchk

# for USB Accessory Library/permission
# Mark for early porting in JB
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml
#PRODUCT_PACKAGES += com.android.future.usb.accessory

ifeq ($(strip $(MTK_VPU_SUPPORT)), yes)
    PRODUCT_PACKAGES += cam_vpu1.img
    PRODUCT_PACKAGES += cam_vpu2.img
    PRODUCT_PACKAGES += cam_vpu3.img
    PRODUCT_PACKAGES += libvpu
    PRODUCT_PACKAGES_DEBUG += vpu_test
endif


PRODUCT_PACKAGES += libapu_mdw
PRODUCT_PACKAGES += libapu_mdw_batch
PRODUCT_PACKAGES += apu_mdw_test
PRODUCT_PACKAGES += libapusys
PRODUCT_PACKAGES += apusys_test
PRODUCT_PACKAGES += libmdla_ut
PRODUCT_PACKAGES_DEBUG += mdla_player
ifeq ($(strip $(MTK_APUSYS_SUPPORT)), yes)
    PRODUCT_PACKAGES += libneuron_runtime
    PRODUCT_PACKAGES += libneuron_runtime.5
    PRODUCT_PACKAGES += libapusys_edma
    PRODUCT_PACKAGES_DEBUG += reviser_test
    PRODUCT_PACKAGES_DEBUG += edma_test
ifneq ($(filter $(TARGET_BUILD_VARIANT),eng userdebug),)
    PRODUCT_PACKAGES += neuronrt
    PRODUCT_PACKAGES += ncc-tflite
endif
endif

    PRODUCT_PACKAGES += libmvpu_config
ifeq ($(strip $(MGVI_MTK_VPU2_SUPPORT)), yes)
    PRODUCT_PACKAGES += libmvpu_engine
    PRODUCT_PACKAGES += libmvpu_pattern
    PRODUCT_PACKAGES += libmvpu_engine_pub
    PRODUCT_PACKAGES += libmvpu_pattern_pub
    PRODUCT_PACKAGES += mvpu_ptn_player
    PRODUCT_PACKAGES += mvpu_test
    PRODUCT_PACKAGES += libmvpu_clc_cl_compiler
    PRODUCT_PACKAGES += libmvpu_clc_mvpu_debuginfo
    PRODUCT_PACKAGES += libmvpu_clc_mvpu_elf
    PRODUCT_PACKAGES += libmvpu_clc_mvpu_utility
    PRODUCT_PACKAGES += libmvpu_clc_vpu_isa
    PRODUCT_PACKAGES += libmvpu_cic_ci_compiler

    PRODUCT_PACKAGES += libmvpu_runtime
    PRODUCT_PACKAGES += libmvpu_runtime_pub
    PRODUCT_PACKAGES += libmvpu_runtime_shim
    PRODUCT_PACKAGES += libmvpuop_mtk_cv
    PRODUCT_PACKAGES += libmvpuop_mtk_nn
    PRODUCT_PACKAGES += mvpu_runtime_test_simplecl
    PRODUCT_PACKAGES += mvpu_runtime_test_simpleci
    PRODUCT_PACKAGES += mvpu_runtime_test_dilatefilter
    PRODUCT_PACKAGES += mvpu_runtime_test_dilatefilter_shim
    PRODUCT_PACKAGES += mvpu_runtime_test_dilatefilter_pub_shim
    PRODUCT_PACKAGES += mvpu_runtime_test_dilatefilter_bv
    PRODUCT_PACKAGES += mvpu_runtime_test_l1usage_shim
    PRODUCT_PACKAGES += mvpu_runtime_test_l1usage_pub_shim
    PRODUCT_PACKAGES += mvpu_runtime_test_l1usage_bv
    PRODUCT_PACKAGES += mvpu_runtime_test_copybufferhw
    PRODUCT_PACKAGES += mvpu_runtime_test_copybuffersw
    PRODUCT_PACKAGES += mvpu_runtime_test_dotproductci
    PRODUCT_PACKAGES += mvpu_runtime_test_twocores
endif

#aurisys library parameters
ifeq ($(MTK_AURISYS_PHONE_CALL_SUPPORT),yes)
PRODUCT_PACKAGES += libfvaudio
#PRODUCT_PACKAGES += AudioSetParam
PRODUCT_COPY_FILES += $(LOCAL_PATH)/aurisys_param/phone_call/forte_media/FV-SAM-MTK2.dat:$(TARGET_COPY_OUT_VENDOR)/etc/FV-SAM-MTK2.dat:mtk
endif

ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
  PRODUCT_PACKAGES += keystore.mt6893
  PRODUCT_PACKAGES += libMcGatekeeper
  PRODUCT_PACKAGES += rda
endif

ifeq ($(strip $(MTK_TEE_TRUSTED_UI_SUPPORT)), yes)
  PRODUCT_PACKAGES += libTui
  PRODUCT_PACKAGES += TuiService
  PRODUCT_PACKAGES += SamplePinpad
  PRODUCT_PACKAGES += libTlcPinpad
endif

#tinyalsa tool
#ifneq ($(filter $(TARGET_BUILD_VARIANT),eng userdebug),)
#PRODUCT_PACKAGES += \
    #tinyplay \
    #tinycap \
    #tinymix \
    #tinyhostless \
    #tinypcminfo
#endif

ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
PRODUCT_PACKAGES   += 	keystore.mt6893
PRODUCT_PACKAGES   += 	gatekeeper.mt6893
PRODUCT_PACKAGES   += 	kmsetkey.mt6893
endif

# userspace sysenv
PRODUCT_PACKAGES += libsysenv
PRODUCT_PACKAGES += sysenv_daemon

# SCLTM Library
ifeq ($(strip $(MTK_SCLTM_SUPPORT)), yes)
    PRODUCT_PACKAGES += libscltm
endif

# add vintf utility
PRODUCT_PACKAGES += \
    #vintf

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-impl-mediatek \
    android.hardware.bluetooth@1.1-service-mediatek

# sound trigger HAL
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.3-impl

PRODUCT_PACKAGES += \
    fs_config_files_nonsystem

# vibrator HAL
ifneq ($(strip $(CUSTOM_KERNEL_VIBRATOR)), no)
PRODUCT_PACKAGES += \
    libvibratormediatekimpl \
    android.hardware.vibrator-service.mediatek
endif

# light HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.mediatek


# thermal HIDL
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-impl
ifneq ($(strip $(MTK_HIDL_PROCESS_CONSOLIDATION_ENABLED)), yes)
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.mtk
endif

# auto_precheck
PRODUCT_PACKAGES += recordevent
PRODUCT_PACKAGES += replayevent

# mtk av enhance
#PRODUCT_PACKAGES += libmtkavenhancements
PRODUCT_PACKAGES += libmtkmkvextractor
#PRODUCT_PACKAGES += libmtkmpeg2extractor

# Usb HAL
ifdef MTK_GENERIC_HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.2-service-mediatekv2
endif

# Chameleon lib
ifeq ($(strip $(MTK_CHAMELEON_DISPLAY_SUPPORT)), yes)
    PRODUCT_PACKAGES += libchameleon
endif

# GnssDebugReport
#PRODUCT_PACKAGES += GnssDebugReport

# NeuroPilot NN SDK
ifeq ($(strip $(MTK_NN_SDK_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_support=1
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn.option=A,B,E,F,Z
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_nn_quant_preferred=1
ifeq ($(TARGET_BUILD_VARIANT),eng)
ifeq ($(strip $(MTK_NN_SDK_LAZY_HAL_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.3-service-mtk-neuron-debug-lazy
else
    PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.3-service-mtk-neuron-debug
endif
else
ifeq ($(strip $(MTK_NN_SDK_LAZY_HAL_SUPPORT)), yes)
    PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.3-service-mtk-neuron-lazy
else
    PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.3-service-mtk-neuron
endif
endif
    PRODUCT_PACKAGES += libnir_neon_driver
    PRODUCT_PACKAGES += armnn_app.config
    PRODUCT_PACKAGES += libneuron_adapter
    ifneq ($(filter kernel-4.14 kernel-4.19,$(LINUX_KERNEL_VERSION)),)
        PRODUCT_PACKAGES += libneuron_platform
    endif
endif

# GiFT
ifeq ($(strip $(MTK_ARC_GIFT_SUPPORT)), yes)
    PRODUCT_PACKAGES += libMEOW_gift
endif

# RayTracing
ifeq ($(strip $(MGVI_MTK_RAY_TRACING_SUPPORT)), yes)
    PRODUCT_PACKAGES += libVkLayer_mtk_rt_sdk_init
    PRODUCT_PACKAGES += libVkLayer_mtk_rt_sdk
endif

# AI BluLight Defender
PRODUCT_PACKAGES += libaibld

# PQ feature
PRODUCT_PACKAGES += libneuron_runtime_dp

# ATMS HIDL
PRODUCT_PACKAGES += vendor.mediatek.hardware.camera.atms@1.0-impl

# IO-ML QoS
PRODUCT_PACKAGES += eara_io_service

# BIP UICC server mode in AP
ifdef MTK_GENERIC_HAL
    PRODUCT_PACKAGES += bip_ap
endif

# Multi media codec config
PRODUCT_COPY_FILES += $(LOCAL_PATH)/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml:mtk
ifneq ($(MTK_BASIC_PACKAGE), yes)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/media_codecs_mediatek_audio_phone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml:mtk
else
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/media_codecs_mediatek_audio_basic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml:mtk
endif
PRODUCT_COPY_FILES += $(LOCAL_PATH)/mtk_omx_core.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_omx_core.cfg:mtk
PRODUCT_COPY_FILES += frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/omx/mediacodec/android.hardware.media.omx@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.media.omx@1.0-service.rc

endif # MTK_GENERIC_HAL
############ Porting from mt6893/device.mk - END #################

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.wifi.sap.concurrent.iface=ap1

# vcodec need 3072 bytes padding
PRODUCT_PROPERTY_OVERRIDES += media.c2.dmabuf.padding=3072

# dynamic log
ifeq ($(MTK_PRODUCT_LINE), smart_phone)
PRODUCT_PACKAGES += libdynamiclog
endif

ifdef MTK_GENERIC_HAL
$(call inherit-product-if-exists,$(LOCAL_PATH)/device-camera.mk)
endif

PRODUCT_SOONG_NAMESPACES += $(wildcard vendor/mediatek/proprietary/hardware/omx/plugin/libstagefrighthw)

# Configure SurfaceFlinger sf-duration and app-duration for backpressure and latchsignaledbuffer mechanism
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.use_phase_offsets_as_durations?=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.sf.duration?=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.app.duration?=20000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.sf.duration?=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.app.duration?=20000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.sf.duration?=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.app.duration?=20000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.hwc.min.duration?=23000000

# set skiagl render engine
PRODUCT_PROPERTY_OVERRIDES += debug.renderengine.backend?=skiagl

#APEX dm-device creation timeout
PRODUCT_PROPERTY_OVERRIDES += apexd.config.dm_create.timeout=5000

#kcm added by phf, 20240819, for focaltech fingerprint
ifeq (yes,$(strip $(FOCALTECH_FINGERPRINT)))
       $(call inherit-product-if-exists, vendor/mediatek/proprietary/hardware/fingerprint/focaltech/focaltech.mk)
endif

#################################################
# device/mediatek/vendor/common/device.mk end   #
#################################################

# Do NOT modify below this line
_my_whitelist := \
  %.img \
  $(TARGET_COPY_OUT_SYSTEM)/apex/com.android.apex.cts.shim.apex \
  $(TARGET_COPY_OUT_SYSTEM)/bin/snapuserd \
  $(TARGET_COPY_OUT_SYSTEM)/etc/init/snapuserd.rc \
  $(TARGET_COPY_OUT_RAMDISK)/system/bin/e2fsck \
  $(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/system/bin/e2fsck \
  $(TARGET_COPY_OUT_DEBUG_RAMDISK)/userdebug_plat_sepolicy.cil \
  $(TARGET_COPY_OUT_ROOT)/init.environ.rc \

_my_paths := \
  $(TARGET_COPY_OUT_VENDOR)/ \
  $(TARGET_COPY_OUT_VENDOR_DLKM)/ \
  $(TARGET_COPY_OUT_ODM)/ \
  $(TARGET_COPY_OUT_ODM_DLKM)/ \
  $(TARGET_COPY_OUT_VENDOR_RAMDISK)/ \
  $(TARGET_COPY_OUT_RECOVERY)/root/system/ \
  $(TARGET_COPY_OUT_SYSTEM_EXT)/etc/selinux/ \
  $(TARGET_COPY_OUT_DATA)/nativetest/ \
  $(TARGET_COPY_OUT_DATA)/nativetest64/ \
  testcases/ \

ifneq ($(wildcard vendor/mediatek/internal/build),)
MTK_SPLIT_BUILD_CHECKER ?= yes
endif
ifeq ($(MTK_SPLIT_BUILD_CHECKER),yes)
ifdef HAL_TARGET_PROJECT
$(call require-artifacts-in-path-relaxed, $(_my_paths), $(_my_whitelist))
endif
endif
