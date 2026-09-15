# Layer Decoupling 2.0 for Conninfra & WMT driver, Userspace Configuration

# for connac2 project
PRODUCT_PACKAGES += conninfra_loader wifi_dump bt_dump

# for connac1 project
PRODUCT_PACKAGES += wmt_launcher wmt_loader wmt_fdb stp_dump3
PRODUCT_PACKAGES_ENG += wmt_concurrency wmt_loopback

$(call inherit-product-if-exists, $(LOCAL_PATH)/gps_product_package-hal.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/fm_product_package-hal.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/wlan_product_package-hal.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/bluetooth_product_package-hal.mk)
$(call inherit-product-if-exists, $(LOCAL_PATH)/connfem_product_package-hal.mk)
