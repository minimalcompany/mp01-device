# For Layer decoupling 2.0
# Wlan Configuration for kernel module only

# common macro for all platforms

# platform macro will be re-defined in Android.mk
CONNAC_VER := 0_0
WLAN_CHIP_ID := common
WIFI_CHIP := common
WIFI_IP_SET := 0
WLAN_BUILD_COMMON := true

# add all supported driver
# remove ko here for KBuild support
PRODUCT_PACKAGES += wmt_chrdev_wifi.ko
PRODUCT_PACKAGES += wmt_chrdev_wifi_connac2.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6893.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6983.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6879.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6895.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6855.ko
PRODUCT_PACKAGES += wlan_drv_gen4m_6789.ko
ifneq ($(LINUX_KERNEL_VERSION), kernel-6.6)
 PRODUCT_PACKAGES += wlan_mt7902_sdio_mt6789.ko
 PRODUCT_PACKAGES += wlan_sdio_reset.ko
endif