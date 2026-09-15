# A workaround for the build hang issue when non-MTK lunch is selected.
# e.g., aosp_arm-eng.
#
# Many Android.mk files under vendor/mediatek will recursively include
# themselves if MTK_PLATFORM isn't defined. e.g.,
#   include $(LOCAL_PATH)/$(shell echo $(MTK_PLATFORM) | tr A-Z a-z )/Android.mk
#
# Only include Android.mk files under vendor/mediatek/ when
# MTK_PROJECT_NAME is defined. This file should be renamed to
# vendor/mediatek/Android.mk, either manually or through <copyfile> setting
# in repo manifest.

LOCAL_PATH := $(call my-dir)
mtk_subdir_makefiles :=
ifneq ($(strip $(MTK_PROJECT_NAME)),)
mtk_subdir_makefiles := $(call first-makefiles-under, $(LOCAL_PATH))
else ifeq ($(is_sdk_build),true)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/libs/anrappmanager/Android.mk)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/libs/mplugin/Android.mk)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/proprietary/frameworks/base/res/Android.mk)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/proprietary/frameworks/common/Android.mk)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/proprietary/frameworks/opt/anr/anrappmanager/Android.mk)
mtk_subdir_makefiles += $(wildcard $(LOCAL_PATH)/proprietary/frameworks/opt/mplugin/Android.mk)
else
vext_subdir_makefiles := $(wildcard $(addprefix $(LOCAL_PATH)/,$(sort $(VEXT_ONE_SHOT_MAKEFILES))))
vext_subdir_makefiles += $(foreach d,$(wildcard $(addprefix $(LOCAL_PATH)/,$(sort $(VEXT_ONE_SHOT_MAKEFILE_DIRS)))),$(call first-makefiles-under, $(d)))
mtk_subdir_makefiles += $(sort $(vext_subdir_makefiles))
endif

ifeq ($(strip $(MTK_CUTTLESTONE)), yes)
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/aee/binary/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/aee/binary_v2/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/aihub/saliency_lib/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/audiodcremoveflt/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/aurisys_3rdparty/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/aurisys/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/bessound_HD/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/blisrc/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/cvsd_plc_codec/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/fuelgauged/libfgauge/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/libbh/libbh/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/libbh/libsmartcharging/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/limiter/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/msbc_codec/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/poweraq/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/shifter/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/thermalalgolib/catm_plus/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/thermalalgolib/thha/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/thermal_core_lib/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/external/thermal_managerlib/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/frameworks/opt/jpe_lib/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_3a/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_core/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_drv/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_ext/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_feature/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/lib3a/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/lib3a_sample/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/lib3am/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/libcamalgo/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/libdngop/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/libispfeature/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/libispfeaturem/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libcamera_lib/libn3d3a/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libsensor/yas/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/libvc1dec/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/hardware/vcodec/common/common/Android.mk),$(mtk_subdir_makefiles))
mtk_subdir_makefiles := $(filter-out $(wildcard $(LOCAL_PATH)/proprietary/modem/Android.mk),$(mtk_subdir_makefiles))
endif

$(foreach mk,$(mtk_subdir_makefiles),$(info including $(mk) ...)$(eval include $(mk)))
