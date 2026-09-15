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

#include <linux/ioctl.h>


#define CAM_MEM_MAGIC               'I'

/*******************************************************************************
 *
 ******************************************************************************/

struct CAM_MEM_DEV_ION_NODE_STRUCT {
	int                memID;
	unsigned long long dma_pa;
	char               username[64];
	bool               need_sec_handle;
	unsigned int       sec_handle;
};

enum CAM_MEM_CMD_ENUM {
	CAM_MEM_CMD_ION_MAP_PA, /* AOSP ION: map physical address(iova) from fd */
	CAM_MEM_CMD_ION_UNMAP_PA, /* AOSP ION: unmap physical address(ivoa) from fd */
	CAM_MEM_CMD_ION_GET_PA,
	CAM_MEM_CMD_POWER_CTRL /* AOSP ION: common larb ctrl */
};

#define CAM_MEM_ION_MAP_PA                      \
	_IOWR(CAM_MEM_MAGIC, CAM_MEM_CMD_ION_MAP_PA, struct CAM_MEM_DEV_ION_NODE_STRUCT)

#define CAM_MEM_ION_UNMAP_PA                      \
	_IOW(CAM_MEM_MAGIC, CAM_MEM_CMD_ION_UNMAP_PA, struct CAM_MEM_DEV_ION_NODE_STRUCT)

#define CAM_MEM_ION_GET_PA             \
	_IOWR(CAM_MEM_MAGIC, CAM_MEM_CMD_ION_GET_PA, struct CAM_MEM_DEV_ION_NODE_STRUCT)

#define CAM_MEM_POWER_CTRL                      \
	_IOW(CAM_MEM_MAGIC, CAM_MEM_CMD_POWER_CTRL, int)
