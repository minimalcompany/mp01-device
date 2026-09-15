ifdef SYS_TARGET_PROJECT
# For virtual project
include $(wildcard $(SYS_PROJECT_FOLDER)/BoardConfig.mk)
else ifdef HAL_TARGET_PROJECT
else ifeq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/vnd_*.mk),)
# For legacy project
include $(wildcard device/mediatek/system/common/BoardConfig.mk)
endif
TARGET_NO_KERNEL :=
ifndef HAL_TARGET_PROJECT
include device/mediatek/vendor/common/BoardConfig-kernel.mk
include device/mediatek/vendor/common/BoardConfig-vext.mk
else
include device/mediatek/vendor/common/BoardConfig-image.mk
endif
ifndef HAL_TARGET_PROJECT
ifdef MTK_TARGET_PROJECT_FOLDER
HAL_VENDOR_CONFIG_MK ?= $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk
KRN_KERNEL_CONFIG_MK ?= $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk
VEXT_PROJECT_CONFIG_MK ?= $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk
endif
endif
ifdef MGVI_PLATFORM_GROUP
MTKCAM_PLATFORM_GROUP := $(MGVI_PLATFORM_GROUP)
else
MTKCAM_PLATFORM_GROUP := $(call to-lower,$(MTK_PLATFORM))
endif

BOARD_CONNECTIVITY_VENDOR := MediaTek
BOARD_USES_MTK_AUDIO := true


MTK_GLOBAL_C_INCLUDES:=
MTK_GLOBAL_CFLAGS:=
MTK_GLOBAL_CONLYFLAGS:=
MTK_GLOBAL_CPPFLAGS:=
MTK_GLOBAL_LDFLAGS:=

# Use the non-open-source part, if present
-include vendor/mediatek/common/BoardConfigVendor.mk

# Use the connectivity Boardconfig
include device/mediatek/vendor/common/connectivity/BoardConfig.mk

# Use ago BoardConfig, if present
-include device/mediatek/vendor/common/ago/BoardConfig.mk

# for flavor build base project assignment
ifneq ($(strip $(VEXT_BASE_PROJECT)),)
  MTK_PROJECT_NAME := $(VEXT_BASE_PROJECT)
else ifneq ($(strip $(MTK_BASE_PROJECT)),)
  MTK_PROJECT_NAME := $(MTK_BASE_PROJECT)
else
  MTK_PROJECT_NAME := $(subst full_,,$(TARGET_PRODUCT))
endif
MTK_PROJECT := $(MTK_PROJECT_NAME)
MTK_PATH_SOURCE := vendor/mediatek/proprietary
MTK_ROOT := vendor/mediatek/proprietary
MTK_PATH_COMMON := vendor/mediatek/proprietary/custom/common
ifdef MTK_PROJECT
MTK_PATH_CUSTOM := vendor/mediatek/proprietary/custom/$(MTK_PROJECT)
endif
# Use TARGET_BOARD_PLATFORM if exits, otherwise use MTK_PLATFORM_DIR
MTK_PATH_CUSTOM_PLATFORM := $(strip $(firstword $(wildcard vendor/mediatek/proprietary/custom/$(TARGET_BOARD_PLATFORM)) $(wildcard vendor/mediatek/proprietary/custom/$(MTK_PLATFORM_DIR))))
ifneq ($(wildcard device/mediatek/$(TARGET_BOARD_PLATFORM)),)
MTK_REL_PLATFORM := $(TARGET_BOARD_PLATFORM)
else
MTK_REL_PLATFORM := $(MTK_PLATFORM_DIR)
endif
ifeq ($(strip $(MTK_K64_SUPPORT)),yes)
KERNEL_CROSS_COMPILE := $(PWD)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-gnu-6.3.1/bin/aarch64-linux-gnu-
else
KERNEL_CROSS_COMPILE := $(PWD)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
endif
TARGET_BOARD_KERNEL_HEADERS :=
ifneq ($(strip $(MTK_REL_PLATFORM)),)
ifneq ($(MTK_REL_PLATFORM),common)
TARGET_BOARD_KERNEL_HEADERS += device/mediatek/$(MTK_REL_PLATFORM)/kernel-headers
endif
endif

ifdef MTK_GENERIC_HAL
# for LD2.0, include mt6893/kernel-headers as default
TARGET_BOARD_KERNEL_HEADERS += device/mediatek/mt6893/kernel-headers
endif

