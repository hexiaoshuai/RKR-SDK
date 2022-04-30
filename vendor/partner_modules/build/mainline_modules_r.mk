#
# Copyright 2020 The Android Open Source Project
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

# Mainline configuration for regular devices that
#   are not low RAM and
#   can support updatable APEX
#
# Flags for partners:
#   MAINLINE_INCLUDE_WIFI_MODULE := true or false
#   - when it is true, WiFi module will be added to PRODUCT_PACKAGES

# Mainline modules - APK type
PRODUCT_PACKAGES += \
    com.google.android.modulemetadata \
    DocumentsUIGoogle \
    CaptivePortalLoginGoogle \
    NetworkPermissionConfigGoogle \
    NetworkStackGoogle \
    com.google.mainline.telemetry \

# Ingesting networkstack.x509.pem
PRODUCT_MAINLINE_SEPOLICY_DEV_CERTIFICATES=vendor/partner_modules/NetworkStackPrebuilt

# Overlay packages for APK-type modules
PRODUCT_PACKAGES += \
    GoogleDocumentsUIOverlay \
    ModuleMetadataGoogleOverlay \
    GooglePermissionControllerOverlay \
    GooglePermissionControllerFrameworkOverlay \
    GoogleExtServicesConfigOverlay \

# Configure APEX as updatable
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Mainline modules - APEX type
PRODUCT_PACKAGES += \
    com.google.android.adbd \
    com.google.android.conscrypt \
    com.google.android.permission \
    com.google.android.ipsec \
    com.google.android.media \
    com.google.android.mediaprovider \
    com.google.android.media.swcodec \
    com.google.android.neuralnetworks \
    com.google.android.os.statsd \
    com.google.android.resolv \
    com.google.android.sdkext \
    com.google.android.tzdata2 \
    com.google.android.extservices \
    com.google.android.tethering \
    com.google.android.cellbroadcast \

# Optional WiFi module
MAINLINE_INCLUDE_WIFI_MODULE ?= false

ifeq ($(MAINLINE_INCLUDE_WIFI_MODULE),true)
PRODUCT_PACKAGES += \
    com.google.android.wifi
endif

# sysconfig files
PRODUCT_COPY_FILES += \
    vendor/partner_modules/build/google-staged-installer-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-staged-installer-whitelist.xml \
    vendor/partner_modules/build/google-rollback-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-rollback-package-whitelist.xml \
