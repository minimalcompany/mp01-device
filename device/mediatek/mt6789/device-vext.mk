TARGET_BOARD_PLATFORM := mt6789
MTK_TARGET_VENDOR_RC = $(TARGET_COPY_OUT_VENDOR)/etc/init/hw
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.rc=/vendor/etc/init/hw/

ifneq ($(strip $(TARGET_BUILD_VARIANT)),user)
    PRODUCT_SET_DEBUGFS_RESTRICTIONS := false
endif

PRODUCT_PACKAGES += selinux_policy_nonsystem

# device/mediatek/mt6789/device.mk
#MTK_OUT_OF_TREE_KERNEL_MODULES += mtk_msr.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_cache_miss.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_dhry.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_maxpower.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_maxpower_L2.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_maxpower_L3.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_maxtrans.ko
#MTK_OUT_OF_TREE_KERNEL_MODULES += cpu_stress_saxpy.ko
# PRODUCT_PACKAGES += met.ko
# PRODUCT_PACKAGES += met_plf.ko
MTK_OUT_OF_TREE_KERNEL_MODULES += fpsgo-user.ko fpsgo-eng.ko
MTK_OUT_OF_TREE_KERNEL_MODULES += fpsgo.ko

# remosaic
PRODUCT_PACKAGES += libremosaiclib

PRODUCT_PACKAGES += fstab.mt6789
PRODUCT_PACKAGES += fstab.mt6789.ramdisk
PRODUCT_PACKAGES += fstab.emmc
PRODUCT_PACKAGES += fstab.emmc.ramdisk

# thermal policy
PRODUCT_PACKAGES += thermal.conf
PRODUCT_PACKAGES += disable_thermal.conf
PRODUCT_PACKAGES += disable_thermal_temp.conf
PRODUCT_PACKAGES += disable_throttling.conf
PRODUCT_PACKAGES += disable_skin_control.conf
PRODUCT_PACKAGES += thermal_policy_00.conf
PRODUCT_PACKAGES += thermal_policy_02.conf
PRODUCT_PACKAGES += thermal_policy_08.conf
PRODUCT_PACKAGES += thermal_mtbf.conf

ifneq ($(PRODUCT_USERDATAIMAGE_FILE_SYSTEM_TYPE_EXT4), true)
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_f2fs_enable=1
endif
# A2DP Offload property
PRODUCT_PROPERTY_OVERRIDES += ro.bluetooth.a2dp_offload.supported?=true
PRODUCT_PROPERTY_OVERRIDES += persist.bluetooth.a2dp_offload.cap?=sbc-aac
PRODUCT_PROPERTY_OVERRIDES += persist.bluetooth.a2dp_offload.disabled?=true

