#!/bin/sh

if [ "$1" = "-h" -o "$1" = "--help" -o -z "$1" ]; then
	echo "USAGE"
	echo "    $0 [-h,--help] {device,simulator} source_dir"
	echo "OPTIONS"
	echo "    -h, --help     Show help and default options"
	echo "    device         Build binary for iOS devices"
	echo "    simulator      Build binary for iOS Simulator"
	echo "    source_dir     Path to OpenCV source directory"
	echo "ENVIRONMENT"
	echo "    INSTALL_PREFIX       Path to OpenCV binary directory"
	echo "    SDK_VERSION          iOS SDK version"
	echo "    IPHONEOS_VERSION_MIN iOS deployment target"
	echo "    CMAKE_OPTIONS        Additional CMake options"
	echo "    CFLAGS               Additional compiler flags"
	exit
fi

if ! type 'cmake' > /dev/null 2>&1; then
	echo "cmake is not found, please install cmake command which is required to build OpenCV."
	exit 1;
fi

TARGET_SDK=`echo "$1"|tr '[:upper:]' '[:lower:]'`
if [ "$TARGET_SDK" = "device" ]; then
	TARGET_SDK_NAME="iPhoneOS"
elif [ "$TARGET_SDK" = "simulator" ]; then
	TARGET_SDK_NAME="iPhoneSimulator"
else
	echo "Please select Device or Simulator."
	exit 1
fi

if [ -z "$SDK_VERSION" ]; then
	SDK_VERSION="5.0"
fi

if [ -z "$IPHONEOS_VERSION_MIN" ]; then
	IPHONEOS_VERSION_MIN="3.0"
fi

DEVELOPER_ROOT="/Developer4.2/Platforms/${TARGET_SDK_NAME}.platform/Developer"
SDK_ROOT="${DEVELOPER_ROOT}/SDKs/${TARGET_SDK_NAME}${SDK_VERSION}.sdk"

if [ ! -d "$SDK_ROOT" ]; then
	echo "iOS SDK Version ${SDK_VERSION} is not found, please select iOS version you have."
	exit 1
fi

if [ -z "$2" ]; then
	echo "Please assign path to OpenCV source directory which includes CMakeLists.txt."
	exit 1
else
	OPENCV_ROOT="$2"
fi

if [ ! -f "${OPENCV_ROOT}/CMakeLists.txt" ]; then
	echo "No CMakeLists.txt in ${OPENCV_ROOT}, please select OpenCV source directory."
	exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
	INSTALL_PREFIX="`pwd`/../opencv_${TARGET_SDK}"
fi

#BUILD_PATH="`pwd`/build_${TARGET_SDK}"
#if [ -d "${BUILD_PATH}" ]; then
#	echo "${BUILD_PATH} is found, please remove it prior to run this command."
#	exit 1
#else
#	mkdir -p "${BUILD_PATH}"
#fi
#cd "${BUILD_PATH}"

echo "Starting cmake..."
echo "CMake version         = `cmake --version`"
echo "Target SDK            = $TARGET_SDK_NAME"
echo "iOS SDK Version       = $SDK_VERSION"
echo "iOS Deployment Target = $IPHONEOS_VERSION_MIN"
echo "OpenCV Root           = $OPENCV_ROOT"
echo "OpenCV Install Prefix = $INSTALL_PREFIX"
echo ""

if [ "$TARGET_SDK" = "device" ]; then
	CFLAGS="-arch armv6 -arch armv7 -mthumb -miphoneos-version-min=${IPHONEOS_VERSION_MIN} ${CFLAGS}"
	ARCH="armv6;armv7"
	CMAKE_OPTIONS="-D ENABLE_SSE=OFF -D ENABLE_SSE2=OFF ${CMAKE_OPTIONS}"
else
	CFLAGS="-m32 ${CFLAGS}"
	ARCH="i386"
	CMAKE_OPTIONS="-D CMAKE_OSX_DEPLOYMENT_TARGET=\"10.6\" ${CMAKE_OPTIONS}"
fi

env \
	CFLAGS="${CFLAGS}" \
	CXXFLAGS="${CFLAGS}" \
cmake \
	-D CMAKE_BUILD_TYPE=Release \
	-D BUILD_NEW_PYTHON_SUPPORT=OFF \
	-D BUILD_SHARED_LIBS=OFF \
	-D BUILD_TESTS=OFF \
	-D OPENCV_BUILD_3RDPARTY_LIBS=OFF \
	-D WITH_1394=OFF \
	-D WITH_CARBON=OFF \
	-D WITH_FFMPEG=OFF \
	-D WITH_JASPER=OFF \
	-D WITH_PVAPI=OFF \
	-D WITH_QUICKTIME=OFF \
	-D WITH_TBB=OFF \
	-D WITH_TIFF=OFF \
	-D CMAKE_C_FLAGS="${CFLAGS}" \
	-D CMAKE_CXX_FLAGS="${CFLAGS}" \
	-D CMAKE_OSX_SYSROOT="${SDK_ROOT}" \
	-D CMAKE_OSX_ARCHITECTURES="${ARCH}" \
	-D CMAKE_C_COMPILER="${DEVELOPER_ROOT}/usr/bin/gcc" \
	-D CMAKE_CXX_COMPILER="${DEVELOPER_ROOT}/usr/bin/g++" \
	-D CMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
	${CMAKE_OPTIONS} \
	"${OPENCV_ROOT}" \
	&& echo "" \
	&& echo "Done! next step is runing make (with -j option if you want to build using multi cores)."
