# Based on OM project
include device/mediatek/vendor/common/rsc/OmBase.mk

# ----------------------------------------------------------------------------
# Diagnostic Monitoring Collector(DMC) Framework
# ----------------------------------------------------------------------------
# [Vendor Partition]
MTK_RSC_VENDOR_PROPERTIES += \
    ro.vendor.mtk_dmc_support=1

MTK_RSC_MODULES += \
    dmc_core \
    mtk_pkm_service \
    libapmonitor_vendor \
    libpkm

# HIDL manifest
ifneq ($(findstring manifest_dmc.xml, $(DEVICE_MANIFEST_FILE)), manifest_dmc.xml)
    DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_dmc.xml
endif

ifneq ($(findstring manifest_apmonitor.xml, $(DEVICE_MANIFEST_FILE)), manifest_apmonitor.xml)
    DEVICE_MANIFEST_FILE += device/mediatek/common/project_manifest/manifest_apmonitor.xml
endif

