# Visual Tracking

Visual tracking can be defined as the main task to solve in Simultaneous Localization and Mapping (SLAM). Besides, it is needed to accomplish the 3D reconstruction of a scene since always there is a need to perform stereo based depth computation.

A first approximation was introduced by @drummond2002real. It was based on active contour tracking of real objects based on a prior knowledge of the CAD model of the tracked object. They use a simplified approach to achieve a frame rate of 25 fps.

One of the most recent open source implementations is CoSLAM developed by @zou2013coslam. Here is a video about the final results:

<iframe width="640" height="480" src="http://www.youtube.com/embed/eK_4Sf_m9bQ?rel=0"></iframe>

The work of @salas2013slampp is pointing in our direction of setting a feedback between the reconstruction and the recognition phase, as they shows in their last work demoed at this video:

<iframe width="640" height="480" src="http://www.youtube.com/embed/tmrAh1CqCRo?rel=0"></iframe>

As the description of the video shows, they use a RGB-D camera to quickly estimate the depth of the scene. Then, the 6 DOF of the camera pose can be extracted using an ICP (Iterative Closest Point) alignment method from consecutive frames. The pose graph allows to close large loops at the same time is able to recover from bad pose estimations.

## Keypoints

- Use dense map of low quality features
- Split the mapping and tracking into two different threads as PTAM does [@klein2007parallel]
- Extract only the relevant keyframes, according to the amount of camera movement

## Stereo initialization

1. Create an initial map of the scene by bootstrapping the camera pose tracker in just a few frames.
2. Matching 2D features between the first frame and the current frame using FAST and optical flow
3. The Essential matrix $ E_{0,i} is computed using RANSAC with the Five Point Algorithm from @stewenius2006fivepoint
4. The SVD yields the relative rotation and translation between frames $0$ and $i$
5. An arbitrary scale factor is applied to the translation vector to determine the scale of the map
6. Matched features are used to generate a 3D map $M$ by triangulating $N$ landmarks detected
7. Each landmark $L$ stores the 3D triangulated position and the $MxM$ image patch of the feature

### References
