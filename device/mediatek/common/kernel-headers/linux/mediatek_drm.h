/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef _UAPI_MEDIATEK_DRM_H
#define _UAPI_MEDIATEK_DRM_H
#include <drm/drm.h>
#define MTK_SUBMIT_NO_IMPLICIT 0x0
#define MTK_SUBMIT_IN_FENCE 0x1
#define MTK_SUBMIT_OUT_FENCE 0x2
#define MTK_DRM_PROP_OVERLAP_LAYER_NUM "OVERLAP_LAYER_NUM"
#define MTK_DRM_PROP_NEXT_BUFF_IDX "NEXT_BUFF_IDX"
#define MTK_DRM_PROP_PRESENT_FENCE "PRESENT_FENCE"
struct mml_frame_info;
struct drm_mtk_gem_create {
  uint64_t size;
  uint32_t flags;
  uint32_t handle;
};
struct drm_mtk_gem_map_off {
  uint32_t handle;
  uint32_t pad;
  uint64_t offset;
};
struct drm_mtk_gem_submit {
  uint32_t type;
  uint32_t session_id;
  uint32_t layer_id;
  uint32_t layer_en;
  uint32_t fb_id;
  uint32_t index;
  int32_t fence_fd;
  uint32_t interface_index;
  int32_t interface_fence_fd;
  int32_t ion_fd;
};
struct drm_mtk_sec_gem_hnd {
  uint32_t sec_hnd;
  uint32_t gem_hnd;
};
struct drm_mtk_session {
  uint32_t type;
  uint32_t device_id;
  uint32_t mode;
  uint32_t session_id;
};
enum drm_disp_ccorr_id_t {
  DRM_DISP_CCORR0 = 0,
  DRM_DISP_CCORR1,
  DRM_DISP_CCORR_TOTAL
};
struct DRM_DISP_CCORR_COEF_T {
  enum drm_disp_ccorr_id_t hw_id;
  unsigned int coef[3][3];
  unsigned int offset[3];
  int FinalBacklight;
  int silky_bright_flag;
};
struct DISP_DITHER_PARAM {
       bool relay;
       uint32_t mode;
};
#define DRM_MTK_GEM_CREATE 0x00
#define DRM_MTK_GEM_MAP_OFFSET 0x01
#define DRM_MTK_GEM_SUBMIT 0x02
#define DRM_MTK_SESSION_CREATE 0x03
#define DRM_MTK_SESSION_DESTROY 0x04
#define DRM_MTK_LAYERING_RULE 0x05
#define DRM_MTK_CRTC_GETFENCE 0x06
#define DRM_MTK_WAIT_REPAINT 0x07
#define DRM_MTK_GET_DISPLAY_CAPS 0x08
#define DRM_MTK_SET_DDP_MODE 0x09
#define DRM_MTK_GET_SESSION_INFO 0x0A
#define DRM_MTK_SEC_HND_TO_GEM_HND 0x0B
#define DRM_MTK_GET_MASTER_INFO 0x0C
#define DRM_MTK_CRTC_GETSFFENCE 0x0D
#define DRM_MTK_MML_GEM_SUBMIT 0x0E
#define DRM_MTK_SET_MSYNC_PARAMS 0x0F
#define DRM_MTK_GET_MSYNC_PARAMS 0x10
#define DRM_MTK_FACTORY_LCM_AUTO_TEST 0x11
#define DRM_MTK_SET_12BIT_GAMMALUT 0x1D
#define DRM_MTK_PQ_PERSIST_PROPERTY 0x1F
#define DRM_MTK_SET_CCORR 0x20
#define DRM_MTK_CCORR_EVENTCTL 0x21
#define DRM_MTK_CCORR_GET_IRQ 0x22
#define DRM_MTK_SET_GAMMALUT 0x23
#define DRM_MTK_SET_PQPARAM 0x24
#define DRM_MTK_SET_PQINDEX 0x25
#define DRM_MTK_SET_COLOR_REG 0x26
#define DRM_MTK_MUTEX_CONTROL 0x27
#define DRM_MTK_READ_REG 0x28
#define DRM_MTK_WRITE_REG 0x29
#define DRM_MTK_BYPASS_COLOR 0x2A
#define DRM_MTK_PQ_SET_WINDOW 0x2B
#define DRM_MTK_GET_LCM_INDEX 0x2C
#define DRM_MTK_SUPPORT_COLOR_TRANSFORM 0x2D
#define DRM_MTK_READ_SW_REG 0x2E
#define DRM_MTK_WRITE_SW_REG 0x2F
#define DRM_MTK_AAL_INIT_REG 0x30
#define DRM_MTK_AAL_GET_HIST 0x31
#define DRM_MTK_AAL_SET_PARAM 0x32
#define DRM_MTK_AAL_EVENTCTL 0x33
#define DRM_MTK_AAL_INIT_DRE30 0x34
#define DRM_MTK_AAL_GET_SIZE 0x35
#define DRM_MTK_HDMI_GET_DEV_INFO 0x3A
#define DRM_MTK_HDMI_AUDIO_ENABLE 0x3B
#define DRM_MTK_HDMI_AUDIO_CONFIG 0x3C
#define DRM_MTK_HDMI_GET_CAPABILITY 0x3D
#define DRM_MTK_DEBUG_LOG 0x3E

