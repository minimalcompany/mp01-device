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
#ifndef _HEADER_DESC_
#define _HEADER_DESC_
#include <linux/videodev2.h>
enum imgsysrotation {
  imgsysrotation_0 = 0,
  imgsysrotation_90,
  imgsysrotation_180,
  imgsysrotation_270
};
enum imgsysflip {
  imgsysflip_off = 0,
  imgsysflip_on = 1,
};
enum img_resize_ratio {
  img_resize_anyratio,
  img_resize_down4,
  img_resize_down2,
  img_resize_down42,
  img_resiz_max
};
#define COMPACT_USE
struct v4l2_ext_plane {
#ifndef COMPACT_USE
  __u32 bytesused;
  __u32 length;
#endif
  union {
#ifndef COMPACT_USE
    __u32 mem_offset;
    __u64 userptr;
#endif
    struct {
      __s32 fd;
      __u32 offset;
    } dma_buf;
  } m;
#ifndef COMPACT_USE
  __u32 data_offset;
  __u32 reserved[11];
#else
  __u64 reserved[2];
#endif
};
#define IMGBUF_MAX_PLANES (3)
struct v4l2_ext_buffer {
#ifndef COMPACT_USE
  __u32 index;
  __u32 type;
  __u32 flags;
  __u32 field;
  __u64 timestamp;
  __u32 sequence;
  __u32 memory;
#endif
  struct v4l2_ext_plane planes[IMGBUF_MAX_PLANES];
  __u32 num_planes;
#ifndef COMPACT_USE
  __u32 reserved[11];
#else
  __u64 reserved[2];
#endif
};
struct mtk_imgsys_crop {
  struct v4l2_rect c;
  struct v4l2_fract left_subpix;
  struct v4l2_fract top_subpix;
  struct v4l2_fract width_subpix;
  struct v4l2_fract height_subpix;
};
struct plane_pix_format {
  __u32 sizeimage;
  __u32 bytesperline;
} __attribute__((packed));
struct pix_format_mplane {
  __u32 width;
  __u32 height;
  __u32 pixelformat;
  struct plane_pix_format plane_fmt[IMGBUF_MAX_PLANES];
} __attribute__((packed));
struct buf_format {
  union {
    struct pix_format_mplane pix_mp;
  } fmt;
};
struct buf_info {
  struct v4l2_ext_buffer buf;
  struct buf_format fmt;
  struct mtk_imgsys_crop crop;
  __u32 rotation;
  __u32 hflip;
  __u32 vflip;
  __u8 resizeratio;
  __u32 secu;
};
#define FRAME_BUF_MAX (1)
struct frameparams {
  struct buf_info bufs[FRAME_BUF_MAX];
};
#define SCALE_MAX (1)
#define TIME_MAX (128)
struct header_desc {
  __u32 fparams_tnum;
  struct frameparams fparams[TIME_MAX][SCALE_MAX];
};
#define TMAX (64)
struct header_desc_norm {
  __u32 fparams_tnum;
  struct frameparams fparams[TMAX][SCALE_MAX];
};
#define IMG_MAX_HW_INPUTS 3
#define IMG_MAX_HW_OUTPUTS 4
#define IMG_MAX_HW_DMAS 72
struct singlenode_desc {
  __u8 dmas_enable[IMG_MAX_HW_DMAS][TIME_MAX];
  struct header_desc dmas[IMG_MAX_HW_DMAS];
  struct header_desc tuning_meta;
  struct header_desc ctrl_meta;
};
struct singlenode_desc_norm {
  __u8 dmas_enable[IMG_MAX_HW_DMAS][TMAX];
  struct header_desc_norm dmas[IMG_MAX_HW_DMAS];
  struct header_desc_norm tuning_meta;
  struct header_desc_norm ctrl_meta;
};
#define V4L2_META_FMT_MTISP_DESC v4l2_fourcc('M', 'T', 'f', 'd')
#define V4L2_META_FMT_MTISP_SD v4l2_fourcc('M', 'T', 'f', 's')
#define V4L2_META_FMT_MTISP_DESC_NORM v4l2_fourcc('M', 'T', 'f', 'r')
#define V4L2_META_FMT_MTISP_SDNORM v4l2_fourcc('M', 'T', 's', 'r')
#define V4L2_PIX_FMT_WARP2P v4l2_fourcc('M', 'W', '2', 'P')
#define V4L2_PIX_FMT_YUV422 v4l2_fourcc('Y', 'U', '1', '6')
#define V4L2_PIX_FMT_YUYV_Y210P v4l2_fourcc('Y', 'U', '1', 'A')
#define V4L2_PIX_FMT_YVYU_Y210P v4l2_fourcc('Y', 'V', '1', 'A')
#define V4L2_PIX_FMT_UYVY_Y210P v4l2_fourcc('U', 'Y', '1', 'A')
#define V4L2_PIX_FMT_VYUY_Y210P v4l2_fourcc('V', 'Y', '1', 'A')
#define V4L2_PIX_FMT_YUV_2P210P v4l2_fourcc('U', '2', '2', 'A')
#define V4L2_PIX_FMT_YVU_2P210P v4l2_fourcc('V', '2', '2', 'A')
#define V4L2_PIX_FMT_YUV_3P210P v4l2_fourcc('Y', '2', '3', 'A')
#define V4L2_PIX_FMT_YUV_2P010P v4l2_fourcc('U', '0', '2', 'A')
#define V4L2_PIX_FMT_YVU_2P010P v4l2_fourcc('V', '0', '2', 'A')
#define V4L2_PIX_FMT_YUV_3P010P v4l2_fourcc('Y', '0', '3', 'A')
#define V4L2_PIX_FMT_YUYV_Y210 v4l2_fourcc('Y', 'U', '1', 'a')
#define V4L2_PIX_FMT_YVYU_Y210 v4l2_fourcc('Y', 'V', '1', 'a')
#define V4L2_PIX_FMT_UYVY_Y210 v4l2_fourcc('U', 'Y', '1', 'a')
#define V4L2_PIX_FMT_VYUY_Y210 v4l2_fourcc('V', 'Y', '1', 'a')
#define V4L2_PIX_FMT_YUV_2P210 v4l2_fourcc('U', '2', '2', 'a')
#define V4L2_PIX_FMT_YVU_2P210 v4l2_fourcc('V', '2', '2', 'a')
#define V4L2_PIX_FMT_YUV_3P210 v4l2_fourcc('Y', '2', '3', 'a')
#define V4L2_PIX_FMT_YUV_2P010 v4l2_fourcc('U', '0', '2', 'a')
#define V4L2_PIX_FMT_YVU_2P010 v4l2_fourcc('V', '0', '2', 'a')
#define V4L2_PIX_FMT_YUV_3P010 v4l2_fourcc('Y', '0', '3', 'a')
#define V4L2_PIX_FMT_YUV_2P012P v4l2_fourcc('U', '0', '2', 'C')
#define V4L2_PIX_FMT_YVU_2P012P v4l2_fourcc('V', '0', '2', 'C')
#define V4L2_PIX_FMT_YUV_2P012 v4l2_fourcc('U', '0', '2', 'c')
#define V4L2_PIX_FMT_YVU_2P012 v4l2_fourcc('V', '0', '2', 'c')
#define V4L2_PIX_FMT_MTISP_RGB3PP8 v4l2_fourcc('M', 'r', '3', '8')
#define V4L2_PIX_FMT_MTISP_RGB3PP10 v4l2_fourcc('M', 'r', '3', 'a')
#define V4L2_PIX_FMT_MTISP_RGB3PP12 v4l2_fourcc('M', 'r', '3', 'c')
#define V4L2_PIX_FMT_MTISP_RGB3PU8 v4l2_fourcc('M', 'R', '3', '8')
#define V4L2_PIX_FMT_MTISP_RGB3PU10 v4l2_fourcc('M', 'R', '3', 'A')
#define V4L2_PIX_FMT_MTISP_RGB3PU12 v4l2_fourcc('M', 'R', '3', 'C')
#define V4L2_PIX_FMT_MTISP_FGRBP8 v4l2_fourcc('M', 'F', 'g', '8')
#define V4L2_PIX_FMT_MTISP_FGRBP10 v4l2_fourcc('M', 'F', 'g', 'a')
#define V4L2_PIX_FMT_MTISP_FGRBP12 v4l2_fourcc('M', 'F', 'g', 'c')
#define V4L2_PIX_FMT_MTISP_FGRBU8 v4l2_fourcc('M', 'F', 'G', '8')
#define V4L2_PIX_FMT_MTISP_FGRBU10 v4l2_fourcc('M', 'F', 'G', 'A')
#define V4L2_PIX_FMT_MTISP_FGRBU12 v4l2_fourcc('M', 'F', 'G', 'C')
#define V4L2_PIX_FMT_MTISP_FGRB3P8 v4l2_fourcc('M', 'f', '3', '8')
#define V4L2_PIX_FMT_MTISP_FGRB3P10 v4l2_fourcc('M', 'f', '3', 'a')
#define V4L2_PIX_FMT_MTISP_FGRB3P12 v4l2_fourcc('M', 'f', '3', 'c')
#define V4L2_PIX_FMT_MTISP_FGRB3U8 v4l2_fourcc('M', 'F', '3', '8')
#define V4L2_PIX_FMT_MTISP_FGRB3U10 v4l2_fourcc('M', 'F', '3', 'A')
#define V4L2_PIX_FMT_MTISP_FGRB3U12 v4l2_fourcc('M', 'F', '3', 'C')
#define V4L2_PIX_FMT_MTISP_RGB48 v4l2_fourcc('M', 'R', '1', '6')
#define V4L2_PIX_FMT_MTISP_Y32 v4l2_fourcc('M', 'T', '3', '2')
#define V4L2_PIX_FMT_MTISP_Y16 v4l2_fourcc('M', 'T', '1', '6')
#define V4L2_PIX_FMT_MTISP_Y8 v4l2_fourcc('M', 'T', '0', '8')
#define V4L2_PIX_FMT_MTISP_SBGGRU10 v4l2_fourcc('M', 'b', 'B', 'A')
#define V4L2_PIX_FMT_MTISP_SGBRGU10 v4l2_fourcc('M', 'b', 'G', 'A')
#define V4L2_PIX_FMT_MTISP_SGRBGU10 v4l2_fourcc('M', 'b', 'g', 'A')
#define V4L2_PIX_FMT_MTISP_SRGGBU10 v4l2_fourcc('M', 'b', 'R', 'A')
#define V4L2_PIX_FMT_MTISP_SBGGRU12 v4l2_fourcc('M', 'b', 'B', 'C')
#define V4L2_PIX_FMT_MTISP_SGBRGU12 v4l2_fourcc('M', 'b', 'G', 'C')
#define V4L2_PIX_FMT_MTISP_SGRBGU12 v4l2_fourcc('M', 'b', 'g', 'C')
#define V4L2_PIX_FMT_MTISP_SRGGBU12 v4l2_fourcc('M', 'b', 'R', 'C')
#define V4L2_PIX_FMT_MTISP_SBGGRU14 v4l2_fourcc('M', 'b', 'B', 'E')
#define V4L2_PIX_FMT_MTISP_SGBRGU14 v4l2_fourcc('M', 'b', 'G', 'E')
#define V4L2_PIX_FMT_MTISP_SGRBGU14 v4l2_fourcc('M', 'b', 'g', 'E')
#define V4L2_PIX_FMT_MTISP_SRGGBU14 v4l2_fourcc('M', 'b', 'R', 'E')
#define V4L2_PIX_FMT_MTISP_SBGGRU15 v4l2_fourcc('M', 'b', 'B', 'F')
#define V4L2_PIX_FMT_MTISP_SGBRGU15 v4l2_fourcc('M', 'b', 'G', 'F')
#define V4L2_PIX_FMT_MTISP_SGRBGU15 v4l2_fourcc('M', 'b', 'g', 'F')
#define V4L2_PIX_FMT_MTISP_SRGGBU15 v4l2_fourcc('M', 'b', 'R', 'F')
#define V4L2_PIX_FMT_MTISP_SBGGR16 v4l2_fourcc('M', 'B', 'B', 'G')
#define V4L2_PIX_FMT_MTISP_SGBRG16 v4l2_fourcc('M', 'B', 'G', 'G')
#define V4L2_PIX_FMT_MTISP_SGRBG16 v4l2_fourcc('M', 'B', 'g', 'G')
#define V4L2_PIX_FMT_MTISP_SRGGB16 v4l2_fourcc('M', 'B', 'R', 'G')
#define V4L2_PIX_FMT_MTISP_SBGGR22 v4l2_fourcc('M', 'B', 'B', 'M')
#define V4L2_PIX_FMT_MTISP_SGBRG22 v4l2_fourcc('M', 'B', 'G', 'M')
#define V4L2_PIX_FMT_MTISP_SGRBG22 v4l2_fourcc('M', 'B', 'g', 'M')
#define V4L2_PIX_FMT_MTISP_SRGGB22 v4l2_fourcc('M', 'B', 'R', 'M')
#define V4L2_PIX_FMT_UFBC_NV12 v4l2_fourcc('U', 'F', '2', '8')
#define V4L2_PIX_FMT_UFBC_NV21 v4l2_fourcc('V', 'F', '2', '8')
#define V4L2_PIX_FMT_UFBC_YUV_2P010P v4l2_fourcc('U', 'F', '2', 'A')
#define V4L2_PIX_FMT_UFBC_YVU_2P010P v4l2_fourcc('V', 'F', '2', 'A')
#define V4L2_PIX_FMT_UFBC_YUV_2P012P v4l2_fourcc('U', 'F', '2', 'C')
#define V4L2_PIX_FMT_UFBC_YVU_2P012P v4l2_fourcc('V', 'F', '2', 'C')
#define V4L2_PIX_FMT_MTISP_UFBC_SBGGR8 v4l2_fourcc('U', 'B', 'B', '8')
#define V4L2_PIX_FMT_MTISP_UFBC_SGBRG8 v4l2_fourcc('U', 'B', 'G', '8')
#define V4L2_PIX_FMT_MTISP_UFBC_SGRBG8 v4l2_fourcc('U', 'B', 'g', '8')
#define V4L2_PIX_FMT_MTISP_UFBC_SRGGB8 v4l2_fourcc('U', 'B', 'R', '8')
#define V4L2_PIX_FMT_MTISP_UFBC_SBGGR10 v4l2_fourcc('U', 'B', 'B', 'A')
#define V4L2_PIX_FMT_MTISP_UFBC_SGBRG10 v4l2_fourcc('U', 'B', 'G', 'A')
#define V4L2_PIX_FMT_MTISP_UFBC_SGRBG10 v4l2_fourcc('U', 'B', 'g', 'A')
#define V4L2_PIX_FMT_MTISP_UFBC_SRGGB10 v4l2_fourcc('U', 'B', 'R', 'A')
#define V4L2_PIX_FMT_MTISP_UFBC_SBGGR12 v4l2_fourcc('U', 'B', 'B', 'C')
#define V4L2_PIX_FMT_MTISP_UFBC_SGBRG12 v4l2_fourcc('U', 'B', 'G', 'C')
#define V4L2_PIX_FMT_MTISP_UFBC_SGRBG12 v4l2_fourcc('U', 'B', 'g', 'C')
#define V4L2_PIX_FMT_MTISP_UFBC_SRGGB12 v4l2_fourcc('U', 'B', 'R', 'C')
#define V4L2_PIX_FMT_MTISP_UFBC_SBGGR14 v4l2_fourcc('U', 'B', 'B', 'E')
#define V4L2_PIX_FMT_MTISP_UFBC_SGBRG14 v4l2_fourcc('U', 'B', 'G', 'E')
#define V4L2_PIX_FMT_MTISP_UFBC_SGRBG14 v4l2_fourcc('U', 'B', 'g', 'E')
#define V4L2_PIX_FMT_MTISP_UFBC_SRGGB14 v4l2_fourcc('U', 'B', 'R', 'E')
#endif
