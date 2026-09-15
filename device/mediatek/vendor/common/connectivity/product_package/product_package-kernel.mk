# Layer Decoupling 2.0 for Conninfra & WMT driver, Kernel Configuration

# for connac2 project
# PRODUCT_PACKAGES += conninfra.ko

# for connac1 project
# PRODUCT_PACKAGES += wmt_drv.ko

$(call inherit-product-if-exists, $(LOCAL_PATH)/gps_product_package-kernel.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/fm_product_package-kernel.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/wlan_product_package-kernel.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/bluetooth_product_package-kernel.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/connfem_product_package-kernel.mk)
