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
#ifndef MTK_FMT_H
#define MTK_FMT_H
typedef struct fmt_pmqos {
  uint32_t tv_sec;
  uint32_t tv_usec;
  uint32_t pixel_size;
  uint32_t rdma_datasize;
  uint32_t wdma_datasize;
} fmt_pmqos_t;
typedef struct gce_cmdq_obj {
  uint64_t cmds_user_ptr;
  uint32_t identifier;
  uint32_t secure;
  uint32_t * taskid;
  fmt_pmqos pmqos_param;
} gce_cmdq_obj_t;
typedef struct dts_info {
  uint32_t pipeNum;
  uint32_t RDMA_baseAddr;
  uint32_t WROT_baseAddr;
  bool RDMA_needWA;
} dts_info_t;
#define FMT_GCE_SET_CMD_FLUSH _IOW('f', 0, struct gce_cmdq_obj)
#define FMT_GCE_WAIT_CALLBACK _IOW('f', 1, unsigned int)
#define FMT_GET_PLATFORM_DTS _IOW('f', 2, dts_info_t)
#endif
