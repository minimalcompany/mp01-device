TARGET_BOARD_PLATFORM ?= mt6789

# device/mediatek/mt6789/device.mk
PRODUCT_PACKAGES += mtk_msr.ko
PRODUCT_PACKAGES += cpu_stress_cache_miss.ko
PRODUCT_PACKAGES += cpu_stress_dhry.ko
PRODUCT_PACKAGES += cpu_stress_maxpower.ko
PRODUCT_PACKAGES += cpu_stress_maxpower_L2.ko
PRODUCT_PACKAGES += cpu_stress_maxpower_L3.ko
PRODUCT_PACKAGES += cpu_stress_maxtrans.ko
PRODUCT_PACKAGES += cpu_stress_saxpy.ko

# PRODUCT_PACKAGES += met.ko
# PRODUCT_PACKAGES += met_plf.ko

ifeq ($(LINUX_KERNEL_VERSION),kernel-4.14)
PRODUCT_PACKAGES += fpsgo-user.ko fpsgo-eng.ko
PRODUCT_PACKAGES += fpsgo.ko
endif

$(call inherit-product, device/mediatek/vendor/common/device-kernel.mk)
