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
#ifndef _MTK_VIDEODEV2_H
#define _MTK_VIDEODEV2_H

#include <linux/videodev2.h>
#include <linux/v4l2-controls.h>

#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4')
#define V4L2_PIX_FMT_H265 v4l2_fourcc('H', '2', '6', '5')
#define V4L2_PIX_FMT_HEIF v4l2_fourcc('H', 'E', 'I', 'F')



#define V4L2_PIX_FMT_VP8_FRAME v4l2_fourcc('V', 'P', '8', 'F')

#define V4L2_PIX_FMT_WMV1 v4l2_fourcc('W', 'M', 'V', '1')
#define V4L2_PIX_FMT_WMV2 v4l2_fourcc('W', 'M', 'V', '2')
#define V4L2_PIX_FMT_WMV3 v4l2_fourcc('W', 'M', 'V', '3')
#define V4L2_PIX_FMT_WMVA v4l2_fourcc('W', 'M', 'V', 'A')
#define V4L2_PIX_FMT_WVC1 v4l2_fourcc('W', 'V', 'C', '1')
#define V4L2_PIX_FMT_RV30 v4l2_fourcc('R', 'V', '3', '0')
#define V4L2_PIX_FMT_RV40 v4l2_fourcc('R', 'V', '4', '0')
#define V4L2_PIX_FMT_AV1 v4l2_fourcc('A', 'V', '1', '0')

#define V4L2_PIX_FMT_MT21 v4l2_fourcc('M', 'M', '2', '1')
#define V4L2_PIX_FMT_MT2110T v4l2_fourcc('M', 'T', '2', 'T')
#define V4L2_PIX_FMT_MT2110R v4l2_fourcc('M', 'T', '2', 'R')
#define V4L2_PIX_FMT_MT21C10T v4l2_fourcc('M', 'T', 'C', 'T')
#define V4L2_PIX_FMT_MT21C10R v4l2_fourcc('M', 'T', 'C', 'R')
#define V4L2_PIX_FMT_MT21CS v4l2_fourcc('M', '2', 'C', 'S')
#define V4L2_PIX_FMT_MT21S v4l2_fourcc('M', '2', '1', 'S')
#define V4L2_PIX_FMT_MT21S10T v4l2_fourcc('M', 'T', 'S', 'T')
#define V4L2_PIX_FMT_MT21S10R v4l2_fourcc('M', 'T', 'S', 'R')
#define V4L2_PIX_FMT_MT21CS10T v4l2_fourcc('M', 'C', 'S', 'T')
#define V4L2_PIX_FMT_MT21CS10R v4l2_fourcc('M', 'C', 'S', 'R')
#define V4L2_PIX_FMT_MT21CSA v4l2_fourcc('M', 'A', 'C', 'S')
#define V4L2_PIX_FMT_MT21S10TJ v4l2_fourcc('M', 'J', 'S', 'T')
#define V4L2_PIX_FMT_MT21S10RJ v4l2_fourcc('M', 'J', 'S', 'R')
#define V4L2_PIX_FMT_MT21CS10TJ v4l2_fourcc('J', 'C', 'S', 'T')
#define V4L2_PIX_FMT_MT21CS10RJ v4l2_fourcc('J', 'C', 'S', 'R')
#define V4L2_PIX_FMT_P010M v4l2_fourcc('P', '0', '1', '0')
#define V4L2_PIX_FMT_P010S v4l2_fourcc('P', '0', '1', 'S')
#define V4L2_PIX_FMT_MT10 v4l2_fourcc('M', 'T', '1', '0')
#define V4L2_PIX_FMT_MT10S v4l2_fourcc('M', '1', '0', 'S')
#define V4L2_PIX_FMT_ARGB1010102  v4l2_fourcc('A', 'B', '3', '0')
#define V4L2_PIX_FMT_ABGR1010102  v4l2_fourcc('A', 'R', '3', '0')
#define V4L2_PIX_FMT_RGBA1010102  v4l2_fourcc('R', 'A', '3', '0')
#define V4L2_PIX_FMT_BGRA1010102  v4l2_fourcc('B', 'A', '3', '0')
#define V4L2_PIX_FMT_RGB32_AFBC v4l2_fourcc('M', 'C', 'R', '8')
#define V4L2_PIX_FMT_BGR32_AFBC v4l2_fourcc('M', 'C', 'B', '8')
#define V4L2_PIX_FMT_RGBA1010102_AFBC v4l2_fourcc('M', 'C', 'R', 'X')
#define V4L2_PIX_FMT_BGRA1010102_AFBC v4l2_fourcc('M', 'C', 'B', 'X')
#define V4L2_PIX_FMT_NV12_AFBC v4l2_fourcc('M', 'C', 'N', '8')
#define V4L2_PIX_FMT_NV12_10B_AFBC v4l2_fourcc('M', 'C', 'N', 'X')
#define V4L2_PIX_FMT_NV21_AFBC v4l2_fourcc('M', 'N', '2', '8')

#define V4L2_BUF_FLAG_CORRUPT 0x00000080
#define V4L2_BUF_FLAG_REF_FREED 0x00000200
#define V4L2_BUF_FLAG_CROP_CHANGED 0x00008000
#define V4L2_BUF_FLAG_CSD 0x00200000
#define V4L2_BUF_FLAG_ROI 0x00400000
#define V4L2_BUF_FLAG_HDR_META 0x00800000
#define V4L2_BUF_FLAG_OUTPUT_NOT_GENERATED 0x02000000
#define V4L2_BUF_FLAG_QP_META 0x01000000
#define V4L2_BUF_FLAG_HAS_META 0x4000000

#define V4L2_EVENT_MTK_VCODEC_START	(V4L2_EVENT_PRIVATE_START + 0x00002000)
#define V4L2_EVENT_MTK_VDEC_ERROR	(V4L2_EVENT_MTK_VCODEC_START + 1)
#define V4L2_EVENT_MTK_VDEC_NOHEADER	(V4L2_EVENT_MTK_VCODEC_START + 2)
#define V4L2_EVENT_MTK_VENC_ERROR	(V4L2_EVENT_MTK_VCODEC_START + 3)


#endif
