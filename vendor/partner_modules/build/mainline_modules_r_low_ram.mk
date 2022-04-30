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

# Mainline configuration for the low RAM devices

# Minimum set of modules for the low ram devices
PRODUCT_PACKAGES += \
    com.google.android.modulemetadata \
    com.android.permission.gms \
    com.android.extservices.gms \

# Alternative packages for the Networking modules
PRODUCT_PACKAGES += \
    InProcessNetworkStack \
    PlatformCaptivePortalLogin \
    PlatformNetworkPermissionConfig \
    com.android.tethering.inprocess \
    CellBroadcastAppPlatform \
    CellBroadcastServiceModulePlatform \

# Overlay packages for APK-type modules
PRODUCT_PACKAGES += \
    ModuleMetadataGoogleOverlay \
    GooglePermissionControllerOverlay \
    GooglePermissionControllerFrameworkOverlay \
    GoogleExtServicesConfigOverlay \

# sysconfig files
PRODUCT_COPY_FILES += \
    vendor/partner_modules/build/google-staged-installer-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-staged-installer-whitelist.xml \
    vendor/partner_modules/build/google-rollback-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-rollback-package-whitelist.xml \
