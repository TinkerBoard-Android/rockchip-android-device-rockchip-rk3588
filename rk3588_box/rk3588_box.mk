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
TARGET_BOARD_PLATFORM_PRODUCT := box

# First lunching is S, api_level is 31
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_DTBO_TEMPLATE := $(LOCAL_PATH)/dt-overlay.in

include device/rockchip/common/build/rockchip/DynamicPartitions.mk
include device/rockchip/rk3588/rk3588_box/BoardConfig.mk
include device/rockchip/common/BoardConfig.mk
$(call inherit-product, device/rockchip/rk3588/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

PRODUCT_PACKAGE_OVERLAYS += device/rockchip/rk3588/rk3588_box/overlay

#DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/../overlay
DEVICE_MANIFEST_FILE := device/rockchip/rk3588/rk3588_box/manifest.xml

PRODUCT_FSTAB_TEMPLATE := device/rockchip/rk3588/rk3588_box/fstab_box.in

PRODUCT_CHARACTERISTICS := tv

PRODUCT_NAME := rk3588_box
PRODUCT_DEVICE := rk3588_box
PRODUCT_BRAND := rockchip
PRODUCT_MODEL := rk3588_box
PRODUCT_MANUFACTURER := rockchip
PRODUCT_AAPT_PREF_CONFIG := tvdpi
#
## add Rockchip properties
#
PRODUCT_PROPERTY_OVERRIDES += ro.wifi.sleep.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.wifi.sleep.delay.ms=0
PRODUCT_PROPERTY_OVERRIDES += persist.bt.power.down=true


# TV Input HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.input@1.0-impl

# Display
TARGET_BASE_PARAMETER_IMAGE := device/rockchip/rk3588/rk3588_box/etc/baseparameter_auto.img

# Disable bluetooth because of continuous driver crashes
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += config.disable_bluetooth=true

# tmp compile needed
BOARD_WITH_RKTOOLBOX := false

# Google TV Service and frp overlay
PRODUCT_USE_PREBUILT_GTVS := no
BUILD_WITH_GOOGLE_FRP := true

BOARD_WITH_SPECIAL_PARTITIONS := baseparameter:1M,logo:16M

# Get the long list of APNs
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/spn-conf.xml:system/etc/spn-conf.xml

PRODUCT_PACKAGES += \
    libcrypto_vendor.vendor \

#PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-service \
    android.hardware.memtrack@1.0-impl \
    memtrack.$(TARGET_BOARD_PLATFORM)

# GTVS add the Client ID (provided by Google)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-rockchip-tv

# copy input keylayout and device config
keylayout_files := $(shell ls device/rockchip/rk3588/rk3588_box/remote_config )
PRODUCT_COPY_FILES += \
        $(foreach file, $(keylayout_files), device/rockchip/rk3588/rk3588_box/remote_config/$(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(file))

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp_policy/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \

BOARD_HS_ETHERNET := true

BOARD_USES_LIBSVEP := false

# use box external_camera_config.xml
PRODUCT_USB_CAMERA_CONFIG := $(LOCAL_PATH)/etc/external_camera_config.xml

# default enalbe mipi camera for box, noeed disable please
TARGET_BOARD_USE_MIPI_CAMEAR := false

# for box mipi camera
ifeq ($(TARGET_BOARD_USE_MIPI_CAMEAR),true)
CAMERA_ETC_PATH := $(TOP)/hardware/rockchip/camera/etc
IQ_FILES_PATH := $(TOP)/external/camera_engine_rkaiq/iqfiles
PRODUCT_COPY_FILES += \
    $(CAMERA_ETC_PATH)/camera/camera3_profiles_$(TARGET_BOARD_PLATFORM).xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera3_profiles.xml \
    $(call find-copy-subdir-files,*,$(CAMERA_ETC_PATH)/firmware,$(TARGET_COPY_OUT_VENDOR)/firmware) \
    $(call find-copy-subdir-files,*,$(CAMERA_ETC_PATH)/camera,$(TARGET_COPY_OUT_VENDOR)/etc/camera) \
    $(call find-copy-subdir-files,*,$(IQ_FILES_PATH)/isp21/,$(TARGET_COPY_OUT_VENDOR)/etc/camera/rkisp2/) \
    $(call find-copy-subdir-files,*,$(IQ_FILES_PATH)/isp3x/,$(TARGET_COPY_OUT_VENDOR)/etc/camera/rkisp2/)
endif


#
#add Rockchip properties here
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.rk_sdk=1 \
    persist.sys.show_color_option=false \
    ro.audio.monitorOrientation=true \
    ro.vendor.nrdp.modelgroup=NEXUSPLAYERFUGU \
    vendor.hwc.device.primary=HDMI-A,TV


TARGET_BOARD_SUPPORT_4K_UI := false
ifeq ($(TARGET_BOARD_SUPPORT_4K_UI),true)
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.framebuffer.main=3840x2160@60
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=480
else
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.framebuffer.main=1920x1080@60
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=213
endif

