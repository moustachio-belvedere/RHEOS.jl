<a name="logo"/>
<div align="center">
<img src="docs/Logo.png" height="142"></img>
</a>
</div>

# RHEOS - RHEology, Open-Source
#### A suite of tools for analysing rheology data

*Documentation currently under development*

## Installation

- Install julia, version > 0.6.
- git clone repository into desired location
- Run TEMP_INSTALL.jl
- Set environment variable "JULIA_NUM_THREADS" equal to number of processor cores available

## To do

+ Documentation
+ Reorganise directory referencing structure and installation to make more robust
+ Add Sync Interpolation for going from variable to constant sample rate
+ Add Tolerance option (relative and absolute) that can be set using the high level interface
+ Add option to save/export the full generated model curves for plotting in other software
+ Split indentation models and standard rheology into two sections, refactor code appropriately
+ Add axes labels in all insight plots
+ Add different test loading methods such as ramp, sinusoidal etc. Allow them to be superposed on each other?
+ For some fractional models, convert time scale τ to cᵦ as it fits better and is more physical (already done for relaxation models)

## References & Included Dependencies
#### [FastConv.jl](https://github.com/aamini/FastConv.jl)
+ A. Alexander, B. Horn and A. Edelman - *Accelerated Convolutions for Efficient Multi-Scale Time to Contact Computation in Julia*, arXiv preprint arXiv:1612.08825 **(2016)**

#### [MittagLeffler.jl](https://github.com/jlapeyre/MittagLeffler.jl)
+ R. Gorenflo, J. Loutchko and Y. Loutchko - *Computation of the Mittag-Leffler function and its derivative*,  Fract. Calc. Appl. Anal. **(2002)**

#### [InverseLaplace.jl](https://github.com/jlapeyre/InverseLaplace.jl)
+ J.A.C Weideman, Algorithms for Parameter Selection in the Weeks Method for Inverting the Laplace Transform, SIAM Journal on Scientific Computing, Vol. 21, pp. 111-128 **(1999)**

+ Abate, J. and Valkó, P.P., Multi-precision Laplace transform inversion International Journal for Numerical Methods in Engineering, Vol. 60 (Iss. 5-7) pp 979–993 **(2004)**

+ Valkó, P.P. and Abate, J., Comparison of Sequence Accelerators for the Gaver Method of Numerical Laplace Transform Inversion, Computers and Mathematics with Application, Vol. 48 (Iss.3-40) pp. 629-636 **(2004)**

#### Fractional Zener, Fractional Maxwell and Fractional Kelvin-Voigt Models
F. Mainardi, G. Spada - [*Creep, relaxation and viscosity properties for basic fractional models in rheology*](https://doi.org/10.1140/epjst/e2011-01387-1), Eur. Phys. J. Spec. Top. **(2011)**

#### Viscoelastic Hertz Model of Spherical Indententation
M. L. Oyen - [*Spherical Indentation Creep Following Ramp Loading*](https://doi.org/10.1557/JMR.2005.0259), Journal of Materials Research **(2005)**  
J. M. Mattice, A. G. Lau, M. L. Oyen and R. W. Kent - [*Spherical indentation load-relaxation of soft biological tissues*](https://doi.org/10.1557/jmr.2006.0243), Journal of Materials Research **(2006)**