TARGET_BOARD_KERNEL_HEADERS += device/mediatek/common/kernel-headers
TARGET_BOARD_KERNEL_HEADERS += device/mediatek/vendor/common/kernel-headers

MTK_GLOBAL_C_INCLUDES += $(MTK_PATH_CUSTOM)/cgen/cfgdefault $(MTK_PATH_CUSTOM)/cgen/cfgfileinc $(MTK_PATH_CUSTOM)/cgen/inc $(MTK_PATH_CUSTOM)/cgen
ifneq ($(strip $(MTK_REL_PLATFORM)),)
MTK_GLOBAL_C_INCLUDES += $(MTK_PATH_CUSTOM_PLATFORM)/cgen/cfgdefault $(MTK_PATH_CUSTOM_PLATFORM)/cgen/cfgfileinc $(MTK_PATH_CUSTOM_PLATFORM)/cgen/inc $(MTK_PATH_CUSTOM_PLATFORM)/cgen
endif
MTK_GLOBAL_C_INCLUDES += $(MTK_PATH_COMMON)/cgen/cfgdefault $(MTK_PATH_COMMON)/cgen/cfgfileinc $(MTK_PATH_COMMON)/cgen/inc $(MTK_PATH_COMMON)/cgen

# Add MTK compile options to wrap MTK's modifications on AOSP.
ifneq ($(strip $(MTK_BASIC_PACKAGE)),yes)
  MTK_BOARD_CONFIG_AOSP_ENH_DEFINED := yes
  MTK_GLOBAL_CFLAGS += -DMTK_AOSP_ENHANCEMENT
endif

# Add vendor BoardConfig defined flag for virtual project on splti build
MTK_BOARD_VENDOR_COMMON_DEFINED := yes

# TODO: remove MTK_PATH_PLATFORM
MTK_PATH_PLATFORM := $(MTK_PATH_SOURCE)/platform/$(MTK_PLATFORM_DIR)
GOOGLE_RELEASE_RIL := no

ifeq ($(strip $(CUSTOM_BUILD_VERNO)),)
  CUSTOM_BUILD_VERNO_HDR := $(shell echo $(firstword $(BUILD_NUMBER)) | cut -b 1-15)
else
  CUSTOM_BUILD_VERNO_HDR := $(shell echo $(firstword $(CUSTOM_BUILD_VERNO)) | cut -b 1-15)
endif

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
# add default super partition size here, will be overwritten by partition_size.mk
BOARD_SUPER_PARTITION_SIZE := 6442450944
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true
endif
ifndef VEXT_TARGET_PROJECT
# add default boot partition size here, will be overwritten by partition_size.mk
BOARD_BOOTIMAGE_PARTITION_SIZE ?= 41943040
endif

#Enable HWUI by default
USE_OPENGL_RENDERER := true

#SELinux Policy File Configuration
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS := \
        device/mediatek/sepolicy/basic/non_plat
BOARD_PLAT_PUBLIC_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_private
  ifeq ($(strip $(HAVE_MTK_DEBUG_SEPOLICY)), yes)
    BOARD_SEPOLICY_DIRS += \
          device/mediatek/sepolicy/basic/debug/non_plat
    BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
          device/mediatek/sepolicy/basic/debug/plat_public
    BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
          device/mediatek/sepolicy/basic/debug/plat_private
  endif
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS := \
        device/mediatek/sepolicy/basic/non_plat \
        device/mediatek/sepolicy/bsp/non_plat
BOARD_PLAT_PUBLIC_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_public \
        device/mediatek/sepolicy/bsp/plat_public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_private \
        device/mediatek/sepolicy/bsp/plat_private
  ifeq ($(strip $(HAVE_MTK_DEBUG_SEPOLICY)), yes)
    BOARD_SEPOLICY_DIRS += \
          device/mediatek/sepolicy/basic/debug/non_plat \
          device/mediatek/sepolicy/bsp/debug/non_plat
    BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
          device/mediatek/sepolicy/basic/debug/plat_public \
          device/mediatek/sepolicy/bsp/debug/plat_public
    BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
          device/mediatek/sepolicy/basic/debug/plat_private \
          device/mediatek/sepolicy/bsp/debug/plat_private
  endif
endif

