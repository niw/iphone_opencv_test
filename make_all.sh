# git clone git://github.com/niw/iphone_opencv_test.git
# get OpenCV

tar xjvf OpenCV-2.3.0.tar.bz2
cd OpenCV-2.3.0
patch -p1 < ../OpenCV-2.3.0.patch

cd ..
mkdir build_simulator
cd build_simulator
../opencv_cmake.sh Simulator ../OpenCV-2.3.0
make -j 4
make install

cd ..
mkdir build_device
cd build_device
../opencv_cmake.sh Device ../OpenCV-2.3.0
make -j 4
make install

cd ..
mkdir -p opencv_universal/lib
lipo opencv_simulator/lib/libopencv_calib3d.a      opencv_device/lib/libopencv_calib3d.a          -output opencv_universal/lib/libopencv_calib3d.a         -create
lipo opencv_simulator/lib/libopencv_contrib.a      opencv_device/lib/libopencv_contrib.a          -output opencv_universal/lib/libopencv_contrib.a         -create
lipo opencv_simulator/lib/libopencv_core.a         opencv_device/lib/libopencv_core.a             -output opencv_universal/lib/libopencv_core.a            -create
lipo opencv_simulator/lib/libopencv_features2d.a   opencv_device/lib/libopencv_features2d.a       -output opencv_universal/lib/libopencv_features2d.a      -create
lipo opencv_simulator/lib/libopencv_flann.a        opencv_device/lib/libopencv_flann.a            -output opencv_universal/lib/libopencv_flann.a           -create
lipo opencv_simulator/lib/libopencv_gpu.a          opencv_device/lib/libopencv_gpu.a              -output opencv_universal/lib/libopencv_gpu.a             -create
lipo opencv_simulator/lib/libopencv_imgproc.a      opencv_device/lib/libopencv_imgproc.a          -output opencv_universal/lib/libopencv_imgproc.a         -create
lipo opencv_simulator/lib/libopencv_ml.a           opencv_device/lib/libopencv_ml.a               -output opencv_universal/lib/libopencv_ml.a              -create
lipo opencv_simulator/lib/libopencv_objdetect.a    opencv_device/lib/libopencv_objdetect.a        -output opencv_universal/lib/libopencv_objdetect.a       -create
lipo opencv_simulator/lib/libopencv_video.a        opencv_device/lib/libopencv_video.a            -output opencv_universal/lib/libopencv_video.a           -create

cp -r opencv_device/lib/pkgconfig opencv_universal/lib/
cp -r opencv_device/include opencv_device/share opencv_universal/
rm -rf opencv_universal/share/opencv/doc
