MTK_PATH_SOURCE := vendor/mediatek/proprietary
MTK_PTGEN_PRODUCT_OUT := $(OUT_DIR)/target/product/$(TARGET_DEVICE)

ifndef HAL_TARGET_PROJECT
TARGET_ARCH := arm
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_ABI := armeabi-v7a
endif#HAL_TARGET_PROJECT

ifndef HAL_TARGET_PROJECT
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
endif#HAL_TARGET_PROJECT

ifndef HAL_TARGET_PROJECT
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
ifneq ($(wildcard vendor/mediatek/internal),)
ifneq ($(COVERITY_LOCAL_SCAN),yes)
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := false
endif
endif
#DISABLE_MTK_CONFIG_CHECK := yes
endif#HAL_TARGET_PROJECT

BOARD_SIGN_IMG ?= yes

# ptgen
ifneq ($(wildcard prebuilts/perl/linux-x86),)
PERL := prebuilts/perl/linux-x86/bin/perl
else
PERL := /usr/bin/perl
endif

