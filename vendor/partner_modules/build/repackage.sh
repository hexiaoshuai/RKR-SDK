#!/bin/bash
#
# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# script to repackage the Mainline train releases to the following formats:
#
# option -f Q_LEGACY : repackage as legacy Q mainline release package
# option -f Q_APKS   : repackage as Q mainline release package using .APKS
#                      format (need patches)
#

# color definition

RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# no trailing slash below

TARGET_FOLDER='./vendor/partner_modules'
ORIGINAL_TARGET_FOLDER='./vendor/original_partner_modules'

IS_REPACKAGED_FLAG_FILE=$TARGET_FOLDER/repackaged.txt

# functions

print_usage_and_exit() {
  echo "Usage: repackage.sh -f <target format>"
  echo "This script replackages vendor/partner_modules/ to the target format"
  echo "  -f <target format> : mandatory. to specify target format"
  echo "     Q_LEGACY        - target format for legacy Q format using .APK / .APEX"
  echo "     Q_APKS          - target format for Q package format using .APKS"
  echo "  -h                 : optional. showing how to use (what you see now)"
  echo ""
  echo "Warning: The conversion is irreversible."
  exit;
}

delete_non_q_artifacts() {
  rm -rf vendor/partner_modules/AdbdPrebuilt
  rm -rf vendor/partner_modules/CellBroadcastPrebuilt
  rm -rf vendor/partner_modules/IKEPrebuilt
  rm -rf vendor/partner_modules/MediaProviderPrebuilt
  rm -rf vendor/partner_modules/NNApiPrebuilt
  rm -rf vendor/partner_modules/SdkExtensionsPrebuilt
  rm -rf vendor/partner_modules/StatsdPrebuilt
  rm -rf vendor/partner_modules/TelemetryTvpPrebuilt
  rm -rf vendor/partner_modules/TetheringPrebuilt
  rm -rf vendor/partner_modules/WiFiPrebuilt

  rm -rf vendor/partner_modules/PermissionControllerPrebuilt/30
  rm -rf vendor/partner_modules/ExtServicesPrebuilt/30
  rm -rf vendor/partner_modules/NetworkPermissionConfigPrebuilt/30
  rm     vendor/partner_modules/PermissionControllerPrebuilt/com.google.android.permission.apks
  rm     vendor/partner_modules/ExtServicesPrebuilt/com.google.android.extservices.apks
  rm     vendor/partner_modules/TimezoneDataPrebuilt/com.google.android.tzdata2.apks
}

# hashmap for Q_LEGACY option

declare -A q_legacy_map
q_legacy_map["CaptivePortalLoginPrebuilt/splits/base"]="CaptivePortalLoginPrebuilt/GoogleCaptivePortalLogin"
q_legacy_map["CaptivePortalLoginPrebuilt/universal"]="CaptivePortalLoginPrebuilt/GoogleCaptivePortalLogin"
q_legacy_map["ConscryptPrebuilt/standalones/standalone"]="ConscryptPrebuilt/com.android.conscrypt"
q_legacy_map["DnsResolverPrebuilt/standalones/standalone"]="DnsResolverPrebuilt/com.android.resolv"
q_legacy_map["DocumentsUiPrebuilt/splits/base"]="DocumentsUiPrebuilt/GoogleDocumentsUIPrebuilt"
q_legacy_map["DocumentsUiPrebuilt/universal"]="DocumentsUiPrebuilt/GoogleDocumentsUIPrebuilt"
q_legacy_map["ExtServicesPrebuilt/29/splits/base"]="ExtServicesPrebuilt/GoogleExtServicesPrebuilt"
q_legacy_map["ExtServicesPrebuilt/29/universal"]="ExtServicesPrebuilt/GoogleExtServicesPrebuilt"
q_legacy_map["MediaFrameworkPrebuilt/standalones/standalone"]="MediaFrameworkPrebuilt/com.android.media"
q_legacy_map["MediaSwCodecPrebuilt/standalones/standalone"]="MediaSwCodecPrebuilt/com.android.media.swcodec"
q_legacy_map["ModuleMetadataGooglePrebuilt/splits/base"]="ModuleMetadataGooglePrebuilt/ModuleMetadataGooglePrebuilt"
q_legacy_map["ModuleMetadataGooglePrebuilt/universal"]="ModuleMetadataGooglePrebuilt/ModuleMetadataGooglePrebuilt"
q_legacy_map["NetworkPermissionConfigPrebuilt/29/universal"]="NetworkPermissionConfigPrebuilt/GoogleNetworkPermissionConfig"
q_legacy_map["NetworkPermissionConfigPrebuilt/29/splits/base"]="NetworkPermissionConfigPrebuilt/GoogleNetworkPermissionConfig"
q_legacy_map["NetworkStackPrebuilt/splits/base"]="NetworkStackPrebuilt/GoogleNetworkStack"
q_legacy_map["NetworkStackPrebuilt/universal"]="NetworkStackPrebuilt/GoogleNetworkStack"
q_legacy_map["PermissionControllerPrebuilt/29/universal"]="PermissionControllerPrebuilt/GooglePermissionControllerPrebuilt"
q_legacy_map["PermissionControllerPrebuilt/29/splits/base"]="PermissionControllerPrebuilt/GooglePermissionControllerPrebuilt"
q_legacy_map["TimezoneDataPrebuilt/standalones/standalone"]="TimezoneDataPrebuilt/com.android.tzdata"

