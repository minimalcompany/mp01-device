# For Layer decoupling 2.0
# ConnFem Configuration for project

MTK_OUT_OF_TREE_KERNEL_MODULES += connfem.ko

PRODUCT_COPY_FILES += vendor/mediatek/kernel_modules/connectivity/connfem/init.connfem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.connfem.rc

# Do NOT modify below this line
ifneq ($(KRN_TARGET_PROJECT),)
PRODUCT_PACKAGES := $(MTK_OUT_OF_TREE_KERNEL_MODULES)
endif
