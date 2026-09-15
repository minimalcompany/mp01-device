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
#ifndef _MT_DPE_H
#define _MT_DPE_H
#include <linux/ioctl.h>
#define KERNEL_LOG
#define _SUPPORT_MAX_DPE_FRAME_REQUEST_ 12
#define _SUPPORT_MAX_DPE_REQUEST_RING_SIZE_ 4
#define SIG_ERESTARTSYS 512
#define DPE_DEV_MAJOR_NUMBER 302
#define DPE_MAGIC 'd'
#define DPE_REG_RANGE (0x1000)
#define DPE_BASE_HW 0x15300000
#define DPE_INT_ST (1UL << 31)
#define DPE_MAX_FRAME_SIZE 307200
#define WB_INT_MEDV_SIZE DPE_MAX_FRAME_SIZE
#define WB_DCV_L_SIZE DPE_MAX_FRAME_SIZE
#define WB_ASFRM_SIZE DPE_MAX_FRAME_SIZE
#define WB_ASFRMExt_SIZE DPE_MAX_FRAME_SIZE
#define WB_WMFHF_SIZE DPE_MAX_FRAME_SIZE
#define WB_TOTAL_SIZE (WB_INT_MEDV_SIZE + WB_DCV_L_SIZE + WB_ASFRM_SIZE + WB_ASFRMExt_SIZE + WB_WMFHF_SIZE)


