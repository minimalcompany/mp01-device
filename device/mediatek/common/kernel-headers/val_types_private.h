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
#ifndef _VAL_TYPES_PRIVATE_H_
#define _VAL_TYPES_PRIVATE_H_
#include "val_types_public.h"
#define OALMEM_STATUS_NUM 16
typedef enum _VAL_HW_COMPLETE_T {
  VAL_POLLING_MODE = 0,
  VAL_INTERRUPT_MODE,
  VAL_MODE_MAX = 0xFFFFFFFF
} VAL_HW_COMPLETE_T;
typedef enum _VAL_CODEC_TYPE_T {
  VAL_CODEC_TYPE_NONE = 0,
  VAL_CODEC_TYPE_MP4_ENC,
  VAL_CODEC_TYPE_MP4_DEC,
  VAL_CODEC_TYPE_H263_ENC,
  VAL_CODEC_TYPE_H263_DEC,
  VAL_CODEC_TYPE_H264_ENC,
  VAL_CODEC_TYPE_H264_DEC,
  VAL_CODEC_TYPE_VC1_SP_DEC,
  VAL_CODEC_TYPE_RV9_DEC,
  VAL_CODEC_TYPE_MP1_MP2_DEC,
  VAL_CODEC_TYPE_VC1_MP_WMV9_DEC,
  VAL_CODEC_TYPE_RV8_DEC,
  VAL_CODEC_TYPE_WMV7_DEC,
  VAL_CODEC_TYPE_WMV8_DEC,
  VAL_CODEC_TYPE_AVS_DEC,
  VAL_CODEC_TYPE_H264_DEC_MAIN,
  VAL_CODEC_TYPE_MAX = 0xFFFFFFFF
} VAL_CODEC_TYPE_T;
typedef enum _VAL_CACHE_TYPE_T {
  VAL_CACHE_TYPE_CACHABLE = 0,
  VAL_CACHE_TYPE_NONCACHABLE,
  VAL_CACHE_TYPE_MAX = 0xFFFFFFFF
} VAL_CACHE_TYPE_T;
typedef struct _VAL_INTMEM_T {
  VAL_VOID_T * pvHandle;
  VAL_UINT32_T u4HandleSize;
  VAL_UINT32_T u4MemSize;
  VAL_VOID_T * pvMemVa;
  VAL_VOID_T * pvMemPa;
  VAL_VOID_T * pvReserved;
  VAL_UINT32_T u4ReservedSize;
} VAL_INTMEM_T;
typedef struct _VAL_EVENT_T {
  VAL_VOID_T * pvHandle;
  VAL_UINT32_T u4HandleSize;
  VAL_VOID_T * pvWaitQueue;
  VAL_VOID_T * pvEvent;
  VAL_UINT32_T u4TimeoutMs;
  VAL_VOID_T * pvReserved;
  VAL_UINT32_T u4ReservedSize;
} VAL_EVENT_T;
typedef struct _VAL_MUTEX_T {
  VAL_VOID_T * pvHandle;
  VAL_UINT32_T u4HandleSize;
  VAL_VOID_T * pvMutex;
  VAL_UINT32_T u4TimeoutMs;
  VAL_VOID_T * pvReserved;
  VAL_UINT32_T u4ReservedSize;
} VAL_MUTEX_T;
typedef struct _VAL_POWER_T {
  VAL_VOID_T * pvHandle;
  VAL_UINT32_T u4HandleSize;
  VAL_DRIVER_TYPE_T eDriverType;
  VAL_BOOL_T fgEnable;
  VAL_VOID_T * pvReserved;
  VAL_UINT32_T u4ReservedSize;
} VAL_POWER_T;
typedef struct _VAL_MMAP_T {
  VAL_VOID_T * pvHandle;
  VAL_UINT32_T u4HandleSize;
  VAL_VOID_T * pvMemPa;
  VAL_UINT32_T u4MemSize;
  VAL_VOID_T * pvMemVa;
  VAL_VOID_T * pvReserved;
  VAL_UINT32_T u4ReservedSize;
} VAL_MMAP_T;
typedef struct {
  VAL_ULONG_T u4ReadAddr;
  VAL_UINT32_T u4ReadData;
} VAL_VCODEC_OAL_MEM_STAUTS_T;
typedef struct {
  VAL_UINT32_T u4HWIsCompleted;
  VAL_UINT32_T u4HWIsTimeout;
  VAL_UINT32_T u4NumOfRegister;
  VAL_VCODEC_OAL_MEM_STAUTS_T * pHWStatus;
} VAL_VCODEC_OAL_HW_REGISTER_T;
typedef struct {
  VAL_VCODEC_OAL_HW_REGISTER_T * Oal_HW_reg;
  VAL_UINT32_T * Oal_HW_mem_reg;
  VAL_UINT32_T * kva_Oal_HW_mem_reg;
  VAL_ULONG_T pa_Oal_HW_mem_reg;
  VAL_ULONG_T ObjId;
  VAL_EVENT_T IsrEvent;
  VAL_UINT32_T slotindex;
  VAL_UINT32_T u4VCodecThreadNum;
  VAL_UINT32_T u4VCodecThreadID[VCODEC_THREAD_MAX_NUM];
  VAL_HANDLE_T pvHandle;
  VAL_UINT32_T u4NumOfRegister;
  VAL_VCODEC_OAL_MEM_STAUTS_T oalmem_status[OALMEM_STATUS_NUM];
  VAL_ULONG_T kva_u4HWIsCompleted;
  VAL_ULONG_T kva_u4HWIsTimeout;
  VAL_UINT32_T tid1;
  VAL_UINT32_T tid2;
  VAL_UINT32_T * va1;
  VAL_UINT32_T * va2;
  VAL_UINT32_T * va3;
  VAL_UINT32_T pa1;
  VAL_UINT32_T pa2;
  VAL_UINT32_T pa3;
} VAL_VCODEC_OAL_HW_CONTEXT_T;
typedef struct {
  int CPUid;
  int Loading;
} VAL_VCODEC_CORE_LOADING_T;
typedef void(* ena) (int);
typedef void(* disa) (int);
typedef void(* ena_timeout) (int, int);
typedef int(* user_reg) (int, int);
typedef void(* user_unreg) (int);
typedef void(* user_enable) (int);
typedef void(* user_disable) (int);
typedef void(* user_enable_timeout) (int, int);
typedef int(* user_reg_scn) (void);
typedef void(* user_reg_scn_config) (int, int, int, int, int, int);
typedef void(* user_unreg_scn) (int);
typedef struct _VAL_INIT_HANDLE {
  int i4DriverType;
  int i4VENCLivePhoto;
} VAL_INIT_HANDLE;
#endif