# hashmap for Q_APKS option

declare -A q_apks_map
q_apks_map["CaptivePortalLoginPrebuilt/CaptivePortalLoginGoogle.apks"]="CaptivePortalLoginPrebuilt/CaptivePortalLoginGoogle.apks"
q_apks_map["ConscryptPrebuilt/com.google.android.conscrypt.apks"]="ConscryptPrebuilt/com.google.android.conscrypt.apks"
q_apks_map["ConscryptPrebuilt/com.android.conscrypt.apks"]="ConscryptPrebuilt/com.google.android.conscrypt.apks"
q_apks_map["DnsResolverPrebuilt/com.google.android.resolv.apks"]="DnsResolverPrebuilt/com.google.android.resolv.apks"
q_apks_map["DocumentsUiPrebuilt/DocumentsUIGoogle.apks"]="DocumentsUiPrebuilt/DocumentsUIGoogle.apks"
q_apks_map["ExtServicesPrebuilt/29/GoogleExtServices.apks"]="ExtServicesPrebuilt/GoogleExtServices.apks"
q_apks_map["MediaFrameworkPrebuilt/com.google.android.media.apks"]="MediaFrameworkPrebuilt/com.google.android.media.apks"
q_apks_map["MediaSwCodecPrebuilt/com.google.android.media.swcodec.apks"]="MediaSwCodecPrebuilt/com.google.android.media.swcodec.apks"
q_apks_map["ModuleMetadataGooglePrebuilt/com.google.android.modulemetadata.apks"]="ModuleMetadataGooglePrebuilt/com.google.android.modulemetadata.apks"
q_apks_map["NetworkPermissionConfigPrebuilt/29/NetworkPermissionConfig.apks"]="NetworkPermissionConfigPrebuilt/NetworkPermissionConfigGoogle.apks"
q_apks_map["NetworkStackPrebuilt/NetworkStackGoogle.apks"]="NetworkStackPrebuilt/NetworkStackGoogle.apks"
q_apks_map["PermissionControllerPrebuilt/29/GooglePermissionController.apks"]="PermissionControllerPrebuilt/GooglePermissionController.apks"
q_apks_map["TimezoneDataPrebuilt/com.android.tzdata.apks"]="TimezoneDataPrebuilt/com.google.android.tzdata.apks"

# 1. check if the script runs at Android repo root folder

if [ ! -d "./build" ] || [ ! -d "./frameworks" ] || [ ! -d "./vendor" ];
then
  echo -e "${RED}Error:${NC} please run this script at the root of Android repository"
#  exit -1
fi

if [ ! -d "$TARGET_FOLDER" ];
then
  echo -e "${RED}Error:${NC} $TARGET_FOLDER not found"
  exit -1
fi

if [ -f $IS_REPACKAGED_FLAG_FILE ];
then
  echo -e "${RED}Error:${NC} $TARGET_FOLDER is already repackaged"
  exit -1
fi

# 2. parse options

TARGET_FORMAT="None"

while getopts ":hf:" opt;
do
  case ${opt} in
    h )
      print_usage_and_exit
      ;;
    f )
      TARGET_FORMAT=$OPTARG
      ;;
    \? )
      echo -e "${RED}Error:{$NC} Invalid option: $OPTARG"
      ;;
    : )
      echo -e "${RED}Error:{$NC} Invalid option: $OPTARG requires an argument"
      ;;
  esac
done
shift $((OPTIND -1))

if [ ! $TARGET_FORMAT == "Q_LEGACY" ] && [ ! $TARGET_FORMAT == "Q_APKS" ];
then
  print_usage_and_exit
