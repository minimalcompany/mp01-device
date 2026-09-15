keys :=
MTK_SPLIT_BUILD_LAYERS :=
project_config_mks :=
ifdef SYS_TARGET_PROJECT_FOLDER
MTK_SPLIT_BUILD_LAYERS += sys
project_config_mks += $(wildcard $(SYS_SYSTEM_CONFIG_MK))
else
ifeq ($(MTK_CUTTLESTONE),yes)
project_config_mks += $(wildcard $(SYS_SYSTEM_CONFIG_MK))
endif
endif
ifdef HAL_TARGET_PROJECT_FOLDER
MTK_SPLIT_BUILD_LAYERS += hal
project_config_mks += $(wildcard $(HAL_VENDOR_CONFIG_MK))
keys += MGVI_PLATFORM_GROUP
keys += MGVI_PLATFORM_DIR
endif
ifdef KRN_TARGET_PROJECT_FOLDER
MTK_SPLIT_BUILD_LAYERS += krn
# Kernel modules only use Android.mk, no Soong requirement.
#project_config_mks += $(wildcard $(KRN_KERNEL_CONFIG_MK))
endif
ifdef VEXT_TARGET_PROJECT_FOLDER
ifneq ($(wildcard $(VEXT_TARGET_PROJECT_FOLDER)/vext_*.mk),)
MTK_SPLIT_BUILD_LAYERS += vext
project_config_mks += $(wildcard $(VEXT_PROJECT_CONFIG_MK))
endif
endif
ifdef MTK_TARGET_PROJECT_FOLDER
ifndef HAL_TARGET_PROJECT_FOLDER
ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/vnd_*.mk),)
MTK_SPLIT_BUILD_LAYERS += vnd
else
MTK_SPLIT_BUILD_LAYERS += full
endif
project_config_mks += $(wildcard $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk)
endif
endif
ifeq ($(MTK_CUTTLESTONE),yes)
MTK_SPLIT_BUILD_LAYERS := full
endif
MTK_SPLIT_BUILD_LAYERS := $(strip $(MTK_SPLIT_BUILD_LAYERS))
project_config_mks := $(strip $(project_config_mks))

ifneq ($(project_config_mks),)
sub_keys := $(strip $(subst =, ,$(shell grep -h -o "^\s*\w\+\s*=" $(project_config_mks))))
keys += $(sub_keys)
endif

ifneq ($(wildcard device/mediatek/build/core/mssi_fo.mk),)
ifdef FO_NEEDED_DEFINE_MSSI_LIST
sub_keys := $(strip $(addprefix MSSI_,$(FO_NEEDED_DEFINE_MSSI_LIST)))
keys += $(sub_keys)
endif
endif

ifneq ($(wildcard device/mediatek/build/core/mgvi_fo.mk),)
ifdef FO_NEEDED_DEFINE_MGVI_LIST
sub_keys := $(strip $(addprefix MGVI_,$(FO_NEEDED_DEFINE_MGVI_LIST)))
keys += $(sub_keys)
endif
endif

keys += \
	HAVE_AEE_FEATURE \
	MSSI_HAVE_AEE_FEATURE \
	MTK_BASE_PROJECT \
	MTK_TARGET_PROJECT \
	VEXT_BASE_PROJECT \
	VEXT_TARGET_PROJECT \
	TARGET_BOARD_PLATFORM \
	TARGET_BRM_PLATFORM \
	MTKCAM_PLATFORM_GROUP \
	MTK_REL_PLATFORM

keys += \
	SYS_BASE_PROJECT \
	SYS_TARGET_PROJECT \
	MTK_SPLIT_BUILD_LAYERS

keys += \
	TRUSTONIC_TEE_VERSION \
	MICROTRUST_TEE_VERSION

keys += \
	TARGET_ARCH \
	TARGET_BUILD_VARIANT \
	MTK_PRODUCT_API_CHECK

keys += \
	VSYNC_EVENT_PHASE_OFFSET_NS \
	GPU_TARGET_BOARD_PLATFORM

ifeq ($(filter mtkPlugin,$(SOONG_CONFIG_NAMESPACES)),)
SOONG_CONFIG_NAMESPACES += mtkPlugin
endif
SOONG_CONFIG_mtkPlugin := $(keys)
$(foreach key,$(keys),$(eval SOONG_CONFIG_mtkPlugin_$(key):=$($(key))))

# not allow to modify after BoardConfig-vext.mk
MTK_OUT_OF_TREE_KERNEL_MODULES ?=
.KATI_READONLY := MTK_OUT_OF_TREE_KERNEL_MODULES

