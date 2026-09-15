LOCAL_PATH := $(call my-dir)
cam_subdir_makefiles := $(call first-makefiles-under, $(LOCAL_PATH))
ifdef MTK_GENERIC_HAL
$(foreach mtkcam_platform,$(MTKCAM_PLATFORM_GROUP),\
  $(eval mtkcam_config_mks := $(wildcard device/mediatek/$(mtkcam_platform)/CameraConfig.mk))\
  $(if $(mtkcam_config_mks),\
    $(eval include $(mtkcam_config_mks))\
    $(foreach mk,$(cam_subdir_makefiles),\
      $(info including $(mk)...)\
      $(eval include $(mk))\
    )\
  )\
)
else
  -include device/mediatek/vendor/common/CameraConfig.mk
  $(foreach mk,$(cam_subdir_makefiles),\
    $(info including $(mk)...)\
    $(eval include $(mk))\
  )
endif
