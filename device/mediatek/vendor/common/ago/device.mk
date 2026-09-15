#From O, project with less than 1G memory, must set prop ro.config.low_ram=true
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_config_max_dram_size=$(CUSTOM_CONFIG_MAX_DRAM_SIZE)

ifeq (yes,$(strip $(MTK_GMO_RAM_OPTIMIZE)))
    $(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.gmo.ram_optimize=1
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/fstab.enableswap_ago:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.enableswap:mtk

    # Disable gesture nav
    #PRODUCT_PACKAGES += NoNavigationBarModeGestural

    # FIX PSI to avoid high kswapd
    PRODUCT_PROPERTY_OVERRIDES += ro.lmk.psi_partial_stall_ms=150
    PRODUCT_PROPERTY_OVERRIDES += ro.lmk.psi_complete_stall_ms=550
    PRODUCT_PROPERTY_OVERRIDES += ro.lmk.kill_timeout_ms=100

    # For the new devices shipped we would use go_handheld_core_hardware.xml and
    # previously launched devices should continue using handheld_core_hardware.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/go_handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

    AGO_DRAM_LIMIT := $(shell printf "%d" 0xC0000000)
    CUR_DRAM_SIZE := $(shell printf "%d" $(CUSTOM_CONFIG_MAX_DRAM_SIZE))
    ifeq ($(shell test $(CUR_DRAM_SIZE) -le $(AGO_DRAM_LIMIT) && echo true), true)
        PRODUCT_PROPERTY_OVERRIDES += \
            ro.zram.mark_idle_delay_mins=30 \
            ro.zram.first_wb_delay_mins=120 \
            ro.zram.periodic_wb_delay_hours=24
        ifneq ($(filter yes,$(BUILD_AGO_GMS) $(MTK_GMO_RAM_OPTIMIZE)),)
            $(call inherit-product, $(SRC_TARGET_DIR)/product/go_defaults.mk)
        endif
      ifdef MTK_TARGET_VENDOR_RC
        PRODUCT_COPY_FILES += device/mediatek/vendor/common/ago/init/init.ago_default.rc:$(MTK_TARGET_VENDOR_RC)/init.ago.rc
      endif
    endif

    ifeq ($(strip $(MTK_K64_SUPPORT)), no)
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote32
    endif

    # Force android.hardware.cas@1.1 to be lazy for AGO project
    PRODUCT_PACKAGES += android.hardware.cas@1.2-service-lazy

    # Reduces GC frequency of foreground apps by 50%.
    # This change will increase RAM usage by at least a few MB and is not recommended for 512MB devices.
    ifneq (0x20000000,$(strip $(CUSTOM_CONFIG_MAX_DRAM_SIZE)))
        PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.foreground-heap-growth-multiplier=2.0
    endif

    # Add f2fs property to enable f2fs service
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_f2fs_enable=1

    # For GSI invisible mkd properties
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
         ro.lmk.kill_heaviest_task=false

    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
         pm.dexopt.downgrade_after_inactive_days=10

    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
         pm.dexopt.shared=quicken

    # Disable fast starting window in GMO project
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.mtk_perf_fast_start_win=0

    # Add ago vm heap parameter
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=128m
    PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=256m

    # Disable USAP pool
    PRODUCT_PRODUCT_PROPERTIES += persist.device_config.runtime_native.usap_pool_enabled=false

    # EM dynamic debugcontrol
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.vendor.em.dy.debug=1

    #Images for LCD test in factory mode
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/custom/common/factory/res/images/lcd_test_00_gmo.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_00.png:mtk
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/custom/common/factory/res/images/lcd_test_01_gmo.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_01.png:mtk
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/custom/common/factory/res/images/lcd_test_02_gmo.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_02.png:mtk

    #inherit common vendor
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml
else
    #non-ago settings
    # Force android.hardware.cas@1.2 to be lazy for Phone project
    PRODUCT_PACKAGES += android.hardware.cas@1.2-service-lazy

    # Add for Automatic Setting for heapgrowthlimit & heapsize
    RESOLUTION_HXW := $(shell expr $(LCM_HEIGHT) \* $(LCM_WIDTH))

    ifeq ($(shell test $(RESOLUTION_HXW) -ge 0 && test $(RESOLUTION_HXW) -lt 3500000 && echo true), true)
        PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=256m
        PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=512m
    endif

    ifeq ($(shell test $(RESOLUTION_HXW) -ge 3500000 && echo true), true)
        PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=384m
        PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=768m
    endif

    # $(call inherit-product, ($SRC_TARGET_DIR)/product/full_base.mk)

    # Handheld core hardware: Default
    PRODUCT_COPY_FILES += frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

    PRODUCT_COPY_FILES += device/mediatek/vendor/common/fstab.enableswap:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.enableswap:mtk
  ifdef MTK_TARGET_VENDOR_RC
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/ago/init/init.default.rc:$(MTK_TARGET_VENDOR_RC)/init.ago.rc
  endif
    # Add the 1GB overlays (to enable pinning on 1GB but not 512)
#    DEVICE_PACKAGE_OVERLAYS += device/mediatek/vendor/common/overlay/ago/ago_1gb

    # F2FS filesystem
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_f2fs_enable?=0
endif

