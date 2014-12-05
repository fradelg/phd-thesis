# Regularization using Total Variation

The total variation measures the change of the image of a function in the codomain. It controls both the size of jumps and the geometry of boundaries. Then,  the minimization of the total variation for a modified image makes this image closer to the original at the same time it removes unwanted detail smoothing away noise in flat regions, even at low signal-to-noise ratios,  whilst preserving geometric details such as edges.

$$ TV(u)= \sum_{i=0}^{n} | u(x_{i+1}) - u(x_i) | $$

If $u$ is monotonic in $[a,b]$, then $TV(u) = |u(b) - u(a)|$. For $n > 1$ variables, then the total variation of $u$ in the open interval $\Omega \in \mathbb{R}^n$ is

$$ TV(u)= \int_\Omega |\nabla u(x)| \mathrm{d}x $$

Total variation can be used as the regularization term in the following variational model proposed by @rudin1992nonlinear:

$$ \min_{u}{E(u)} =\alpha TV(u) + \frac{1}{2}||Ku - z||^2$$

where the first term (regularization) is controlled by a regularization parameter $\lambda$ which measures how much the resulting function $u$ looks like the input function in the optimization process. The second term (data fidelity) measures the distance between the function $u$ and its approximation using some kind of normalized distance such as L1 and L2. By differentiating this functional with respect to $u$, we can derive a corresponding Euler-Lagrange equation, that can be numerically integrated using the original signal $f$ as initial condition. So depending the use of L1 and L2 norm, the problem consists of minimizing the following energy functionals:

$$E_1(u, \lambda) := \int_D |\nabla u(x)| + \lambda \int_D |u-f| \mathrm{d}x$$

$$E_2(u, \lambda) := \int_D |\nabla u(x)| + \lambda \int_D (u-f)^2 \mathrm{d}x$$

where the image $f$ can be modeled as the optimized image $u$ convoluted with a kernel $K$ representing the point spread function of the optical system, and adding a white noise $n$.

$$f := K * u + n$$

For $E_2$ the model is convex with a unique global minimizer but the same is not true for $E_1$. However the TV-L1 model introduces some surprising and useful features such as:

 - Contrast preservation
 - Data driven scale detection
 - Cleaner multiscale decompositions
 - Intrinsic geometric properties which provide a way to solve non-convex shape optimization problems via convex optimization methods

In the discrete version of the method, the total variation norm can be an isotropic function and not differentiable, such as the following one

$$TV(u) = \sum_{i,j} \sqrt{|u_{i+1,j} - u_{i,j}|^2 + |u_{i,j+1} - u_{i,j}|^2 }$$

or an anisotropic version of the same function which it may sometimes be easier to minimize, such as the following one

$$TV(u) = \sum_{i,j} |u_{i+1,j} - u_{i,j}| + |u_{i,j+1} - u_{i,j}| $$

The same minimization strategy can be used to solve several kind of problems such as volumetric surface adjustment, image denoising and image restoration.

# References
