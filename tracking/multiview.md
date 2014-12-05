# Multiple View Geometry

This section is heavily based on the contents of @hartley2003multiple.

## Epipolar geometry

The projections of a 3D point $\mathbf{x}$ over images are always related by the fundamental matrix $\mathbf{F}$.

$$ \mathbf{x'^T}\mathbf{F}\mathbf{x} = 0 $$

![](http://lfa.mobivap.uva.es/~fradelg/phd/figures/epipolar.svg "Epipolar constraints between two camera view")

Adding intrinsic parameters with $\mathbf{K}$ to the fundamental matrix gives a metric "object" such that the image points can be related by the essential matrix $\mathbf{E}$.

$$ \mathbf{\hat{x}'^T}\mathbf{E}\mathbf{\hat{x}} = 0 $$
$$ \mathbf{\hat{x}} = \mathbf{K}\mathbf{x} $$
$$ \mathbf{E} = \mathbf{K}^T\mathbf{F}\mathbf{K} $$

This matrix links the relative position of the cameras to the fundamental matrix. Camera poses can be recovered using SVD decomposition.

$$ \mathbf{E} = \mathbf{U} \mathbf{\Sigma} \mathbf{V}^T $$

where $\mathbf{U}, \mathbf{V}, \mathbf{\Sigma} \in \mathbb{R}_{3 \times 3}$. The first two matrices are orthogonal while the last one is a diagonal matrix with the diagonal entries as the singular values of $\mathbf{E}$ which, according to the internal constraints of the essential matrix, must consist of two identical and one zero value.

$$ \mathbf{\Sigma} = \begin{pmatrix} s & 0 & 0 \\ 0 & s & 0 \\ 0 & 0 & 0 \end{pmatrix} $$

By defining a helper matrix $\mathbf{W}$ as

$$ \mathbf{W} = \begin{pmatrix} 0 & -1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 1 \end{pmatrix} \rightarrow \mathbf{W}^{-1} = \mathbf{W}^T = \begin{pmatrix} 0 & 1 & 0 \\ -1 & 0 & 0 \\ 0 & 0 & 1 \end{pmatrix} $$

the rotation matrix $\mathbf{R}$ and translation vector $[\mathbf{t}]_{\times}$ can be computed as

$$ \mathbf{R} = \mathbf{U} \mathbf{W}^{-1} \mathbf{V}^{T} $$
$$ [\mathbf{t}]_{\times} = \mathbf{V} \mathbf{W} \mathbf{\Sigma} \mathbf{V}^{T} $$

In some cases an alternative formulation of the translation vector can be used if $\mathbf{\Sigma}$ does not completely fulfill the constraints of real world data:

$$ [\mathbf{t}]_{\times} = \mathbf{V} \mathbf{W}^{-1} \mathbf{V}^{T}$$

If the scene is planar ($\mathbf{T} = 0$) the points are related by a simple homography $H$ such that $\mathbf{x}'=\mathbf{H}\mathbf{x}$.

## Triangulation

The triangulation problem consists of computing the 3D point $\mathbf{X}$ from two point $\mathbf{x}, \mathbf{x}'$ and the camera projection $\mathbf{P}, \mathbf{P}'$ from two different views. The problem is that in the presence of noise back projected rays do not intersect. There are different solutions according to @hartley1997triangulation

![](http://lfa.mobivap.uva.es/~fradelg/phd/figures/triangulation.svg "The triangulation problem")

- Compute the mid-point of the shortest line between the two projection rays using vector
- Compute the **linear** triangulation using linear algebra, where $X$ can be solved up to scale. However the value being minimized has no geometric meaning and multiplying the equations by some weights will change the solution. The **iterative** approach reweights the linear equations adaptively so that this equations correspond to errors in point coordinates. The main advantage of these methods is that they are easy to implement but convergence is not always guaranteed. The iterations can be applied over two different linear methods:
    * **Eigen**: find $\mathbf{x}$ which minimize $||Ax||, ||x|| = 1$. The solution is the unit eigenvector corresponding to the smallest eigenvector of the matrix $A^TA$ computed using SVD.
    * **Least-Squares**: representing $x = (x, y, z, 1)$ the set of homogeneous equations $\mathbf{A}\mathbf{x} = 0$ can be reduced to 4 non-homogeneous equations in 3 unknowns. SVD or pseudo-inverses can be used to solve this problem.
- Minimizing a statistical error (optimization): the aim is to estimate a $\mathbf{\hat{X}}$ from $\mathbf{x}$, \mathbf{x}'$ which minimizes the reprojection error using $d$ as the euclidean distance between two points.

$$ C(\mathbf{x}, \mathbf{x}') = d(\mathbf{x}, \hat{\mathbf{x_i}})^2 + d(\mathbf{x}', \hat{\mathbf{x_i}'})^2 $$

Even when minimization appears to be over the three parameters of $\mathbf{X}$, it can be reduced to just a single parameter.

### Direct Linear Transform

Triangulation can be applied from two to $n$ views so that there are more equations to overdetermine the linear system. In such case, the Direct Linear Transform (DLT) algorithm can be applied:

![](http://lfa.mobivap.uva.es/~fradelg/phd/figures/triangulation-n.svg "Triangulation of a point seen from multiple views")

1. For each correspondence $(\mathbf{x},\mathbf{x}')$ build matrix $\mathbf{A}_i$ with at least the first two rows
2. Join $2n \times 9$ matrices $\mathbf{A}_i$ into a single $\mathbf{A}$
3. Compute the $SVD(\mathbf{A})$
4. The solution for $\mathbf{h}$ is the last column of $V$
5. Determine $\mathbf{H}$ from $\mathbf{h}$

In order to guaranteed method stability since DLT is not invariant, it is recommended to normalize coordinates in both images independently before applying DLT and denormalize after.

1. Translate centroid to the origin
2. Scale to a $\sqrt{2}$ average distance to the origin

The resulting matrix to apply will be:

$$ \mathbf{T}_{norm} = \left[ \begin{matrix} w \times h & 0 & w/2 \\ 0 & w \times h & h/2 \\ 0 & 0 & 1 \end{matrix} \right]$$