fi;

echo "- Target format = $TARGET_FORMAT"

# 3 delete non Q artifacts and rename target folder

echo "- Preprocessing"

delete_non_q_artifacts
mv $TARGET_FOLDER $ORIGINAL_TARGET_FOLDER

# 4. Handling Q_LEGACY option

ERROR_FLAG="false"

if [ $TARGET_FORMAT == "Q_LEGACY" ];
then
  # 4.1 unzip template structure
  echo "- Extracting template"
  unzip -q -o $ORIGINAL_TARGET_FOLDER/build/q_legacy_template.zip -d .

  # 4.2 unzip all the .apks files in original target folder
  echo "- Extracting .apks files"
  for i in $(find $ORIGINAL_TARGET_FOLDER -name *.apks);
  do
    unzip -q $i -d $(dirname $i)
  done

  # 4.3 convert module files using hashmap
  echo "- Converting extracted module prebuilt files"

  for i in $(find $ORIGINAL_TARGET_FOLDER -name *.apk -o -name *.apex);
  do
    file_name=$(basename $i)
    if [[ $file_name == *-* ]];
    then
      file_extension="-${file_name##*-}"
    else
      file_extension=".${file_name##*.}"
    fi

    partial_file_name=${file_name%"$file_extension"}
    key="$(dirname $i | cut -d '/' -f 4- )/$partial_file_name"
    val=${q_legacy_map["$key"]}

    file_extension=$(echo $file_extension | sed "s/^.*master\(.*\)/\1/")
    file_extension=$(echo $file_extension | sed "s/armeabi_v7a.arm64_v8a/arm64/")
    file_extension=$(echo $file_extension | sed "s/armeabi_v7a/arm/")
    file_extension=$(echo $file_extension | sed "s/arm64_v8a/arm64/")
    file_extension=$(echo $file_extension | sed "s/x86.x86_64/x86_64/")

    if [[ ! -z $val ]];
    then
      echo "- Copying $i to $TARGET_FOLDER/$val$file_extension"
      cp $i $TARGET_FOLDER/$val$file_extension
    else
      echo -e "${RED}Error${NC} $i not found in the conversion hashmap"
      ERROR_FLAG="true"
    fi
#    read -n1 key
  done

# 5. Handling Q_APKS option

elif [[ $TARGET_FORMAT == "Q_APKS" ]];
then
  # 5.1 unzip template structure
  echo "- Extracting template"
  unzip -q -o $ORIGINAL_TARGET_FOLDER/build/q_apks_template.zip -d .

  # 5.2 move module files using hashmap
  echo "- Converting module prebuilt files"
  for i in $(find $ORIGINAL_TARGET_FOLDER -name *.apks);
  do
    file_name=$(basename $i)
    key="$(echo $i | cut -d '/' -f 4-)"
    val=${q_apks_map["$key"]}

    if [[ ! -z $val ]];
    then
      echo "- Copying $i to $TARGET_FOLDER/$val"
      cp $i $TARGET_FOLDER/$val
    else
      echo -e "${RED}Error${NC} $i not found in the conversion hashmap"
      ERROR_FLAG="true"
    fi
#    read -n1 key
  done
fi

if [[ $ERROR_FLAG == "true" ]];
then
  echo -e "${RED}ERROR:${NC} conversion failed."
  echo -e "${RED}ERROR:${NC} Please delete $TARGET_FOLDER and start from unzipping"
  rm -rf $TARGET_FOLDER
  mv $ORIGINAL_TARGET_FOLDER $TARGET_FOLDER
  exit -1;
fi

# 6. copy files that are not prebuilt or Android.bp or Android.mk as is
echo "- Copying other files"

mkdir -p $TARGET_FOLDER/build

cd $ORIGINAL_TARGET_FOLDER

# 6a. move back .git to preserve the git history
for i in $(find . -type d -name .git); do
  mv $i ../../$TARGET_FOLDER/$i
done

for i in $(find . -type f -not -path *.git* -not -path *.repo* -not -name Android.bp -not -name *.apks -not -name *.apk -not -name *.apex -not -path *sdk_library* -not -name toc.pb)
do
  cp $i ../../$TARGET_FOLDER/$i
done
cd - > /dev/null

# 7. delete original target folder

rm -rf $ORIGINAL_TARGET_FOLDER

echo "repackaged to $TARGET_FORMAT format " > $IS_REPACKAGED_FLAG_FILE

echo -e "${GREEN}Repackaging completed${NC}"
