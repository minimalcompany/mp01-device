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
#ifndef _MT_FDVT_H
#define _MT_FDVT_H
#include <linux/ioctl.h>
#define KERNEL_LOG
#define MAX_FDVT_FRAME_REQUEST 32
#define MAX_FDVT_REQUEST_RING_SIZE 32
#define SIG_ERESTARTSYS 512
#define FDVT_DEV_MAJOR_NUMBER 258
#define FDVT_MAGIC 'N'
#define FDVT_REG_RANGE (0x1000)
#define FDVT_BASE_HW 0x1B001000
#define FDVT_INT_ST (1 << 0)
struct FDVT_REG_STRUCT {
  unsigned int module;
  unsigned int addr;
  unsigned int val;
};
#define FDVT_REG_STRUCT struct FDVT_REG_STRUCT
struct FDVT_REG_IO_STRUCT {
  FDVT_REG_STRUCT * pData;
  unsigned int count;
};
#define FDVT_REG_IO_STRUCT struct FDVT_REG_IO_STRUCT
enum FDVT_IRQ_CLEAR_ENUM {
  FDVT_IRQ_CLEAR_NONE,
  FDVT_IRQ_CLEAR_WAIT,
  FDVT_IRQ_WAIT_CLEAR,
  FDVT_IRQ_CLEAR_STATUS,
  FDVT_IRQ_CLEAR_ALL
};
#define FDVT_IRQ_CLEAR_ENUM enum FDVT_IRQ_CLEAR_ENUM
enum FDVT_IRQ_TYPE_ENUM {
  FDVT_IRQ_TYPE_INT_FDVT_ST,
  FDVT_IRQ_TYPE_AMOUNT
};
#define FDVT_IRQ_TYPE_ENUM enum FDVT_IRQ_TYPE_ENUM
struct FDVT_WAIT_IRQ_STRUCT {
  FDVT_IRQ_CLEAR_ENUM clear;
  FDVT_IRQ_TYPE_ENUM type;
  unsigned int status;
  unsigned int timeout;
  int user_key;
  int process_id;
  unsigned int dump_reg;
  bool isSecure;
};
#define FDVT_WAIT_IRQ_STRUCT struct FDVT_WAIT_IRQ_STRUCT
struct FDVT_CLEAR_IRQ_STRUCT {
  FDVT_IRQ_TYPE_ENUM type;
  int user_key;
  unsigned int status;
};
#define FDVT_CLEAR_IRQ_STRUCT struct FDVT_CLEAR_IRQ_STRUCT

struct FDVT_ROI {
	uint32_t x1;
	uint32_t y1;
	uint32_t x2;
	uint32_t y2;
};

struct FDVT_PADDING {
	uint32_t left;
	uint32_t right;
	uint32_t down;
	uint32_t up;
};

struct FDVT_MetaDataToGCE {
	unsigned int ImgSrcY_Handler;
	unsigned int ImgSrcUV_Handler;
	unsigned int YUVConfig_Handler;
	unsigned int YUVOutBuf_Handler;
	unsigned int RSConfig_Handler;
	unsigned int RSOutBuf_Handler;
	unsigned int FDConfig_Handler;
	unsigned int FDOutBuf_Handler;
	unsigned int FD_POSE_Config_Handler;
	unsigned int FDResultBuf_MVA;
	unsigned int ImgSrc_Y_Size;
	unsigned int ImgSrc_UV_Size;
	unsigned int YUVConfigSize;
	unsigned int YUVOutBufSize;
	unsigned int RSConfigSize;
	unsigned int RSOutBufSize;
	unsigned int FDConfigSize;
	unsigned int FD_POSE_ConfigSize;
	unsigned int FDOutBufSize;
	unsigned int FDResultBufSize;
	unsigned int FDMode;
	unsigned int srcImgFmt;
	unsigned int srcImgWidth;
	unsigned int srcImgHeight;
	unsigned int maxWidth;
	unsigned int maxHeight;
	unsigned int rotateDegree;
	unsigned short featureTH;
	unsigned short SecMemType;
	unsigned int enROI;
	struct FDVT_ROI src_roi;
	unsigned int enPadding;
	struct FDVT_PADDING src_padding;
	unsigned int SRC_IMG_STRIDE;
	unsigned int pyramid_width;
	unsigned int pyramid_height;
	bool isReleased;
};
#define FDVT_MetaDataToGCE struct FDVT_MetaDataToGCE