/* C3D */
#define DRM_MTK_C3D_GET_BIN_NUM     0x40
#define DRM_MTK_C3D_GET_IRQ         0x41
#define DRM_MTK_C3D_EVENTCTL        0x42
#define DRM_MTK_C3D_SET_LUT         0x44
#define DRM_MTK_SET_BYPASS_C3D      0x45
/* CHIST */
#define DRM_MTK_GET_CHIST           0x46
#define DRM_MTK_GET_CHIST_CAPS      0x47
#define DRM_MTK_SET_CHIST_CONFIG    0x48

#define DRM_MTK_SET_DITHER_PARAM 0x43
#define DRM_MTK_BYPASS_DISP_GAMMA 0x49

/* DISP TDSHP */
#define DRM_MTK_SET_DISP_TDSHP_REG 0x50
#define DRM_MTK_DISP_TDSHP_GET_SIZE 0x51
#define DRM_MTK_CRTC_GETPQFENCE 0x52
#define DRM_MTK_CRTC_RELEASEPQFENCE 0x53

#define DRM_MTK_GET_PQ_CAPS 0x54
#define DRM_MTK_SET_PQ_CAPS 0x55
#define DRM_MTK_SUPPORT_SLD 0x56
#define DRM_MTK_SET_SLD_PARAM 0x57

#define DRM_MTK_AIBLD_CV_MODE 0x58

#define DRM_MTK_GET_PANELS_INFO 0x5a

/* C3D */
#define DISP_C3D_1DLUT_SIZE 32

struct DISP_C3D_LUT {
  unsigned int lut1d[DISP_C3D_1DLUT_SIZE];
  unsigned long long lut3d;
};

