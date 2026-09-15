# This RSC only need config in vendor
MTK_RSC_VENDOR_ONLY := true

# For CTA requirement
MTK_RSC_VENDOR_PROPERTIES += ro.vendor.mtk_cta_support=1

# optional: inherit from base makefile if needed
include device/mediatek/vendor/common/rsc/OmBase.mk
