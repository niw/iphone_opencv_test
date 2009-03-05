Using OpenCV on iPhone
----------------------
This source repository includes pre-compiled OpenCV library and headeres
so that you can get started easily!
see /opencv_arm6 for iPhone device and /opencv_sim for iPhone simulator(for Intel Mac only).

Building Static Link Version of OpenCV
--------------------------------------
If you want to build it from source code, you can do by next steps.

1. 	Getting source code from sourceforge. I tested with [opencv-1.1pre1.tar.gz](http://sourceforge.net/project/showfiles.php?group_id=22870&package_id=16948&release_id=634504).

2.  Extract tar.gz in the top of project dir

        % tar xzvf opencv-1.1pre1.tar.gz

3.  Edit opencv_build_scripts/configure_*.sh for your enviroment(--prefix etc...) if need

4.  Build for each platforms(armv6, sim)

        % cd opencv-1.1.0
        % mkdir build_(platform)
        % pushd build_(platform)
		% ../../opencv_build_scripts/configure_(platform).sh
		% make
		% make install
		% popd