enum MTKFB_DISPIF_TYPE {
  DISPIF_TYPE_DBI = 0,
  DISPIF_TYPE_DPI,
  DISPIF_TYPE_DSI,
  DISPIF_TYPE_DPI0,
  DISPIF_TYPE_DPI1,
  DISPIF_TYPE_DSI0,
  DISPIF_TYPE_DSI1,
  HDMI = 7,
  HDMI_SMARTBOOK,
  MHL,
  DISPIF_TYPE_EPD,
  DISPLAYPORT,
  SLIMPORT
};
enum MTKFB_DISPIF_MODE {
  DISPIF_MODE_VIDEO = 0,
  DISPIF_MODE_COMMAND
};
struct mtk_dispif_info {
  unsigned int display_id;
  unsigned int isHwVsyncAvailable;
  enum MTKFB_DISPIF_TYPE displayType;
  unsigned int displayWidth;
  unsigned int displayHeight;
  unsigned int displayFormat;
  enum MTKFB_DISPIF_MODE displayMode;
  unsigned int vsyncFPS;
  unsigned int physicalWidth;
  unsigned int physicalHeight;
  unsigned int isConnected;
  unsigned int lcmOriginalWidth;
  unsigned int lcmOriginalHeight;
};
enum MTK_DRM_SESSION_MODE {
  MTK_DRM_SESSION_INVALID = 0,
  MTK_DRM_SESSION_DL,
  MTK_DRM_SESSION_DOUBLE_DL,
  MTK_DRM_SESSION_DC_MIRROR,
  MTK_DRM_SESSION_TRIPLE_DL,
  MTK_DRM_SESSION_NUM,
};
enum MTK_LAYERING_CAPS {
  MTK_LAYERING_OVL_ONLY = 0x00000001,
  MTK_MDP_RSZ_LAYER = 0x00000002,
  MTK_DISP_RSZ_LAYER = 0x00000004,
  MTK_MDP_ROT_LAYER = 0x00000008,
  MTK_MDP_HDR_LAYER = 0x00000010,
  MTK_NO_FBDC = 0x00000020,
  MTK_CLIENT_CLEAR_LAYER = 0x00000040,
  MTK_DISP_CLIENT_CLEAR_LAYER = 0x00000080,
  MTK_DMDP_RSZ_LAYER = 0x00000100,
  MTK_MML_OVL_LAYER = 0x00000200,
  MTK_MML_DISP_DIRECT_LINK_LAYER = 0x00000400,
  MTK_MML_DISP_DIRECT_DECOUPLE_LAYER = 0x00000800,
  MTK_MML_DISP_DECOUPLE_LAYER = 0x00001000,
  MTK_MML_DISP_MDP_LAYER = 0x00002000,
  MTK_MML_DISP_NOT_SUPPORT = 0x00004000,
};
struct drm_mtk_layer_config {
  uint32_t ovl_id;
  uint32_t src_fmt;
  int dataspace;
  uint32_t dst_offset_x, dst_offset_y;
  uint32_t dst_width, dst_height;
  int ext_sel_layer;
  uint32_t src_offset_x, src_offset_y;
  uint32_t src_width, src_height;
  uint32_t layer_caps;
  uint32_t clip;
  __u8 compress;
  __u8 secure;
};
#define LYE_CRTC 4
struct drm_mtk_layering_info {
  struct drm_mtk_layer_config * input_config[LYE_CRTC];
  int disp_mode[LYE_CRTC];
  int disp_mode_idx[LYE_CRTC];
  int layer_num[LYE_CRTC];
  int gles_head[LYE_CRTC];
  int gles_tail[LYE_CRTC];
  int hrt_num;
  uint32_t disp_idx;
  uint32_t disp_list;
  int res_idx;
  uint32_t hrt_weight;
  uint32_t hrt_idx;
  struct mml_frame_info * mml_cfg[LYE_CRTC];
};
/* Msync 2.0 */
struct msync_level_table {
  uint32_t level_id;
  uint32_t level_fps;
  uint32_t max_fps;
  uint32_t min_fps;
};
struct msync_parameter_table {
  uint32_t msync_max_fps;
  uint32_t msync_min_fps;
  uint32_t msync_level_num;
  struct msync_level_table *level_tb;
};
struct drm_mtk_fence {
  uint32_t crtc_id;
  int32_t fence_fd;
  uint32_t fence_idx;
};
enum DRM_REPAINT_TYPE {
  DRM_WAIT_FOR_REPAINT,
  DRM_REPAINT_FOR_ANTI_LATENCY,
  DRM_REPAINT_FOR_SWITCH_DECOUPLE,
  DRM_REPAINT_FOR_SWITCH_DECOUPLE_MIRROR,
  DRM_REPAINT_FOR_IDLE,
  DRM_REPAINT_TYPE_NUM,
};
enum MTK_DRM_DISP_FEATURE {
  DRM_DISP_FEATURE_HRT = 0x00000001,
  DRM_DISP_FEATURE_DISP_SELF_REFRESH = 0x00000002,
  DRM_DISP_FEATURE_RPO = 0x00000004,
  DRM_DISP_FEATURE_FORCE_DISABLE_AOD = 0x00000008,
  DRM_DISP_FEATURE_OUTPUT_ROTATED = 0x00000010,
  DRM_DISP_FEATURE_THREE_SESSION = 0x00000020,
  DRM_DISP_FEATURE_FBDC = 0x00000040,
  DRM_DISP_FEATURE_SF_PRESENT_FENCE = 0x00000080,
  DRM_DISP_FEATURE_PQ_34_COLOR_MATRIX = 0x00000100,
  DRM_DISP_FEATURE_MSYNC2_0 = 0x00000200,
  DRM_DISP_FEATURE_MML_PRIMARY = 0x00000400,
  DRM_DISP_FEATURE_VIRUTAL_DISPLAY = 0x00000800,
  DRM_DISP_FEATURE_IOMMU           = 0x00001000,
  DRM_DISP_FEATURE_OVL_BW_MONITOR  = 0x00002000,
  DRM_DISP_FEATURE_GPU_CACHE       = 0x00004000,
  DRM_DISP_FEATURE_SPHRT           = 0x00008000,
};
#define DRM_HDMI_DEV_DRV "dev/dri/card0"
#define MTK_DRM_CHANNEL_2_BIT (1 << MTK_DRM_CHANNEL_2)
#define MTK_DRM_CHANNEL_3_BIT (1 << MTK_DRM_CHANNEL_3)
#define MTK_DRM_CHANNEL_4_BIT (1 << MTK_DRM_CHANNEL_4)
#define MTK_DRM_CHANNEL_5_BIT (1 << MTK_DRM_CHANNEL_5)
#define MTK_DRM_CHANNEL_6_BIT (1 << MTK_DRM_CHANNEL_6)
#define MTK_DRM_CHANNEL_7_BIT (1 << MTK_DRM_CHANNEL_7)
#define MTK_DRM_CHANNEL_8_BIT (1 << MTK_DRM_CHANNEL_8)
#define MTK_DRM_SAMPLERATE_32K_BIT (1 << MTK_DRM_SAMPLERATE_32K)
#define MTK_DRM_SAMPLERATE_44K_BIT (1 << MTK_DRM_SAMPLERATE_44K)
#define MTK_DRM_SAMPLERATE_48K_BIT (1 << MTK_DRM_SAMPLERATE_48K)
#define MTK_DRM_SAMPLERATE_96K_BIT (1 << MTK_DRM_SAMPLERATE_96K)
#define MTK_DRM_SAMPLERATE_192K_BIT (1 << MTK_DRM_SAMPLERATE_192K)
#define MTK_DRM_BITWIDTH_16_BIT (1 << MTK_DRM_BITWIDTH_16)
#define MTK_DRM_BITWIDTH_24_BIT (1 << MTK_DRM_BITWIDTH_24)
#define MTK_DRM_CAPABILITY_CHANNEL_MASK 0x7f
#define MTK_DRM_CAPABILITY_CHANNEL_SFT 0
#define MTK_DRM_CAPABILITY_SAMPLERATE_MASK 0x1f
#define MTK_DRM_CAPABILITY_SAMPLERATE_SFT 8
#define MTK_DRM_CAPABILITY_BITWIDTH_MASK 0x7
#define MTK_DRM_CAPABILITY_BITWIDTH_SFT 16
enum MTK_DRM_CHANNEL {
  MTK_DRM_CHANNEL_2,
  MTK_DRM_CHANNEL_3,
  MTK_DRM_CHANNEL_4,
  MTK_DRM_CHANNEL_5,
  MTK_DRM_CHANNEL_6,
  MTK_DRM_CHANNEL_7,
  MTK_DRM_CHANNEL_8,
  MTK_DRM_CHANNEL_NUM
};
enum MTK_DRM_SAMPLERATE {
  MTK_DRM_SAMPLERATE_32K,
  MTK_DRM_SAMPLERATE_44K,
  MTK_DRM_SAMPLERATE_48K,
  MTK_DRM_SAMPLERATE_96K,
  MTK_DRM_SAMPLERATE_192K,
  MTK_DRM_SAMPLERATE_NUM
};
enum MTK_DRM_BITWIDTH {
  MTK_DRM_BITWIDTH_16,
  MTK_DRM_BITWIDTH_24 = 2,
  MTK_DRM_BITWIDTH_NUM = 2
};
enum mtk_mmsys_id {
  MMSYS_MT2701 = 0x2701,
  MMSYS_MT2712 = 0x2712,
  MMSYS_MT8173 = 0x8173,
  MMSYS_MT6779 = 0x6779,
  MMSYS_MT6789 = 0x6789,
  MMSYS_MT6885 = 0x6885,
  MMSYS_MT6983 = 0x6983,
  MMSYS_MT6873 = 0x6873,
  MMSYS_MT6853 = 0x6853,
  MMSYS_MT6833 = 0x6833,
  MMSYS_MT6877 = 0x6877,
  MMSYS_MT6879 = 0x6879,
  MMSYS_MT6895 = 0x6895,
  MMSYS_MT6855 = 0x6855,
  MMSYS_MT6835 = 0x6835,
  MMSYS_MAX,
};