#Kill Switch or FRP FO
ifeq ($(strip $(MTK_FACTORY_RESET_PROTECTION_SUPPORT)),yes)
ifneq ($(filter yes,$(MTK_EMMC_SUPPORT) $(MTK_UFS_SUPPORT)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/frp
endif
endif

# GPU
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.vulkan.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml
PRODUCT_PROPERTY_OVERRIDES += ro.opengles.version=196610
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.vulkan?=mali
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl?=mali
PRODUCT_SOONG_NAMESPACES += vendor/mediatek/proprietary/hardware/gpu_mali/mali_valhall
PRODUCT_SOONG_NAMESPACES += vendor/mediatek/proprietary/hardware/gpu_mali/mali_valhall/r32p1-00bet0
PRODUCT_PROPERTY_OVERRIDES += graphics.gpu.profiler.support=true
PRODUCT_PROPERTY_OVERRIDES += ro.gfx.driver.0=com.mediatek.mt6789.gamedriver
PRODUCT_PACKAGES += GpuGameDriver.mt6789

ifneq ($(filter yes,$(MTK_EMMC_SUPPORT) $(MTK_UFS_SUPPORT)),)
  PRODUCT_COPY_FILES += device/mediatek/mt6789/ueventd.mt6789.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc
endif

# GPS relative file
ifeq ($(MTK_GPS_SUPPORT),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml
endif

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml
ifeq (yes,$(strip $(MTK_BT_SUPPORT)))
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml
endif
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PROPERTY_OVERRIDES += vendor.camera.mdp.dre.enable=1
PRODUCT_PROPERTY_OVERRIDES += vendor.camera.mdp.cz.enable=1


ifeq ($(strip $(MTK_CAM_FD_SUPPORT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.directfdyuv.support=1
endif
PRODUCT_PROPERTY_OVERRIDES += vendor.mtk.camera.app.fd.video=1

# camera hal3 default buffer count for fd yuv.
# Enlarge the buffer number if fdyuv buffers are shared with aiawb.
ifeq ($(strip $(MTK_CAM_AIAWB_SUPPORT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.high_ram.fdyuv=6
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.camera3.pipeline.bufnum.min.low_ram.fdyuv=6
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT6620)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=1
  endif
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT6628)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=1
  endif
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT3332)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=0
  endif
endif

PRODUCT_COPY_FILES += $(LOCAL_PATH)/MNL_Config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/MNL_Config.xml:mtk


ifeq (MT6620_FM,$(strip $(MTK_FM_CHIP)))
  PRODUCT_PROPERTY_OVERRIDES += fmradio.driver.chip=1
endif

ifeq (MT6626_FM,$(strip $(MTK_FM_CHIP)))
  PRODUCT_PROPERTY_OVERRIDES += fmradio.driver.chip=2
endif

ifeq (MT6628_FM,$(strip $(MTK_FM_CHIP)))
  PRODUCT_PROPERTY_OVERRIDES += fmradio.driver.chip=3
endif

ifneq ($(strip $(MTK_LOCKSCREEN_TYPE)),)
  PRODUCT_PROPERTY_OVERRIDES += curlockscreen=$(MTK_LOCKSCREEN_TYPE)
endif

# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1


ifeq (yes,$(strip $(MTK_FD_SUPPORT)))
  # Only support the format: n.m (n:1 or 1+ digits, m:Only 1 digit) or n (n:integer)
  # Time Unit:0.1 sec
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.fd.counter=150
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.fd.off.counter=50
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.fd.r8.counter=150
  PRODUCT_PROPERTY_OVERRIDES += persist.vendor.radio.fd.off.r8.counter=50
endif

# for USB Accessory Library/permission
# Mark for early porting in JB
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml
PRODUCT_PACKAGES += com.android.future.usb.accessory

# System property for MediaTek ANR pre-dump.
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.mtk-stack-trace-file=/data/anr/mtk_traces.txt

ifeq ($(strip $(MTK_FACTORY_RESET_PROTECTION_SUPPORT)),yes)
ifneq ($(filter yes,$(MTK_EMMC_SUPPORT) $(MTK_UFS_SUPPORT)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/frp
endif
endif

PRODUCT_COPY_FILES += device/mediatek/mt6789/init.mt6789.rc:$(MTK_TARGET_VENDOR_RC)/init.mt6789.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/factory_init.rc:$(MTK_TARGET_VENDOR_RC)/factory_init.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/init.modem.rc:$(MTK_TARGET_VENDOR_RC)/init.modem.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/meta_init.modem.rc:$(MTK_TARGET_VENDOR_RC)/meta_init.modem.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/meta_init.rc:$(MTK_TARGET_VENDOR_RC)/meta_init.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/init.mt6789.usb.rc:$(MTK_TARGET_VENDOR_RC)/init.mt6789.usb.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/init.recovery.mt6789.rc:recovery/root/init.recovery.mt6789.rc
PRODUCT_COPY_FILES += device/mediatek/mt6789/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/egl/egl.cfg:mtk
PRODUCT_COPY_FILES += device/mediatek/mt6789/init.cgroup-$(LINUX_KERNEL_VERSION).rc:$(MTK_TARGET_VENDOR_RC)/init.cgroup.rc

ifneq ($(strip $(MTK_EMMC_SUPPORT)), yes)
ifneq ($(strip $(MTK_UFS_SUPPORT)),yes)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab.mt6789.nand:root/fstab.mt6789
endif
endif


PRODUCT_COPY_FILES += $(LOCAL_PATH)/partition_permission.sh:$(TARGET_COPY_OUT_VENDOR)/etc/partition_permission.sh:mtk
PRODUCT_COPY_FILES += $(LOCAL_PATH)/throttle.sh:$(TARGET_COPY_OUT_VENDOR)/etc/throttle.sh:mtk

ifeq (0x100000000,$(strip $(CUSTOM_CONFIG_MAX_DRAM_SIZE)))
    PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/media_codecs_c2_4g.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml:mtk
    PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/mtk_platform_codecs_config_4g.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_platform_codecs_config.xml:mtk
else
    PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/media_codecs_c2_svp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml:mtk
    PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/mtk_platform_codecs_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_platform_codecs_config.xml:mtk
endif

ifneq ($(MTK_BASIC_PACKAGE), yes)
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/libc2/service/android.hardware.media.c2@1.2-mediatek.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.media.c2@1.2-mediatek.rc
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/hardware/libc2/service/seccomp_policy/android.hardware.media.c2@1.2-extended-seccomp-policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/android.hardware.media.c2@1.2-extended-seccomp-policy
endif
PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml:mtk

# media_profiles.xml for media profile support
PRODUCT_COPY_FILES += device/mediatek/$(TARGET_BOARD_PLATFORM)/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml:mtk

ifneq ($(wildcard vendor/mediatek/proprietary/custom/mt6789/hal/pd_buf_mgr/pd_calibration/default_pd_calibration.bin),)
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/custom/mt6789/hal/pd_buf_mgr/pd_calibration/default_pd_calibration.bin:$(TARGET_COPY_OUT_VENDOR)/etc/default_pd_calibration.bin:mtk
endif

#Audio low latency
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml


# USB ADB
PRODUCT_PROPERTY_OVERRIDES += \
    persist.adb.nonblocking_ffs=0

# AUDIO kernel buffer size
AUDIO_PARAM_OPTIONS_LIST += KERNEL_BUFFER_SIZE_NORMAL=16384
AUDIO_PARAM_OPTIONS_LIST += KERNEL_BUFFER_SIZE_DEEP=32768
AUDIO_PARAM_OPTIONS_LIST += DPCM_DEEP_BUFFER=Playback_3

# camera hal3 zsl default backtrace timestamp
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera3.zsl.default=260

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mediatek.platform=MT6789

# setup dalvik vm configs
# copy from frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapstartsize=16m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=256m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=512m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heaptargetutilization=0.5
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapminfree=8m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapmaxfree=32m

# for logd filter
ifeq ($(OPTR_SPEC_SEG_DEF),OP03_SPEC0200_SEGDEFAULT)
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += persist.log.tag=I
endif
endif

# GamePQ
ifeq ($(strip $(MTK_GAMEPQ_SUPPORT)), yes)
  ifeq ($(strip $(MTK_SCLTM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += debug.mediatek.game_pq_enable=1
  endif
endif

# remove this change after bring up and display porting done
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_ovl_bringup=0

# JPEG dec opt. flag
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.jpeg_decode_sw_opt=1

# Camera SMVR capability
ifeq ($(strip $(MTK_SLOW_MOTION_VIDEO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.smvr.p2batch.vga=8
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.smvr.p2batch.hd=4
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_slow_motion_support=1
endif

# Camera HDR10+ recording capability
ifeq  ($(strip $(MTK_HDR10_PLUS_RECORDING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.vendor.hdr10plus.enable=1
endif

# Display decompression
PRODUCT_PROPERTY_OVERRIDES += debug.mediatek.disp_decompress=1
PRODUCT_PROPERTY_OVERRIDES += debug.mediatek.appgamepq_compress=1

# Hevc encode support
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_video_hevc_enc_support=1

# lmkd parameters
ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
PRODUCT_PROPERTY_OVERRIDES += \
     ro.lmk.psi_complete_stall_ms=150 \
     ro.lmk.swap_free_low_percentage=20 \
     ro.lmk.thrashing_limit=30 \
     ro.lmk.thrashing_limit_decay=50 \
     ro.lmk.swap_util_max=90 \
     ro.lmk.kill_timeout_ms=100
endif

# NeuroPilot
ifeq ($(strip $(MTK_NN_SDK_SUPPORT)), yes)
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/ncc/nann_lib/android.hardware.neuralnetworks-shim-service-mtk/$(TARGET_BOARD_PLATFORM)/res/android.hardware.neuralnetworks-shim-service-mtk.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/android.hardware.neuralnetworks-shim-service-mtk.xml
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/ncc/nann_lib/android.hardware.neuralnetworks-shim-service-mtk/$(TARGET_BOARD_PLATFORM)/res/android.hardware.neuralnetworks-shim-service-mtk.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.neuralnetworks-shim-service-mtk.rc
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_apuware_apusys.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_apuware_apusys.xml
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_apuware_utils.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_apuware_utils.xml
    PRODUCT_COPY_FILES += device/mediatek/vendor/common/project_manifest/manifest_apuware_hmp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/manifest_apuware_hmp.xml
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/ncc/nann_lib/nnapi_powerhal.json/$(TARGET_BOARD_PLATFORM)/arm/nnapi_powerhal.json:$(TARGET_COPY_OUT_VENDOR)/etc/nnapi_powerhal.json:mtk)
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/hardware/gpu_nn_lib/armnn_app.config/$(TARGET_BOARD_PLATFORM)/arm/armnn_app.config:$(TARGET_COPY_OUT_VENDOR)/etc/armnn_app.config:mtk)
    PRODUCT_COPY_FILES += \
        $(call add-to-product-copy-files-if-exists, vendor/mediatek/proprietary/ncc/ncc_lib/nhw/$(TARGET_BOARD_PLATFORM)/arm/nhw:$(TARGET_COPY_OUT_VENDOR)/etc/nhw:mtk)
endif

PRODUCT_COPY_FILES +=  device/mediatek/mt6789/task_profiles-$(LINUX_KERNEL_VERSION).json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \

# surface flinger support gpu secure compose
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

# use SurfaceFlinger to process virtual display as default behavior
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.enable_hwc_vds=0

# set SF default properties
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.use_phase_offsets_as_durations=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.sf.duration=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.late.app.duration=20000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.sf.duration=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.early.app.duration=20000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.sf.duration=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.sf.earlyGl.app.duration=20000000

# set SF dynamic duration default value
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.switch=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.late=14600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.late=18000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.early=14600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.early=18000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.earlyGl=14600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.earlyGl=18000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.decouple=27600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.decouple=20000000
# set SF dynamic duration for 60/90/120hz/144
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.late.60=15600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.late.60=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.early.60=15600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.early.60=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.earlyGl.60=15600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.earlyGl.60=16600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.late.90=13100000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.late.90=19200000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.early.90=13100000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.early.90=19200000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.earlyGl.90=13100000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.earlyGl.90=19200000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.late.120=12300000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.late.120=11600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.early.120=12300000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.early.120=11600000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.sf.earlyGl.120=12300000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.dynamic_duration.app.earlyGl.120=11600000

#use vendor hwc min duration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.hwc.min.duration=2000000

# Support SF fpsgo
#PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.uclamp.min=305
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.upbound_uclamp_min=350
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.max_correct_offset=150
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.rt_bl_min=300
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.base_min_bl=310
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.sf_cpu_thres=290
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.upbound_uclamp_max_ll=262
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.hw_comp_suspend=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.hw_hfr_suspend=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.xgf_min=25
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_60_mml=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_30_mml=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.lowbound_uclamp_min=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.upbound_uclamp_ret_sys=210
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_60=130
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_90=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_120=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.min_boost=165
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.power_up_120=-300000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.power_down_120=300000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.debug.sf.cpupolicy.re_hfr=0

# Display support HDR
PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.has_HDR_display=false

# support MIPC
# PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_mipc_support=1

#for PQ
PQ_XML_PATH:= vendor/mediatek/proprietary/custom/mt6789/hal/pq
ifneq ($(wildcard $(PQ_XML_PATH)/cust_silky_brightness.xml),)
    PRODUCT_COPY_FILES += $(PQ_XML_PATH)/cust_silky_brightness.xml:$(TARGET_COPY_OUT_VENDOR)/etc/cust_silky_brightness.xml:mtk
endif
# PQ XML Customize file
ifneq ($(wildcard $(PQ_XML_PATH)/cust_color.xml),)
    PRODUCT_COPY_FILES += $(PQ_XML_PATH)/cust_color.xml:$(TARGET_COPY_OUT_VENDOR)/etc/cust_color.xml:mtk
endif

# MD-RSRA for non-5G GKI platform
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.mdrsra_v2_support=1
# XFRM support for non-5G GKI platform
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.xfrm_support=1

# venc simlink
VEXT_PRODUCT_SYMLINK_FILES += \
/vendor/bin/mt6789/v3avpud.mt6789:vendor/bin/v3avpud

# for Gen93 RILD log tag
$(call inherit-product, device/mediatek/vendor/common/RilGen93LogTag.mk)

$(call inherit-product, device/mediatek/vendor/common/device-vext.mk)

# support VDEC FMT
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk.c2.vdec.fmt.support.level=1

# overwrite the MGVI setting for hwcomposer 2.3
$(call inherit-product, device/mediatek/vendor/common/project_hal_mk/hwcomposer_2_3.mk)

# support mtee svp
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.mtk_svp_on_mtee_support=2

# HEIF decoder
PRODUCT_PROPERTY_OVERRIDES += vendor.media.heif.highThreshold=20
PRODUCT_PROPERTY_OVERRIDES += vendor.media.heif.feature.off=1

# netflix ID
PRODUCT_PROPERTY_OVERRIDES += ro.netflix.bsp_rev=MTK6789-35965-1
