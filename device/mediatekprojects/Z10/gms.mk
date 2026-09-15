###############################################################################
# GMS home folder location
# Note: we cannot use $(my-dir) in this makefile
ANDROID_PARTNER_GMS_HOME := vendor/google

$(call inherit-product, build/target/product/product_launched_with_p.mk)
# Android Build system uncompresses DEX files (classes*.dex) in the privileged
# apps by default, which breaks APK v2/v3 signature. Because some privileged
# GMS apps are still shipped with compressed DEX, we need to disable
# uncompression feature to make them work correctly.
  DONT_UNCOMPRESS_PRIV_APPS_DEXS := true

# GMS mandatory core packages
GMS_PRODUCT_PACKAGES += \
    AndroidPlatformServices \
    ConfigUpdater \
    GoogleExtShared \
    GoogleFeedback \
    GoogleLocationHistory \
    GoogleOneTimeInitializer \
    GooglePackageInstaller \
    GooglePartnerSetup \
    GooglePrintRecommendationService \
    GoogleRestore \
    GoogleServicesFramework \
    GoogleCalendarSyncAdapter \
    GoogleContactsSyncAdapter \
    SpeechServicesByGoogle \
    GmsCore \
    Phonesky \
    WebViewGoogle \
    Wellbeing

# GMS common RRO packages
GMS_PRODUCT_PACKAGES += GmsConfigOverlayCommon GmsConfigOverlayGSA

# GMS optional RRO packages
GMS_PRODUCT_PACKAGES += GmsConfigOverlayGeotz

# GMS common configuration files
GMS_PRODUCT_PACKAGES += \
    play_store_fsi_cert \
    gms_fsverity_cert \
    default_permissions_allowlist_google \
    privapp_permissions_google_system \
    privapp_permissions_google_product \
    privapp_permissions_google_system_ext \
    split_permissions_google \
    preferred_apps_google \
    sysconfig_google \
    sysconfig_wellbeing \
    sysconfig_d2d_cable_migration_feature \
    google_hiddenapi_package_allowlist \
    sysconfig_gmsexpress

#pre-load turbo
#$(call inherit-product-if-exists, vendor/google/products/turbo.mk)

# Overlay for GMS devices: default backup transport in SettingsProvider
ifeq ($(strip $(MTK_PRODUCT_LINE)),tablet)
    PRODUCT_PACKAGE_OVERLAYS += $(ANDROID_PARTNER_GMS_HOME)/overlay/gms_overlay_tablet
else
    PRODUCT_PACKAGE_OVERLAYS += $(ANDROID_PARTNER_GMS_HOME)/overlay/gms_overlay
endif

# GMS mandatory application packages
GMS_PRODUCT_PACKAGES += \
    Chrome \
    Drive \
    Gmail2 \
    Duo \
    Maps \
    YTMusic \
    Photos \
    Velvet \
    Videos \
    YouTube \
    AssistantShell

#add for GKS
ifeq ($(strip $(MTK_PRODUCT_LINE)),tablet)
GMS_PRODUCT_PACKAGES += \
    GoogleKidsSpace \
    YouTubeKids \
    Books
endif

#add GKS feature flag
ifeq ($(strip $(MTK_PRODUCT_LINE)),tablet)
GMS_PRODUCT_PACKAGES += \
    sysconfig_gks
endif

# GMS comms suite
$(call inherit-product, $(ANDROID_PARTNER_GMS_HOME)/products/google_comms_suite.mk)

# GMS optional application packages
GMS_PRODUCT_PACKAGES += \
    CalendarGoogle \
    TagGoogle \
    talkback \
    LatinImeGoogle

GMS_PRODUCT_PACKAGES += \
    FilesGoogle

ifneq ($(PLATFORM_SDK_VERSION),32)
GMS_PRODUCT_PACKAGES += \
    SearchLauncherQuickStep
endif

# Add GMS package into system product packages
PRODUCT_PACKAGES += $(GMS_PRODUCT_PACKAGES)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.threebutton;com.android.theme.icon.squircle

# Add acsa property for CarrierServices
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.acsa=true

include $(ANDROID_PARTNER_GMS_HOME)/products/gms_package_version.mk

PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.rotation_locked=true \
    setupwizard.theme=glif_v3_light \
    ro.opa.eligible_device=true \
    ro.com.google.gmsversion=$(GMS_PACKAGE_VERSION_ID)