#define MTK_DRM_COLOR_FORMAT_A_BIT (1 << MTK_DRM_COLOR_FORMAT_A)
#define MTK_DRM_COLOR_FORMAT_R_BIT (1 << MTK_DRM_COLOR_FORMAT_R)
#define MTK_DRM_COLOR_FORMAT_G_BIT (1 << MTK_DRM_COLOR_FORMAT_G)
#define MTK_DRM_COLOR_FORMAT_B_BIT (1 << MTK_DRM_COLOR_FORMAT_B)
#define MTK_DRM_COLOR_FORMAT_Y_BIT (1 << MTK_DRM_COLOR_FORMAT_Y)
#define MTK_DRM_COLOR_FORMAT_U_BIT (1 << MTK_DRM_COLOR_FORMAT_U)
#define MTK_DRM_COLOR_FORMAT_V_BIT (1 << MTK_DRM_COLOR_FORMAT_V)
#define MTK_DRM_COLOR_FORMAT_S_BIT (1 << MTK_DRM_COLOR_FORMAT_S)
#define MTK_DRM_COLOR_FORMAT_H_BIT (1 << MTK_DRM_COLOR_FORMAT_H)
#define MTK_DRM_COLOR_FORMAT_M_BIT (1 << MTK_DRM_COLOR_FORMAT_M)


#define MTK_DRM_DISP_CHIST_CHANNEL_COUNT 7

enum MTK_DRM_CHIST_COLOR_FORMT {
  MTK_DRM_COLOR_FORMAT_A,
  MTK_DRM_COLOR_FORMAT_R,
  MTK_DRM_COLOR_FORMAT_G,
  MTK_DRM_COLOR_FORMAT_B,
  MTK_DRM_COLOR_FORMAT_Y,
  MTK_DRM_COLOR_FORMAT_U,
  MTK_DRM_COLOR_FORMAT_V,
  MTK_DRM_COLOR_FORMAT_S,
  MTK_DRM_COLOR_FORMAT_H,
  MTK_DRM_COLOR_FORMAT_M,
  MTK_DRM_COLOR_FORMAT_MAX
};

