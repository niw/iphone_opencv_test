Using OpenCV on iPhone
----------------------
This source repository does NOT include pre-compiled OpenCV library or headers! It helps you building yours, from OpenCV source code.
More documents you can see on [this article](http://niw.at/articles/2009/03/14/using-opencv-on-iphone/), but it is kinda old now.
As far as I can see, the [original repo](https://github.com/niw/iphone_opencv_test) is not maintained anymore. I'm not sure to
let the XCode project in future release, it is more noise than anything in the repo. If anyone is annoyed by this, please tell me!


Build every versions in one pass
--------------------------------

Build support script ``opencv_cmake.sh`` has some options to build OpenCV with iOS SDK.
Try ``--help`` option to get the all options of it. By default, the iOS SDK 5.0 is used.
It supposed you use XCode 4.2, situated in directory /Developer

Script ``make_all.sh`` uses ``opencv_cmake.sh`` to build the simulator version, the device
version and the universal version (both i386 and armv6/7) in one pass. Just give it
the OpenCV version as a parameter. You must have the OpenCV archive in the same directory.
**BE CAREFUL** with last version 2.3.1a, the last ``a`` breaks the script, so please, rename
the archive as ``OpenCV-2.3.1.tar.bz2``. This script uses ``make -j 4`` specifying that
4 building jobs are run simultaneously. You should probably adapt this to your own configuration.


Modifications to the original sources
-------------------------------------
To be usable to use the whole library both on the simulator and on the device, I had to remove some parts of highgui like Cocoa and QuickTime support. Removing the whole highgui package prevents you to build on the simulator with some libraries linked.

Here is the list of all the files I've changed (see the patch for further details):

1. into ``features2d/oneway.cpp``

        - OneWayDescriptor::Save() does not save image anymore ;
        - function loadPCAFeatures() does not extractPatches() as before, this is probably a problem if you use it...

2. into ``objdetect/latentsvmdetector.cpp``

        - function cvLatentSvmDetectObjects() does not swap red and blue components before and after its process.

3. into ``objdetect/latentsvm.cpp``

        - functions showRootFilterBoxes(), showPartFilterBoxes() and showBoxes() does not show image anymore.

4. into ``contrib/chamfermatching.cpp``

        - function ChamferMatcher::Template::show() does not show image anymore.

If you know some way to recover these functionalities without breaking the build, you can propose a different patch.

After these modifications, I've produced the patch with the command:

			diff -crB OpenCV-VERSION ../OpenCV-VERSION > OpenCV-VERSION.patch

with ``../OpenCV-VERSION`` the directory containing the modified version.


Building Static Link Version of OpenCV
--------------------------------------
If you want to build it from source code, you can do by next steps.

1.  Building OpenCV requires [CMake](http://www.cmake.org/).
    You can easily install it by using [Homebrew](http://mxcl.github.com/homebrew/) or [MacPorts](http://www.macports.org/).

        # Using Homebrew
        % brew install cmake
        # Using MacPorts
        % sudo port install cmake

2.  Clone this project from github.com, then move into the project directory

        % git clone git://github.com/stephanepechard/iphone_opencv_test.git

3.  Getting source code from sourceforge. I tested with [OpenCV-2.3.1.tar.bz2](http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.3.1/OpenCV-2.3.1a.tar.bz2/download).

4.  Extract downloaded archive on the top of demo project directory

        % tar xjvf OpenCV-2.3.1.tar.bz2

5.  Apply patch for iPhone SDK

        % cd OpenCV-2.3.1
        % patch -p1 < ../OpenCV-2.3.1.patch

6.  Following next steps to build OpenCV static library for simulator.
    All files are installed into ``opencv_simulator`` directory.
    When running ``make`` command, you've better assign ``-j`` option and number according to number of your CPU cores.
    Without ``-j`` option, it takes a long time.

        % cd ..
        % mkdir build_simulator
        % cd build_simulator
        % ../opencv_cmake.sh Simulator ../OpenCV-2.3.1
        % make -j 4
        % make install

7.  Following next steps to build OpenCV static library for device
    All files are installed into ``opencv_device`` directory.

        % cd ..
        % mkdir build_device
        % cd build_device
        % ../opencv_cmake.sh Device ../OpenCV-2.3.1
        % make -j 4
        % make install


Change Log
----------
 *  12/07/2011 - Support OpenCV 2.3.1 + iOS SDK 5.0.1 + XCode 4.2.1 + Mac OS X 10.7
					  Cleaner ``make_all.sh`` script.
					  Allows building highgui with some removed functionalities.
 *  09/23/2011 - Support OpenCV 2.3.1 + iOS SDK 5.0 + XCode 4 [first stephanepechard commit]
 *  04/11/2011 - Support OpenCV 2.2.0 + iOS SDK 4.3 + XCode 4
 *  10/30/2010 - Support iOS SDK 4.1
 *  08/22/2010 - Support OpenCV 2.1.0 + iOS SDK 4.0
 *  12/21/2009 - Support Snow Leopard + iPhone SDK 3.1.2, Thank you Hyon!
 *  11/15/2009 - Support OpenCV to 2.0.0 + iPhone SDK 3.x
 *  03/14/2009 - Release this project with OpenCV 1.0.0 + iPhone SDK 2.x
