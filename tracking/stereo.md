# Depth Map Estimation

A depth map is an image representing the depth of each pixel instead of the RGB intensity as usual. Pixel depth can be estimated using several approaches taking into account the capturing device and the kind of available data. In our approach we can estimate depth based on **stereo matching** across the current frame and a previous key frame. Only those key frames introducing a good number of overlapping features and a significant baseline will be selected.

Stereo matching consists of finding corresponding pixels between two images $I$, $I'$ taken from two different viewpoints with lens distortions removed. Here, the goal is to locate two pixels (one for each image) from the same physical object which gives a depth value for each pixel $i = (u, v) \in I$ that has minimal costs $C$ among all possible depth values $d \in D$

$$d_i = argmin_{d \in D}{C(i, d)}$$

The cost function is based on the ZNCC (Zero-mean Normalized Cross Correlation) over image patches. Let $I_p$ be a square patch in image $I$ centered at pixel $p$ and $I'_p$ the projection of this patch into image $I'$ according to depth $d$:

$$I'_p(i) = I'(\pi(KM\pi^{−1}(i, d))) \, \forall{i} \in I_p$$

where $K$ is the intrinsic matrix of the camera, $M$ describes the relative motion between the two cameras, function $\pi^{-1}(i,d) = dK^{−1}i$ converts pixel $i$ into a 3D scene point $x$ according to depth $d$. Then $C$ is given by

$$ C(i, d) = −\sum_{j \in I_p}{\frac{(I_p(j) − \overline{I_p})·(I'_p(j) − \overline{I'_p})}{\sigma(I_p)·σ(I'_p)}}$$

where $I_p(j)$ returns the intensity value in patch $I_p$ at pixel $j$, $\overline{I_p}$ is the mean and $\sigma(I_p)$ the standard deviation in the pixel intensities in patch $I_p$.

The evaluation of the cost equation in high-resolution images with high depth precision is prohibitively expensive. However, the optimization proposed by @bleyer2011patchmatch introduces a runtime independent of the number of depth values. The algorithm is bases on a cycle of random depth generation combined with depth propagation. The main drawback is that the performance of the algorithm depends on the correlation window size and the number of iterations performed over the image.

Stereo algorithms can be divided into two main categories:

- **Global** strategies formulate an energy function which will be minimized taking all image pixels into account. However, the optimization techniques to minimize the function are too slow for real-time applications. Approximate global optimization methods based on dynamic programming [@michael2013real] gives reasonable frame rates but they are restricted to low-resolution images working on a strongly quantized depth range.

- **Local** stereo algorithms search corresponding pixels evaluating the correlation between local image patches. The correlation function to evaluate the quality of the correspondence can be viewed as a filter. For instance, the sum of absolute differences (SAD) corresponds to a simple box filter, which can be easily parallelized as in @gallup2009cuda. Most recent approaches weight each pixel in the mask filter based on image edges, e.g. based on bilateral filtering [@yang2013bilateral] or guided image filtering [@hosni2013fast]. However, these approaches only show good performance for a low number of depth values giving a low depth precision.

![kinectfusion](http://lfa.mobivap.uva.es/~fradelg/phd/figures/stereo-face.png "Block Matching Stereo over two short baseline frames")

## References