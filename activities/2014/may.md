## May

### 1st week

- Setup of OpenNI 2 to use RGB-D cameras
	+ In linux, only the [OpenKinect](https://github.com/OpenKinect/libfreenect/tree/master/OpenNI2-FreenectDriver) driver works
	+ It requires to compile libfreenect too. Actually, they are in the same project
- Added a wrapper to interoperate with OpenCV `cv::Mat` from [Roy Shilkrot](http://web.media.mit.edu/~roys/src/OpenNI2OpenCVInterop.h), a PhD student @ MIT Media Lab
	+ Tweaked conversion of depth map using 1/32 scale instead 1/4 to achieve a wider range of values (the original solution only provides binary images!)

![kinectrgb](../../figures/video_rgb.avi "Kinect RGB output example")
![pkinectdepth](../../figures/video_depth.avi "Kinect Depth output example")

### 2nd week

- **Documentation** -> improvement of the markdown code, including references extracted from BibTex using Pandoc processor in a Makefile
- Evaluation of different strategies for tracker initialization
- PTAM approach from @klein2007parallel
	+ Stereo initilization from a short baseline movement of the camera
- MonoFusion approach from pradeep2013monofusion
	+ Bootstrap initilization, triangulating a set of landmarks created with short movements of the camera

### 3rd week

- The five point estimator of the $E$ matrix from @nister2004efficient shows the best performance vs stability tradeoff, based on the RANSAC framework
- A first triangulation of visual landmarks will be mandatory to create a first map
	+ Added documentation about triangulation using DLT and SVD to solve the least-squared problem
- Maybe the rest of iterations should update the map using bundle adjustment?
- A code inspection of Open Multiple View Geometry reveals that it is an improved version of libmv, developed by Pierre Moulon
	+ It is even possible to interface with Elise, the image library of [MicMac](http://logiciels.ign.fr/?Telechargement,20) developed y the IGN (France)
	+ Added as dependency using GIT submodules in my own project

### 4th week

- Implemented robust estimation of the Essential matrix using 5-point solver from OpenMVG
	+ There are 4 possible solutions
	+ The best solution maximizes the number of points in front of two cameras (positive depth)
	+ POSE is extracted using the SVD decomposition from @hartley2003multiple
- Porting OpenCV that uses liear algebra to Eigen3
	+ It is really easy to make algebra computations
	+ Matrix types are compatible with OpenCV and OpenMVG
	+ There are more implementations in "Unsupported modules" section

#### References
