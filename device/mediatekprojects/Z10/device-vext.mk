PRODUCT_PROPERTY_OVERRIDES :=
PRODUCT_COPY_FILES :=
MTK_OUT_OF_TREE_KERNEL_MODULES :=

PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.mtkgki.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mtkgki.rc
PRODUCT_COPY_FILES += $(LOCAL_PATH)/factory_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.project.rc
PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.project.rc
PRODUCT_COPY_FILES += $(LOCAL_PATH)/meta_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.project.rc
PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.insmod.mt6789.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.mt6789.cfg
#oca72390-fw:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/oca72390_fw/ocs72xxx_cf.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ocs72xxx_cf.bin

#oca72390-params:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/oca72390_params/ocs_params.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ocs_params.bin
#oca72390-lib32:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/oca72390_lib32/ocs_lib_for_hal.so:$(TARGET_COPY_OUT_VENDOR)/lib/hw/ocs_lib_for_hal.so
#oca72390-lib64:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/oca72390_lib64/ocs_lib_for_hal_64.so:$(TARGET_COPY_OUT_VENDOR)/lib64/hw/ocs_lib_for_hal_64.so

#CPS4021-bl:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/cps4021_bl/CPS4021_BL.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/CPS4021_BL.bin
#CPS4021-fw:
PRODUCT_COPY_FILES += $(LOCAL_PATH)/cps4021_fw/CPS4021.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/CPS4021.bin

PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density ?= 180

# for hwcomposer 2.1
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.composer_version=2.1

ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  ifneq ($(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)),V1)
    MTK_AUDIO_PARAM_DIR_LIST += $(MTK_TARGET_PROJECT_FOLDER)/audio_param
  endif
endif

#
$(call inherit-product, device/mediatek/mt6789/device-vext.mk)
$(call inherit-product, device/mediatek/vendor/common/project_hal_mk/hwcomposer_2_1.mk)
