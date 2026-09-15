PLATFORM_VERSION_MAJOR := $(word 1, $(subst ., $(space), $(PLATFORM_VERSION)))
MICROTRUST_TEE_VERSION ?= 400
MICROTRUST_SRC_DIR := vendor/mediatek/proprietary/trustzone/microtrust/source/common/$(MICROTRUST_TEE_VERSION)/teei

ifeq ($(shell expr $(PLATFORM_VERSION_MAJOR) \>= 7), 1)
MICROTRUST_OUT_VENDOR_DIR := $(TARGET_COPY_OUT_VENDOR)/thh
VENDOR_TAG := :mtk

ifneq ($(strip $(MICROTRUST_TEE_MIN_MEM_SUPPORT)), yes)
TARGET_COPY_OUT_ALIPAY_TA := $(MICROTRUST_OUT_VENDOR_DIR)/ta/08010203000000000000000000000000.ta$(VENDOR_TAG)
TARGET_COPY_OUT_FP_SERVER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/7778c03fc30c4dd0a319ea29643d4d4b.ta$(VENDOR_TAG)
TARGET_COPY_OUT_SPI_SERVER:= $(MICROTRUST_OUT_VENDOR_DIR)/ta/93feffccd8ca11e796c7c7a21acb4932.ta$(VENDOR_TAG)
TARGET_COPY_OUT_INIT_THH  := $(TARGET_COPY_OUT_VENDOR)/bin/init_thh$(VENDOR_TAG)
TARGET_COPY_OUT_UTAGENT   := $(MICROTRUST_OUT_VENDOR_DIR)/ta/0102030405060708090a0b0c0d0e0f10.ta$(VENDOR_TAG)
TARGET_COPY_OUT_OTRP_SERVER   := $(MICROTRUST_OUT_VENDOR_DIR)/ta/22e039bbf7364adca2a732e76a1533cc.ta$(VENDOR_TAG)
TARGET_COPY_OUT_WECHAT   := $(MICROTRUST_OUT_VENDOR_DIR)/ta/d78d338b1ac349e09f65f4efe179739d.ta$(VENDOR_TAG)
endif

TARGET_COPY_OUT_KM3_SERVER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/b09c9c5daa504b78b0e46eda61556c3a.ta$(VENDOR_TAG)
TARGET_COPY_OUT_KM_SERVER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/c09c9c5daa504b78b0e46eda61556c3a.ta$(VENDOR_TAG)
TARGET_COPY_OUT_KM_KEY_MANAGER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/d91f322ad5a441d5955110eda3272fc0.ta$(VENDOR_TAG)
TARGET_COPY_OUT_GK_SERVER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/c1882f2d885e4e13a8c8e2622461b2fa.ta$(VENDOR_TAG)
PRODUCT_PACKAGES += libmtee
else
MICROTRUST_OUT_VENDOR_DIR := system/thh
VENDOR_TAG :=
TARGET_COPY_OUT_ALIPAY_TA := $(MICROTRUST_OUT_VENDOR_DIR)/ta/alipayapp$(VENDOR_TAG)
TARGET_COPY_OUT_FP_SERVER := $(MICROTRUST_OUT_VENDOR_DIR)/ta/fp_server$(VENDOR_TAG)
TARGET_COPY_OUT_INIT_THH  := $(TARGET_COPY_OUT_VENDOR)/bin/init_thh$(VENDOR_TAG)
TARGET_COPY_OUT_UTAGENT   := $(MICROTRUST_OUT_VENDOR_DIR)/ta/uTAgent$(VENDOR_TAG)
TARGET_COPY_OUT_WECHAT    := $(MICROTRUST_OUT_VENDOR_DIR)/ta/d78d338b1ac349e09f65f4efe179739d.ta$(VENDOR_TAG)
endif

ifneq ($(filter yes, $(MTK_SOTER_SUPPORT) $(MICROTRUST_WECHAT_SUPPORT)),)
PRODUCT_PACKAGES += wechat.beanpod
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.wechat=beanpod
endif

