PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_hwcomposer_2_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_hwcomposer.xml
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/android.hardware.graphics.composer@2.3-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.3-service.rc

# We will pack multiple composer service so to MGVI when LD2.0, so we need to delete the rc files that is not used by the platform
ifdef MTK_GENERIC_HAL
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.1-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.1-service.rc
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.2-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.2-service.rc
PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_hal_rc/empty/android.hardware.graphics.composer@2.4-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.composer@2.4-service.rc
endif
