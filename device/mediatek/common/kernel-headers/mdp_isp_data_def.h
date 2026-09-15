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
#ifndef __MDP_ISP_DATA_H__
#define __MDP_ISP_DATA_H__
struct cmdqMetaBuf {
  uint64_t va;
  uint64_t size;
};
#define CMDQ_ISP_META_CNT 8
struct cmdqSecIspMeta {
  struct cmdqMetaBuf ispBufs[CMDQ_ISP_META_CNT];
  uint64_t CqSecHandle;
  uint32_t CqSecSize;
  uint32_t CqDesOft;
  uint32_t CqVirtOft;
  uint64_t TpipeSecHandle;
  uint32_t TpipeSecSize;
  uint32_t TpipeOft;
  uint64_t BpciHandle;
  uint64_t LsciHandle;
  uint64_t LceiHandle;
  uint64_t DepiHandle;
  uint64_t DmgiHandle;
};
#endif