# MTK Internal SELinux Policy File Configuration
BOARD_SEPOLICY_DIRS += \
        device/mediatek/sepolicy/internal/non_plat
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
        device/mediatek/sepolicy/internal/plat_public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
        device/mediatek/sepolicy/internal/plat_private

#widevine data migration for OTA upgrade from O to P
ifneq ($(call math_lt,$(PRODUCT_SHIPPING_API_LEVEL),28),)
BOARD_SEPOLICY_DIRS += $(wildcard device/mediatek/sepolicy/bsp/ota_upgrade)
endif

#kcm added by phf, 20240825, for focaltech fingerprint sepolicy
ifeq (yes,$(strip $(FOCALTECH_FINGERPRINT)))
  BOARD_VENDOR_SEPOLICY_DIRS += vendor/mediatek/proprietary/hardware/fingerprint/focaltech/sepolicy
endif

ifneq ($(MTK_BUILD_IGNORE_IMS_REPO),yes)
ifdef CUSTOM_MODEM
  ifeq ($(strip $(TARGET_BUILD_VARIANT)),eng)
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  else
    MTK_MODEM_MODULE_MAKEFILES := $(foreach item,$(CUSTOM_MODEM),$(firstword $(wildcard vendor/mediatek/proprietary/modem/$(patsubst %_prod,%,$(item))_prod/Android.mk vendor/mediatek/proprietary/modem/$(item)/Android.mk)))
  endif
  MTK_MODEM_APPS_SEPOLICY_DIRS :=
  $(foreach f,$(MTK_MODEM_MODULE_MAKEFILES),\
    $(if $(strip $(MTK_MODEM_APPS_SEPOLICY_DIRS)),,\
      $(eval MTK_MODEM_APPS_SEPOLICY_DIRS := $(wildcard $(patsubst %/Android.mk,%/sepolicy/s0,$(f))))\
    )\
  )
BOARD_SEPOLICY_DIRS += $(MTK_MODEM_APPS_SEPOLICY_DIRS)
endif
endif

# Include an expanded selection of fonts
EXTENDED_FONT_FOOTPRINT := true

# To disable AOSP rild
ENABLE_VENDOR_RIL_SERVICE := true

ifeq (yes,$(strip $(MTK_GMO_RAM_OPTIMIZE)))
     BOARD_MTK_GMO_VENDOR_SIZE_KB := 417792
     BOARD_MTK_GMO_CACHE_SIZE_KB  := 114688
endif

PERL := prebuilts/perl/linux-x86/bin/perl

# Add MTK's MTK_PTGEN_OUT definitions
ifeq (,$(strip $(OUT_DIR)))
  ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
    MTK_PTGEN_OUT_DIR := $(TOPDIR)out
  else
    MTK_PTGEN_OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
  endif
else
    MTK_PTGEN_OUT_DIR := $(strip $(OUT_DIR))
endif
# Change flavor progect to base project
MTK_PTGEN_PRODUCT_OUT := $(MTK_PTGEN_OUT_DIR)/target/product/$(TARGET_DEVICE)

ifneq ($(CALLED_FROM_SETUP),true)
ifdef VEXT_TARGET_PROJECT
else ifdef MTK_TARGET_PROJECT
ifneq ($(strip $(MTK_TARGET_PROJECT)), $(strip $(TARGET_DEVICE)))
$(shell mkdir -p $(OUT_DIR)/target/product && ln -sfn $(TARGET_DEVICE) $(OUT_DIR)/target/product/$(MTK_TARGET_PROJECT))
endif
endif
endif

MTK_PTGEN_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN
MTK_PTGEN_MK_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN
MTK_PTGEN_TMP_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN_TMP

TARGET_CUSTOM_OUT := $(MTK_PTGEN_PRODUCT_OUT)/custom

# Define MTK Recovery updater
ifneq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
  TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_mtk
  TARGET_RECOVERY_UPDATER_EXTRA_LIBS := libpartition
endif

# Define MTK Recovery UI
MTK_RECOVERY_MEDIUM_RES := yes
TARGET_RECOVERY_UI_LIB := librecovery_ui_mtk

