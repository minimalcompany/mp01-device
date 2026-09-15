MTK_PATH_SOURCE := vendor/mediatek/proprietary
MTK_ROOT := vendor/mediatek/proprietary
MTK_PATH_COMMON := vendor/mediatek/proprietary/custom/common
# Use TARGET_BOARD_PLATFORM if exits, otherwise use MTK_PLATFORM_DIR
MTK_PATH_CUSTOM_PLATFORM := $(strip $(firstword $(wildcard vendor/mediatek/proprietary/custom/$(TARGET_BOARD_PLATFORM)) $(wildcard vendor/mediatek/proprietary/custom/$(MTK_PLATFORM_DIR))))
ifneq ($(wildcard device/mediatek/$(TARGET_BOARD_PLATFORM)),)
MTK_REL_PLATFORM := $(TARGET_BOARD_PLATFORM)
else
MTK_REL_PLATFORM := $(MTK_PLATFORM_DIR)
endif
ifdef TARGET_BOARD_PLATFORM
ifneq ($(TARGET_BOARD_PLATFORM),common)
ifeq ($(USE_DEFAULT_MGVI_PLATFORM_GROUP),yes)
  MGVI_PLATFORM_GROUP := $(filter $(TARGET_BOARD_PLATFORM),$(MGVI_PLATFORM_GROUP))
  MTKCAM_PLATFORM_GROUP := $(filter $(TARGET_BOARD_PLATFORM),$(MTKCAM_PLATFORM_GROUP))
endif
endif
endif

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
# add default super partition size here, will be overwritten by partition_size.mk
BOARD_SUPER_PARTITION_SIZE := 6442450944
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true
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
MTK_PTGEN_PRODUCT_OUT := $(MTK_PTGEN_OUT_DIR)/target/product/$(TARGET_DEVICE)
MTK_PTGEN_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN
MTK_PTGEN_MK_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN
MTK_PTGEN_TMP_OUT := $(MTK_PTGEN_PRODUCT_OUT)/obj/PTGEN_TMP

TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_DEVICE)

# Define MTK ota and secure boot tool extension
TARGET_RELEASETOOLS_EXTENSIONS := vendor/mediatek/proprietary/scripts/releasetools
SECURITY_SIG_TOOL := vendor/mediatek/proprietary/scripts/sign-image/sign_image.sh
SECURITY_IMAGE_PATH := vendor/mediatek/proprietary/custom/$(MTK_PLATFORM_DIR)/security/cert_config/img_list.txt

# lk enhance menu
ifeq ($(TARGET_BUILD_VARIANT),user)
ifneq ($(wildcard vendor/mediatek/internal/enhance_menu),)
BOARD_BUILD_ENHANCE_MENU:=yes
else
BOARD_BUILD_ENHANCE_MENU:=no
endif
endif

BOARD_SIGN_IMG ?= yes

ifndef HAL_TARGET_PROJECT

ifneq ($(filter 3 4,$(BOARD_BOOT_HEADER_VERSION)),)
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
endif

ifeq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
ifeq ($(filter 3 4,$(BOARD_BOOT_HEADER_VERSION)),)
BOARD_USES_RECOVERY_AS_BOOT := true
endif
TARGET_NO_RECOVERY := true
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := boot system vendor
ifeq ($(strip $(TARGET_COPY_OUT_PRODUCT)),product)
AB_OTA_PARTITIONS += product
endif
#else
#BOARD_INCLUDE_RECOVERY_DTBO := true
endif
BOARD_AVB_ENABLE := true
MAIN_VBMETA_IN_BOOT ?= no
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

endif#HAL_TARGET_PROJECT

