#mtkcam_config_mks :=

# to include cameraconfig.mk for PLATFORM
#mtkcam_config_mks +=$(wildcard $(MTKCAM_TARGET_BOARD_PLATFORM)/cameraconfig.mk)

keys :=
#ifneq ($(mtkcam_config_mks),)
#sub_keys := $(strip $(subst =, ,$(shell grep -h -o "^\s*\w\+\s*=" $(mtkcam_config_mks))))
#keys += $(sub_keys)
#endif

#ifeq ($(filter mtkPlugin,$(SOONG_CONFIG_NAMESPACES)),)
#SOONG_CONFIG_NAMESPACES += mtkcamPlugin
#endif
#SOONG_CONFIG_mtkcamPlugin := $(keys)
#$(foreach key,$(keys),$(eval SOONG_CONFIG_mtkcamPlugin_$(key):=$($(key))))


$(foreach mtkcam_platform,$(MTKCAM_PLATFORM_GROUP),\
  $(eval mtkcam_config_mks :=$(wildcard device/mediatek/$(mtkcam_platform)/CameraConfig.mk))\
  $(eval include $(mtkcam_config_mks))\
  $(if $(mtkcam_config_mks),\
    $(eval sub_keys := $(strip $(subst =, ,$(shell grep -h -o "^\s*\w\+\s*=" $(mtkcam_config_mks)))))\
	$(eval keys += $(sub_keys))\
	$(eval SOONG_CONFIG_NAMESPACES += mtkcamPlugin.$(mtkcam_platform))\
	$(eval SOONG_CONFIG_mtkcamPlugin.$(mtkcam_platform) := $(keys))\
	$(foreach key,$(keys),$(eval SOONG_CONFIG_mtkcamPlugin.$(mtkcam_platform)_$(key):=$($(key)))))\
)