enum MTK_DRM_CHIST_CALLER {
  MTK_DRM_CHIST_CALLER_PQ,
  MTK_DRM_CHIST_CALLER_HWC,
  MTK_DRM_CHIST_CALLER_UNKONW

};
struct mtk_drm_disp_caps_info {
  unsigned int hw_ver;
  unsigned int disp_feature_flag;
  int lcm_degree;
  unsigned int rsz_in_max[2];
  int lcm_color_mode;
  unsigned int max_luminance;
  unsigned int average_luminance;
  unsigned int min_luminance;

  /* for color histogram */
  unsigned int color_format;
  unsigned int max_bin;
  unsigned int max_channel;

  /* Msync 2.0 */
  unsigned int msync_level_num;
};
struct drm_mtk_session_info {
  unsigned int session_id;
  unsigned int vsyncFPS;
  unsigned int physicalWidthUm;
  unsigned int physicalHeightUm;
};

struct DISP_TDSHP_REG {
  uint32_t tdshp_softcoring_gain;
  uint32_t tdshp_gain_high;
  uint32_t tdshp_gain_mid;
  uint32_t tdshp_ink_sel;
  uint32_t tdshp_bypass_high;
  uint32_t tdshp_bypass_mid;
  uint32_t tdshp_en;
  uint32_t tdshp_limit_ratio;
  uint32_t tdshp_gain;
  uint32_t tdshp_coring_zero;
  uint32_t tdshp_coring_thr;
  uint32_t tdshp_coring_value;
  uint32_t tdshp_bound;
  uint32_t tdshp_limit;
  uint32_t tdshp_sat_proc;
  uint32_t tdshp_ac_lpf_coe;
  uint32_t tdshp_clip_thr;
  uint32_t tdshp_clip_ratio;
  uint32_t tdshp_clip_en;
  uint32_t tdshp_ylev_p048;
  uint32_t tdshp_ylev_p032;
  uint32_t tdshp_ylev_p016;
  uint32_t tdshp_ylev_p000;
  uint32_t tdshp_ylev_p112;
  uint32_t tdshp_ylev_p096;
  uint32_t tdshp_ylev_p080;
  uint32_t tdshp_ylev_p064;
  uint32_t tdshp_ylev_p176;
  uint32_t tdshp_ylev_p160;
  uint32_t tdshp_ylev_p144;
  uint32_t tdshp_ylev_p128;
  uint32_t tdshp_ylev_p240;
  uint32_t tdshp_ylev_p224;
  uint32_t tdshp_ylev_p208;
  uint32_t tdshp_ylev_p192;
  uint32_t tdshp_ylev_en;
  uint32_t tdshp_ylev_alpha;
  uint32_t tdshp_ylev_256;
  uint32_t pbc1_radius_r;
  uint32_t pbc1_theta_r;
  uint32_t pbc1_rslope_1;
  uint32_t pbc1_gain;
  uint32_t pbc1_lpf_en;
  uint32_t pbc1_en;
  uint32_t pbc1_lpf_gain;
  uint32_t pbc1_tslope;
  uint32_t pbc1_radius_c;
  uint32_t pbc1_theta_c;
  uint32_t pbc1_edge_slope;
  uint32_t pbc1_edge_thr;
  uint32_t pbc1_edge_en;
  uint32_t pbc1_conf_gain;
  uint32_t pbc1_rslope;
  uint32_t pbc2_radius_r;
  uint32_t pbc2_theta_r;
  uint32_t pbc2_rslope_1;
  uint32_t pbc2_gain;
  uint32_t pbc2_lpf_en;
  uint32_t pbc2_en;
  uint32_t pbc2_lpf_gain;
  uint32_t pbc2_tslope;
  uint32_t pbc2_radius_c;
  uint32_t pbc2_theta_c;
  uint32_t pbc2_edge_slope;
  uint32_t pbc2_edge_thr;
  uint32_t pbc2_edge_en;
  uint32_t pbc2_conf_gain;
  uint32_t pbc2_rslope;
  uint32_t pbc3_radius_r;
  uint32_t pbc3_theta_r;
  uint32_t pbc3_rslope_1;
  uint32_t pbc3_gain;
  uint32_t pbc3_lpf_en;
  uint32_t pbc3_en;
  uint32_t pbc3_lpf_gain;
  uint32_t pbc3_tslope;
  uint32_t pbc3_radius_c;
  uint32_t pbc3_theta_c;
  uint32_t pbc3_edge_slope;
  uint32_t pbc3_edge_thr;
  uint32_t pbc3_edge_en;
  uint32_t pbc3_conf_gain;
  uint32_t pbc3_rslope;
  uint32_t tdshp_mid_softlimit_ratio;
  uint32_t tdshp_mid_coring_zero;
  uint32_t tdshp_mid_coring_thr;
  uint32_t tdshp_mid_softcoring_gain;
  uint32_t tdshp_mid_coring_value;
  uint32_t tdshp_mid_bound;
  uint32_t tdshp_mid_limit;
  uint32_t tdshp_high_softlimit_ratio;
  uint32_t tdshp_high_coring_zero;
  uint32_t tdshp_high_coring_thr;
  uint32_t tdshp_high_softcoring_gain;
  uint32_t tdshp_high_coring_value;
  uint32_t tdshp_high_bound;
  uint32_t tdshp_high_limit;
  uint32_t edf_clip_ratio_inc;
  uint32_t edf_edge_gain;
  uint32_t edf_detail_gain;
  uint32_t edf_flat_gain;
  uint32_t edf_gain_en;
  uint32_t edf_edge_th;
  uint32_t edf_detail_fall_th;
  uint32_t edf_detail_rise_th;
  uint32_t edf_flat_th;
  uint32_t edf_edge_slope;
  uint32_t edf_detail_fall_slope;
  uint32_t edf_detail_rise_slope;
  uint32_t edf_flat_slope;
  uint32_t edf_edge_mono_slope;
  uint32_t edf_edge_mono_th;
  uint32_t edf_edge_mag_slope;
  uint32_t edf_edge_mag_th;
  uint32_t edf_edge_trend_flat_mag;
  uint32_t edf_edge_trend_slope;
  uint32_t edf_edge_trend_th;
  uint32_t edf_bld_wgt_mag;
  uint32_t edf_bld_wgt_mono;
  uint32_t edf_bld_wgt_trend;
  uint32_t tdshp_cboost_lmt_u;
  uint32_t tdshp_cboost_lmt_l;
  uint32_t tdshp_cboost_en;
  uint32_t tdshp_cboost_gain;
  uint32_t tdshp_cboost_yconst;
  uint32_t tdshp_cboost_yoffset_sel;
  uint32_t tdshp_cboost_yoffset;
  uint32_t tdshp_post_ylev_p048;
  uint32_t tdshp_post_ylev_p032;
  uint32_t tdshp_post_ylev_p016;
  uint32_t tdshp_post_ylev_p000;
  uint32_t tdshp_post_ylev_p112;
  uint32_t tdshp_post_ylev_p096;
  uint32_t tdshp_post_ylev_p080;
  uint32_t tdshp_post_ylev_p064;
  uint32_t tdshp_post_ylev_p176;
  uint32_t tdshp_post_ylev_p160;
  uint32_t tdshp_post_ylev_p144;
  uint32_t tdshp_post_ylev_p128;
  uint32_t tdshp_post_ylev_p240;
  uint32_t tdshp_post_ylev_p224;
  uint32_t tdshp_post_ylev_p208;
  uint32_t tdshp_post_ylev_p192;
  uint32_t tdshp_post_ylev_en;
  uint32_t tdshp_post_ylev_alpha;
  uint32_t tdshp_post_ylev_256;
};

