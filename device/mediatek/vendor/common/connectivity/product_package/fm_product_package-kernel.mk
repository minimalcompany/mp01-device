# kernel module
ifeq ($(strip $(MTK_FM_SUPPORT)), yes)
#    PRODUCT_PACKAGES += fmradio_drv_soc.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6625.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6627.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6630.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6631.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6632.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6635.ko
#    PRODUCT_PACKAGES += fmradio_drv_mt6631_6635.ko
# disable it for KBuild
#    PRODUCT_PACKAGES += fmradio_drv_connac2x.ko
endif

