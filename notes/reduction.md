# Group Linearization

An application $f: \mathbb{R}^{n} \rightarrow \mathbb{R}^{p}$ can be linearized by means of a group reduction applied over the fiber bundles. The same can be extended to fibrations. This premise is based on the following **proposition**: 

----------

If there exists an euclidean metric over a manifold $M$, there exists a group reduction from the general linear group $GL(n, \mathbb{R})$ to the special orthogonal group $SO(n)$

----------
 
This result can be intuitively understood using two different arguments:

 1. If the metric exists then each arbitrary reference can be ortho-normalized (Gram-Schmid) so that the acting group was $SO(n)$
 2. Every regular matrix can be decomposed as the product of a symmetric matrix and a special orthogonal matrix. Since the set of all symmetric matrices is a vector space and a vector space can be contracted in a point, thus the general linear group of regular matrices can be contracted to $SO(n)$. This approach introduces the main advantage that this kind of polar decomposition is valid for other groups (Iwasawa theorem)

## Euclidean reconstruction 

Over the domain and codamin of $f: \mathbb{R}^{n} \rightarrow \mathbb{R}^{p}$ acts the homeomorphism product which do not alter the domain $Homeom(\mathbb{R}^{n}) \times Homeom(\mathbb{R}^{p})$ denoted with $\mathcal{A} = \mathcal{R}\times \mathcal{L}$ where $R$ is right and $L$ is left. The action over the application set is described by

$$(h, k)*f mapsto k\circ f\circ h^{-1}$$ 

for every $(h, k)\in \mathcal{A}$. This action represents the synchronous variation in the scene (3D) and the image (2D) proyected over the camera plane.
 
## Linearization
 
The linearization of the $\mathcal{A}$-action gives a differential application $dk \circ df \circ (dh)^{-1}$ which is the composition of three linear applications represented by its Jacobian matrix. The differential of an homeomorphism which maintains the origin is an element of the linear general group. Thus, $dk$ y $dh$ are elements of the same group. Each matrix can be reduced to elements of $SO$ using the euclidean metric for 3D reconstruction. This provides a mathematical framework for the point of view detailed by @tomasi1992shape

## Affine

The above explanation can be extended to the affine case taking into account that the translation vector added to the previous argument has zero differential. It is equivalent to the isomorphism between the homeomorphism groups which do not alter the origin and the groups which do not alter a point $x\in \mathbb{R}^{n}$ or a point $y\in \mathbb{R}^{p}$. 

## Contribution

The previous arguments can be extended using **gauge groups** acting over the fibers of a **fibration** when the structure is not as simple as a vectorial fiber bundle. Then, we can explains facts such as:

 - What happens when $f$ is deformed?
 - What happens when the fibers (vectors of image features) are continuos manifolds?

The main idea is to recreate the same steps over fibrations instead of constrained to fiber bundles. Working into groups is very difficult, so it is advisable their linearization and build the same results over the linked Lie Algebras which parametrize the linearization of deformations. The problem is these algebras have $\infty$ dimension but there are some "tricks" to solve it such as the use of nilpotent matrices (square matrix $N$ such that $N^k = 0$ for some positive integer $k$ and the subsequent $j > k$) or the reduction of the degree of the objects (in this case functions or transformations).