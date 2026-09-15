include device/mediatek/vendor/common/BoardConfig-image.mk
include device/mediatek/vendor/common/BoardConfig-vext.mk

ifneq ($(wildcard vendor/mediatek/internal/mtklog_enable),)
  HAVE_VEXT_DEBUG_SEPOLICY := yes
else ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
  HAVE_VEXT_DEBUG_SEPOLICY := yes
else ifeq ($(strip $(MTK_LOG_CUSTOMER_SUPPORT)),yes)
  HAVE_VEXT_DEBUG_SEPOLICY := yes
else
  HAVE_VEXT_DEBUG_SEPOLICY := no
endif

#SELinux Policy File Configuration
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS := \
        device/mediatek/sepolicy/basic/non_plat
BOARD_PLAT_PUBLIC_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR := \
        device/mediatek/sepolicy/basic/plat_private
  ifeq ($(strip $(HAVE_VEXT_DEBUG_SEPOLICY)), yes)
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
  ifeq ($(strip $(HAVE_VEXT_DEBUG_SEPOLICY)), yes)
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

ifneq ($(PRODUCT_USERDATAIMAGE_FILE_SYSTEM_TYPE_EXT4), true)
# File System: Enable f2fs in data partition
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
TARGET_USERIMAGES_USE_F2FS := true
endif
endif

ifndef HAL_TARGET_PROJECT
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

else
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

endif
endif#HAL_TARGET_PROJECT

# mkbootimg header, which is used in LK
ifeq ($(MTK_DYNAMIC_KERNEL_LOADING), yes)
BOARD_KERNEL_BASE = 0
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_OFFSET = 0
else
BOARD_KERNEL_OFFSET = 0
endif
BOARD_RAMDISK_OFFSET = 0
BOARD_TAGS_OFFSET = 0
else
BOARD_KERNEL_BASE = 0x40000000
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_OFFSET = 0
else
BOARD_KERNEL_OFFSET = 0
endif
BOARD_RAMDISK_OFFSET = 0x26F00000
BOARD_TAGS_OFFSET = 0x07C80000
endif
TARGET_USES_64_BIT_BINDER := true
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_CMDLINE = bootopt=64S3,32S1,32S1
else
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
endif
BOARD_BOOT_HEADER_VERSION = 4
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_TAGS_OFFSET)

TARGET_RECOVERY_FSTAB := $(MTK_PTGEN_PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(TARGET_BOARD_PLATFORM)

BOARD_SIGN_IMG:=yes

ifneq ($(wildcard vendor/mediatek/internal/sboot_disable),)
BOARD_BUILD_SBOOT_DIS:=yes
BOARD_BUILD_RPMB_KEY_PL:=yes
else
BOARD_BUILD_SBOOT_DIS:=no
BOARD_BUILD_RPMB_KEY_PL:=no
endif

TINYSYS_STRUCTURE_VERSION := 2

TRUSTONIC_TEE_VERSION ?= 510
MICROTRUST_TEE_VERSION ?= 450
# for metadata encrypto
BOARD_USES_METADATA_PARTITION := true

#VF project setting to the ro.board.first_api_level
ifneq (-4.14,$(findstring -4.14,$(LINUX_KERNEL_VERSION)))
BOARD_SHIPPING_API_LEVEL := 31
endif

include device/mediatek/build/core/target_brm_platform.mk
