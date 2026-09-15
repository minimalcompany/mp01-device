ifndef MTK_PLATFORM_DIR
  MTK_PLATFORM_DIR := $(call to-lower,$(MTK_PLATFORM))
endif

# for krn only
ifneq ($(strip $(KRN_TARGET_PROJECT)),)

#####################################################################


PRODUCT_PACKAGES += fpsgo-user.ko fpsgo-eng.ko
#PRODUCT_PACKAGES += fpsgo.ko
PRODUCT_PACKAGES += gf_spi.ko
PRODUCT_PACKAGES += ft3518u.ko
PRODUCT_PACKAGES += ft3518.ko
#PRODUCT_PACKAGES += st61y.ko
PRODUCT_PACKAGES += synaptics_tcm.ko
PRODUCT_PACKAGES += gt9916p.ko
PRODUCT_PACKAGES += ft3881_common_ad10.ko
PRODUCT_PACKAGES += ft3681_common_ad10.ko

$(call inherit-product, $(LOCAL_PATH)/connectivity/product_package/product_package-kernel.mk)

#inherit test case
$(call inherit-product-if-exists, vendor/mediatek/tests/kernel/test_list_kernel.mk)

#####################################################################

endif
ifneq ($(strip $(VEXT_TARGET_PROJECT)),)
PRODUCT_PACKAGES :=
endif
PRODUCT_PROPERTY_OVERRIDES :=

