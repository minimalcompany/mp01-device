MGVI_DEFAULT_PLATFORM_GROUP := $(patsubst device/mediatek/%/mgvi.$(MTK_PRODUCT_LINE).enabled,%,$(wildcard device/mediatek/*/mgvi.$(MTK_PRODUCT_LINE).enabled))

ifndef MGVI_PLATFORM_GROUP
MGVI_INTERNAL_PLATFORM_GROUP :=
ifeq ($(wildcard device/mediatekprojects),)
ifeq ($(wildcard vendor/mediatek/internal),)
MGVI_INTERNAL_PLATFORM_GROUP := $(patsubst device/mediatek/%/mgvi.$(MTK_PRODUCT_LINE).internal,%,$(wildcard device/mediatek/*/mgvi.$(MTK_PRODUCT_LINE).internal))
  ifneq ($(wildcard vendor/mediatek/proprietary/custom/k6893v1_64_swrgo),)
  ifeq ($(wildcard vendor/mediatek/proprietary/custom/k6891v1_64),)
    # workaround for k6893v1_64_swrgo in SP flow
    ifeq (mt6893,$(MGVI_INTERNAL_PLATFORM_GROUP))
      MGVI_INTERNAL_PLATFORM_GROUP :=
    else
      MGVI_INTERNAL_PLATFORM_GROUP := $(filter mt6893,$(MGVI_INTERNAL_PLATFORM_GROUP))
    endif
  endif
  endif
endif
endif
MGVI_PLATFORM_GROUP := $(filter-out $(MGVI_INTERNAL_PLATFORM_GROUP),$(MGVI_DEFAULT_PLATFORM_GROUP))
USE_DEFAULT_MGVI_PLATFORM_GROUP := yes
endif

ifndef MGVI_PLATFORM_DIR
MGVI_PLATFORM_DIR := $(MTK_PLATFORM)
endif

#ifdef HAL_TARGET_PROJECT
#ifndef VEXT_TARGET_PROJECT
#$(KATI_deprecated_var LINUX_KERNEL_VERSION)
#$(KATI_deprecated_var MTK_PLATFORM)
#$(KATI_deprecated_var MTK_PLATFORM_DIR)
#$(KATI_deprecated_var MTK_PATH_CUSTOM)
#endif
#endif

