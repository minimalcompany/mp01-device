mtkcam_platform := $(notdir $(LOCAL_PATH))
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) :=
# Do NOT modify above this line

##########################
# device-camera.mk start #
##########################
CUSTOM_HAL_IMGSENSOR = s5k3p3sp_mipi_raw bf2553l_mipi_raw imx586_mipi_raw ov48b_mipi_raw s5k3p9sp_mipi_raw s5k3m5sx_mipi_raw imx481_mipi_raw imx519_mipi_raw imx398_mipi_raw imx350_mipi_raw s5k2l7_mipi_raw imx386_mipi_raw imx386_mipi_mono s5k2t7sp_mipi_raw imx499_mipi_raw s5k2lqsx_mipi_raw s5k4h7_mipi_raw hi1339_mipi_raw ov13b10main_mipi_raw s5k4h7front_mipi_raw sc800cs_mipi_raw 
#CUSTOM_HAL_IMGSENSOR = s5k3p3sp_mipi_raw bf2553l_mipi_raw

ALL_SENSOR_LIST = $(addsuffix _tuning,$(notdir $(foreach f,$(CUSTOM_HAL_IMGSENSOR),$(wildcard vendor/mediatek/proprietary/custom/mt6789/hal/imgsensor/ver1/$(f)))))

MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  $(ALL_SENSOR_LIST) \


# MediaTek Camera Hal test
ifneq ($(TARGET_BUILD_VARIANT),user)
MTKCAM_PRODUCT_PACKAGES.$(mtkcam_platform) += \
  mtkcam-ut-p2c \
  test_hal \
  camsys_dump_tool \
  mtkBackend_ut \
  mtkcam_pipemgr_ut \

endif

CUSTOM_HAL_IMGSENSOR :=  

##########################
# device-camera.mk end   #
##########################

# Do NOT modify below this line
mtkcam_platform :=