struct DISP_TDSHP_DISPLAY_SIZE {
  int width;
  int height;
  int lcm_width;
  int lcm_height;
};

struct drm_mtk_channel_hist {
  unsigned int channel_id;
  enum MTK_DRM_CHIST_COLOR_FORMT color_format;
  unsigned int hist[256];
  unsigned int bin_count;
};

struct drm_mtk_chist_info {
  unsigned int present_fence;
  unsigned int device_id;
  enum MTK_DRM_CHIST_CALLER caller;
  unsigned int get_channel_count;
  struct drm_mtk_channel_hist channel_hist[MTK_DRM_DISP_CHIST_CHANNEL_COUNT];
};

struct drm_mtk_channel_config {
  bool enabled;
  enum MTK_DRM_CHIST_COLOR_FORMT color_format;
  unsigned int bin_count;
  unsigned int channel_id;
  unsigned int blk_width;
  unsigned int blk_height;
  unsigned int roi_start_x;
  unsigned int roi_start_y;
  unsigned int roi_end_x;
  unsigned int roi_end_y;
};

struct drm_mtk_chist_caps {
  unsigned int device_id;
  unsigned int support_color;
  unsigned int lcm_width;
  unsigned int lcm_height;
  struct drm_mtk_channel_config chist_config[MTK_DRM_DISP_CHIST_CHANNEL_COUNT];
};

struct drm_mtk_chist_config {
  unsigned int device_id;
  unsigned int lcm_color_mode;
  unsigned int config_channel_count;
  enum MTK_DRM_CHIST_CALLER caller;
  struct drm_mtk_channel_config chist_config[MTK_DRM_DISP_CHIST_CHANNEL_COUNT];
};

struct drm_mtk_ccorr_caps {
  unsigned int ccorr_bit;
  unsigned int ccorr_number;
  unsigned int ccorr_linear;//1st byte:high 4 bit:CCORR1,low 4 bit:CCORR0
};

struct mtk_drm_pq_caps_info {
  struct drm_mtk_ccorr_caps ccorr_caps;
};

