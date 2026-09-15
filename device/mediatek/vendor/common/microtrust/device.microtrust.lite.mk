PRODUCT_PACKAGES += keystore.itrusty
PRODUCT_PACKAGES += istorageproxyd
PRODUCT_PACKAGES += libitrusty
PRODUCT_PACKAGES += kmsetkey.itrusty
PRODUCT_PACKAGES += teei_loader
PRODUCT_PACKAGES += isee_product.cfg
PRODUCT_PACKAGES += TAs_list
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_microtrust_tee_support=1
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.gatekeeper=itrusty
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.keystore=itrusty
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.kmsetkey=itrusty

ifeq ($(strip $(MICROTRUST_THH_SUPPORT)), yes)
  PRODUCT_PACKAGES += init_thh
endif
