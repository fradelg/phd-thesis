# Depht Map Fusion

The fusion of multiple depth maps with noise and outliers allows to reconstruct the 3D surface from a set of range images (acquired by active or passive sensors) to create virtual models of real objects or environments. The generation of high quality, dense geometric models from a sparse or semi-dense set of given 3D points often requires a volumetric representation as the underlying data structure (Voronoi cells, regular grids or level sets).

Early range image fusion methods incorporating a regular voxel space based on the from from @curless1996volumetric. This method initially computes a signed distance function (SDF) for the final surface by averaging the distance fields from the range images. The reconstructed mesh is obtained by an isosurface polygonization method of the function's zero level set using the method proposed by @bloomenthal1994polygonizer. The merged distance field is computed separately on voxels, which allows those methods to be efficient, but spatial coherence and smoothness of the resulting mesh cannot be enforced.

There are other methods to reconstruct an object surface from only image data from passive sensors. An important group of methods estimates the object surface using a consistency score for voxels (a photo-consistency measure). Other group of approaches generate intermediate depth maps from small-baseline stereo in the first instance and use multiple depth images to perform a final surface integration step. In some cases the initial depth maps can be cleaned by fusing information from neighboring views.

The method proposed in @zach2008fast is a robust approach based on total variation shape denoising using a set of depth maps with noise and outliers. Each depth map contains a 2.5D geometry of the scene which can be converted to a truncated signed distance field $f_i : \Omega \rightarrow \mathbb{R}$ (\Omega is a voxel space). The true distances are approximated using a simple Z comparison.

It uses a total variation framework in which the distance based fidelity term is replaced by an histogram based one, allowing optimal GPU acceleration. In this framework, the implicit representation of the final surface is computed as the spatially regularized median of the provided 3D distance transforms, i.e. minimizing a convex TV-L1 energy functional composed by a total variation term $\int|\nabla u| d\vec{x} = \int ||\nabla u||_2 d\vec{x}$ (the regularization term), and a $L^1$ distance (the data fidelity term) $\sum_i{|u−f_i|}$ which measure the distance of the solution to the individual distance fields $f_i$. Thus, the energy functional to minimize with respect to $u$ for the given set of distance transforms $f_i$ is the following one

$$ E(u) = \int_{\Omega}{ \{ |\nabla u| + \lambda \sum_{i}{|u - f_i|} \} d\vec{x}} $$

The resulting function $u : \Omega \rightarrow \mathbb{R}$ is the final signed distance to the fused model such that the surface can be computed using any surface polygonalization method (marching cubes, e.g.)

The data term can be efficiently computed by weighting the frequency $n_i$ for the bin $i$ to evenly spaced discrete values $c_i$ as $\sum_i{n_i|u-c_i|}$ in the histogram of each voxel, i.e. how often the value $c_i$ occurred in the distance field $f_i$ of the current voxel. The expensive generalized thresholding step is performed using a simple and fast descent step.

Another approach to minimize the functional is to use the first-order primal-dual algorithm from @chambolle2011first which minimize without performing any approximation. The algorithm performs a gradient descent step in the $u$ variable while performing a gradient ascent steps in the dual variable $p: \Omega \rightarrow \mathbb{R}^3$

$$ max_{||p||_{\infty} < 1} = \{ - \int_{\Omega} u\,div\,p + \lambda \sum_{i}{\int_{\Omega}n_i|u(x) - c_i|d\vec{x}} \} $$

In each step, the algorithm estimates the new value of $u$ and $p$ using the following equations

$$ u^{n+1} = prox_{hist}(u^n - \tau(-div\,p^n)) $$

$$ p^{n+1} = proj_{||p||_\infty \leq 1}(p^n + \sigma\nabla(2u^{n+1}-u^n)) $$

where $\tau,\sigma > 0$ are the primal and dual steps respectively.

The function $proj$ defines a point-wise projection of the dual variable onto the unit ball. The projection of a vector $q_x$ at a position $x$ is defined as

$$ proj_{||p||_\infty \leq 1}(q_x) = \frac{q_x}{max(1, ||q_x||)} $$

The function $prox$ is the proximal operator whose solution is obtained minimizing a quadratic distance term plus the histogram term. Thus, the definition of the proximal operator for a number $v_x$ at a point $x$ is defined as

$$ prox_{hist}(v_x) =  arg\,min_u \{ \frac{||u-v_x||^2}{2\tau} + \lambda \sum_{i}{n_i|u - f_i|} \}$$

It is known that the global minimizer can be computed via a generalized shrinkage formula given by computing the median by sorting a sequence of 2N + 1 elements

$$ prox_{hist}(v) = median(d_1,..., d_N, p_0,...,p_N) $$

where $d_i$ are the distances related to the according histogram bin $i$ and $p_i$ are computed as follows

$$ p_i = v - \tau \lambda W_i, \; W_i = -\sum_{j=1}^i n_j + \sum_{j=i+1}^n n_j $$

### References
