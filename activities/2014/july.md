# July

## 1st week

- Documentation:
    - Added a new section for computing depth map using stereo matching
    - Studied the method of depth map fusion using a cost volume of a regular voxel grid
    - Added new details for minimizing the first-order primal dual algorithm from @chambolle2011first

- Implementation
    - Tested [Gallup](http://www.cs.unc.edu/~gallup/cuda-stereo) implementation of local stereo matching using SAD in CUDA

## 2nd week

- Studying Dense Tracking and Mapping (DTAM) implementation by @newcombe2010dtam
    - Base mesh is build over sparse point cloud from PTAM by the polygonalization of the function's zero level set of a function $f$ fit to the data points $$\mathbb{R}^3 \rightarrow \mathbb{R}, f(x) = 0$$
    - Model predictive optical flow using projected images from the base model
    - Use of dense TVL1 optical flow implementation to track pixels
    - Mesh optimization using scene flow to compute vertex updates $$\triangle \mathbf{x}_j$$ which lie in the ray from the reference camera intersecting the base model vertex $$\mathbf{x}_j$$

## 3rd week

- Added documentation about Scene Flow and Optical Flow by @vedula1999sceneflow
- Put some glue to all ideas making a new introduction to the main framework based on vector spaces over fibrations

## 4th week

- Testing feature tracking based on FAST detector combined with fast matching using ZNCC search
- ORB and FAST feature detectors are tested in the GPU. Both are fast and more stable than the `goodfeaturestotrack`

## 5th week

- Removed submodule dependencies from OpenCV and OpenMVG: they increases project complexity and at currently they are not modified
    - In fact, QtCreator does not recognize the OpenCV INCLUDEPATH using submodules
- Debugging triangulation procedures to reduce the high Mean Reprojection Error (from 1000 to less than 1.0!)

## References
