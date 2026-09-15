# GPS Configuration
PRODUCT_PACKAGES += mnld
PRODUCT_PACKAGES += gps.default

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  ifneq ($(strip $(MTK_HIDL_PROCESS_CONSOLIDATION_ENABLED)), yes)
    PRODUCT_PACKAGES += android.hardware.gnss-service.mediatek \
                        lbs_hidl_service
  endif

  ifeq ($(strip $(MTK_AGPS_APP)), yes)
    PRODUCT_PACKAGES += mtk_agpsd \
                        libviagpsrpc \
                        librpc
  endif
endif

PRODUCT_PACKAGES += slpd
