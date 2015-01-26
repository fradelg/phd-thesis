# Semi-dense depth maps

Monocular reconstruction from image features makes an abstraction of the problem which reduces its complexity and allows it to be tackled in real time. However, they introduces two significant drawbacks

 1. Only a small portion of the image information conforming to the respective feature type and parametrization is utilized
 2. Feature matching requires the costly computation of scale- and rotation-invariant descriptors and robust outlier estimation methods like RANSAC

Dense SLAM methods take advantage of all the available image information by working directly on the images for both mapping and tracking. The world is modeled as dense surface at the same time that new frames are tracked using whole-image alignment. These methods increase tracking accuracy and robustness using powerful GPU processors. The same methods can be used in combination with RGB-D cameras (giving the depth for each pixel), or stereo camera rigs to simplify the problem.

A *semi-dense depth map* is a depth map which does not include the depth for every pixel of the stereo pair but only for a subset of the moving pixels.

## Estimation

The depth map is propagated from frame to frame and refined with new stereo depth measurements. Depth is computed by performing per-pixel, adaptive-baseline stereo comparisons allowing accurate estimations of depth both of close-by and far-away image regions. Each inverse depth hypothesis is maintained per pixel and represented as a Gaussian probability distribution.

In stereo matching there is always a trade-off between precision and accuracy. A first approach consist of accumulating the respective cost functions over many frames. However, Engel et al. introduce a probabilistic approach taking advantage of the fact that in a video, small baseline frames are available before large-baseline frames [@engel2013slam].

The depth map is updated as follows:

 1. A subset of pixels is selected for which the accuracy of a disparity search is sufficiently large. To achieve this goal three efficient local criteria are used to determine for which pixel a stereo update is worth the computational cost.

  * the photometric disparity error $\sigma^2_{\lambda(\xi,\pi)}$, depending on the magnitude of the image gradient along the epipolar line
  * the geometric disparity error $\sigma^2_{\lambda(I)}$, depending on the angle between the image gradient and the epipolar line
  * the pixel to inverse depth ratio $\alpha$, depending on the camera translation, the focal length and the pixel’s position.

 2. For each selected pixel, a suitable reference frame is selected for each pixel to perform a one-dimensional disparity search according to the pixel's age. The selection is done by searching the oldest frame the pixel was observed in, where the disparity search range and the observation angle does not exceed a given threshold.
 3. The inverse depth estimation is performed by searching the pixel’s intensity along the epipolar line in the selected reference frame. Then a sub-pixel accurate localization of the matching disparity is performed. If a prior inverse depth hypothesis is available, the search interval is limited by $d ± 2 \sigma_d$, where $d$ and $\sigma_d$ denote the mean and standard deviation of the prior hypothesis. Otherwise, the full disparity range is searched. The error is calculated with SSD over five equidistant points on the epipolar line.
 4. The depth estimation is fused into the global depth map as follows: if there is not a prior hypothesis about depth, the value is initialized with the observation; otherwise the two distributions are multiplied simulating the update step in a Kalman filter such that given a prior distribution $N(d_p, \sigma_p^2)$ and a noisy observation $N(d_o, \sigma_o^2)$, the posterior is given by:

$$ \mathbb{N}(\frac{\sigma^2_p d_o + \sigma^2_o d_p}{\sigma^2_p + \sigma^2_o}, \frac{\sigma^2_p \sigma^2_o}{\sigma^2_p + \sigma^2_o}) $$

## Propagation

Once the camera position of the next frame has been estimated the estimated inverse depth $d_0$ is propagated to that frame. The corresponding 3D point is calculated from $d_0$ and projected into the new frame, providing the initial inverse depth estimate $d_1$ in the new frame. Then, the hypothesis is assigned to the closest integer pixel position (maintaing sub-pixel accuracy to avoid discretization errors). Assuming that the camera rotation es small, $d_1$ can be approximated by:

$$ d_1(d_0) = (d_0^{−1} - t_z)^{-1}$$

where $t_z$ is the camera translation along the optical axis. The variance of $d_1$ is defined as:

$$ \sigma^2_{d_1} = J_{d_1} \sigma^2_{d_0} J^T_{d_1} + \sigma^2_{p} = (\frac{d_1}{d_0})^4 \sigma^2_{d_0} + \sigma^2_{p} $$

where $\sigma^2_{p}$ is the prediction uncertainty (the prediction step in an extended Kalman filter). It can be seen as keeping the variance on the z-coordinate of a point fixed $\sigma^2_{z_0} = \sigma^2_{z_1}$

In the case of two inverse depth hypothesis are propagated to the same pixel there are two alternatives
 1. they are fused as two independent observations of the pixel’s depth if they lie within $2\sigma$ bounds
 2. otherwise, it is assumed that the furthest point is assumed so it is removed

## Regularization

A regularization iteration is performed for each frame which computes each inverse depth value as the average of the surrounding
inverse depths, weighted by their respective variances. When two adjacent inverse depth values are statistically different (further away than $2\sigma$), they are not merged to preserve sharp edges.

The validity of each inverse depth hypothesis is represented by the probability that it is an outlier (e.g., due to occlusion or a moving object). For each successful stereo observation, this probability is decreased and increased for each failed stereo search, i.e. the respective intensity changes significantly on propagation, or when the absolute image gradient falls below a given threshold.

If the probability that all contributing neighbors are outliers rises above a given threshold, the hypothesis is removed. Equally, if the probability drops below another threshold in a pixel without hypothesis a new one is created from the neighbors. This fills holes arising from the forward-warping nature of the propagation step, and dilates the depth map to a small neighborhood around sharp edges, which significantly increases tracking and mapping robustness.

## Dense tracking

The semi-dense inverse depth map for the current camera image can be used for estimating the camera pose of the next frame. Dense tracking is preformed using dense image alignment [REF] based on the direct minimization of the photometric error:

$$ r_i(\xi) := ( I_2 (w(\mathbf{x}_i, d_i, \xi_i)) − I_1 (x_i))^2 $$

where the warp function

$$ w : \sigma_1 \times \mathbb{R} \times \mathbb{R}^6 \rightarrow \sigma_2 $$

maps each point $x_i \in \sigma_1$ in the reference image $I_1$ to the respective point $w(x_i, d_i, \xi) \in \sigma_2$ in the new image $I_2$. As input it only requires the 3D pose of the camera $\xi \in \mathbb{R}^6$ and uses the estimated inverse depth $d_i \in \mathbb{R}$ for the pixel in $I_1$. The final energy term to minimize is:

$$ E(\xi) := \sum_{i} \frac{\alpha(r_i(\xi))}{\sigma^{2}_{d_i}} r_i(\xi)$$

where $\alpha: \mathbb{R} \rightarrow \mathbb{R}$ weights each residual.
