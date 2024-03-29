#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$BASH_SOURCE")/.."; pwd)"
source "$PROJECT_ROOT/scripts/env.sh"

echo "PROJECT_ROOT:".$PROJECT_ROOT
echo "PROJECT:".$PROJECT

xcodebuild -version
clang -v
rm -rf "$EXPORT_PATH"
mkdir -p "$EXPORT_PATH"


xcodebuild clean -workspace "$PROJECT" -scheme "$TARGET" -configuration Release  || { echo "clean Failed"; exit 1; }

PRODUCT_SETTINGS_PATH="$PROJECT_ROOT/Lotus/Info.plist"
version=$(git describe --tags `git rev-list --tags --max-count=1`)
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" $PRODUCT_SETTINGS_PATH
vv=`date "+%Y%m%d%H%M%S"`
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $vv" $PRODUCT_SETTINGS_PATH

echo "version ${version} $vv"
echo "PROJECT:"$PROJECT
echo "EXPORT_ARCHIVE:"$EXPORT_ARCHIVE
echo "BUILD_FLAG:"$BUILD_FLAG
# exit -1


#xcodebuild archive -workspace YourProject.xcworkspace -scheme YourScheme -archivePath "build/YourProject.xcarchive" -configuration Release
# xcodebuild archive -project "/Users/xuxihai/github/Lotus/Lotus.xcodeproj" -scheme Lotus -archivePath "/Users/xuxihai/github/Lotus/dist/archive.xcarchive" -configuration Release  || { echo "Archive Failed:"; exit 1; }
xcodebuild archive \
  -workspace "$PROJECT" \
  -scheme Lotus \
  -archivePath "$EXPORT_ARCHIVE" \
  -configuration Release $BUILD_FLAG || { echo "Archive Failed:"; exit 1; }

if [[ $USE_CODE_SIGN == "disable" ]]
then
  echo "export without code signing"
  ditto "$EXPORT_ARCHIVE/Products/Applications/$TARGET.app" "$EXPORT_APP"
  ls "$EXPORT_PATH"
else
  /usr/bin/xcodebuild -exportArchive \
  -archivePath "$EXPORT_ARCHIVE" \
  -exportOptionsPlist "$PROJECT_ROOT/scripts/ExportOptions.plist" \
  -exportPath "$EXPORT_PATH" $BUILD_FLAG || { echo "Export Archive Failed : xcodebuild exportArchive action failed"; exit 1; }

  # /usr/bin/xcodebuild -exportArchive \
  # -archivePath "/Users/xuxihai/github/Lotus/dist/archive.xcarchive" \
  # -exportOptionsPlist "/Users/xuxihai/github/Lotus/scripts/ExportOptions.plist" \
  # -exportPath "/Users/xuxihai/github/Lotus/dist" || { echo "Export Archive Failed : xcodebuild exportArchive action failed"; exit 1; }
  # ditto -c -k --sequesterRsrc --keepParent "$EXPORT_APP" "$EXPORT_ZIP"
fi
