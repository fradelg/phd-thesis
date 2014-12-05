# Lie algebra and Lie groups

A **lie group**  $G$ is a group with a smooth and differential structure. Its associated **Lie algebra** $\mathfrak{g} := T_{p}G$ is a vector space that represents the tangent space of the group at a point $p \in G$. This tangent space provides a linearization of the Lie group when $p = I$, maintaining most of its properties.

The special orthogonal Lie group called $SO(3)$ represents all rotations about the origin of the three-dimensional euclidean space $\mathbb{R}^3$. It is given as the set of all orthogonal matrices with unit determinant, i.e.

$$ A \in SO(3) \iff AA^T = I, \quad det(A) = 1$$

It is also a subgroup of the general linear group $GL(3)$ of regular matrices. Its Lie algebra $\mathfrak{so}(3)$ is given by all skew-symmetric $3 \times 3$ matrices with the **commutator operator** defined as

$$ [A,B] = AB - BA $$

The commutator is skew-symmetric $[A,B]  = - [B, A] $ and verifies the Jacobi identity:

$$[[A,B], C] + [[B, C], A] + [[C,A], B] = 0$$

which characterize an abstract Lie algebra structure.

The link between a Lie group and its Lie algebra is the **exponential map** $exp$ and its inverse $exp^{-1} = log$. They allow us to switch between the vector space generated by the Lie algebra and the Lie group. It can be defined for all groups $G \subset GL(n, \mathbb{R})$ where $GL(n, \mathbb{R})$ is the group of $n \times n$ real invertible matrices.

$$exp(A) = \sum_{k \ge 0}{\frac{A^k}{k!}}$$

## 3D rigid body transformations

A basic requirement of the tracking system is that the projection equation must be differentiable with respect to changes in camera pose. Changes to camera pose are represented by left-multiplication with a camera motion $M \in \mathbb{R}^{4 \times 4}$ given by

$$ M_i = M M_{i-1} = exp(\mu) M_{i-1} $$

where the camera motion is an element of $SE(3)$, the Lie group of rigid transformations in $\mathbb{R}^3$ whose tangent space is represented by the Lie algebra $\mathfrak{se}(3)$. It is important to note that $\mathfrak{se}(3)$ is isomorphic with $\mathbb{R}^6$ such that there exists a map that transforms between both spaces. Thus, this algebra can be parametrized by a vector $\mu = (\omega, \upsilon) \in \mathbb{R}^6$  where $\upsilon \in \mathbb{R}^3$ represent a translation, whereas $\omega \in \mathbb{R}^3$ represent a rotation axis and a rotation angle $\omega$ with its magnitude. These properties allow to enforce all the constraints of $SE(3)$ while keeping the optimization procedures simple on the vector space of $\mathfrak{se}(3) \approx \mathbb{R}^6$

There are simpler ways to compute the exponential map for some groups such as $SO(3)$ and $SE(3)$. Using an adaptation of the original Rodrigues formula we can define the exponential map of $SE(3)$ for a matrix $S$ parametrized by $\mu$

$$exp: \mathfrak{se}(3) \rightarrow SE(3)$$

$$exp(S) = I_4 + S + \frac{(1-\cos \theta)S^2}{\theta^2} + \frac{(1-\sin \theta)S^3}{\theta^3}$$

$$ S = \left[\begin{array}{cccc}
0 & -\omega_z & \omega_y & \upsilon_x \\
\omega_z & 0 & -\omega_x & \upsilon_y \\
-\omega_y & \omega_x & 0 & \upsilon_z \\
0 & 0 & 0 & 0 \\
\end{array} \right] $$

$$\theta = || \omega ||$$

The camera motion parameters in $\mu$ are estimated from a bunch of image measurements using the Weighted Least Squares method with a M-estimator. This method provides a robust estimation of a sigma-squared for all the measurements to reduce the outliers influence. After this optimization, the exponentiation over a vector in $SE(3)$ generates the matrix to update the current pose of the camera.

## Weighted Least Squares (WLS)

A Lie group formalism allows to cast the motion computation problem into simple geometric terms so that it becomes an optimization problem. The pose update is computed iteratively by minimizing a robust objective function based on the reprojection error. This optimization can be solved using the iterative WLS algorithm in which an estimator is used for re-weighting $w_i$ on each iteration, such as the Tukey biweight objective function used by @klein2007parallel.

