$(call inherit-product, device/mediatek/vendor/common/device-kernel.mk)

PRODUCT_PACKAGES += msync2_dms.ko
PRODUCT_PACKAGES += msync2_frd.ko

ifndef VEXT_TARGET_PROJECT

#PRODUCT_PACKAGES += gt9886.ko
#PRODUCT_PACKAGES += gt9896s.ko

endif
