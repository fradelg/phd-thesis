Meeting Notes
=============

December, 12, 2012
------------------

-   Material properties will require to combine bilineal and quadratic
    projection modes of lightning
    -   It should be done only if possible as a minor contribution
-   Real Time Camera Tracking will be approximated using motion
    estimation

-   The PhD is focused on monocular video but RGB-D cameras are not
    discarted yet

-   Long loop scenes
    -   Using tangent space from skew-symmetric matrices of Lie algebra
    -   Open loops can be closed by interpolating using a bilineal
        transformation
-   Mesh simplification during reconstruction
    -   Reduces memory footprint
    -   Boost future computations

### Next steps

-   Determine prototypes and software requirements
-   Design pipeline architecture
-   Establish criteria for a quantitative evaluation of the results
    using percentage of error or improvement from state of the art

* * * * *

February 7, 2013
================

-   Tracking and Mapping will be two coupled components with a closed
    feedback between them
-   Noise from measures must be taken into account in every step:
    minimize the reprojection error
-   Consider VTK or some visualization library for point clouds
-   Energy functional and evaluation / validation procedures require
    more explanation
-   Consider Wallenstein distance: it looks for similarities between
    grouped data by mesuring orden $k$ moments
    -   It includes the Hausdorff measure (2010)
-   Consider background segmentation to reduce the noise in the scene
-   In the evaluation, it is recommended to parametrize the total error
    wrt camera velocity and background distance

### Next steps

-   First implementation of a 3D reconstruction pipeline
    -   Using FAST features
    -   KLT tracking
    -   Triangulation
-   Describe the smart meshing procedures taken into consideration