#Add MTK's Recovery fstab definitions
TARGET_RECOVERY_FSTAB := $(MTK_PTGEN_PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(TARGET_BOARD_PLATFORM)

ifndef MTK_USE_PREBUILT_BOOTIMAGE
ifneq ($(filter user,$(TARGET_BUILD_VARIANT)),)
MTK_USE_PREBUILT_BOOTIMAGE := yes
endif#TARGET_BUILD_VARIANT
endif#MTK_USE_PREBUILT_BOOTIMAGE
ifeq ($(MTK_USE_PREBUILT_BOOTIMAGE),yes)
ifeq ($(MTK_K64_SUPPORT),yes)
MTK_KERNEL_ARCH := aarch64
else
MTK_KERNEL_ARCH := arm
endif
MTK_BOARD_PREBUILT_BOOTIMAGE := $(wildcard vendor/aosp_gki/$(LINUX_KERNEL_VERSION)/$(MTK_KERNEL_ARCH)/boot.img)
ifeq ($(LINUX_KERNEL_VERSION),kernel-6.6)
ifeq (,$(strip $(MTK_KERNEL_COMPRESS_FORMAT)))
MTK_KERNEL_COMPRESS_FORMAT := gz
endif
MTK_BOARD_PREBUILT_BOOTIMAGE := $(wildcard vendor/aosp_gki/$(LINUX_KERNEL_VERSION)/aarch64/boot-gz.img)
endif
ifneq ($(MTK_BOARD_PREBUILT_BOOTIMAGE),)
ifeq ($(BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE),true)
TARGET_NO_KERNEL := true
endif
BOARD_RAMDISK_USE_LZ4 := true
BOARD_PREBUILT_BOOTIMAGE := $(MTK_BOARD_PREBUILT_BOOTIMAGE)
endif
endif#MTK_USE_PREBUILT_BOOTIMAGE

ifndef HAL_TARGET_PROJECT
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_USES_NETWORK := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
ifneq ($(wildcard vendor/mediatek/internal),)
ifneq ($(COVERITY_LOCAL_SCAN),yes)
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := false
endif
endif
DISABLE_MTK_CONFIG_CHECK := yes
endif#HAL_TARGET_PROJECT

TARGET_KERNEL_USE_CLANG ?= true

ifeq ($(MTK_K64_SUPPORT), yes)
KERNEL_TARGET_ARCH := arm64
else
KERNEL_TARGET_ARCH := arm
endif
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

ifeq ($(strip $(MTK_PLATFORM_DTB_NAME)),)
ifeq ($(MTK_K64_SUPPORT), yes)
PLATFORM_DTB_NAME := mediatek/$(TARGET_BOARD_PLATFORM)
else
PLATFORM_DTB_NAME := $(TARGET_BOARD_PLATFORM)
endif
else
PLATFORM_DTB_NAME := $(MTK_PLATFORM_DTB_NAME)
endif

ifeq ($(strip $(MTK_PROJECT_DTB_NAMES)),)
ifdef VEXT_TARGET_PROJECT
ifeq ($(MTK_K64_SUPPORT), yes)
PROJECT_DTB_NAMES := mediatek/$(VEXT_TARGET_PROJECT)
else
PROJECT_DTB_NAMES := $(VEXT_TARGET_PROJECT)
endif
else
ifeq ($(MTK_K64_SUPPORT), yes)
PROJECT_DTB_NAMES ?= mediatek/$(MTK_TARGET_PROJECT)
else
PROJECT_DTB_NAMES ?= $(MTK_TARGET_PROJECT)
endif
endif
else
PROJECT_DTB_NAMES := $(MTK_PROJECT_DTB_NAMES)
endif

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(MTK_PTGEN_PRODUCT_OUT)/obj/PACKAGING/dtb
BOARD_PREBUILT_DTBOIMAGE := $(MTK_PTGEN_PRODUCT_OUT)/obj/PACKAGING/dtboimage/dtbo.img

ifneq (,$(filter kernel-5.4 kernel-5.10 kernel-6.6 kernel-mainline,$(strip $(LINUX_KERNEL_VERSION))))
KERNEL_OUT ?= $(OUT_DIR)/target/product/$(TARGET_DEVICE)/obj/KERNEL_OBJ/$(LINUX_KERNEL_VERSION)
endif
KERNEL_OUT ?= $(OUT_DIR)/target/product/$(TARGET_DEVICE)/obj/KERNEL_OBJ

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
    SET_RECOVERY_AS_CHAIN ?= yes

    ifeq ($(strip $(MAIN_VBMETA_IN_BOOT)),no)
        ifeq ($(strip $(SET_RECOVERY_AS_CHAIN)),yes)
            #settings for recovery, which is configured as chain partition
            BOARD_AVB_RECOVERY_KEY_PATH := device/mediatek/vendor/common/$(AVB_KEY_PATH)/recovery_prvk.pem
            BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
            BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 0
            # Always assign "1" to BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION
            # if MTK_OTP_FRAMEWORK_V2 is turned on in LK. In other words,
            # rollback_index_location "1" can only be assigned to
            # recovery partition.
            BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
        endif
    endif
endif

# For Kernel Touch KO copy
ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-6.6)
REL_KERNEL_DEVICE_MODULE_DIR := kernel_device_modules-$(word 2,$(subst -, ,$(LINUX_KERNEL_VERSION)))
BOARD_VENDOR_KERNEL_MODULES += $(foreach TOUCH,$(MTK_TOUCH_KO),$(KERNEL_OUT)/../$(REL_KERNEL_DEVICE_MODULE_DIR)/drivers/input/touchscreen/$(TOUCH)/$(call to-lower,$(TOUCH)).ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD += $(foreach TOUCH,$(MTK_TOUCH_KO),$(KERNEL_OUT)/../$(REL_KERNEL_DEVICE_MODULE_DIR)/drivers/input/touchscreen/$(TOUCH)/$(call to-lower,$(TOUCH)).ko)
BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_OUT)/../$(REL_KERNEL_DEVICE_MODULE_DIR)/drivers/input/touchscreen/tui-common.ko
else
BOARD_VENDOR_KERNEL_MODULES += $(foreach TOUCH,$(MTK_TOUCH_KO),$(KERNEL_OUT)/drivers/input/touchscreen/$(TOUCH)/$(call to-lower,$(TOUCH)).ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD += $(foreach TOUCH,$(MTK_TOUCH_KO),$(KERNEL_OUT)/drivers/input/touchscreen/$(TOUCH)/$(call to-lower,$(TOUCH)).ko)
endif

ifneq (,$(wildcard vendor/mediatek/kernel_modules/mtk_input))
ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-6.6)
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
ifeq ($(strip $(MTK_FINGERPRINT_SUPPORT)),yes)
ifeq ($(strip $(MTK_FINGERPRINT_SELECT)),$(filter $(MTK_FINGERPRINT_SELECT), GF5216 GF3658))
BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_OUT)/../vendor/mediatek/kernel_modules/mtk_input/fingerprint/goodix/6.6/gf_spi.ko
BOARD_VENDOR_KERNEL_MODULES_LOAD += $(KERNEL_OUT)/../vendor/mediatek/kernel_modules/mtk_input/fingerprint/goodix/6.6/gf_spi.ko
endif
endif
endif
endif
endif

