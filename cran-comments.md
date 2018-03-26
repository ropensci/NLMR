## New submission/Updated package

nlmr replaces NLMR. This update is the development of a review process through 
rOpenSci. During that, we were encouraged to split the package into two distinct 
packages and rename it - hence this package is now a slender version that
is focused only on simulating the data and not handling it. 
The renaming was done to meet the requirements of rOpenSci and ensure a long-term
compliance to their software standards.

The package itself keeps its main functionality, so none of the users should 
have major difficulties. Since there are no reverse depencies, the renaming of
the package should have only minor drawbacks in general.

## Test environments

* local Ubuntu Linux 16.04 LTS install
* Ubuntu 14.04 (on travis-ci)
* Windows Server 2012 R2 x64 (build 9600) (on appveyor)
* Rhub
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  * Debian Linux, R-devel, GCC ASAN/UBSAN
  * Fedora Linux, R-devel, clang, gfortran
  * macOS 10.11 El Capitan, R-release
  * macOS 10.9 Mavericks, R-oldrel
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

1 Note about rev as author role. Here we credit both reviewers from rOpenSci.

## Reverse dependencies

There are currently no reverse dependencies.
