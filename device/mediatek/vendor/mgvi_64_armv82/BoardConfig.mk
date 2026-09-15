# PRODUCT_USERDATAIMAGE_FILE_SYSTEM_TYPE_EXT4 shall be assigned before including device/mediatek/mt6893/BoardConfig.mk
PRODUCT_USERDATAIMAGE_FILE_SYSTEM_TYPE_EXT4 := false

BOARD_BOOT_HEADER_VERSION := 3

TARGET_BOARD_PLATFORM := common
include device/mediatek/vendor/common/BoardConfig.mk
include device/mediatek/build/core/target_brm_platform.mk

MTK_INTERNAL_CDEFS := $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)))
#MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),$(foreach v,$(shell echo $($(t)) | tr '[a-z]' '[A-Z]'),-D$(v))))
#MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)=\"$(strip $($(t)))\"))
MTK_GLOBAL_CFLAGS += $(MTK_INTERNAL_CDEFS)


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

#Config partition size
ifneq ($(strip $(MTK_AB_OTA_UPDATER)), yes)
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_ODM := vendor/odm

ifneq ($(FPGA_EARLY_PORTING), yes)
MTK_HWC_SUPPORT := yes
else
MTK_HWC_SUPPORT := no
endif

TARGET_USES_HWC2 := false
TARGET_USES_HWC2ON1ADAPTER := true
MTK_HWC_VERSION := 2.0.0
MTK_HWC_USE_DRM_DEVICE := yes

BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_MTK_BOOT_SIZE_KB := 65536

ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_CMDLINE = bootopt=64S3,32S1,32S1
else
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
endif

ifndef VEXT_TARGET_PROJECT
BOARD_RECOVERY_KERNEL_MODULES :=
BOARD_VENDOR_RAMDISK_KERNEL_MODULES :=
BOARD_VENDOR_KERNEL_MODULES :=
BOARD_ODM_KERNEL_MODULES :=
PLATFORM_DTB_NAME :=
PROJECT_DTB_NAMES :=
include device/mediatek/build/core/soong_config.mk
include device/mediatek/build/core/mtkcam_config.mk
endif
