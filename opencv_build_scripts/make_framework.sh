#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin
make -j 5 framework FRAMEWORK_ARCH=armv6 FRAMEWORK_INSTALL_PATH="@executable_path/../Frameworks"
