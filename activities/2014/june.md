## June

### 1st week

- Adding OpenCV and OpenMVG as GIT submodules to the project
	- It allows local compilation and debug
	- Changes to main repositories can be submitted as contributions
- Porting Essential matrix estimation and decomposition to OpenCV
	- Both algorithms are now implemented in 3.0 version
	- OpenCV seems up to twice times faster thanks to OpenCL support
- Analyzing implementations of stereo matching algorithms
	- Dense depth map for current frame $I_i$ is fused with $I_{0..i-1}$ in a cost volume, according to @newcombe2010dtam
	- PathMatch stereo algorithm from @bleyer2011patchmatch

### 2nd week

- Implemented support for block matching in GPU using OpenCV CUDA support
	- Added a basic point cloud rendering shader to represent depths from disparity maps using `cv::cuda::reprojectTo3D()`
- Added visualization using OpenGL avoiding to download the image from GPU
	- Refactored rendering code to use a "layer" drawing concept in OpenGL
	- Created a Layer to render OpenCV images coming from CPU / GPU
- Studying and documenting a general framework to feedback reconstruction and recognition (see `rec2rec.md` for more information)
- Recorded a video demoing the camera tracking using the OpenCV essential estimator

![tracking](../../figures/tracking.avi "Camera tracking demo using a moving cube")

### 3rd week

- Documentation:
    - Added more documentation related with fibrations and fiber bundles
    - Improved description of relations between Lie groups and Lie algebras
    - Added total variation description as the regularization term in optimization approaches
		- Added explanation of linearization of the $GL$ group using a structural group

### 4rd week

- Implementation and code review:
		- Analysis of the [Urho3D](https://github.com/urho3d/Urho3D) project as a C++ rendering engine for future AR applications
		- Study JNI bridge for executing native ARM code from Java applications in Android
		- Reading optimization procedures in the $\mathfrak{SE}(3)$ algebra instead in the $SE(3)$ group

#### References
