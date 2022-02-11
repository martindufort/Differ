#!/usr/bin/env bash

set -o errexit
set -o nounset

OUTPUT_DIR=${OUTPUT_DIR?error: Please provide the build directory via the 'OUTPUT_DIR' environment variable}
PROJECT_FILE=${PROJECT_FILE?error: Please provide the Xcode project file name via the 'PROJECT_FILE' environment variable}
SCHEME_NAME=${SCHEME_NAME?error: Please provide the Xcode scheme to build via the 'SCHEME_NAME' environment variable}

# Generate iOS framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-iphoneos.xcarchive" -destination "generic/platform=iOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate iOS Simulator framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-iossimulator.xcarchive" -destination "generic/platform=iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate macOS framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-macosx.xcarchive" -destination "generic/platform=macOS,name=Any Mac" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate macOS Catalyst framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-maccatalyst.xcarchive" -destination "generic/platform=macOS,variant=Mac Catalyst" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES -scheme "${SCHEME_NAME}" archive

# Generate tvOS framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-appletvos.xcarchive" -destination "generic/platform=tvOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate tvOS Simulator framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-appletvsimulator.xcarchive" -destination "generic/platform=tvOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate watchOS framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-watchos.xcarchive" -destination "generic/platform=watchOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate watchOS Simulator framework
xcodebuild -project "${PROJECT_FILE}" -configuration Release -archivePath "${OUTPUT_DIR}/${SCHEME_NAME}-watchsimulator.xcarchive" -destination "generic/platform=watchOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -scheme "${SCHEME_NAME}" archive

# Generate XCFramework
xcodebuild -create-xcframework \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-appletvos.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-appletvsimulator.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-iphoneos.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-iossimulator.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-macosx.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-maccatalyst.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-watchos.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -archive "${OUTPUT_DIR}/${SCHEME_NAME}-watchsimulator.xcarchive" -framework "${SCHEME_NAME}.framework" \
    -output "${OUTPUT_DIR}/${SCHEME_NAME}.xcframework"

# Zip it!
ditto -c -k --rsrc --keepParent "${OUTPUT_DIR}/${SCHEME_NAME}.xcframework" "${OUTPUT_DIR}/${SCHEME_NAME}.xcframework.zip"
rm -rf "${OUTPUT_DIR}/${SCHEME_NAME}.xcframework"
