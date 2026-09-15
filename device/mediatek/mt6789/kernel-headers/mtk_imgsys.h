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
#ifndef _MTK_IMGSYS_H
#define _MTK_IMGSYS_H
#include <linux/ioctl.h>


#define BASE_VIDIOC_PRIVATE 192
#define FD_MAX (32)

struct fd_info {
	uint8_t fd_num;
	unsigned int fds[FD_MAX];
} __attribute__ ((__packed__));


#define MTKDIP_IOC_ADD_KVA _IOW('V', BASE_VIDIOC_PRIVATE + 8, struct fd_info)
#define MTKDIP_IOC_DEL_KVA _IOW('V', BASE_VIDIOC_PRIVATE + 9, struct fd_info)

struct fd_tbl {
	uint8_t fd_num;
	unsigned int *fds;
} __attribute__ ((__packed__));
#define MTKDIP_IOC_ADD_IOVA _IOW('V', BASE_VIDIOC_PRIVATE + 10, struct fd_tbl)
#define MTKDIP_IOC_DEL_IOVA _IOW('V', BASE_VIDIOC_PRIVATE + 11, struct fd_tbl)

struct sensor_info {
	uint16_t full_wd;
	uint16_t full_ht;
};
#define MTKDIP_IOC_S_SENSOR_INFO \
			_IOW('V', BASE_VIDIOC_PRIVATE + 12, struct sensor_info)

#endif
