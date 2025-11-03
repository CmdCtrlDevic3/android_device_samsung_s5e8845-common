#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/s5e8845-common

# VINTF
DEVICE_MANIFEST_FILE := $(COMMON_PATH)/configs/vintf/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/samsung/vintf/samsung_framework_compatibility_matrix.xml
