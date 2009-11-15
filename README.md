Using OpenCV on iPhone
----------------------
This source repository includes pre-compiled OpenCV library and headeres so that you can get started easily!
More documents you can see on [this article](http://niw.at/articles/2009/03/14/using-opencv-on-iphone/).

Building Static Link Version of OpenCV
--------------------------------------
If you want to build it from source code, you can do by next steps.

1.  Clone this project from github.com, then move into the project directory

        % git clone git://github.com/niw/iphone_opencv_test.git

2.  Getting source code from sourceforge. I tested with [OpenCV-2.0.0.tar.bz2](http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.0/OpenCV-2.0.0.tar.bz2/download).

3.  Extract downloaded archive on the top of project project directory

        % tar xjvf opencv-2.0.0.tar.bz2

3.  Apply patch for iPhone SDK

        % cd OpenCV-2.0.0
		% patch -p0 < ../cvcalibration.cpp.patch_opencv-2.0.0

4.  Following next steps to build OpenCV static library for simulator

        % cd OpenCV-2.0.0
		% mkdir build_simulator
		% ../../configure_opencv
		% make
		% make install # Install all files into ../../opencv_simulator

5.  Following next steps to build OpenCV static library for device

        % cd OpenCV-2.0.0
		% mkdir build_device
		% ARCH=device ../../configure_opencv
		% make
		% make install # Install all files into ../../opencv_device

Patch and Configure support script
----------------------------------

OpenCV 2.0.0 (and also 1.1.0) has a glitch which refuse builing the library with iPhone SDK.
You need to apply the patch(cvcalibration.cpp.patch) so that you can build it.

Congiure support script(configure\_opencv) has some options to build OpenCV with iPhone SDK.
Try to ``--help`` option to get the all options of it.

Change Log
----------
 *  11/15/2009 - Support OpenCV to 2.0.0 + iPhone SDK 3.x
 *  03/14/2009 - Release this project with OpenCV 1.0.0 + iPhone SDK 2.x