ifeq ($(strip $(LINUX_KERNEL_VERSION)),kernel-6.6)
ALL_LOADED_GKI_MODULES := $(patsubst kernel/%,%,$(shell cat kernel/prebuilts/$(subst kernel-,,$(strip $(LINUX_KERNEL_VERSION)))/arm64/modules.load))
ifeq ($(MTK_K64_SUPPORT), yes)
ifneq ($(MTK_BOARD_PREBUILT_BOOTIMAGE),)
BOARD_SYSTEM_KERNEL_MODULES_LOAD += $(addprefix $(KERNEL_OUT)/../prebuilts/,$(notdir $(ALL_LOADED_GKI_MODULES)))
else
BOARD_SYSTEM_KERNEL_MODULES_LOAD += $(addprefix $(KERNEL_OUT)/,$(ALL_LOADED_GKI_MODULES))
endif
endif
endif

# Set TINYSYS_PLATFORM default value as TARGET_BOARD_PLATFORM
TINYSYS_PLATFORM ?= $(TARGET_BOARD_PLATFORM)

ifneq ($(wildcard keystone-tools),)
BOARD_DEEP_GPT_UPDATE:=yes
endif

#Add MTK's hook
ifndef HAL_TARGET_PROJECT
-include device/mediatek/build/core/base_rule_hook.mk
-include vendor/mediatek/build/core/base_rule_hook.mk
endif

# Add defalut recovery mode drm format
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
