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
#ifndef __DDP_GAMMA_H__
#define __DDP_GAMMA_H__
typedef enum {
  DISP_GAMMA0 = 0,
  DISP_GAMMA_TOTAL
} disp_gamma_id_t;
typedef unsigned int gamma_entry;
#ifdef GAMMA_12BIT_SUPPORT
#define GAMMA_ENTRY(r12,g12) (((g12) << 12) | (r12))
#else
#define GAMMA_ENTRY(r10,g10,b10) (((r10) << 20) | ((g10) << 10) | (b10))
#endif
#ifdef GAMMA_12BIT_SUPPORT
#define DISP_GAMMA_LUT_SIZE 1024
#else
#define DISP_GAMMA_LUT_SIZE 512
#endif
typedef struct {
  disp_gamma_id_t hw_id;
  gamma_entry lut[DISP_GAMMA_LUT_SIZE];
} DISP_GAMMA_LUT_T;
typedef struct {
  disp_gamma_id_t hw_id;
  gamma_entry lut_0[DISP_GAMMA_LUT_SIZE];
  gamma_entry lut_1[DISP_GAMMA_LUT_SIZE];
} DISP_GAMMA_12BIT_LUT_T;
typedef enum {
  DISP_CCORR0 = 0,
  DISP_CCORR_TOTAL
} disp_ccorr_id_t;
typedef struct {
  disp_ccorr_id_t hw_id;
  unsigned int coef[3][3];
} DISP_CCORR_COEF_T;
#endif
