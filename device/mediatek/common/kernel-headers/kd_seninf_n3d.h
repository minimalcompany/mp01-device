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
#ifndef _KD_SENINF_N3D_H_
#define _KD_SENINF_N3D_H_
struct sensor_info {
  unsigned int sensor_id;
  unsigned int sensor_idx;
  unsigned int cammux_id;
  unsigned int fl_active_delay;
  unsigned int def_fl_lc;
  unsigned int max_fl_lc;
  unsigned int def_shutter_lc;
};
struct n3d_perframe {
  unsigned int sensor_id;
  unsigned int sensor_idx;
  unsigned int min_fl_lc;
  unsigned int shutter_lc;
  unsigned int margin_lc;
  unsigned int flicker_en;
  unsigned int out_fl_lc;
  unsigned int pclk;
  unsigned int linelength;
  unsigned int lineTimeInNs;
};
struct KD_REGISTER_SENSOR {
  struct sensor_info sensor;
};
struct KD_N3D_AE_INFO {
  struct n3d_perframe ae_info;
};
struct KD_N3D_PERFRAME {
  struct n3d_perframe per1;
  struct n3d_perframe per2;
};
#define SENINF_N3D_MAGIC 'i'
#define KDSENINFN3DIOC_X_REGISTER_SENSOR _IOWR(SENINF_N3D_MAGIC, 0, struct KD_REGISTER_SENSOR)
#define KDSENINFN3DIOC_X_UNREGISTER_SENSOR _IOWR(SENINF_N3D_MAGIC, 5, struct KD_REGISTER_SENSOR)
#define KDSENINFN3DIOC_X_START_SYNC _IO(SENINF_N3D_MAGIC, 10)
#define KDSENINFN3DIOC_X_STOP_SYNC _IO(SENINF_N3D_MAGIC, 15)
#define KDSENINFN3DIOC_X_UPDATE_AE_INFO _IOWR(SENINF_N3D_MAGIC, 20, struct KD_N3D_AE_INFO)
#define KDSENINFN3DIOC_X_PERFRAME_CTRL _IOWR(SENINF_N3D_MAGIC, 25, struct KD_N3D_PERFRAME)
#endif
