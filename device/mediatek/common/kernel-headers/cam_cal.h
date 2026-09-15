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
#ifndef _CAM_CAL_H
#define _CAM_CAL_H

#include <linux/ioctl.h>
#ifdef CONFIG_COMPAT
/*64 bit*/
#include <linux/fs.h>
#include <linux/compat.h>
#endif

#define CAM_CALAGIC 'i'
/*IOCTRL(inode * ,file * ,cmd ,arg )*/
/*S means "set through a ptr"*/
/*T means "tell by a arg value"*/
/*G means "get by a ptr"*/
/*Q means "get by return a value"*/
/*X means "switch G and S atomically"*/
/*H means "switch T and Q atomically"*/

/**********************************************
 *
 **********************************************/

/*CAM_CAL write*/
#define CAM_CALIOC_S_WRITE _IOW(CAM_CALAGIC, 0, struct stCAM_CAL_INFO_STRUCT)
/*CAM_CAL read*/
#define CAM_CALIOC_G_READ _IOWR(CAM_CALAGIC, 5, struct stCAM_CAL_INFO_STRUCT)
/*CAM_CAL set sensor info*/
#define CAM_CALIOC_S_SENSOR_INFO \
	_IOW(CAM_CALAGIC, 10, struct CAM_CAL_SENSOR_INFO)
/*CAM_CAL read (GKI)*/
#define CAM_CALIOC_G_GKI_READ _IOWR(CAM_CALAGIC, 15, struct STRUCT_CAM_CAL_DATA_STRUCT)
#define CAM_CALIOC_G_GKI_QUERY _IOR(CAM_CALAGIC, 20, struct STRUCT_CAM_CAL_DATA_STRUCT)
#define CAM_CALIOC_G_GKI_NEED_POWER_ON \
	_IOWR(CAM_CALAGIC, 25, struct STRUCT_CAM_CAL_NEED_POWER_ON)

#ifdef CONFIG_COMPAT
#define COMPAT_CAM_CALIOC_S_WRITE \
	_IOW(CAM_CALAGIC, 0, struct COMPAT_stCAM_CAL_INFO_STRUCT)
#define COMPAT_CAM_CALIOC_G_READ \
	_IOWR(CAM_CALAGIC, 5, struct COMPAT_stCAM_CAL_INFO_STRUCT)
#endif
#endif /*_CAM_CAL_H*/
