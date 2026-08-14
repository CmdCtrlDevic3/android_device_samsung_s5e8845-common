#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Enable virtual A/B with vendor ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.audio@7.1-impl \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.3-impl \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usbv2.default

$(call soong_config_set_bool,frameworks_av,use_aosp_audio_policy_volumes,true)
$(call soong_config_set_bool,frameworks_av,use_aosp_default_volume_tables,true)
$(call soong_config_set_bool,frameworks_av,use_aosp_r_submix_audio_policy_configuration,true)

PRODUCT_PACKAGES += \
    aosp_audio_policy_volumes.xml \
    aosp_default_volume_tables.xml \
    aosp_r_submix_audio_policy_configuration.xml \
    audio_effects.xml \
    audio_policy_configuration.xml \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usbv2.default \
    bluetooth_with_le_audio_policy_configuration_7_0.xml \
    usbv2_audio_policy_configuration.xml \
    SamsungDAP

TARGET_EXCLUDES_AUDIOFX := true

# Codec2
PRODUCT_PACKAGES += \
    samsung.hardware.media.c2-service \
    libExynosC2Av1Dec \
    libExynosC2H264Dec \
    libExynosC2H264Enc \
    libExynosC2HevcDec \
    libExynosC2HevcEnc \
    libExynosC2Vp8Dec \
    libExynosC2Vp8Enc \
    libExynosC2Vp9Dec \
    libExynosC2Vp9Enc \
    media_codecs_c2.xml \
    media_codecs_performance_c2.xml \

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider-service.samsung

$(call soong_config_set_bool,samsungCameraVars,needs_fps_field,true)
$(call soong_config_set_bool,samsungCameraVars,usage_64bit,true)

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.composer.hwc3-service.slsi \
    android.hardware.graphics.allocator-aidl-service-sgr \
    android.hardware.graphics.mapper@4.0-impl-sgr \
    android.hardware.memtrack-service.exynos \
    libdrm_sgpu

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.samsung \
    android.hardware.health-service.samsung-recovery \
    vendor.lineage.health-service.default

$(call soong_config_set_bool,lineage_health,charging_control_charging_bypass,true)
$(call soong_config_set_bool,lineage_health,charging_control_charging_deadline,false)
$(call soong_config_set_bool,lineage_health,charging_control_charging_toggle,true)
$(call soong_config_set,lineage_health,charging_control_charging_disabled,0)
$(call soong_config_set,lineage_health,charging_control_charging_enabled,1)
$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/power_supply/battery/charging_enabled)
$(call soong_config_set,lineage_health,fast_charge_node,/sys/class/sec/switch/afc_disable)
$(call soong_config_set,lineage_health,fast_charge_value_fast_charge,0)
$(call soong_config_set,lineage_health,fast_charge_value_none,1)

# Init
PRODUCT_PACKAGES += \
    fstab.s5e8845 \
    fstab.s5e8845.vendor_ramdisk \
    init.recovery.s5e8845.rc \
    init.s5e8845.rc \
    init.samsung.rc \
    ueventd.s5e8845.rc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    otapreopt_script

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# Kernel Modules
PRODUCT_PACKAGES += \
    linker.vendor_ramdisk \
    toolbox.vendor_ramdisk \
    fsck.f2fs.vendor_ramdisk

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/samsung

# Linker
PRODUCT_PACKAGES += \
    public.libraries.txt

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    android.hardware.audio.low_latency.prebuilt.xml \
    android.hardware.bluetooth_le.prebuilt.xml \
    android.hardware.camera.flash-autofocus.prebuilt.xml \
    android.hardware.camera.full.prebuilt.xml \
    android.hardware.hardware_keystore_V3.xml \
    android.hardware.sensor.accelerometer.prebuilt.xml \
    android.hardware.sensor.compass.prebuilt.xml \
    android.hardware.sensor.gyroscope.prebuilt.xml \
    android.hardware.sensor.light.prebuilt.xml \
    android.hardware.sensor.proximity.prebuilt.xml \
    android.hardware.sensor.stepcounter.prebuilt.xml \
    android.hardware.sensor.stepdetector.prebuilt.xml \
    android.hardware.usb.accessory.prebuilt.xml \
    android.hardware.usb.host.prebuilt.xml \
    android.hardware.vulkan.compute-0.prebuilt.xml \
    android.hardware.vulkan.level-1.prebuilt.xml \
    android.hardware.vulkan.version-1_3.prebuilt.xml \
    android.software.opengles.deqp.level-2021-03-01.prebuilt.xml \
    android.software.vulkan.deqp.level-2021-03-01.prebuilt.xml

# Task Profiles
PRODUCT_PACKAGES += task_profiles.json.s5e8845

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.pixel-libperfmgr \
    powerhint.json

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.pixel \
    thermal_info_config.json \
    thermal_symlinks

# Call the proprietary setup
$(call inherit-product, vendor/samsung/s5e9925-common/s5e8845-common-vendor.mk)

# Call Samsung LSI board support package makefiles
$(call inherit-product, hardware/samsung_slsi-linaro/config/config.mk)
$(call inherit-product, hardware/samsung_slsi-linaro/graphics/base/hwcomposer_property.mk)