struct DVS_ME_CFG {
  unsigned int DVS_ME_00;
  unsigned int DVS_ME_01;
  unsigned int DVS_ME_02;
  unsigned int DVS_ME_03;
  unsigned int DVS_ME_04;
  unsigned int DVS_ME_06;
  unsigned int DVS_ME_07;
  unsigned int DVS_ME_08;
  unsigned int DVS_ME_09;
  unsigned int DVS_ME_10;
  unsigned int DVS_ME_11;
  unsigned int DVS_ME_12;
  unsigned int DVS_ME_13;
  unsigned int DVS_ME_14;
  unsigned int DVS_ME_15;
  unsigned int DVS_ME_16;
  unsigned int DVS_ME_17;
  unsigned int DVS_ME_18;
  unsigned int DVS_ME_19;
  unsigned int DVS_ME_20;
  unsigned int DVS_ME_21;
  unsigned int DVS_ME_22;
  unsigned int DVS_ME_23;
  unsigned int DVS_ME_24;
	unsigned int DVS_ME_25;
	unsigned int DVS_ME_26;
	unsigned int DVS_ME_27;
	unsigned int DVS_ME_28;
	unsigned int DVS_ME_29;
	unsigned int DVS_ME_30;
	unsigned int DVS_ME_31;
	unsigned int DVS_ME_32;
	unsigned int DVS_ME_33;
	unsigned int DVS_ME_34;
	unsigned int DVS_ME_35;
	unsigned int DVS_ME_36;
	unsigned int DVS_ME_37;
	unsigned int DVS_ME_38;
	unsigned int DVS_ME_39;
	unsigned int DVS_DEBUG;
	unsigned int DVS_ME_RESERVED;
	unsigned int DVS_ME_ATPG;
	unsigned int DVS_ME_40;
	unsigned int DVS_ME_41;
};
struct DVS_OCC_CFG {
  unsigned int DVS_OCC_PQ_0;
  unsigned int DVS_OCC_PQ_1;
  unsigned int DVS_OCC_PQ_2;
  unsigned int DVS_OCC_PQ_3;
  unsigned int DVS_OCC_PQ_4;
  unsigned int DVS_OCC_PQ_5;
	unsigned int DVS_OCC_PQ_6; 
	unsigned int DVS_OCC_PQ_7; 
	unsigned int DVS_OCC_PQ_8; 
	unsigned int DVS_OCC_PQ_9; 
	unsigned int DVS_OCC_PQ_10;
	unsigned int DVS_OCC_PQ_11;
	unsigned int DVS_OCC_ATPG;
};
struct DVP_CORE_CFG {
  unsigned int DVP_CORE_00;
  unsigned int DVP_CORE_01;
  unsigned int DVP_CORE_02;
  unsigned int DVP_CORE_03;
  unsigned int DVP_CORE_04;
  unsigned int DVP_CORE_05;
  unsigned int DVP_CORE_06;
  unsigned int DVP_CORE_07;
  unsigned int DVP_CORE_08;
  unsigned int DVP_CORE_09;
  unsigned int DVP_CORE_10;
  unsigned int DVP_CORE_11;
  unsigned int DVP_CORE_12;
  unsigned int DVP_CORE_13;
  unsigned int DVP_CORE_14;
  unsigned int DVP_CORE_15;
  unsigned int DVP_CORE_16;
};
struct DPE_REG_STRUCT {
  unsigned int module;
  unsigned int Addr;
  unsigned int Val;
};
struct DPE_REG_IO_STRUCT {
  struct DPE_REG_STRUCT * pData;
  unsigned int Count;
};
enum DPE_IRQ_CLEAR_ENUM {
  DPE_IRQ_CLEAR_NONE,
  DPE_IRQ_CLEAR_WAIT,
  DPE_IRQ_WAIT_CLEAR,
  DPE_IRQ_CLEAR_STATUS,
  DPE_IRQ_CLEAR_ALL
};
enum DPE_IRQ_TYPE_ENUM {
  DPE_IRQ_TYPE_INT_DVP_ST,
  DPE_IRQ_TYPE_INT_DVS_ST,
  DPE_IRQ_TYPE_AMOUNT
};
struct DPE_WAIT_IRQ_STRUCT {
  enum DPE_IRQ_CLEAR_ENUM Clear;
  enum DPE_IRQ_TYPE_ENUM Type;
  unsigned int Status;
  unsigned int Timeout;
  int UserKey;
  int ProcessID;
  unsigned int bDumpReg;
};
struct DPE_CLEAR_IRQ_STRUCT {
  enum DPE_IRQ_TYPE_ENUM Type;
  int UserKey;
  unsigned int Status;
};
struct DPE_Kernel_Config {
	unsigned int	DVS_CTRL00;
	unsigned int	DVS_CTRL01;
	unsigned int	DVS_CTRL02;
	unsigned int	DVS_CTRL03;
//	unsigned int	DVS_CTRL04;
//	unsigned int	DVS_CTRL05;
	unsigned int	DVS_CTRL06;
	unsigned int	DVS_CTRL07;
	unsigned int	DVS_IRQ_00;
	unsigned int	DVS_CTRL_STATUS0;
//	unsigned int	DVS_CTRL_STATUS1;
	unsigned int	DVS_CTRL_STATUS2;
	unsigned int	DVS_IRQ_STATUS;
	unsigned int	DVS_FRM_STATUS0;
	unsigned int	DVS_FRM_STATUS1;
//	unsigned int	DVS_FRM_STATUS2;
//	unsigned int	DVS_FRM_STATUS3;
	unsigned int	DVS_CUR_STATUS;
	unsigned int	DVS_SRC_CTRL;
	unsigned int	DVS_CRC_CTRL;
	unsigned int	DVS_CRC_IN;
	unsigned int	DVS_DRAM_STA0;
	unsigned int	DVS_DRAM_STA1;
	unsigned int	DVS_DRAM_ULT;
	unsigned int	DVS_DRAM_PITCH;
	unsigned int	DVS_SRC_00;
	unsigned int	DVS_SRC_01;
	unsigned int	DVS_SRC_02;
	unsigned int	DVS_SRC_03;
	unsigned int	DVS_SRC_04;
	unsigned int	DVS_SRC_05_L_FRM0;
	unsigned int	DVS_SRC_06_L_FRM1;
	unsigned int	DVS_SRC_07_L_FRM2;
	unsigned int	DVS_SRC_08_L_FRM3;
	unsigned int	DVS_SRC_09_R_FRM0;
	unsigned int	DVS_SRC_10_R_FRM1;
	unsigned int	DVS_SRC_11_R_FRM2;
	unsigned int	DVS_SRC_12_R_FRM3;
	unsigned int	DVS_SRC_13_L_VMAP0;
	unsigned int	DVS_SRC_14_L_VMAP1;
	unsigned int	DVS_SRC_15_L_VMAP2;
	unsigned int	DVS_SRC_16_L_VMAP3;
	unsigned int	DVS_SRC_17_R_VMAP0;
	unsigned int	DVS_SRC_18_R_VMAP1;
	unsigned int	DVS_SRC_19_R_VMAP2;
	unsigned int	DVS_SRC_20_R_VMAP3;
	unsigned int	DVS_SRC_21_P4_L_DV_ADR;
	unsigned int	DVS_SRC_26_OCCDV0;
	unsigned int	DVS_SRC_27_OCCDV1;
	unsigned int	DVS_SRC_28_OCCDV2;
	unsigned int	DVS_SRC_29_OCCDV3;
	unsigned int	DVS_SRC_34_P4_R_DV_ADR;
	unsigned int	DVS_SRC_42_OCCDV_EXT0;
	unsigned int	DVS_SRC_43_OCCDV_EXT1;
	unsigned int	DVS_SRC_44_OCCDV_EXT2;
	unsigned int	DVS_SRC_45_OCCDV_EXT3;
	unsigned int 	DVS_SRC_46;
	unsigned int	DVS_CRC_OUT_0;
	unsigned int	DVS_CRC_OUT_1;
	unsigned int	DVS_CRC_OUT_2;
	unsigned int	DVS_CRC_OUT_3;
	unsigned int  DVS_DRAM_SEC;
	unsigned int	DVS_PD_SRC_00_L_FRM0;
	unsigned int	DVS_PD_SRC_01_L_FRM1;
	unsigned int	DVS_PD_SRC_02_L_FRM2;
	unsigned int	DVS_PD_SRC_03_L_FRM3;
	unsigned int	DVS_PD_SRC_04_R_FRM0;
	unsigned int	DVS_PD_SRC_05_R_FRM1;
	unsigned int	DVS_PD_SRC_06_R_FRM2;
	unsigned int	DVS_PD_SRC_07_R_FRM3;
	unsigned int	DVS_PD_SRC_08_OCCDV0;
	unsigned int	DVS_PD_SRC_09_OCCDV1;
	unsigned int	DVS_PD_SRC_10_OCCDV2;
	unsigned int	DVS_PD_SRC_11_OCCDV3;
	unsigned int	DVS_PD_SRC_12_OCCDV_EXT0;
	unsigned int	DVS_PD_SRC_13_OCCDV_EXT1;
	unsigned int	DVS_PD_SRC_14_OCCDV_EXT2;
	unsigned int	DVS_PD_SRC_15_OCCDV_EXT3;
	unsigned int	DVS_PD_SRC_16_DCV_CONF0;
	unsigned int	DVS_PD_SRC_17_DCV_CONF1;
	unsigned int	DVS_PD_SRC_18_DCV_CONF2;
	unsigned int	DVS_PD_SRC_19_DCV_CONF3;
	unsigned int	DVS_CTRL_RESERVED;
	unsigned int	DVS_CTRL_ATPG;
	unsigned int	DVS_ME_00;
	unsigned int	DVS_ME_01;
	unsigned int	DVS_ME_02;
	unsigned int	DVS_ME_03;
	unsigned int	DVS_ME_04;
	unsigned int	DVS_ME_05;
	unsigned int	DVS_ME_06;
	unsigned int	DVS_ME_07;
	unsigned int	DVS_ME_08;
	unsigned int	DVS_ME_09;
	unsigned int	DVS_ME_10;
	unsigned int	DVS_ME_11;
	unsigned int	DVS_ME_12;
	unsigned int	DVS_ME_13;
	unsigned int	DVS_ME_14;
	unsigned int	DVS_ME_15;
	unsigned int	DVS_ME_16;
	unsigned int	DVS_ME_17;
	unsigned int	DVS_ME_18;
	unsigned int	DVS_ME_19;
	unsigned int	DVS_ME_20;
	unsigned int	DVS_ME_21;
	unsigned int	DVS_ME_22;
	unsigned int	DVS_ME_23;
	unsigned int	DVS_ME_24;
	unsigned int	DVS_ME_25;
	unsigned int	DVS_ME_26;
	unsigned int	DVS_ME_27;
	unsigned int	DVS_ME_28;
	unsigned int	DVS_ME_29;
	unsigned int	DVS_ME_30;
	unsigned int	DVS_ME_31;
	unsigned int	DVS_ME_32;
	unsigned int	DVS_ME_33;
	unsigned int	DVS_ME_34;
	unsigned int	DVS_ME_35;
	unsigned int	DVS_ME_36;
	unsigned int	DVS_ME_37;
	unsigned int	DVS_ME_38;
	unsigned int	DVS_ME_39;
	unsigned int	DVS_DEBUG;
	unsigned int	DVS_ME_RESERVED;
	unsigned int	DVS_ME_ATPG;
	unsigned int	DVS_ME_40;
	unsigned int	DVS_ME_41;
	unsigned int	DVS_OCC_PQ_0;
	unsigned int	DVS_OCC_PQ_1;
	unsigned int	DVS_OCC_PQ_2;
	unsigned int	DVS_OCC_PQ_3;
	unsigned int	DVS_OCC_PQ_4;
	unsigned int	DVS_OCC_PQ_5;
	unsigned int	DVS_OCC_PQ_6;
	unsigned int	DVS_OCC_PQ_7;
	unsigned int	DVS_OCC_PQ_8;
	unsigned int	DVS_OCC_PQ_9;
	unsigned int	DVS_OCC_PQ_10;
	unsigned int	DVS_OCC_PQ_11;
	unsigned int  DVS_OCC_ATPG;
	unsigned int	DVP_CTRL00;
	unsigned int	DVP_CTRL01;
	unsigned int	DVP_CTRL02;
	unsigned int	DVP_CTRL03;
	unsigned int	DVP_CTRL04;
	unsigned int	DVP_CTRL07;
	unsigned int	DVP_IRQ_00;
	unsigned int  DVP_IRQ_01;
	unsigned int	DVP_CTRL_STATUS0;
	unsigned int	DVP_CTRL_STATUS1;
	unsigned int	DVP_CTRL_STATUS2;
	unsigned int	DVP_IRQ_STATUS;
	unsigned int	DVP_FRM_STATUS0;
	unsigned int	DVP_FRM_STATUS2;
	unsigned int	DVP_CUR_STATUS;
	unsigned int	DVP_SRC_00;
	unsigned int	DVP_SRC_01;
	unsigned int	DVP_SRC_02;
	unsigned int	DVP_SRC_03;
	unsigned int	DVP_SRC_04;
	unsigned int	DVP_SRC_05_Y_FRM0;
	unsigned int	DVP_SRC_06_Y_FRM1;
	unsigned int	DVP_SRC_07_Y_FRM2;
	unsigned int	DVP_SRC_08_Y_FRM3;
	unsigned int	DVP_SRC_09_C_FRM0;
	unsigned int	DVP_SRC_10_C_FRM1;
	unsigned int	DVP_SRC_11_C_FRM2;
	unsigned int	DVP_SRC_12_C_FRM3;
	unsigned int	DVP_SRC_13_OCCDV0;
	unsigned int	DVP_SRC_14_OCCDV1;
	unsigned int	DVP_SRC_15_OCCDV2;
	unsigned int	DVP_SRC_16_OCCDV3;
	unsigned int	DVP_SRC_17_CRM;
	unsigned int	DVP_SRC_18_ASF_RMDV;
	unsigned int DVP_SRC_19_ASF_RDDV;
	unsigned int DVP_SRC_20_ASF_DV0;
	unsigned int DVP_SRC_21_ASF_DV1;
	unsigned int DVP_SRC_22_ASF_DV2;
	unsigned int DVP_SRC_23_ASF_DV3;
	unsigned int DVP_SRC_24_WMF_HFDV;
	unsigned int DVP_SRC_25_WMF_DV0;
	unsigned int DVP_SRC_26_WMF_DV1;
	unsigned int DVP_SRC_27_WMF_DV2;
	unsigned int DVP_SRC_28_WMF_DV3;
	unsigned int DVP_CORE_00;
	unsigned int DVP_CORE_01;
	unsigned int DVP_CORE_02;
	unsigned int DVP_CORE_03;
	unsigned int DVP_CORE_04;
	unsigned int DVP_CORE_05;
	unsigned int DVP_CORE_06;
	unsigned int DVP_CORE_07;
	unsigned int DVP_CORE_08;
	unsigned int DVP_CORE_09;
	unsigned int DVP_CORE_10;
	unsigned int DVP_CORE_11;
	unsigned int DVP_CORE_12;
	unsigned int DVP_CORE_13;
	unsigned int DVP_CORE_14;
	unsigned int DVP_CORE_15;
	unsigned int DVP_CORE_16;
	unsigned int DVP_SRC_CTRL;
	unsigned int DVP_CTRL_RESERVED;
	unsigned int DVP_CTRL_ATPG;
	unsigned int DVP_CRC_OUT_0;
	unsigned int DVP_CRC_OUT_1;
	unsigned int DVP_CRC_OUT_2;
	unsigned int DVP_CRC_CTRL;
	unsigned int DVP_CRC_OUT;
	unsigned int DVP_CRC_IN;
	unsigned int DVP_DRAM_STA;
	unsigned int DVP_DRAM_ULT;
	unsigned int DVP_DRAM_PITCH;
	unsigned int DVP_CORE_CRC_IN;
	unsigned int DVP_EXT_SRC_13_OCCDV0;
	unsigned int DVP_EXT_SRC_14_OCCDV1;
	unsigned int DVP_EXT_SRC_15_OCCDV2;
	unsigned int DVP_EXT_SRC_16_OCCDV3;
	unsigned int DVP_EXT_SRC_18_ASF_RMDV;
	unsigned int DVP_EXT_SRC_19_ASF_RDDV;
	unsigned int DVP_EXT_SRC_20_ASF_DV0;
	unsigned int DVP_EXT_SRC_21_ASF_DV1;
	unsigned int DVP_EXT_SRC_22_ASF_DV2;
	unsigned int DVP_EXT_SRC_23_ASF_DV3;
	//unsigned int	USERDUMP_EN;
	unsigned int DPE_MODE;
};
enum DPEMODE {
  MODE_DVS_DVP_BOTH = 0,
  MODE_DVS_ONLY,
  MODE_DVP_ONLY
};
enum DPE_MAINEYE_SEL {
  LEFT = 0,
  RIGHT = 1
};
struct DVS_SubModule_EN {
  bool sbf_en;
  bool conf_en;
  bool occ_en;
};
struct DVP_SubModule_EN {
  bool asf_crm_en;
  bool asf_rm_en;
  bool asf_rd_en;
  bool asf_hf_en;
  bool wmf_hf_en;
  bool wmf_filt_en;
  unsigned int asf_hf_rounds;
  unsigned int asf_nb_rounds;
  unsigned int wmf_filt_rounds;
  bool asf_recursive_en;
  unsigned int asf_conf_en;
	unsigned int asf_depth_mode;
};
struct DVS_Iteration {
  unsigned int y_IterTimes;
  unsigned int y_IterStartDirect_0;
  unsigned int y_IterStartDirect_1;
  unsigned int x_IterStartDirect_0;
  unsigned int x_IterStartDirect_1;
};
struct DPE_feedback {
  unsigned int reg1;
  unsigned int reg2;
};
struct DVS_Settings {
	enum DPE_MAINEYE_SEL mainEyeSel;
	struct DVS_ME_CFG TuningBuf_ME;
	struct DVS_OCC_CFG TuningBuf_OCC;
	struct DVS_SubModule_EN SubModule_EN;
	struct DVS_Iteration Iteration;
	bool is_pd_mode;
	unsigned int pd_frame_num; // set by driver
	unsigned int pd_st_x; // set by driver
	unsigned int frm_width;
	unsigned int frm_height;
	unsigned int l_eng_start_x;
	unsigned int r_eng_start_x;
	unsigned int eng_start_y;
	unsigned int eng_width;
	unsigned int eng_height;
	unsigned int occ_width;
	unsigned int dram_out_pitch_en;
	unsigned int dram_out_pitch;
	unsigned int occ_start_x;
	unsigned int dram_pxl_pitch;
	unsigned int input_offset;
	unsigned int output_offset;
	unsigned int out_adj_en;
	unsigned int out_adj_dv_en;
	unsigned int out_adj_dv_width;
	unsigned int out_adj_dv_high;
};
struct DVP_Settings {
  enum DPE_MAINEYE_SEL mainEyeSel;
  bool Y_only;
  struct DVP_CORE_CFG TuningBuf_CORE;
  struct DVP_SubModule_EN SubModule_EN;
	unsigned int frm_width;
	unsigned int frm_height;
	unsigned int eng_start_x;//engStart_x
	unsigned int eng_start_y;
	unsigned int eng_width;
	unsigned int eng_height;
};

