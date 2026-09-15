# GPS Configuration

GPS_ENABLE_KBUILD := true
GPS_CHIP_ID := common
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.14)
	GPS_ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.19)
	GPS_ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.19-lc)
	GPS_ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-5.4)
	GPS_ENABLE_KBUILD := false
endif
ifeq ($(GPS_ENABLE_KBUILD), false)
PRODUCT_PACKAGES += gps_drv_stp.ko
PRODUCT_PACKAGES += gps_drv_dl_v010.ko
PRODUCT_PACKAGES += gps_drv_dl_v030.ko
PRODUCT_PACKAGES += gps_drv_dl_v050.ko
PRODUCT_PACKAGES += gps_scp.ko
PRODUCT_PACKAGES += gps_pwr.ko
endif
