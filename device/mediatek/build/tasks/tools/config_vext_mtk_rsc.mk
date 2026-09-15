
vext_mtk_rsc_parameter_variables := \
	MTK_RSC_APKS \
	MTK_RSC_MODULES \
	MTK_RSC_COPY_FILES \
	MTK_RSC_SYSTEM_PROPERTIES \
	MTK_RSC_VENDOR_PROPERTIES \
	MTK_RSC_XML_OPTR \
	MTK_RSC_SYSTEM_ONLY \
	MTK_RSC_VENDOR_ONLY \


$(call clear-var-list, $(vext_mtk_rsc_parameter_variables))

VEXT_MTK_RSC_MAKEFILE := $(firstword $(wildcard $(VEXT_TARGET_PROJECT_FOLDER)/rsc/$(vext_mtk_rsc_name)/RuntimeSwitch.mk $(VEXT_PROJECT_FOLDER)/rsc/$(vext_mtk_rsc_name)/RuntimeSwitch.mk))
ifdef VEXT_MTK_RSC_MAKEFILE
VEXT_MTK_RSC_LOCAL_PATH := $(patsubst %/,%,$(dir $(VEXT_MTK_RSC_MAKEFILE)))
endif

VEXT_MTK_RSC_NAME := $(vext_mtk_rsc_name)
VEXT_MTK_RSC_PROJECT_NAME := $(VEXT_MTK_RSC_NAME)


include $(VEXT_MTK_RSC_MAKEFILE)


ifeq ($(MTK_RSC_SYSTEM_ONLY),true)
ifeq ($(MTK_RSC_VENDOR_ONLY),true)
$(error $(MTK_RSC_MAKEFILE): MTK_RSC_SYSTEM_ONLY and MTK_RSC_VENDOR_ONLY cannot set to true at the same time)
endif
endif
VEXT_MTK_RSC_RELATIVE_DIR := $(if $(PRODUCT_VEXT_MTK_RSC_ROOT_PATH),/$(PRODUCT_VEXT_MTK_RSC_ROOT_PATH)/$(VEXT_MTK_RSC_PROJECT_NAME))
ifeq (1,$(words $(CURRENT_VEXT_RSC_NAMES)))
  VEXT_MTK_RSC_PROP_RELATIVE_DIR :=
else
  VEXT_MTK_RSC_PROP_RELATIVE_DIR := $(VEXT_MTK_RSC_RELATIVE_DIR)
endif

MTK_RSC_MODULES += \
	vext.ro.prop.mtk_rsc.$(VEXT_MTK_RSC_NAME) \
	vext.rw.prop.mtk_rsc.$(VEXT_MTK_RSC_NAME)


$(foreach f,$(MTK_RSC_COPY_FILES),\
  $(eval pair := $(subst :,$(space),$(f)))\
  $(eval src := $(word 1,$(pair)))\
  $(eval img := $(word 2,$(pair)))\
  $(eval dst := $(word 3,$(pair)))\
  $(eval own := $(word 4,$(pair)))\
  $(eval PRODUCT_COPY_FILES += $(src):$(TARGET_COPY_OUT_$(img))$(VEXT_MTK_RSC_RELATIVE_DIR)/$(dst)$(if $(own),:$(own)))\
)

PRODUCT_PACKAGES += $(MTK_RSC_MODULES)

#$(foreach f,$(MTK_RSC_APKS),\
#  $(eval pair := $(subst :,$(space),$(f)))\
#  $(eval m := $(word 1,$(pair)))\
#  $(eval MTK_RSC_OVERRIDE_APKS := $(MTK_RSC_OVERRIDE_APKS) $(m))\
#)

VEXT_MTK_RSC_MAKEFILES := $(VEXT_MTK_RSC_MAKEFILES) $(VEXT_MTK_RSC_MAKEFILE)