#define GET_PANELS_STR_LEN 64
struct mtk_drm_panels_info {
  int connector_cnt;
  int default_connector_id;
  unsigned int *connector_obj_id;
  char **panel_name;
  unsigned int *panel_id;
};

#define DRM_IOCTL_MTK_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GEM_CREATE, struct drm_mtk_gem_create)
#define DRM_IOCTL_MTK_GEM_MAP_OFFSET DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GEM_MAP_OFFSET, struct drm_mtk_gem_map_off)
#define DRM_IOCTL_MTK_GEM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GEM_SUBMIT, struct drm_mtk_gem_submit)
#define DRM_IOCTL_MTK_SESSION_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SESSION_CREATE, struct drm_mtk_session)
#define DRM_IOCTL_MTK_SESSION_DESTROY DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SESSION_DESTROY, struct drm_mtk_session)
#define DRM_IOCTL_MTK_LAYERING_RULE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_LAYERING_RULE, struct drm_mtk_layering_info)
#define DRM_IOCTL_MTK_CRTC_GETFENCE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CRTC_GETFENCE, struct drm_mtk_fence)
#define DRM_IOCTL_MTK_CRTC_GETSFFENCE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CRTC_GETSFFENCE, struct drm_mtk_fence)
#define DRM_IOCTL_MTK_MML_GEM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_MML_GEM_SUBMIT, struct mml_submit)
#define DRM_IOCTL_MTK_SET_MSYNC_PARAMS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_MSYNC_PARAMS, struct msync_parameter_table)
#define DRM_IOCTL_MTK_GET_MSYNC_PARAMS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_MSYNC_PARAMS, struct msync_parameter_table)
#define DRM_IOCTL_MTK_FACTORY_LCM_AUTO_TEST DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_FACTORY_LCM_AUTO_TEST, int)
#define DRM_IOCTL_MTK_WAIT_REPAINT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_WAIT_REPAINT, unsigned int)
#define DRM_IOCTL_MTK_GET_DISPLAY_CAPS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_DISPLAY_CAPS, struct mtk_drm_disp_caps_info)
#define DRM_IOCTL_MTK_SET_DDP_MODE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_DDP_MODE, unsigned int)
#define DRM_IOCTL_MTK_GET_SESSION_INFO DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_SESSION_INFO, struct drm_mtk_session_info)
#define DRM_IOCTL_MTK_GET_MASTER_INFO DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_MASTER_INFO, int)
#define DRM_IOCTL_MTK_SET_12BIT_GAMMALUT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_12BIT_GAMMALUT, DISP_GAMMA_12BIT_LUT_T)
#define DRM_IOCTL_MTK_PQ_PERSIST_PROPERTY DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_PQ_PERSIST_PROPERTY, unsigned int [32])
#define DRM_IOCTL_MTK_SET_CCORR DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_CCORR, DRM_DISP_CCORR_COEF_T)
#define DRM_IOCTL_MTK_SUPPORT_SLD  DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SUPPORT_SLD, bool)
#define DRM_IOCTL_MTK_SET_SLD_PARAM    DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_SLD_PARAM, DISP_SLD_PARAM)

#define DRM_IOCTL_MTK_CCORR_EVENTCTL DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CCORR_EVENTCTL, unsigned int)
#define DRM_IOCTL_MTK_AIBLD_CV_MODE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AIBLD_CV_MODE, bool)
#define DRM_IOCTL_MTK_CCORR_GET_IRQ DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CCORR_GET_IRQ, unsigned int)
#define DRM_IOCTL_MTK_SET_GAMMALUT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_GAMMALUT, DISP_GAMMA_LUT_T)
#define DRM_IOCTL_MTK_SET_PQPARAM DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_PQPARAM, DISP_PQ_PARAM)
#define DRM_IOCTL_MTK_SET_PQINDEX DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_PQINDEX, DISPLAY_PQ_T)
#define DRM_IOCTL_MTK_SET_COLOR_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_COLOR_REG, DISPLAY_COLOR_REG_T)
#define DRM_IOCTL_MTK_MUTEX_CONTROL DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_MUTEX_CONTROL, unsigned int)
#define DRM_IOCTL_MTK_READ_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_READ_REG, DISP_READ_REG)
#define DRM_IOCTL_MTK_WRITE_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_WRITE_REG, DISP_WRITE_REG)
#define DRM_IOCTL_MTK_BYPASS_COLOR DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_BYPASS_COLOR, unsigned int)
#define DRM_IOCTL_MTK_PQ_SET_WINDOW DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_PQ_SET_WINDOW, DISP_PQ_WIN_PARAM)
#define DRM_IOCTL_MTK_GET_LCM_INDEX DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_LCM_INDEX, unsigned int)
#define DRM_IOCTL_MTK_GET_PANELS_INFO   DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_PANELS_INFO, struct mtk_drm_panels_info)
#define DRM_IOCTL_MTK_SUPPORT_COLOR_TRANSFORM DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SUPPORT_COLOR_TRANSFORM, struct DISP_COLOR_TRANSFORM)
#define DRM_IOCTL_MTK_READ_SW_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_READ_SW_REG, DISP_READ_REG)
#define DRM_IOCTL_MTK_WRITE_SW_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_WRITE_SW_REG, DISP_WRITE_REG)
// for Display TDSHP
#define DRM_IOCTL_MTK_SET_DISP_TDSHP_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_DISP_TDSHP_REG, struct DISP_TDSHP_REG)
#define DRM_IOCTL_MTK_DISP_TDSHP_GET_SIZE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_DISP_TDSHP_GET_SIZE, struct DISP_TDSHP_DISPLAY_SIZE)

