# Introduction to the general framework

Linearization is the key to design a feedback strategy between recognition and reconstruction problems. Linearization is a way of approximating a function at a given point using a linear representation of the function. Fibrations allow to integrate the linearization of transformations and functions defined over objects and the linearization of functionals defined over procedures.

## Recognition

In this framework, features can be represented as the elements of a fiber bundle 

$$ \pi : \mathbf{B} \times \mathbf{F} \rightarrow \mathbf{B}$$

1. **Feature detectors** outputs are represented in the base space $\mathbf{B}$ of the fiber bundle
2. **Feature descriptors** are represented as the fiber $\mathbf{F}$ of the fiber bundle, which can be a vectorial fiber bundle (in the general case), a principal fiber bundle (using transformation groups) or a fibration (when dealing with deformations).

## Reconstruction

Some remarks about the modeling of the information:

- Linearized information about the objects can be modeled using plane arrangements in arbitrary dimension (hyperplanes)
- The elements of a dual $\mathbf{V^*}$ of a vector space $\mathbf{V}$ defined over a field $\mathbf{F}$ are called covectors or one-forms. In fact, they are linear functionals of the form

$$ \phi: \mathbf{V} \rightarrow \mathbf{F}$$

- A field is just a set $ \mathbf{F} $ which is a commutative group with respect to multiplication and addition where the additive identity $0$ has no multiplicative inverse. Any field can be used as the scalars of a vector space for linear algebra.
- A plane is the result of the linearization of an object but it can also be represented as a one-form. For instance, the one-form $[1,1,1] \in \mathbf{R}^3$ defines an infinite number of parallel planes over the field $\mathbf{F}$ such as $x + y + z = 0$. See the example at [Wolfram Alpha](http://www.wolframalpha.com/input/?i=x%2By%2Bz%3D0)
- A differential one-form is linked to the numeric evaluation of the fields (escalar, vectorial or tensorial) modeling the changes in the surface of the model. In theory, these one-forms can have arbitrary dimension defined as the fiber of a fiber bundle.
- **Advantage**: a one-form can model objects, transformations and deformations, including functionals defined over them