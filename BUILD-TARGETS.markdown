# Building a universal static framework for iOS simulator and device:
- Create a static library target for your project named "<PROJECT-NAME>-StaticLib".
- Verify that the static library target builds with no issues for both the simulator SDK and the device SDK for both Debug and Release configurations.
- Create new target using the Other->Aggregate target template named <PROJECT-NAME>-iPhone.
- Create a new Run Script build phase named "Build architecture-specific static libs" to build the two versions (simulator and device) of the static library target.  The contents of this script should be:
        xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphonesimulator3.2 -target ${PROJECT_NAME}-StaticLib -configuration ${CONFIGURATION} clean build
        xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphoneos3.2 -target ${PROJECT_NAME}-StaticLib -configuration ${CONFIGURATION} clean build
- Create a new Run Script build phase named "Build universal static lib" to build the framework which will contain the combined static library created from the two static libraries.  The contents of this script should be:
        SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}-StaticLib.a" &&
        	DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}-StaticLib.a" &&
        	UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal" &&
        	UNIVERSAL_LIBRARY_PATH="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}" &&
        	FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}.framework" &&

        # Create framework directory structure.
        	rm -rf "${FRAMEWORK}" &&
        	mkdir -p "${UNIVERSAL_LIBRARY_DIR}" &&
        	mkdir -p "${FRAMEWORK}/Versions/A/Headers" &&
        	mkdir -p "${FRAMEWORK}/Versions/A/Resources" &&

        # Generate universal binary from desktop, device, and simulator builds.
        	lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${UNIVERSAL_LIBRARY_PATH}" &&

        # Move files to appropriate locations in framework paths.
        	cp "${UNIVERSAL_LIBRARY_PATH}" "${FRAMEWORK}/Versions/A" &&
        	cd "${FRAMEWORK}/Versions" &&
        	ln -s "A" "Current" &&
        	cd "${FRAMEWORK}" &&
        	ln -s "Versions/Current/Headers" "Headers" &&
        	ln -s "Versions/Current/Resources" "Resources" &&
        	ln -s "Versions/Current/${PRODUCT_NAME}" "${PRODUCT_NAME}"
- Create a Copy Files build phase named "Copy headers to framework" that will put the necessary file headers into the framework directory structure.  Set the Destination to Absolute Path, and set the Full Path to:
        ${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal/${PRODUCT_NAME}.framework/Headers
- Add all public headers to the "Copy headers to framework" build phase.
- Optionally, create a Copy Files build phase named "Copy resources to framework" to copy custom resource artifacts (such as Info.plist or README or license.txt) to the framework Resources directory.  Set the Destination to Absolute Path, and set the Full Path to: :
        ${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal/${PRODUCT_NAME}.framework/Resources
- Build using the Base SDK (which should probably be a Mac OS X 10.x SDK, based on what we've seen).  If you get build errors related to missing architecture, try changing the selected target SDK.
- Projects that consume your static library may need to pass -ObjC and/or -all_load with the Other Linker Flags build option.  See (http://developer.apple.com/mac/library/qa/qa2006/qa1490.html).
