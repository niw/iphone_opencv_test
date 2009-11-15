Using OpenCV on iPhone
----------------------
This source repository includes pre-compiled OpenCV library and headeres
so that you can get started easily!

Building Static Link Version of OpenCV
--------------------------------------
If you want to build it from source code, you can do by next steps.

1.  Clone this project from github.com, then move into the project directory

        % git clone git://github.com/niw/iphone_opencv_test.git

2.  Getting source code from sourceforge. I tested with [opencv-2.0.0.tar.bz2](http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.0/OpenCV-2.0.0.tar.bz2/download).

3.  Extract downloaded archive on the top of project project directory

        % tar xjvf opencv-2.0.0.tar.bz2

3.  Apply patch for using iPhone SDK 3.x with OpenCV 2.0.0

        % cd OpenCV-2.0.0
		% patch -p0 < ../cvcalibration.cpp.patch_opencv-2.0.0

4.  Following next steps to build OpenCV static library for simulator

        % cd OpenCV-2.0.0
		% mkdir build_simulator
		% ../../configure_opencv
		% make
		% make install

5.  Following next steps to build OpenCV static library for device

        % cd OpenCV-2.0.0
		% mkdir build_device
		% ARCH=device ../../configure_opencv
		% make
		% make install

Configure support script and patch
----------------------------------

OpenCV 2.0.0 (and also 1.1.0) has a bug which refuse builing the library with iPhone SDK.
You need to apply the patch(cvcalibration.cpp.patch) so that you can build it.

Congiure support script(configure\_opencv) has some options to build OpenCV with iPhone SDK.
Try to ``--help`` option to get the all options of it.

Change Log
----------
 *  11/15/2009 - Update OpenCV to 2.0.0 + iPhone SDK 3.x, change configure support script, adding patch
 *  03/14/2009 - Make an article on the web with OpenCV 1.0.0 + iPhone SDK 2.x