# Add defalut recovery mode drm format
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Define MTK ota and secure boot tool extension
TARGET_RELEASETOOLS_EXTENSIONS := vendor/mediatek/proprietary/scripts/releasetools
SECURITY_SIG_TOOL := vendor/mediatek/proprietary/scripts/sign-image/sign_image.sh
SECURITY_IMAGE_PATH := vendor/mediatek/proprietary/custom/$(MTK_PLATFORM_DIR)/security/cert_config/img_list.txt

ifeq ($(BUILD_GMS),yes)
  ifeq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
    DONT_DEXPREOPT_PREBUILTS := false
  else
    DONT_DEXPREOPT_PREBUILTS := true
  endif
else
  ifeq ($(TARGET_BUILD_VARIANT),userdebug)
    DEX_PREOPT_DEFAULT := nostripping
  endif
endif

ifeq (yes,$(BUILD_MTK_LDVT))
MTK_RELEASE_GATEKEEPER := no
endif
ifeq (yes,$(MTK_BASIC_PACKAGE))
MTK_RELEASE_GATEKEEPER := no
endif

ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_USES_NETWORK := true
SKIP_BOOT_JARS_CHECK := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
ifneq ($(wildcard vendor/mediatek/internal),)
ifneq ($(COVERITY_LOCAL_SCAN),yes)
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := false
endif
endif

# define S VF setting ro.board.first_api_level for S MGVI
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
#BOARD_SHIPPING_API_LEVEL := 31
endif

# Assign target level version
ifneq ($(call math_lt,$(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),28),)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_o.xml
else ifneq ($(call math_lt,$(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),29),)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_p.xml
else ifneq ($(call math_lt,$(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),30),)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_q.xml
else ifneq ($(call math_lt,$(PRODUCT_SHIPPING_API_LEVEL_OVERRIDE),31),)
    DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_r.xml
else
    ifneq ($(strip $(MTK_GENERIC_HAL)), yes)
        DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_r.xml
    else
        DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest_target_level_s.xml
    endif
endif

ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
DEVICE_MANIFEST_FILE += device/mediatek/vendor/common/manifest.xml
DEVICE_MATRIX_FILE := device/mediatek/vendor/common/compatibility_matrix.xml
else
    ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/manifest.xml),)
        DEVICE_MANIFEST_FILE += $(MTK_TARGET_PROJECT_FOLDER)/manifest.xml
        DEVICE_MATRIX_FILE := $(MTK_TARGET_PROJECT_FOLDER)/compatibility_matrix.xml
    else
        DEVICE_MANIFEST_FILE += device/mediatek/$(MTK_REL_PLATFORM)/manifest.xml
        DEVICE_MATRIX_FILE := device/mediatek/$(MTK_REL_PLATFORM)/compatibility_matrix.xml
    endif
endif

ifneq ($(filter 3 4,$(BOARD_BOOT_HEADER_VERSION)),)
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
endif

# A/B System updates
ifeq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
ifeq ($(filter 3 4,$(BOARD_BOOT_HEADER_VERSION)),)
BOARD_USES_RECOVERY_AS_BOOT := true
endif
TARGET_NO_RECOVERY := true
AB_OTA_UPDATER := true

ifeq ($(strip $(TARGET_COPY_OUT_PRODUCT)),product)
# A/B OTA partitions
AB_OTA_PARTITIONS := \
boot \
system \
product \
vendor
else
AB_OTA_PARTITIONS := \
boot \
system \
vendor
endif

# Install odex files into the other system image
BOARD_USES_SYSTEM_OTHER_ODEX := true

# A/B OTA dexopt update_engine hookup
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true
else
BOARD_INCLUDE_RECOVERY_DTBO := true
endif

#settings for main vbmeta
BOARD_AVB_ENABLE ?= true

#########################################
#
# Configure Product Security Level Here
#
#########################################
SEC_LEVEL := 0
AVB_KEY_PATH := key/rsa2048
AVB_ALGO := SHA256_RSA2048
ifeq ($(SEC_LEVEL), 1)
    AVB_ALGO := SHA256_RSA4096
    AVB_KEY_PATH := key/rsa4096
else ifeq ($(SEC_LEVEL), 2)
    AVB_ALGO := SHA256_RSA8192
    AVB_KEY_PATH := key/rsa8192
else
    $(warning SEC_LEVEL=$(SEC_LEVEL) invalid, use 0 as default.)
endif

#setting for main vbmeta in boot
MAIN_VBMETA_IN_BOOT ?= no

