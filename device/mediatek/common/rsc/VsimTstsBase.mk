#VSIM treble SIM
MTK_RSC_VENDOR_PROPERTIES += \
    persist.vendor.radio.msimmode=tsts \
    ro.vendor.radio.max.multisim=tsts \
    persist.vendor.mims_support=2 \
    persist.vendor.radio.smart.data.switch=1 \
    ro.vendor.mtk_disable_cap_switch=0 \
    ro.vendor.mtk_data_config=1 \
    ro.vendor.num_md_protocol=3 \
    ro.vendor.mtk_external_sim_support=1 \
    ro.vendor.mtk_external_sim_only_slots=4 \
    ro.vendor.mtk_non_dsda_rsim_support=1

MTK_RSC_SYSTEM_PROPERTIES += \
    persist.radio.multisim.config=tsts \
    ro.telephony.sim.count=3 \
    telephony.active_modems.max_count=3 \
    ro.boot.product.hardware.sku=tsts
