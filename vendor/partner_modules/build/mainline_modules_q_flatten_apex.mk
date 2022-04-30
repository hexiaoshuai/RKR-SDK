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
# Mainline configuration for regular devices using Android 10 that
#   are not low RAM and
#   can not support updatable APEX
#
# Flags for partners:
#   MAINLINE_INCLUDE_DOCUMENTSUI_MODULE := true(default) or false
#   - when it is true, DocumentsUI module will be added to PRODUCT_PACKAGES
#
#   MAINLINE_INCLUDE_NETWORKING_MODULES := true(default) or false
#   - when it is true, Network Stack, Network Permission Config and
#     Captive Portal Login modules will be added to PRODUCT_PACKAGES
#   - when it is false, alternative packages for them will be added to
#     PRODUCT_PACKAGES
#

# Mainline modules - APK-type

# APK-type Mandatory modules
PRODUCT_PACKAGES += \
    ModuleMetadataGooglePrebuilt \
    GooglePermissionControllerPrebuilt \
    GoogleExtServicesPrebuilt \

# Overlay packages for APK-type mandatory modules
PRODUCT_PACKAGES += \
    ModuleMetadataGoogleOverlay \
    GooglePermissionControllerOverlay \
    GooglePermissionControllerFrameworkOverlay \
    GoogleExtServicesConfigOverlay \

# Handling the default value for the options if not set
MAINLINE_INCLUDE_DOCUMENTSUI_MODULE ?= true
MAINLINE_INCLUDE_NETWORKING_MODULES ?= true

# Mainline modules - DocumentsUI
ifeq ($(MAINLINE_INCLUDE_DOCUMENTSUI_MODULE),true)
PRODUCT_PACKAGES += \
    GoogleDocumentsUIPrebuilt \
    GoogleDocumentsUIOverlay
endif

# Mainline modules - networking modules
ifeq ($(MAINLINE_INCLUDE_NETWORKING_MODULES),true)
PRODUCT_PACKAGES += \
    GoogleCaptivePortalLogin \
    GoogleNetworkStack \
    GoogleNetworkPermissionConfig
else
# alternative packages for networking modules
PRODUCT_PACKAGES += \
    InProcessNetworkStack \
    PlatformCaptivePortalLogin \
    PlatformNetworkPermissionConfig
endif