struct fdvt_config {
  unsigned int FDVT_RSCON_BASE_ADR;
  unsigned int FDVT_YUV2RGB;
  unsigned int FDVT_YUV2RGBCON_BASE_ADR;
  unsigned int FDVT_FD_CON_BASE_ADR;
  unsigned int FDVT_FD_POSE_CON_BASE_ADR;
  unsigned int FDVT_YUV_SRC_WD_HT;
  unsigned int FD_MODE;
  unsigned int RESULT;
  unsigned int RESULT1;
  unsigned int FDVT_IS_SECURE;
  unsigned int FDVT_RSCON_BUFSIZE;
  unsigned int FDVT_YUV2RGBCON_BUFSIZE;
  unsigned int FDVT_FD_CON_BUFSIZE;
  unsigned int FDVT_FD_POSE_CON_BUFSIZE;
  unsigned int FDVT_LOOPS_OF_FDMODE;
  unsigned int FDVT_NUMBERS_OF_PYRAMID;
  struct NSCam::NSIoPipe::FD_RESULT *FDOUTPUT;
  struct NSCam::NSIoPipe::ATTRIBUTE_RESULT *ATTRIBUTEOUTPUT;
  struct NSCam::NSIoPipe::POSE_RESULT *POSEOUTPUT;
  FDVT_MetaDataToGCE FDVT_METADATA_TO_GCE;
  unsigned int *FDVT_IMG_Y_VA;
  unsigned int *FDVT_IMG_UV_VA;
  unsigned int FDVT_IMG_Y_FD;
  unsigned int FDVT_IMG_UV_FD;
  unsigned int FDVT_IMG_Y_OFFSET;
  unsigned int FDVT_IMG_UV_OFFSET;
  unsigned int SRC_IMG_STRIDE;
  struct FDVT_ROI src_roi;
  NSCam::NSIoPipe::FDVTFORMAT SRC_IMG_FMT;
  unsigned int enROI;
  unsigned int IS_LEGACY;
};
#define FDVT_Config struct fdvt_config
enum FDVT_CMD_ENUM {
  FDVT_CMD_RESET,
  FDVT_CMD_DUMP_REG,
  FDVT_CMD_DUMP_ISR_LOG,
  FDVT_CMD_READ_REG,
  FDVT_CMD_WRITE_REG,
  FDVT_CMD_WAIT_IRQ,
  FDVT_CMD_CLEAR_IRQ,
  FDVT_CMD_ENQUE_NUM,
  FDVT_CMD_ENQUE,
  FDVT_CMD_ENQUE_REQ,
  FDVT_CMD_DEQUE_NUM,
  FDVT_CMD_DEQUE,
  FDVT_CMD_DEQUE_REQ,
  FDVT_CMD_TOTAL,
};
struct FDVT_Request {
  unsigned int m_ReqNum;
  FDVT_Config * m_pFdvtConfig;
};
#define FDVT_Request struct FDVT_Request
#define FDVT_RESET _IO(FDVT_MAGIC, FDVT_CMD_RESET)
#define FDVT_DUMP_REG _IO(FDVT_MAGIC, FDVT_CMD_DUMP_REG)
#define FDVT_DUMP_ISR_LOG _IO(FDVT_MAGIC, FDVT_CMD_DUMP_ISR_LOG)
#define FDVT_READ_REGISTER _IOWR(FDVT_MAGIC, FDVT_CMD_READ_REG, FDVT_REG_IO_STRUCT)
#define FDVT_WRITE_REGISTER _IOWR(FDVT_MAGIC, FDVT_CMD_WRITE_REG, FDVT_REG_IO_STRUCT)
#define FDVT_WAIT_IRQ _IOW(FDVT_MAGIC, FDVT_CMD_WAIT_IRQ, FDVT_WAIT_IRQ_STRUCT)
#define FDVT_CLEAR_IRQ _IOW(FDVT_MAGIC, FDVT_CMD_CLEAR_IRQ, FDVT_CLEAR_IRQ_STRUCT)
#define FDVT_ENQNUE_NUM _IOW(FDVT_MAGIC, FDVT_CMD_ENQUE_NUM, int)
#define FDVT_ENQUE _IOWR(FDVT_MAGIC, FDVT_CMD_ENQUE, FDVT_Config)
#define FDVT_ENQUE_REQ _IOWR(FDVT_MAGIC, FDVT_CMD_ENQUE_REQ, FDVT_Request)
#define FDVT_DEQUE_NUM _IOR(FDVT_MAGIC, FDVT_CMD_DEQUE_NUM, int)
#define FDVT_DEQUE _IOWR(FDVT_MAGIC, FDVT_CMD_DEQUE, FDVT_Config)
#define FDVT_DEQUE_REQ _IOWR(FDVT_MAGIC, FDVT_CMD_DEQUE_REQ, FDVT_Request)
#endif
