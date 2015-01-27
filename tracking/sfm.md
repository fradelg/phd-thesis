# Structure from Motion (SfM)

SfM consists of estimating 3D structures from 2D image sequences. In a first step it is mandatory to find correspondences between images using features such as corner points, which must be tracked from one image to the next. These trajectories are used to refine the position of world points and the camera's motion at the same time.

## Kernel concept

A kernel is an association between three elements:

1. the data points used for a robust estimation problem
2. a model solver / estimator, parametrized by
    - the minimal number of points for the model estimation
    - the maximum number of models that the solver can return
3. a metric to measure the residual error, i.e. the quality of the fitting for a sample data with regard to the reference model

## Reprojection error

The reprojection error was defined by @hartley2003multiple. It is the geometric error computed as the distance between a projected point and the real point over an image. It is used to quantify how closely an estimate of a 3D point $\hat{\mathbf{x}}$ recreates the point's true projection $\mathbf{x}$:

$$ d(\mathbf{x_i}, \hat{\mathbf{x_i}}) $$

The function $d$ can vary according to the application. For instance, in multiview stereo applications the problem consists of seeking a homography $\hat{H}$ given a set of pairs of perfectly matched points $\hat{x}_i$ and $\hat{x}'_i$ that minimizes the total error function:

$$ \sum{i}{d(\mathbf{x_i}, \hat{\mathbf{x_i}})^2 + d(\mathbf{x'_i}, \hat{\mathbf{x'_i}})^2} $$

## Five-point relative orientation algorithm

This algorithm uses only five point correspondences between two calibrated views to estimate the relative camera pose. It gives up to ten real solutions (candidates) which must be filtered. Only the solutions whose 3D point cloud is in front of the camera and not rotated are chosen. This is termed as the check of the cheirality of a 3D point with respect to the camera, which is defined as the property of a point that specifies that it lies in front or behind a given camera.

There are two basic estimators for the essential matrix $\mathbf{E}$:

- Based on linear algebra from @nister2004efficient, implemented by [OpenCV](https://github.com/Itseez/opencv/blob/master/modules/calib3d/src/five-point.cpp) and [libmv](https://github.com/keir/libmv/blob/master/src/libmv/multiview/five_point.cc). This algorithm computes the coefficients of a tenth degree polynomial in closed form to find its roots.
- Based on an algebraic geometry framework (easier to understand) from @stewenius2006fivepoint. It has been implemented by its author in Matlab, and ported to C++ in libmv and [openMVG](https://github.com/openMVG/openMVG/blob/master/src/openMVG/multiview/solver_essential_five_point.hpp). It handles planar and non-planar cases, and it is numerically more stable than the previous one.

Fortunately, OpenCV and libmv are both based on the same Linear Algebra library (Eigen3) so it is not too difficult to achieve interoperability between them.

## Bundle adjustment

Bundle adjustment is an optimization procedure that refines an initial camera and structure parameter estimations for finding the values that most accurately predict the locations of the observed points in the set of available images. The problem is stated as:

- A set of $n$ 3D points projected in $m$ views
- $\mathbf{x}_{ij}$ is the point $p_i$ projected on image $I_j$
- $v_{ij} = \begin{cases} 1 & p_i \in I_j \\ 0 & otherwise \end{cases}$
- Each camera $j$ is parameterized by a vector $\mathbf{a}_j$ and each 3D point $i$ by a vector $\mathbf{b}_i$

Bundle adjustment minimizes the total reprojection error with respect to all 3D point and camera parameters:

$$ \min_{\mathbf{a}_j, \, \mathbf{b}_i} \displaystyle\sum_{i=1}^{n} \; \displaystyle\sum_{j=1}^{m} \; v_{ij} \, d(\mathbf{Q}(\mathbf{a}_j, \, \mathbf{b}_i), \; \mathbf{x}_{ij})^2 $$

where $\mathbf{Q}(\mathbf{a}_j, \mathbf{b}_i)$ is the predicted projection of $p_i$ on $I_j$ and $d(\mathbf{x}, \mathbf{y})$ denotes the Euclidean distance between the image points $\mathbf{x}$ and $\mathbf{y}$.

## Levenberg - Marquardt algorithm

The Levenberg–Marquardt algorithm (LMA) solves the non-linear least squares (NLLS) problem. It interpolates between the Gauss–Newton algorithm and the method of gradient descent. The LMA is more robust than the Gauss-Newton finding a local minimum (not global) even if it starts very far off the minimum. However, it tends to be slower than the Gauss-Newton depending on the starting parameters. LMA can also be viewed as Gauss Newton using a trust region approach.

It is applied to solve curve fitting problems such as: given a set of $m$ empirical datum pairs of independent and dependent variables $(x_i, y_i)$, optimize the parameters $\beta$ of the model curve $f(x, \boldsymbol \beta)$ so that the sum of the squares of the deviations becomes minimal.

$$ S(\boldsymbol \beta) = \sum_{i=1}^m [y_i - f(x_i, \ \boldsymbol \beta) ]^2 $$

### References
