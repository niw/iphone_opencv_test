#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin
../configure \
    --host=arm-apple-darwin \
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
	CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin9-gcc-4.0.1 \
	CXX=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin9-g++-4.0.1 \
	CFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.2.sdk" \
	CXXFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.2.sdk" \
	CPP=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/cpp \
	CXXCPP=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/cpp \
	AR=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ar
