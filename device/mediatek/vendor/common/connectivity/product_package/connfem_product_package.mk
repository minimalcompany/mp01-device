# ConnFem Configuration
ENABLE_KBUILD := true
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.14)
	ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.19)
	ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-4.19-lc)
	ENABLE_KBUILD := false
endif
ifeq ($(LINUX_KERNEL_VERSION), kernel-5.4)
	ENABLE_KBUILD := false
endif

ifeq ($(ENABLE_KBUILD), true)
	PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/connfem/init.connfem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.connfem.rc
endif

PRODUCT_PACKAGES += libconnfem
PRODUCT_PACKAGES += connfem_test

ifeq ($(ENABLE_KBUILD), false)
	PRODUCT_PACKAGES += connfem.ko
endif
