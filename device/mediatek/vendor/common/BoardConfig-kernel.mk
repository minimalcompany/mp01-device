MTK_PATH_SOURCE := vendor/mediatek/proprietary
MTK_PTGEN_PRODUCT_OUT := $(OUT_DIR)/target/product/$(TARGET_DEVICE)
ifneq (,$(filter kernel-5.4 kernel-5.10 kernel-6.1 kernel-6.6 kernel-mainline,$(strip $(LINUX_KERNEL_VERSION))))
KERNEL_OUT ?= $(OUT_DIR)/target/product/$(TARGET_DEVICE)/obj/KERNEL_OBJ/$(LINUX_KERNEL_VERSION)
endif
KERNEL_OUT ?= $(OUT_DIR)/target/product/$(TARGET_DEVICE)/obj/KERNEL_OBJ

ifeq ($(strip $(MTK_TARGET_PROJECT))$(strip $(HAL_TARGET_PROJECT)),)
TARGET_ARCH := arm
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_ABI := armeabi-v7a
endif

ifeq ($(strip $(MTK_TARGET_PROJECT))$(strip $(HAL_TARGET_PROJECT)),)
BOARD_BOOT_HEADER_VERSION ?= 4
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_PREBUILT_DTBIMAGE_DIR :=
BOARD_PREBUILT_DTBOIMAGE :=

include device/mediatek/vendor/common/BoardConfig-image.mk
endif

ifeq ($(strip $(MTK_TARGET_PROJECT))$(strip $(HAL_TARGET_PROJECT)),)
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
ifneq ($(wildcard vendor/mediatek/internal),)
ifneq ($(COVERITY_LOCAL_SCAN),yes)
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := false
endif
endif
DISABLE_MTK_CONFIG_CHECK := yes
endif

TARGET_KERNEL_USE_CLANG ?= true

ifeq ($(MTK_K64_SUPPORT), yes)
KERNEL_TARGET_ARCH := arm64
else
KERNEL_TARGET_ARCH := arm
endif

ifeq ($(MTK_K64_SUPPORT), yes)
MTK_PACK_PREBUILT_KERNEL_MODULES_TO_LOAD += $(wildcard kernel/prebuilts/$(subst kernel-,,$(strip $(LINUX_KERNEL_VERSION)))/arm64/*.ko)
endif
