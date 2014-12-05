# Markov Random Fields

Markov Random Fields (MRF) are a tool for modeling image data which coupled with a set of recently developed algorithms, as a means of making inferences about images. They allows to solve problems related with image and scene structure such as:

* image reconstruction
* image segmentation
* object and region labeling

Each MRF has a graph representing the probabilistic conditional dependencies between hidden variables and states represented by the nodes. Graphs structures used in vision problems are predominantly gridlike, but can also be irregular, even using superpixels (cluster of adjacent pixels with similar color).

## Markov Chains

A Markov chain is composed by a sequence of random variables $\mathbf{X}=(X_1, X_2,...)$ linked to a joint distribution specified by the conditionals $P(X_i|X_{i-1},X_{i-2},...,X_1)$. In the simplest form of a Markov chain we make a first order Markov assumption $P(X_i|X_{i-1},X_{i-2},...,X_1) = P(X_i|X_{i-1})$. Thus, the set of conditional probabilities can be represented only with a $N \times N$ matrix, where $N$ is the total number of possible values for $X$

The stationary Markov chain implies that the matrix

$$M_i(x,x') = P(X_i = x | X_{i−1} = x')$$

is independent of time $i$ such that $M_i=M_{i-1}$.

Just two considerations about the Markov chains:

* The first-order explicit structure implicitly carries longer-range dependencies
$$P(X_i=x | X_{i-2}=x) = \sum_{x' \in L}{M_i(x, x')M_{i−1}(x', x'')}$$
* The joint density is a product of conditional densities which can be expressed in a directed or undirected form:
$$P(\mathbf{x}) = P(x_N | x_{N-1})...P(x_i | x_{i-1})...P(x_2 | x_1)P(x_1)$$
$$P(\mathbf{x}) = \Phi_{N,N-1}(x_N | x_{N-1})...\Phi_{i,i-1}(x_i | x_{i-1})...\Phi_{2,1}(x_2 | x_1)$$

The last one (undirected form) is a more natural way of expressing probabilistic models used in computer vision.

## Hidden Markov Models (HMM)

Markov models can be used to represent state variables $X_i$ inferred from observations $z_i$ which instantiates a random variable $Z$. The posterior distribution for the possible states $X$ given observations $z$ is computed using Bayes's formula

$$P(x|z) \propto P(z|x)P(x)$$

where $P(X|x)$ represent the prior distribution over states (i.e. what is known about states $X$ in the absence of any observation)

The term $P(z|x)$ is the likelihood of the observations, which is essentially a measure of the quality of the measurements. It is often assumed that observations are independent across the different sites.
