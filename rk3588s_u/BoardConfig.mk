#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include device/rockchip/rk3588/BoardConfig.mk
BUILD_WITH_GO_OPT := false
BOARD_BUILD_GKI := false
ifeq ($(strip $(BOARD_BUILD_GKI)), true)
    #for gki
    # AB image definition
    BOARD_USES_AB_IMAGE := true
    BOARD_ROCKCHIP_VIRTUAL_AB_ENABLE := true
    #PRODUCT_KERNEL_CONFIG := rockchip_defconfig android-13.config
    PRODUCT_KERNEL_CONFIG := gki_defconfig rockchip_gki.config
    BOARD_BOOT_HEADER_VERSION := 4
else
    BOARD_ROCKCHIP_VIRTUAL_AB_ENABLE := false
    BOARD_USES_AB_IMAGE := false
 #   PRODUCT_KERNEL_CONFIG := rockchip_defconfig android-13.config
endif

BOARD_GRAVITY_SENSOR_SUPPORT := true
BOARD_GYROSCOPE_SENSOR_SUPPORT := true
BOARD_PROXIMITY_SENSOR_SUPPORT := true
BOARD_LIGHT_SENSOR_SUPPORT := true

ifeq ($(strip $(BOARD_USES_AB_IMAGE)), true)
    include device/rockchip/common/BoardConfig_AB.mk
endif

ifeq ($(strip $(BOARD_BUILD_GKI)), true)
    #for gki
    BOARD_SUPER_PARTITION_SIZE := 6442450944
    BOARD_ROCKCHIP_DYNAMIC_PARTITIONS_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
endif

PRODUCT_UBOOT_CONFIG := rk3588
PRODUCT_KERNEL_DTS := rk3588s-tablet-v11
BOARD_CAMERA_SUPPORT_EXT := true
BOARD_HS_ETHERNET := true
