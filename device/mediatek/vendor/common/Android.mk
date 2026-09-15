LOCAL_PATH := $(call my-dir)

define add-mgvi-platform-package
$(foreach p,$(2),\
  $(if $(filter $(1):$(1).$(p),$(MGVI_SHARED_LIBRARY_PAIR)),\
    $(1)\
  ,\
    $(1).$(p)\
  )\
)
endef

include $(CLEAR_VARS)
LOCAL_MODULE := mgvi_platform_package
LOCAL_MODULE_OWNER := mtk
LOCAL_REQUIRED_MODULES += $(foreach m,$(MGVI_SHARED_LIBRARY_LIST),$(call add-mgvi-platform-package,$(m),$(MGVI_PLATFORM_GROUP)))
LOCAL_REQUIRED_MODULES += $(filter-out $(SOONG_MTKCAM_MODULE_LIST),$(MTKCAM_PRODUCT_PACKAGES.common))
LOCAL_REQUIRED_MODULES += $(foreach p,$(MTKCAM_PLATFORM_GROUP),$(foreach m,$(filter $(SOONG_MTKCAM_MODULE_LIST),$(MTKCAM_PRODUCT_PACKAGES.common) $(MTKCAM_PRODUCT_PACKAGES.$(p))),$(m).$(p)))
include $(BUILD_PHONY_PACKAGE)

