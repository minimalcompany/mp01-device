# GPS Configuration
PRODUCT_PACKAGES += mnld
PRODUCT_PACKAGES += gps.default

ifneq ($(LINUX_KERNEL_VERSION), kernel-5.10)
PRODUCT_PACKAGES += gps_drv.ko
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.gps.chrdev=gps_drv
else
GPS_CHRDEV_VER := stp
ifneq (,$(filter CONSYS_6893,$(MTK_COMBO_CHIP)))
	GPS_CHRDEV_VER := dl_v010
endif
PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/gps/init.gps_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gps_drv.rc
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.gps.chrdev=gps_drv_$(GPS_CHRDEV_VER)
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  ifneq ($(strip $(MTK_HIDL_PROCESS_CONSOLIDATION_ENABLED)), yes)
    PRODUCT_PACKAGES += android.hardware.gnss-service.mediatek \
                        lbs_hidl_service
  endif
  ifeq ($(strip $(MTK_AGPS_APP)), yes)
    PRODUCT_PACKAGES += mtk_agpsd

    ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
      PRODUCT_PACKAGES += \
            libviagpsrpc \
            librpc
    endif

    ifndef MTK_AGPS_CONF_XML_SRC
        MTK_AGPS_CONF_XML_SRC := agps_profiles_conf2.xml
    endif
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/agps/$(MTK_AGPS_CONF_XML_SRC):$(TARGET_COPY_OUT_VENDOR)/etc/gnss/agps_profiles_conf2.xml:mtk

    # agps configuration for carriers
    PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,device/mediatek/vendor/common/agps/carrier,$(TARGET_COPY_OUT_VENDOR)/etc/gnss/carrier)

    # SUPL Root Certificates for users
    PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,device/mediatek/vendor/common/agps/certutil/files/cacerts_supl,$(TARGET_COPY_OUT_VENDOR)/etc/security/cacerts_supl)
    # SUPL Root Certificates for lab tests
    PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,device/mediatek/vendor/common/agps/certutil/files/cacerts_supl_lab,$(TARGET_COPY_OUT_VENDOR)/etc/security/cacerts_supl/lab)
  endif
endif

PRODUCT_PACKAGES += slpd
PRODUCT_COPY_FILES += device/mediatek/vendor/common/slp/slp_conf:$(TARGET_COPY_OUT_VENDOR)/etc/slp_conf:mtk
