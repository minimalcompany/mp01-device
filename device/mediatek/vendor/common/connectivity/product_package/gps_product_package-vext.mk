# GPS Configuration

GPS_CHRDEV_VER := stp
ifneq (,$(filter CONSYS_6885 CONSYS_6893,$(MTK_COMBO_CHIP)))
	GPS_CHRDEV_VER := dl_v010
endif
ifneq (,$(filter CONSYS_6877,$(MTK_COMBO_CHIP)))
	GPS_CHRDEV_VER := dl_v030
endif
ifneq (,$(filter CONSYS_6879 CONSYS_6983 CONSYS_6895,$(MTK_COMBO_CHIP)))
	GPS_CHRDEV_VER := dl_v050
endif

$(warning MTK_COMBO_CHIP=$(MTK_COMBO_CHIP))
$(warning GPS_CHRDEV_VER=$(GPS_CHRDEV_VER))

MTK_OUT_OF_TREE_KERNEL_MODULES += gps_drv_$(GPS_CHRDEV_VER).ko

PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/gps/init.gps_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gps_drv.rc
ifneq (,$(filter CONSYS_6893 CONSYS_6983 CONSYS_6895,$(MTK_COMBO_CHIP)))
	MTK_OUT_OF_TREE_KERNEL_MODULES += gps_scp.ko
	PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/gps/gps_scp/init.gps_scp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gps_scp.rc
endif
ifneq (,$(filter CONSYS_6879 CONSYS_6893 CONSYS_6983 CONSYS_6895 CONSYS_6855 CONSYS_6789,$(MTK_COMBO_CHIP)))
	MTK_OUT_OF_TREE_KERNEL_MODULES += gps_pwr.ko
	PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/gps/gps_pwr/init.gps_pwr.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gps_pwr.rc
endif
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.gps.chrdev=gps_drv_$(GPS_CHRDEV_VER)

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  ifeq ($(strip $(MTK_AGPS_APP)), yes)
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

PRODUCT_COPY_FILES += device/mediatek/vendor/common/slp/slp_conf:$(TARGET_COPY_OUT_VENDOR)/etc/slp_conf:mtk

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif
