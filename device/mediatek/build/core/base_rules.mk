LOCAL_MODULE := $(strip $(LOCAL_MODULE))
LOCAL_IS_HOST_MODULE := $(strip $(LOCAL_IS_HOST_MODULE))
ifdef LOCAL_IS_HOST_MODULE
  ifneq ($(LOCAL_IS_HOST_MODULE),true)
    $(error $(LOCAL_PATH): LOCAL_IS_HOST_MODULE must be "true" or empty, not "$(LOCAL_IS_HOST_MODULE)")
  endif
  ifeq ($(LOCAL_HOST_PREFIX),)
    my_prefix := HOST_
  else
    my_prefix := $(LOCAL_HOST_PREFIX)
  endif
  my_host := host-
  my_kind := HOST
else
  my_prefix := TARGET_
  my_kind :=
  my_host :=
endif

ifeq ($(my_prefix),HOST_CROSS_)
  my_host_cross := true
else
  my_host_cross :=
endif

my_32_64_bit_suffix := $(if $($(LOCAL_2ND_ARCH_VAR_PREFIX)$(my_prefix)IS_64_BIT),64,32)
my_register_name := $(LOCAL_MODULE)
ifeq ($(my_host_cross),true)
  my_register_name := host_cross_$(LOCAL_MODULE)
endif
ifdef LOCAL_2ND_ARCH_VAR_PREFIX
ifndef LOCAL_NO_2ND_ARCH_MODULE_SUFFIX
my_register_name := $(my_register_name)$($(my_prefix)2ND_ARCH_MODULE_SUFFIX)
endif
endif


ifdef MTK_RSC_OVERRIDE_APKS

  my_apks := $(filter $(MTK_RSC_OVERRIDE_APKS),$(LOCAL_REQUIRED_MODULES))
  ifdef my_apks
    $(info $(LOCAL_MODULE_MAKEFILE): remove $(my_apks) from LOCAL_REQUIRED_MODULES)
    LOCAL_REQUIRED_MODULES := $(filter-out $(MTK_RSC_OVERRIDE_APKS),$(LOCAL_REQUIRED_MODULES))
  endif
  my_apks :=

  ifeq ($(LOCAL_MODULE_CLASS),APPS)
  ifneq ($(filter $(MTK_RSC_OVERRIDE_APKS),$(LOCAL_PACKAGE_NAME)),)
    #LOCAL_UNINSTALLABLE_MODULE := true
  endif
  endif

endif


# workaround for AOSP layer decoupling violation
# hardware/interfaces/security/keymint/aidl/default/Android.bp
ifeq ($(LOCAL_MODULE),android.hardware.security.keymint-service)
LOCAL_REQUIRED_MODULES := $(filter-out RemoteProvisioner,$(LOCAL_REQUIRED_MODULES))
endif
# system/core/fs_mgr/Android.bp
ifeq ($(LOCAL_MODULE),libfs_mgr.recovery)
LOCAL_REQUIRED_MODULES := $(filter-out e2freefrag e2fsdroid,$(LOCAL_REQUIRED_MODULES))
endif
# frameworks/av/media/codec2/hidl/services/Android.bp
ifeq ($(LOCAL_MODULE),android.hardware.media.c2@1.2-default-seccomp_policy)
LOCAL_REQUIRED_MODULES := $(filter-out crash_dump.policy,$(LOCAL_REQUIRED_MODULES))
endif
# vendor/mediatek/proprietary/hardware/libc2/service/Android.bp
ifeq ($(LOCAL_MODULE),android.hardware.media.c2@1.2-mediatek-seccomp-policy)
LOCAL_REQUIRED_MODULES := $(filter-out crash_dump.policy,$(LOCAL_REQUIRED_MODULES))
endif
# frameworks/rs/Android.bp
ifneq ($(filter $(LOCAL_MODULE),libRS libRS.vendor libRS.product),)
LOCAL_REQUIRED_MODULES := $(filter-out libRS_internal libRSDriver libRSCacheDir,$(LOCAL_REQUIRED_MODULES))
endif
# external/e2fsprogs/e2fsck/Android.bp
ifeq ($(LOCAL_MODULE),e2fsck.vendor_ramdisk)
LOCAL_REQUIRED_MODULES := $(filter-out badblocks,$(LOCAL_REQUIRED_MODULES))
endif


ifneq ($(filter vnd vext,$(MTK_SPLIT_BUILD_LAYERS)),)
# virtual build
ifeq ($(LOCAL_MODULE_CLASS),SHARED_LIBRARIES)
ifeq ($(LOCAL_PROPRIETARY_MODULE),true)
ifeq ($(LOCAL_MODULE_MAKEFILE),$(SOONG_ANDROID_MK))
  ifneq ($(filter $(LOCAL_MODULE_STEM),$(MGVI_SHARED_LIBRARY_LIST)),)
    my_platform_required := $(lastword $(strip $(subst /, ,$(LOCAL_MODULE_PATH))))
    ifneq ($(filter $(my_platform_required),$(TARGET_BOARD_PLATFORM)),)
      # create symbolic link
      my_installed_module := $(LOCAL_MODULE_PATH)$(LOCAL_MODULE_STEM).so
      my_installed_symlink := $(dir $(patsubst %/,%,$(LOCAL_MODULE_PATH)))$(notdir $(my_installed_module))
      ALL_MODULES.$(my_register_name).INSTALLED := $(strip $(ALL_MODULES.$(my_register_name).INSTALLED) $(my_installed_symlink))
      $(call symlink-file,$(my_installed_module),$(my_platform_required)/$(notdir $(my_installed_module)),$(my_installed_symlink))
    else
      # skip install
      LOCAL_UNINSTALLABLE_MODULE := true
    endif
  endif#LOCAL_MODULE_STEM
