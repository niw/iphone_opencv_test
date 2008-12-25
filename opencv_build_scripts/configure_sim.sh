#!/bin/sh
PREFIX=`pwd`/`dirname $0`/../opencv_sim
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin
../configure --prefix=${PREFIX} \
	--host=i686-apple-darwin \
	--enable-static \
	--disable-shared \
	--without-python \
	--without-ffmepg \
	--without-1392libs \
	--without-v41 \
	--without-imageio \
	--without-quicktime \
	--without-carbon \
	--without-gtk \
	--without-gthread \
	--disable-apps \
	CC=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/i686-apple-darwin9-gcc-4.0.1 \
	CXX=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/i686-apple-darwin9-g++-4.0.1 \
	CFLAGS="-arch i386 -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.2.sdk" \
	CXXFLAGS="-arch i386 -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.2.sdk" \
	CPP=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/cpp \
	CXXCPP=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/cpp \
	AR=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/ar