$$ \hat{\boldsymbol{\beta}} = \underset{\mathbf{\beta}} {\operatorname{arg\,min} }\, \sum_{i=1}^{m} w_i \left|y_i - \sum_{j=1}^{n} X_{ij}\beta_j\right|^2 = \underset{\boldsymbol \beta}{ \operatorname{arg\,min} } \, \big\|W^{1/2} (\mathbf y - X \boldsymbol \beta) \big\|^2 $$

which can also be represented in its matrix form

$$ \left(X^{\rm T} W X \right)\hat{\boldsymbol{\beta}} = X^{\rm T} W \mathbf y $$

So, it can be considered as a fixed point by the product application. This interpretation can be reformulated as an equilibrium vector of a dynamical system defined on the space of matrices, i.e., a local minimum for an optimization problem.

## Parameterization of rotations

A rotation vector is an appropriate and more compact representation of a rotation matrix (any rotation matrix has just 3 degrees of freedom). Then, it can be represented using only 4 parameters: a rotation vector $\mathbf{v}, \mathbf{k} \in \mathbb{R}^3, |\mathbf{k}| = 1$ describing the rotation axis and a rotation angle $\theta$ according to the right hand rule. The Rodrigues formula allows to define the rotation vector [@corrochano2001geometric]

$$ \mathbf{v}_\mathrm{rot} = \mathbf{v} \cos\theta + (\mathbf{k} \times \mathbf{v})\sin\theta + \mathbf{k} (\mathbf{k} \cdot \mathbf{v}) (1 - \cos\theta) $$

which can be expressed in matrix terms

$$ \mathbf{R} = e^{\mathbf{K}\theta} = \mathbf{I} +  \mathbf{K} \sin{ \theta} +  \mathbf{K}^2 [1 - \cos{\theta}] $$

where $\mathbf{K}$ is the skew-symmetrical matrix of the unit rotation vector $k$

$$ \mathbf{K} = \left[ \begin{matrix} 0 & -k_x & k_y \\ k_x & 0 & -k_z \\ -k_y & k_z & 0 \end{matrix} \right] $$

The **exponential map** operation ($exp$) allows to convert a Lie algebra $\mathfrak{g}$ to a Lie group $G$. For elementary (not composed) rotations, it transfors an axis-angle representation of rotations to a $3 \times 3$ rotation matrix.

$$ \exp\colon \mathfrak{so}(3) \to \mathrm{SO}(3) $$

Thus, the unit vector $\omega$ and the angle $\theta$ are sometimes called the exponential coordinate of the elementary rotation matrix $\mathbf{R}$. A more "compact" representation of Rodrigues notation can be achieved in $v \in \mathbb{R}^3$ [OpenCV]. The rotation angle $\theta$ is represented as the module of the vector $v$ while the rotation axis is the normalized vector $v/|v|$. Rodrigues and Euler representation of rotations are related but they have singularities and other problems when representing rotations at 180 degrees.

## Euclidean transformations

An Euclidean transformation $E$ is composed by a composition of rotations and translations in the three-dimensional space.  This can be represented using a $3\times4$ matrix operating on homogeneous coordinates, so that a vector $\mathbf{x}$ is transformed to a new location $\mathbf{x}'$ by $ \mathbf{x}' = E \mathbf{x}$

$$ \begin{bmatrix}x'\\y'\\z'\end{bmatrix} = \begin{pmatrix}r_{11} & r_{12} & r_{13} & t_1\\r_{21} & r_{22} & r_{23} & t_2\\r_{31} & r_{32} & r_{33} & t_3\end{pmatrix}\begin{bmatrix}x\\y\\z\\1\end{bmatrix} $$

This is a 3D rigid body transformation which is a member of the Special Euclidean Lie group $SE(3)$. This group can be parameterised in $\mathbb{R}^3$ by the vector space which supports the Lie Algebra $ \mathfrak{se}(3)$ . Usually, the first three parameters are a translation vector while the second three are a rotation vector, whose direction is the axis of rotation and length the "amount" of rotation (in radians), as for $SO(3)$