else#LOCAL_MODULE_MAKEFILE
  ifneq ($(my_mgvi_platform),)
    my_platform_required := $(my_mgvi_platform)
    ifeq ($(my_mgvi_platform),$(TARGET_BOARD_PLATFORM))
      # create symbolic link
      my_installed_module := $($(LOCAL_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/$(LOCAL_MODULE_RELATIVE_PATH)/$(LOCAL_INSTALLED_MODULE_STEM)
      my_installed_symlink := $(dir $(patsubst %/,%,$(dir $(my_installed_module))))$(notdir $(my_installed_module))
      ALL_MODULES.$(my_register_name).INSTALLED := $(strip $(ALL_MODULES.$(my_register_name).INSTALLED) $(my_installed_symlink))
      $(call symlink-file,$(my_installed_module),$(my_platform_required)/$(notdir $(my_installed_module)),$(my_installed_symlink))
    endif#my_mgvi_platform
  endif#my_mgvi_platform
endif#LOCAL_MODULE_MAKEFILE
endif#LOCAL_PROPRIETARY_MODULE
endif#LOCAL_MODULE_CLASS
endif#MTK_SPLIT_BUILD_LAYERS


# Vendor snapshot
ifndef LOCAL_IS_HOST_MODULE
ifneq ($(LOCAL_MODULE_MAKEFILE),$(SOONG_ANDROID_MK))
ifeq ($(LOCAL_PROPRIETARY_MODULE),true)

  vsdk_hook := true
  ifneq ($(filter device/% vendor/%,$(LOCAL_PATH)),)
    vsdk_hook :=
  else ifneq ($(filter hardware/%,$(LOCAL_PATH)),)
    ifneq ($(filter hardware/interfaces/% hardware/libhardware/% hardware/libhardware_legacy/%,$(LOCAL_PATH)),)
    else
      vsdk_hook :=
    endif
  endif
  ifeq ($(vsdk_hook),true)




    vsdk_path :=
    vsdk_suffix :=
    ifneq ($(filter EXECUTABLES,$(LOCAL_MODULE_CLASS)),)
      vsdk_path := binary
      VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)BINARY_MODULES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)BINARY_MODULES) $(my_register_name)
    endif
    ifneq ($(filter SHARED_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
      vsdk_path := shared
      vsdk_suffix := .so
      VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)SHARED_MODULES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)SHARED_MODULES) $(my_register_name)
    endif
    ifneq ($(filter STATIC_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
      vsdk_path := static
      vsdk_suffix := .a
      VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)STATIC_MODULES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)STATIC_MODULES) $(my_register_name)
    endif
    ifneq ($(filter HEADER_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
      vsdk_path := header
    endif
    ifneq ($(vsdk_path),)
      json_text := "ModuleName":"$(LOCAL_MODULE)"
      ifneq ($(filter SHARED_LIBRARIES STATIC_LIBRARIES HEADER_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
        ifneq ($(LOCAL_EXPORT_C_INCLUDE_DIRS),)
          json_text := $(json_text)$(comma)"ExportedDirs":[$(strip $(foreach i,$(LOCAL_EXPORT_C_INCLUDE_DIRS),"$(i)"$(comma)))]
          VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)INCLUDE_DIRS := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)INCLUDE_DIRS) $(LOCAL_EXPORT_C_INCLUDE_DIRS)
        endif
      endif
      ifneq ($(filter EXECUTABLES SHARED_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
        ifneq ($(LOCAL_MODULE_RELATIVE_PATH),)
          json_text := $(json_text)$(comma)"RelativeInstallPath":"$(LOCAL_MODULE_RELATIVE_PATH)"
        endif
        ifneq ($(LOCAL_SHARED_LIBRARIES),)
          json_text := $(json_text)$(comma)"SharedLibs":[$(strip $(foreach i,$(LOCAL_SHARED_LIBRARIES),"$(i)"$(comma)))]
        endif
      endif
      ifneq ($(filter EXECUTABLES,$(LOCAL_MODULE_CLASS)),)
        my_init_rc := $(LOCAL_INIT_RC_$(my_32_64_bit_suffix)) $(LOCAL_INIT_RC)
        ifneq ($(strip $(my_init_rc)),)
          json_text := $(json_text)$(comma)"InitRc":[$(strip $(foreach rc,$(my_init_rc),"configs/$(notdir $(rc))"$(comma)))]
          VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)CONFIGS_FILES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)CONFIGS_FILES) $(addprefix $(LOCAL_PATH)/,$(my_init_rc))
        endif
        ifneq ($(LOCAL_VINTF_FRAGMENTS),)
          json_text := $(json_text)$(comma)"VintfFragments":[$(strip $(foreach xml,$(LOCAL_VINTF_FRAGMENTS),"configs/$(notdir $(xml))"$(comma)))]
          VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)CONFIGS_FILES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)CONFIGS_FILES) $(addprefix $(LOCAL_PATH)/,$(LOCAL_VINTF_FRAGMENTS))
        endif
      endif
      vsdk_intermediates := $(call intermediates-dir-for,PACKAGING,vendor_snapshot_vsdk)
      vsdk_json_filename := $(vsdk_intermediates)/$(TARGET_$(LOCAL_2ND_ARCH_VAR_PREFIX)ARCH)/$(vsdk_path)/$(LOCAL_MODULE)$(vsdk_suffix).json
      VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)JSON_FILES := $(VSDK_$(LOCAL_2ND_ARCH_VAR_PREFIX)JSON_FILES) $(vsdk_json_filename)
$(vsdk_json_filename): private_text := {$(subst $(comma)],],$(json_text))}
$(vsdk_json_filename):
	@mkdir -p $(dir $@)
	@echo '$(private_text)' > $@

    endif#vsdk_path
  endif#vsdk_hook
endif
endif
endif

ifndef LOCAL_IS_HOST_MODULE
ifneq ($(LOCAL_MODULE_MAKEFILE),$(SOONG_ANDROID_MK))
ifneq ($(BOARD_VNDK_VERSION),current)
ifeq ($(LOCAL_VENDOR_MODULE),true)
ifneq ($(LOCAL_USE_VNDK), true)
  # TODO
  SOONG_VENDOR_SNAPSHOT_VSDK_MODULES := $(SOONG_VENDOR_SNAPSHOT_VSDK_MODULES) $(LOCAL_MODULE)
endif
endif
endif
endif
endif