PRODUCT_PACKAGES += teei_daemon
PRODUCT_PACKAGES += libteei_daemon_vfs
PRODUCT_PACKAGES += bp_kmsetkey_ca
PRODUCT_PACKAGES += libTEECommon
PRODUCT_PACKAGES += kmsetkey.beanpod
PRODUCT_PACKAGES += gatekeeper.beanpod
ifeq ($(strip $(KEYMASTER_VERSION)), 5.0)
PRODUCT_PACKAGES += keymint_server
else
PRODUCT_PACKAGES += keymaster_server4
endif
PRODUCT_PACKAGES += gatekeeper_server
PRODUCT_PACKAGES += km_key_manager_ta
PRODUCT_PACKAGES += isee_model.json
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.kmsetkey=beanpod
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gatekeeper=beanpod

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_microtrust_tee_support=1

ifneq ($(strip $(MICROTRUST_TEE_MIN_MEM_SUPPORT)), yes)
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/tee:$(MICROTRUST_OUT_VENDOR_DIR)/tee$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/inner_1:$(MICROTRUST_OUT_VENDOR_DIR)/inner_1$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/inner_2:$(MICROTRUST_OUT_VENDOR_DIR)/inner_2$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/tui:$(MICROTRUST_OUT_VENDOR_DIR)/tui$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/fido:$(MICROTRUST_OUT_VENDOR_DIR)/fido$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_pa:$(MICROTRUST_OUT_VENDOR_DIR)/general_pa$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_storage:$(MICROTRUST_OUT_VENDOR_DIR)/general_storage$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_antitheft:$(MICROTRUST_OUT_VENDOR_DIR)/general_antitheft$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_antiroot:$(MICROTRUST_OUT_VENDOR_DIR)/general_antiroot$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_antivirus:$(MICROTRUST_OUT_VENDOR_DIR)/general_antivirus$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_reserved1:$(MICROTRUST_OUT_VENDOR_DIR)/general_reserved1$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/general_reserved2:$(MICROTRUST_OUT_VENDOR_DIR)/general_reserved2$(VENDOR_TAG))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/fp_server:$(TARGET_COPY_OUT_FP_SERVER))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/init_thh:$(TARGET_COPY_OUT_INIT_THH))
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/uTAgent:$(TARGET_COPY_OUT_UTAGENT))
ifeq ($(strip $(MICROTRUST_FINGERPRINT_SUPPORT)), yes)
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/93feffccd8ca11e796c7c7a21acb4932.ta:$(TARGET_COPY_OUT_SPI_SERVER))
endif
ifeq ($(strip $(MICROTRUST_OTRP_SUPPORT)), yes)
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
  $(MICROTRUST_SRC_DIR)/otrp_server:$(TARGET_COPY_OUT_OTRP_SERVER))
endif
ifeq ($(strip $(MICROTRUST_TUI_SUPPORT)), yes)
ifeq ($(shell expr $(PLATFORM_VERSION_MAJOR) \>= 8), 1)
PRODUCT_PACKAGES += utr_tui_manager libutr_tui_tac libutr_tui_jni vendor.microtrust.hardware.tui@2.0-service
else
PRODUCT_PACKAGES += utr_tui_manager utr_tui_daemon libutr_tui_tac libutr_tui_jni libutr_tui_daemon
endif
endif
ifeq ($(strip $(MICROTRUST_IFAA_SUPPORT)), yes)
  PRODUCT_PACKAGES += libteeclientjni ifaa_service vendor.microtrust.hardware.ifaa@2.0-service
endif
ifeq ($(strip $(MICROTRUST_THH_SUPPORT)), yes)
  PRODUCT_PACKAGES += libthhclient
  PRODUCT_PACKAGES += vendor.microtrust.hardware.thh@2.0-service
  PRODUCT_PACKAGES += init_thh
endif
ifeq ($(strip $(MICROTRUST_WECHAT_SUPPORT)), yes)
  PRODUCT_PACKAGES += wechat.beanpod
  PRODUCT_PROPERTY_OVERRIDES += ro.hardware.wechat=beanpod
  PRODUCT_PACKAGES += vendor.microtrust.hardware.soter@1.0-service \
                        vendor.microtrust.hardware.soter@1.0-impl \
                        sotertestca \
                        SoterService \
                        SoterServiceApp
endif

endif #end of MICROTRUST_TEE_MIN_MEM_SUPPORT = no

ifeq ($(strip $(MICROTRUST_TEE_FINGERPRINT_SUPPORT)), yes)
     #DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/mediatek/common/androidP_beanpod_pay_pkg/compatibility_matrix.xml
     include device/mediatek/vendor/common/swfp.mk
endif
