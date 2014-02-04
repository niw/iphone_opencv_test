#!/bin/sh

# first, get OpenCV from http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$OPENCV_VERSION
if [ -z "$1" ]; then
    OPENCV_VERSION="2.3.1"
	echo "No OpenCV version given, using default: " $OPENCV_VERSION
else
	OPENCV_VERSION="$1"
fi

# open archive and patch it
tar xjvf OpenCV-"$OPENCV_VERSION".tar.bz2 &&
cd OpenCV-"$OPENCV_VERSION" &&
patch -p1 < ../OpenCV-"$OPENCV_VERSION".patch

# build Simulator version
cd .. &&
mkdir build_simulator &&
cd build_simulator &&
../opencv_cmake.sh Simulator ../OpenCV-"$OPENCV_VERSION" &&
make -j 4 &&
make install

# build Device version
cd .. &&
mkdir build_device &&
cd build_device &&
../opencv_cmake.sh Device ../OpenCV-"$OPENCV_VERSION" &&
make -j 4 &&
make install

# build Universal version
cd .. &&
mkdir -p opencv_universal/lib &&
lipo opencv_simulator/lib/libopencv_calib3d.a      opencv_device/lib/libopencv_calib3d.a          -output opencv_universal/lib/libopencv_calib3d.a         -create
lipo opencv_simulator/lib/libopencv_contrib.a      opencv_device/lib/libopencv_contrib.a          -output opencv_universal/lib/libopencv_contrib.a         -create
lipo opencv_simulator/lib/libopencv_core.a         opencv_device/lib/libopencv_core.a             -output opencv_universal/lib/libopencv_core.a            -create
lipo opencv_simulator/lib/libopencv_features2d.a   opencv_device/lib/libopencv_features2d.a       -output opencv_universal/lib/libopencv_features2d.a      -create
lipo opencv_simulator/lib/libopencv_flann.a        opencv_device/lib/libopencv_flann.a            -output opencv_universal/lib/libopencv_flann.a           -create
lipo opencv_simulator/lib/libopencv_gpu.a          opencv_device/lib/libopencv_gpu.a              -output opencv_universal/lib/libopencv_gpu.a             -create
lipo opencv_simulator/lib/libopencv_highgui.a      opencv_device/lib/libopencv_highgui.a          -output opencv_universal/lib/libopencv_highgui.a         -create
lipo opencv_simulator/lib/libopencv_imgproc.a      opencv_device/lib/libopencv_imgproc.a          -output opencv_universal/lib/libopencv_imgproc.a         -create
lipo opencv_simulator/lib/libopencv_legacy.a       opencv_device/lib/libopencv_legacy.a           -output opencv_universal/lib/libopencv_legacy.a          -create
lipo opencv_simulator/lib/libopencv_ml.a           opencv_device/lib/libopencv_ml.a               -output opencv_universal/lib/libopencv_ml.a              -create
lipo opencv_simulator/lib/libopencv_objdetect.a    opencv_device/lib/libopencv_objdetect.a        -output opencv_universal/lib/libopencv_objdetect.a       -create
lipo opencv_simulator/lib/libopencv_video.a        opencv_device/lib/libopencv_video.a            -output opencv_universal/lib/libopencv_video.a           -create

# copy common files
cp -r opencv_device/lib/pkgconfig opencv_universal/lib/ &&
cp -r opencv_device/include opencv_device/share opencv_universal/ &&

# clean
rm -rf opencv_universal/share/OpenCV/doc
