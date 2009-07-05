#!/bin/sh
if [ -z "${SDK_VERSION}" ]; then
	SDK_VERSION=3.0
fi
if [ -z "${GCC_VERSION}" ]; then
	if [ `expr ${SDK_VERSION} \\>= 3.0` = '1' ]; then
		GCC_VERSION=4.2
	else
		GCC_VERSION=4.0
	fi
fi
PLATFORM=/Developer/Platforms/iPhoneOS.platform
BIN=${PLATFORM}/Developer/usr/bin
SDK=${PLATFORM}/Developer/SDKs/iPhoneOS${SDK_VERSION}.sdk

PREFIX=`pwd`/`dirname $0`/../opencv_armv6
PATH=/bin:/sbin:/usr/bin:/usr/sbin:${BIN}

../configure --prefix=${PREFIX} \
	--build=i686-apple-darwin9 \
	--host=arm-apple-darwin9 \
	--enable-static \
	--disable-shared \
	--disable-apps \
	--without-python \
	--without-ffmpeg \
	--without-1394libs \
	--without-v4l \
	--without-imageio \
	--without-quicktime \
	--without-carbon \
	--without-gtk \
	--without-gthread \
	CC=${BIN}/gcc-${GCC_VERSION} \
	CXX=${BIN}/g++-${GCC_VERSION} \
	CFLAGS="-arch armv6 -isysroot ${SDK}" \
	CXXFLAGS="-arch armv6 -isysroot ${SDK}" \
	CPP=${BIN}/cpp-${GCC_VERSION} \
	CXXCPP=${BIN}/cpp-${GCC_VERSION} \
	AR=${BIN}/ar
