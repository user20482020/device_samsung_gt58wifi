# Copyright (C) 2017 The LineageOS Project
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
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

#Inherit from vendor
$(call inherit-product-if-exists, vendor/samsung/gt58lte/gt58lte-vendor.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit from common
$(call inherit-product, device/samsung/msm8916-common/msm8916.mk)

# Inhert dalvik heap values from aosp
$(call inherit-product, frameworks/native/build/tablet-7in-xhdpi-2048-dalvik-heap.mk)

LOCAL_PATH := device/samsung/gt58lte

# Common overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# enable on screen nav keys
# ro.opengles.version=196608 needed to fix google play store not showing some apps
PRODUCT_PROPERTY_OVERRIDES += \
	qemu.hw.mainkeys=0 \
	ro.opengles.version=196608

# copy over GPS proprietary files
PRODUCT_COPY_FILES += \
	vendor/samsung/msm8916-common/proprietary/lib/libloc_api_v02.so:$(TARGET_COPY_OUT_VENDOR)/lib/libloc_api_v02.so \
	vendor/samsung/msm8916-common/proprietary/lib/libloc_ds_api.so:$(TARGET_COPY_OUT_VENDOR)/lib/libloc_ds_api.so
	
# TimeKeep - Qualcomm RTC is readonly.  Use this to keep time after a reboot and for TWRP.
PRODUCT_PACKAGES += \
    timekeep \
    TimeKeep

# RT 17.1 audio.primary.msm8916.so MUST go in /vendor/lib/hw in order for proprietary NXP tfa9895 amplifier to work with external audio
# RT 17.1 Tfa9895.cnt does not come with msm8916 repo, it must go in /system/etc as per the following error message
# tfa98xx: ERROR vendor/samsung/frameworks/audio/tfa_amp/TFA9895/srv/src/tfaContainer.c:tfaReadFile:1493: Can't open /system/etc/Tfa9895.cnt
PRODUCT_COPY_FILES += \
       vendor/samsung/gt58lte/proprietary/lib/hw/audio.primary.msm8916.so:$(TARGET_COPY_OUT_VENDOR)/lib/hw/audio.primary.msm8916.so \
       vendor/samsung/gt58lte/proprietary/etc/Tfa9895.cnt:$(TARGET_COPY_OUT_SYSTEM)/etc/Tfa9895.cnt

# Audio
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
	$(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	$(LOCAL_PATH)/configs/audio/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml
	
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/audio_platform_info.xml

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/mixer_paths.xml

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml

PRODUCT_COPY_FILES += \
	frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Bluetooth
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/bluetooth/iop_bt.db:$(TARGET_COPY_OUT_SYSTEM)/etc/bluetooth/iop_bt.db \
    $(LOCAL_PATH)/configs/bluetooth/iop_device_list.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/bluetooth/iop_device_list.conf

# RIL
PRODUCT_PACKAGES += \
	libril \
	librilutils \
	rild

# Device specific properties
# Remove ro.radio.noril=1 \
PRODUCT_PROPERTY_OVERRIDES += \
	ro.qualcomm.cabl=0 \
	ro.carrier=unknown \
	ro.config.low_ram=false \
	ro.config.zram=false \
	ro.sf.lcd_density=160 \
	ro.opengles.version=196608 \
	telephony.lteOnCdmaDevice=0

#enable voice path for PCM VoIP by default	
PRODUCT_PROPERTY_OVERRIDES += \
	use.voice.path.for.pcm.voip=true

# Camera
PRODUCT_PACKAGES += \
	libqc-opt

# Configs
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/camera/A05QF_sr544_module_info.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/A05QF_sr544_module_info.xml \
	$(LOCAL_PATH)/configs/camera/A05QF_sr544_module_info.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/B05QF_sr544_module_info.xml \
	$(LOCAL_PATH)/configs/camera/A05QF_sr544_module_info.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/C05QF_sr544_module_info.xml

# FlipFlap
PRODUCT_PACKAGES += \
    FlipFlap

# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.audio.low_latency.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.camera.full.xml \
	frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.sensor.compass.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.sensor.proximity.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.nxp.mifare.xml

# Ramdisk
PRODUCT_PACKAGES += \
	init.target.rc
