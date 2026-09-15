mtkcam_platform := common
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) :=
# Do NOT modify above this line

##########################
# device-camera.mk start #
##########################

MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  camerahalserver \
  libmtkcam_streaminfo_plugin-p1stt \
  android.hardware.camera.provider@2.6-service-mediatek \
  android.hardware.camera.provider@2.6-impl-mediatek \
  vendor.mediatek.hardware.camera.advcam@1.0-impl \
  vendor.mediatek.hardware.camera.isphal@1.0-impl \
  vendor.mediatek.hardware.camera.isphal@1.1-impl \
  vendor.mediatek.hardware.camera.atms@1.0-impl \
  vendor.mediatek.hardware.camera.lomoeffect@1.0-impl \
  vendor.mediatek.hardware.camera.ccap@1.0-impl \
  vendor.mediatek.hardware.camera.bgservice@1.0-impl \
  vendor.mediatek.hardware.camera.bgservice@1.1-impl \
  libmtkcam_modulefactory_custom \
  libmtkcam_modulefactory_drv \
  libmtkcam_modulefactory_aaa \
  libmtkcam_modulefactory_feature \
  libmtkcam_modulefactory_utils \
  libcam.halsensor.hwintegration \
  libcameracustom.plugin \
  libcam.hal3a.cctsvr \
  libcam.hal3a.cctsvr.v4l2 \
  jpegtool \
  libmtkcam_cct \
  lib3a.aishutter.models \
  libpq_cust_base \
  libacdk

# MediaTek Camera Feature
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  libneuron_runainr \
  libneuron_aidepth \
  libaibc_tuning \
  libaibc_tuning_p2 \
  libaibc_tuning_p3 \
  libaibc_tuning_p4 \
  libcamalgo.util1 \
  libcamalgo.util2 \
  libaidepth_tuning \
  libcamalgo.platform2 \
  libvainr_model \

ifeq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
ifeq ($(TARGET_BUILD_VARIANT), eng)
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += EmCamera
endif
else
ifneq ($(TARGET_BUILD_VARIANT), user)
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += EmCamera
endif
endif


# MediaTek Camera Hal test
ifneq ($(TARGET_BUILD_VARIANT),user)
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  mtkcam-debug \
  securecamera_test \
  mmshal_test \
  isphal_test \
  sentest \
  eeprom_test \
  eeprom_write
endif

# for IoctlFuzzer (MediaTek internal-use)
ifeq ($(TARGET_BUILD_VARIANT),eng)
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  ioctl_fuzzer \
  ioctl_camera_isp
endif

# lazy hal
#ifeq ($(strip $(MTK_CAM_LAZY_HAL)), yes)
#    PRODUCT_PROPERTY_OVERRIDES += ro.camera.enableLazyHal=true
#    PRODUCT_PACKAGES += android.hardware.camera.provider@2.6-service-lazy
#endif


##########################
#    DEVICE_MANIFEST     #
##########################

# For MTK Camera
ifeq ($(strip $(MTK_GENERIC_HAL)), yes)
ifneq ($(strip $(MTKCAM_FPGA_EARLY_PORTING)), yes)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/project_manifest/manifest_cameraprovider.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_cameraprovider.xml
endif #MTKCAM_FPGA_EARLY_PORTING
endif #MTK_GENERIC_HAL

# for HIDL BGService
#DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_bgservice.xml


##########################
#        PROPERTY        #
##########################


##########################
# device-camera.mk end   #
##########################

# Do NOT modify below this line
MTKCAM_PLATFORM_MAKEFILES := $(foreach p,$(MGVI_PLATFORM_GROUP),$(if $(wildcard device/mediatek/$(p)/CameraConfig.mk),device/mediatek/$(p)/device-camera.mk))
$(foreach f,$(MTKCAM_PLATFORM_MAKEFILES),$(eval $(call inherit-product-if-exists,$(f))))

