Using OpenCV on iPhone
----------------------
This source repository includes pre-compiled OpenCV library and headeres
so that you can get started easily!
see /opencv_arm6 for iPhone device and /opencv_sim for iPhone simulator.

Building Static Link Version of OpenCV
--------------------------------------
If you want to build it from source code, you can do by next steps.

1. 	Getting source code from sourceforge svn

        % svn co https://opencvlibrary.svn.sourceforge.net/svnroot/opencvlibrary/trunk/opencv opencv_svnhead

2.  Edit opencv_build_scripts/configure_*.sh for your enviroment(--prefix etc...) if need

3.  Build for each platforms(arm6, sim)

        % mkdir build_(platform)
        % pushd build_(platform); ../../opencv_build_scripts/configure_(platform).sh; make; make install; popd
