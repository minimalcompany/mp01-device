ifneq ($(strip $(VENDOR_OPTR_BASE_DEFINE)),yes)
    VENDOR_OPTR_BASE_DEFINE := yes
    ifndef my_rsc_script_path
        ifneq ($(wildcard vendor/mediatek/proprietary/operator/hardware/ril/fusion/Android.mk),)
            PRODUCT_PACKAGES += libmtk-rilop
            PRODUCT_PACKAGES += libmtkmipc-rilop
            # Telephony library for op sw decouple
            ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), ss)
              DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_ss.xml
            endif
            ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsds)
              DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_dsds.xml
            endif
            ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), dsda)
              DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_dsds.xml
            endif
            ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), tsts)
              ifeq ($(strip $(MTK_EXTERNAL_SIM_RSIM_ENHANCEMENT)), yes)
                DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_dsds.xml
              else
                DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_tsts.xml
              endif
            endif
            ifeq ($(strip $(MTK_MULTI_SIM_SUPPORT)), qsqs)
              DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/project_manifest/manifest_op_qsqs.xml
            endif
        endif
    endif
endif