struct DPE_Config_map {
	unsigned int Dpe_InBuf_SrcImg_Y_L_fd;
	unsigned int Dpe_InBuf_SrcImg_Y_L_Pre_fd;
	unsigned int Dpe_InBuf_SrcImg_Y_L_Ofs;
	unsigned int Dpe_InBuf_SrcImg_Y_L_Pre_Ofs;
	unsigned int Dpe_InBuf_SrcImg_Y_R_fd;
	unsigned int Dpe_InBuf_SrcImg_Y_R_Pre_fd;
	unsigned int Dpe_InBuf_SrcImg_Y_R_Ofs;
	unsigned int Dpe_InBuf_SrcImg_Y_R_Pre_Ofs;
	unsigned int Dpe_InBuf_SrcImg_Y_fd;
	unsigned int Dpe_InBuf_SrcImg_Y_Ofs;
	unsigned int Dpe_InBuf_SrcImg_C_fd;
	unsigned int Dpe_InBuf_SrcImg_C_Ofs;
	unsigned int Dpe_InBuf_ValidMap_L_fd;
	unsigned int Dpe_InBuf_ValidMap_L_Ofs;
	unsigned int Dpe_InBuf_ValidMap_R_fd;
	unsigned int Dpe_InBuf_ValidMap_R_Ofs;
	unsigned int Dpe_OutBuf_CONF_fd;
	unsigned int Dpe_OutBuf_CONF_Ofs;
	unsigned int Dpe_OutBuf_OCC_fd;
	unsigned int Dpe_OutBuf_OCC_Ofs;
	unsigned int Dpe_OutBuf_OCC_Ext_fd;
	unsigned int Dpe_OutBuf_OCC_Ext_Ofs;
	unsigned int Dpe_InBuf_OCC_fd;
	unsigned int Dpe_InBuf_OCC_Ofs;
	unsigned int Dpe_InBuf_OCC_Ext_fd;
	unsigned int Dpe_InBuf_OCC_Ext_Ofs;
	unsigned int Dpe_OutBuf_CRM_fd;
	unsigned int Dpe_OutBuf_CRM_Ofs;
	unsigned int Dpe_OutBuf_ASF_RD_fd;
	unsigned int Dpe_OutBuf_ASF_RD_Ofs;
	unsigned int Dpe_OutBuf_ASF_RD_Ext_fd;
	unsigned int Dpe_OutBuf_ASF_RD_Ext_Ofs;
	unsigned int Dpe_OutBuf_ASF_HF_fd;
	unsigned int Dpe_OutBuf_ASF_HF_Ofs;
	unsigned int Dpe_OutBuf_ASF_HF_Ext_fd;
	unsigned int Dpe_OutBuf_ASF_HF_Ext_Ofs;
	unsigned int Dpe_OutBuf_WMF_FILT_fd;
	unsigned int Dpe_OutBuf_WMF_FILT_Ofs;
	unsigned int DVS_SRC_21_INTER_MEDV_fd;
	unsigned int DVS_SRC_21_INTER_MEDV_Ofs;
	unsigned int DVS_SRC_34_DCV_L_FRM0_fd;
	unsigned int DVS_SRC_34_DCV_L_FRM0_Ofs;
	unsigned int DVP_SRC_18_ASF_RMDV_fd;
	unsigned int DVP_SRC_18_ASF_RMDV_Ofs;
	unsigned int DVP_SRC_24_WMF_HFDV_fd;
	unsigned int DVP_SRC_24_WMF_HFDV_Ofs;
	unsigned int DVP_EXT_SRC_18_ASF_RMDV_fd;
	unsigned int DVP_EXT_SRC_18_ASF_RMDV_Ofs;
	unsigned int Dpe_InBuf_P4_L_DV_fd;
	unsigned int Dpe_InBuf_P4_L_DV_Ofs;
	unsigned int Dpe_InBuf_P4_R_DV_fd;
	unsigned int Dpe_InBuf_P4_R_DV_Ofs;
};