#define DRM_IOCTL_MTK_C3D_GET_BIN_NUM DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_C3D_GET_BIN_NUM, unsigned int)

#define DRM_IOCTL_MTK_C3D_GET_IRQ DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_C3D_GET_IRQ, unsigned int)

#define DRM_IOCTL_MTK_C3D_EVENTCTL DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_C3D_EVENTCTL, unsigned int)

#define DRM_IOCTL_MTK_C3D_SET_LUT DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_C3D_SET_LUT, struct DISP_C3D_LUT)

#define DRM_IOCTL_MTK_SET_BYPASS_C3D DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_BYPASS_C3D, unsigned int)

#define DRM_IOCTL_MTK_GET_CHIST DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_CHIST, struct drm_mtk_chist_info)

#define DRM_IOCTL_MTK_GET_CHIST_CAPS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_CHIST_CAPS, struct drm_mtk_chist_caps)

#define DRM_IOCTL_MTK_SET_CHIST_CONFIG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_CHIST_CONFIG, struct drm_mtk_chist_config)

#define DRM_IOCTL_MTK_SET_DITHER_PARAM DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_DITHER_PARAM, struct DISP_DITHER_PARAM)
#define DRM_IOCTL_MTK_BYPASS_DISP_GAMMA DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_BYPASS_DISP_GAMMA, unsigned int)

#define DRM_IOCTL_MTK_AAL_INIT_REG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_INIT_REG, DISP_AAL_INITREG)
#define DRM_IOCTL_MTK_AAL_GET_HIST DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_GET_HIST, DISP_AAL_HIST)
#define DRM_IOCTL_MTK_AAL_SET_PARAM DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_SET_PARAM, DISP_AAL_PARAM)
#define DRM_IOCTL_MTK_AAL_EVENTCTL DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_EVENTCTL, unsigned int)
#define DRM_IOCTL_MTK_AAL_INIT_DRE30 DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_INIT_DRE30, DISP_DRE30_INIT)
#define DRM_IOCTL_MTK_AAL_GET_SIZE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_AAL_GET_SIZE, DISP_AAL_DISPLAY_SIZE)
#define DRM_IOCTL_MTK_SEC_HND_TO_GEM_HND DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SEC_HND_TO_GEM_HND, struct drm_mtk_sec_gem_hnd)
#define DRM_IOCTL_MTK_HDMI_GET_DEV_INFO DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_HDMI_GET_DEV_INFO, struct mtk_dispif_info)
#define DRM_IOCTL_MTK_HDMI_AUDIO_ENABLE DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_HDMI_AUDIO_ENABLE, unsigned int)
#define DRM_IOCTL_MTK_HDMI_AUDIO_CONFIG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_HDMI_AUDIO_CONFIG, unsigned int)
#define DRM_IOCTL_MTK_HDMI_GET_CAPABILITY DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_HDMI_GET_CAPABILITY, unsigned int)
#define DRM_IOCTL_MTK_CRTC_GETPQFENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CRTC_GETPQFENCE, struct drm_mtk_fence)
#define DRM_IOCTL_MTK_CRTC_RELEASEPQFENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_CRTC_RELEASEPQFENCE, struct drm_mtk_fence)
#define DRM_IOCTL_MTK_DEBUG_LOG DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_DEBUG_LOG, int)
#define DRM_IOCTL_MTK_GET_PQ_CAPS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_GET_PQ_CAPS, struct mtk_drm_pq_caps_info)
#define DRM_IOCTL_MTK_SET_PQ_CAPS DRM_IOWR(DRM_COMMAND_BASE + DRM_MTK_SET_PQ_CAPS, struct mtk_drm_pq_caps_info)

#define MTK_DRM_FORMAT_DIM fourcc_code('D', ' ', '0', '0')
#define DRM_FORMAT_MOD_VENDOR_MTK 0x0A
#define DRM_FORMAT_MOD_MTK_PREMULTIPLIED fourcc_mod_code(MTK, 1)
#define DRM_FORMAT_MOD_MTK_SECURE fourcc_mod_code(MTK, 2)
#endif
