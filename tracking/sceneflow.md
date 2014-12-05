
# Scene Flow

The optical flow introduces a tow-dimensional motion field over the image plane. It is the projection of a three-dimensional motion in the world which, in a non-rigid scene, can be represented as a dense 3D vector field for every point in the scene. This concept was defined by the term "scene flow" by @vedula1999sceneflow.

Let $f(x,y,z;t) = 0$ a non-rigidly moving surface captured with a single camera with a projection matrix $\mathbf{P}_i$ and the image sequence $I_i = I_i(u_i, v_i; t)$ captured by the camera. Then, the relation between a point on the surface $\mathbf{x} = (x,y,z)$ and its image coordinates $\mathbf{u}_i = (u_i, v_i)$ is given by:

$$ \mathbf{u}_i = \mathbf{P}_i \mathbf{x}$$

The differential relationship between $x$ and $u_i$is represented by the Jacobian matrix $J = \frac{\partial \mathbf{u}_i}{\partial \mathbf{x}}$ where each column stores the differential change in the image coordinates per unit change in $x$, $y$ and $z$. Thus, Jacobian relates small changes in points on the surface and its projection in the $i$-th image

$$\triangle \mathbf{u}_i = J_i \triangle \mathbf{x}$$

The *plenoptic function* $E := E(\mathbf{m};\mathbf{x};t)$ represents the irradiance or illumination flux measured at the position $\mathbf{x}$ in the direction $\mathbf{m}$ at time $t$. The net directional irradiance of light $s$ is defined as the surface integral of the irradiance $E$ over the visible hemisphere of all possible directions from which light can fall on a surface patch with a surface normal $\mathbf{n}$

$$s(\mathbf{x};t) := \int_{S(n)} E(\mathbf{x};\mathbf{m}; t)d\mathbf{m}$$

$$S(\mathbf{n}):=\{\mathbf{m} : ||\mathbf{m}||=1, \mathbf{m}·\mathbf{n} \leq 0\}$$

Assuming that the surface is Lambertian with albedo $\rho := \rho(\mathbf{x};t)$ and that the intensity registereng in the $i$-th image $I_i$ is proportional to the radiance of the point $\mathbf{x}$ then

$$I_i(\mathbf{u}_i;t) = -C·\rho(\mathbf{x};t)[\mathbf{n}(\mathbf{x};t)·\mathbf{s}(\mathbf{x};t)])$$

where $C$ depends upon the diameter of the lens and the distance between the lens and the image plane.

## Optical Flow

Suppose that the 2D path of a point over the image of the $$i-th$$ camera is $$\mathbf{u}_i(t)$$, the optical flow is $$\frac{d\mathbf{u}_i}{dt}$$

Assuming that the point $$\mathbf{x}(t)$$ moves on the surface, this albedo remains constant such that 

$$ \frac{d\rho}{dt} = 0 $$

The following equation is the basis for optical flow computation in algorithms

$$ \frac{dI_i}{dt} = \nabla I_i · \frac{d\mathbf{u}_i}{dt} + \frac{\partial I_i}{\partial t} = -C · \rho(\mathbf{x};t)\frac{d}{dt}[\mathbf{n}·\mathbf{s}]$$

where $\nabla I_i$ is the spatial gradient of the image and $\frac{\partial I_i}{\partial t}$ is the rate of change of the image intensity.

It is assumed that the $\mathbf{n}·\mathbf{s}$ term is constant to avoid explicit dependence upon the structure of the three-dimensional scene. This term depends both the shape and the illumination of the surface such that the assumption is true at least for surfaces with uniform illumination or with an almost constant normal. Then, with $\frac{dI_i}{dt} = 0$ we have the *Normal Flow* or *Gradient Constraint Equation* used by differential optical flow algorithms to estimate $\frac{d\mathbf{u}_i}{dt}$

$$ \nabla I_i · \frac{d\mathbf{u}_i}{dt} + \frac{\partial I_i}{\partial t} = 0 $$

## Scene Flow

It is the three-dimensional flow field $\frac{d\mathbf{x}}{dt}$ describing the motion for each point of the scene. If the camera is not moving, the variations in $\mathbf{u}_i$ are determined by changes in $\mathbf{x}$

$$ \frac{d\mathbf{u}_i}{dt} = \frac{\partial \mathbf{u}_i}{\partial \mathbf{x}} \frac{d\mathbf{x}}{dt} $$

This relationship cannot be inverted without prior knowledge about the surface $f$. Beasides, we need to take into account that $\mathbf{x}$ depends not only on $\mathbf{u}_i$ but also in the time $t$ that affects the surface $f=f(\mathbf{x};t)$. Then, $\mathbf{x} = \mathbf{x}(\mathbf{u}_i(t);t)$ and differentiationg this expression with respect to time $t$ we have

$$ \left. \frac{d\mathbf{x}}{dt} = \frac{\partial \mathbf{x}}{\partial \mathbf{u}_i} \frac{d\mathbf{u}_i}{dt} + \frac{\partial \mathbf{x}}{\partial t} \right |_{\mathbf{u}_i} $$

There are two components which contribute to the motion of the point $\mathbf{x}$:

- The projection of the scene flow on the plane tangent to the surface taking the optical flow backprojected into the scene using the inverse Jacobian.
- The three-dimensional motion of the point in the scene projected in a fixed pixel which is the instantaneous motion of $\mathbf{x}$ along the ray to $\mathbf{u}_i$ such that the value is proportional to the rate of change of the depth of the surface along the ray.

Taking into account what is known about the scene at each instant, there are three different ways to compute the scene flow:

1. The structure of the scene is known at every second including surface normals, depth maps and their rate of change.
2. Only stereo correspondences are known such that the depth maps can be obtained.
3. The structure of the scene is completely unknown.

In each case, a different strategy should be used to estimate the scene flow. The less information from scene structure we have, the more optical flows must be used due to degeneration in linear equations used to compute the scene flow.

### References