struct DPE_Config {
	enum DPEMODE Dpe_engineSelect;
	unsigned int Dpe_is16BitMode;
	struct DVS_Settings	Dpe_DVSSettings;
	struct DVP_Settings	Dpe_DVPSettings;
	struct DPE_Config_map DPE_DMapSettings;
	unsigned int Dpe_InBuf_SrcImg_Y_L;
	unsigned int Dpe_InBuf_SrcImg_Y_R;
	unsigned int Dpe_InBuf_SrcImg_Y;
	unsigned int Dpe_InBuf_SrcImg_C;
	unsigned int Dpe_InBuf_ValidMap_L;
	unsigned int Dpe_InBuf_ValidMap_R;
	unsigned int Dpe_OutBuf_CONF;
	unsigned int Dpe_OutBuf_OCC;
	unsigned int Dpe_OutBuf_OCC_Ext;
	unsigned int Dpe_InBuf_OCC;
	unsigned int Dpe_InBuf_OCC_Ext;
	unsigned int Dpe_OutBuf_CRM;
	unsigned int Dpe_OutBuf_ASF_RM;
	unsigned int Dpe_OutBuf_ASF_RM_Ext;
	unsigned int Dpe_OutBuf_ASF_RD;
	unsigned int Dpe_OutBuf_ASF_RD_Ext;
	unsigned int Dpe_OutBuf_ASF_HF;
	unsigned int Dpe_OutBuf_ASF_HF_Ext;
	unsigned int Dpe_OutBuf_WMF_HF;
	unsigned int Dpe_OutBuf_WMF_FILT;
	unsigned int DVP_SRC_18_ASF_RMDV;
	unsigned int DVP_SRC_24_WMF_HFDV;
	unsigned int DVP_EXT_SRC_18_ASF_RMDV;
	unsigned int Dpe_InBuf_SrcImg_Y_L_Pre;
	unsigned int Dpe_InBuf_SrcImg_Y_R_Pre;
	unsigned int Dpe_InBuf_P4_L_DV;
	unsigned int Dpe_InBuf_P4_R_DV;
	struct DPE_feedback	Dpe_feedback;
};
enum DPE_CMD_ENUM {
  DPE_CMD_RESET,
  DPE_CMD_DUMP_REG,
  DPE_CMD_DUMP_ISR_LOG,
  DPE_CMD_READ_REG,
  DPE_CMD_WRITE_REG,
  DPE_CMD_WAIT_IRQ,
  DPE_CMD_CLEAR_IRQ,
  DPE_CMD_ENQUE_NUM,
  DPE_CMD_ENQUE,
  DPE_CMD_ENQUE_REQ,
  DPE_CMD_DEQUE_NUM,
  DPE_CMD_DEQUE,
  DPE_CMD_DEQUE_REQ,
  DPE_CMD_TOTAL,
};
struct DPE_Request {
  unsigned int m_ReqNum;
  struct DPE_Config * m_pDpeConfig;
};
#define DPE_RESET _IO(DPE_MAGIC, DPE_CMD_RESET)
#define DPE_DUMP_REG _IO(DPE_MAGIC, DPE_CMD_DUMP_REG)
#define DPE_DUMP_ISR_LOG _IO(DPE_MAGIC, DPE_CMD_DUMP_ISR_LOG)
#define DPE_READ_REGISTER _IOWR(DPE_MAGIC, DPE_CMD_READ_REG, struct DPE_REG_IO_STRUCT)
#define DPE_WRITE_REGISTER _IOWR(DPE_MAGIC, DPE_CMD_WRITE_REG, struct DPE_REG_IO_STRUCT)
#define DPE_WAIT_IRQ _IOW(DPE_MAGIC, DPE_CMD_WAIT_IRQ, struct DPE_WAIT_IRQ_STRUCT)
#define DPE_CLEAR_IRQ _IOW(DPE_MAGIC, DPE_CMD_CLEAR_IRQ, struct DPE_CLEAR_IRQ_STRUCT)
#define DPE_ENQNUE_NUM _IOW(DPE_MAGIC, DPE_CMD_ENQUE_NUM, int)
#define DPE_ENQUE _IOWR(DPE_MAGIC, DPE_CMD_ENQUE, struct DPE_Config)
#define DPE_ENQUE_REQ _IOWR(DPE_MAGIC, DPE_CMD_ENQUE_REQ, struct DPE_Request)
#define DPE_DEQUE_NUM _IOR(DPE_MAGIC, DPE_CMD_DEQUE_NUM, int)
#define DPE_DEQUE _IOWR(DPE_MAGIC, DPE_CMD_DEQUE, struct DPE_Config)
#define DPE_DEQUE_REQ _IOWR(DPE_MAGIC, DPE_CMD_DEQUE_REQ, struct DPE_Request)
#endif