ifneq ($(strip $(BOARD_AVB_ENABLE)), true)
    # if avb2.0 is not enabled
    #$(call inherit-product, build/target/product/verity.mk)
else

    BOARD_AVB_ALGORITHM ?= $(AVB_ALGO)
    BOARD_AVB_KEY_PATH ?= device/mediatek/vendor/common/$(AVB_KEY_PATH)/oem_prvk.pem
    BOARD_AVB_ROLLBACK_INDEX ?= 0

    SET_RECOVERY_AS_CHAIN ?= yes

    ifeq ($(strip $(MAIN_VBMETA_IN_BOOT)),no)
        ifeq ($(strip $(SET_RECOVERY_AS_CHAIN)),yes)
            #settings for recovery, which is configured as chain partition
            BOARD_AVB_RECOVERY_KEY_PATH := device/mediatek/vendor/common/$(AVB_KEY_PATH)/recovery_prvk.pem
            BOARD_AVB_RECOVERY_ALGORITHM := $(AVB_ALGO)
            BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 0
            # Always assign "1" to BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION
            # if MTK_OTP_FRAMEWORK_V2 is turned on in LK. In other words,
            # rollback_index_location "1" can only be assigned to
            # recovery partition.
            BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
        endif
        BOARD_AVB_BOOT_KEY_PATH := device/mediatek/vendor/common/$(AVB_KEY_PATH)/boot_prvk.pem
        BOARD_AVB_BOOT_ALGORITHM := $(AVB_ALGO)
        BOARD_AVB_BOOT_ROLLBACK_INDEX := 0
        BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3
    endif

    ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
        BOARD_AVB_VBMETA_VENDOR := vendor
        BOARD_AVB_VBMETA_VENDOR_KEY_PATH := device/mediatek/vendor/common/$(AVB_KEY_PATH)/vendor_prvk.pem
        BOARD_AVB_VBMETA_VENDOR_ALGORITHM := $(AVB_ALGO)
        BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := 0
        BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 4
    else
        BOARD_AVB_VENDOR_KEY_PATH := device/mediatek/vendor/common/$(AVB_KEY_PATH)/vendor_prvk.pem
        BOARD_AVB_VENDOR_ALGORITHM := $(AVB_ALGO)
        BOARD_AVB_VENDOR_ROLLBACK_INDEX := 0
        BOARD_AVB_VENDOR_ROLLBACK_INDEX_LOCATION := 4
    endif

    BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
    BOARD_AVB_ODM_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
    BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
    BOARD_AVB_ODM_DLKM_ADD_HASHTREE_FOOTER_ARGS := --hash_algorithm sha256
endif

# Temp add TOP to keep NINJA_ENV
BUILD_BROKEN_NINJA_USES_ENV_VARS := TOP
BUILD_BROKEN_NINJA_USES_ENV_VARS += CCACHE_DIR
BUILD_BROKEN_NINJA_USES_ENV_VARS += CCACHE_READONLY
BUILD_BROKEN_NINJA_USES_ENV_VARS += CCACHE_TEMPDIR

# Set TINYSYS_PLATFORM default value as TARGET_BOARD_PLATFORM
TINYSYS_PLATFORM ?= $(TARGET_BOARD_PLATFORM)

# Set TARGET_VCODEC_PLATFORM default value as TARGET_BOARD_PLATFORM
TARGET_VCODEC_PLATFORM ?= $(TARGET_BOARD_PLATFORM)

# Set TEE_BRM_PLATFORM default value as TARGET_BOARD_PLATFORM
TEE_BRM_PLATFORM ?= $(TARGET_BOARD_PLATFORM)

# hal ca release
ifdef MTK_GENERIC_HAL
MGVI_MTK_TEE_RELEASE := yes
ifeq (yes, $(strip $(MGVI_MTK_TEE_RELEASE)))
TRUSTONIC_TEE_VERSION ?= 510
MICROTRUST_TEE_VERSION ?= 450
endif
endif

#Add MTK's hook
-include device/mediatek/build/core/base_rule_hook.mk
-include vendor/mediatek/build/core/base_rule_hook.mk
-include vendor/mediatek/build/core/rpgen.mk

include vendor/nxp/pn8xt/BoardConfigNfc.mk
#enable widevine to suppport 64bit
ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
TARGET_ENABLE_MEDIADRM_64 := true
endif
