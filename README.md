
<!-- README.md is generated from README.Rmd. Please edit README.Rmd instead. -->

<img src="man/figures/bilbyr.png"
     width="200"
     align="right">

### bilbyr

<strong> Behavioural Investigation of Low-dimensional<br> projections
Before Your tour in R </strong>

<!-- badges: start -->

<!-- badges: end -->

`bilbyr` is an R package for **diagnosing, exploring, and benchmarking
projection pursuit indices (PPIs)** before and during their use in
projection pursuit guided tours.

Projection pursuit relies on an index to identify interesting
low-dimensional projections of high-dimensional data. However, a
statistic that performs well on a single two-dimensional example is not
necessarily a useful projection pursuit index.

Before allowing an index to guide a tour, we would like to understand:

- whether it detects the structure it is intended to find;
- whether it distinguishes meaningful structure from noise;
- how it behaves with changes in sample size, noise, scaling, and
  rotation;
- whether its index landscape can be successfully optimised; and
- whether the correct projection can still be recovered as
  dimensionality increases.

`bilbyr` provides diagnostic and simulation tools for investigating
these questions.

## Why `bilbyr`?

The name **BILBYR** stands for:

> **B**ehavioural **I**nvestigation of **L**ow-dimensional projections
> **B**efore **Y**our tour in **R**

The name reflects the main philosophy of the package:

> **Investigate an index before trusting it to guide a tour.**

The package is also named after the **greater bilby (*Macrotis
lagotis*)**, an Australian burrowing marsupial recognised by its long,
rabbit-like ears. **Bilbies are powerful diggers**. They use their
strong forelimbs and claws to search beneath the ground for food and to
construct deep burrows for shelter. Their strong sense of smell and
hearing also helps them locate resources that are not immediately
visible at the surface.

This behaviour provides a natural analogy for `bilbyr`. A projection
pursuit index may return only a single numerical value, but that value
does not tell the whole story. Like a bilby digging beneath the surface,
`bilbyr` aims to investigate what lies behind an index value: whether it
represents meaningful structure or noise, how stable it is, and whether
an optimiser can use it to recover an informative projection.

The greater bilby was once widespread across much of Australia but has
experienced a substantial reduction in its range and is nationally
listed as **Vulnerable**. The name is also meaningful because this work
began while I was a PhD student at **Monash University in Australia**,
connecting the package to both its scientific purpose and the place
where it was developed.

## What does `bilbyr` do?

`bilbyr` focuses on the **development and diagnosis of projection
pursuit indices**.

The package provides tools for:

- generating benchmark datasets with known structure;
- comparing structured and noise projections;
- simulating null distributions and estimating noise baselines;
- studying sample-size effects;
- calibrating and rescaling indices;
- investigating sensitivity to noise, scaling, and rotation;
- profiling index behaviour through projection space;
- evaluating optimisation behaviour in guided tours;
- comparing recovered projections with known optimal projections; and
- studying performance as irrelevant or noise dimensions are added.

The aim is to provide a reproducible framework for understanding both
the **statistical behaviour of an index** and its **behaviour during
optimisation**.

## Scagnostics as case-study PPIs

The initial development of `bilbyr` is motivated by **scagnostics**,
numerical measures describing geometric characteristics of scatterplots.
Scagnostic indices implemented in
[`cassowaryr`](https://numbats.github.io/cassowaryr/) provide useful
candidate PPIs because different measures target different types of
two-dimensional structure. For example, the stringy index targets
elongated, nonlinear, string-like structures, while the skinny index
targets thin structures.

However, successfully identifying an ideal pattern does not
automatically make a scagnostic a useful projection pursuit index. Its
behaviour under noise, different sample sizes, and optimisation also
needs to be understood.

`bilbyr` therefore uses scagnostics as case studies for developing a
more general PPI diagnostic framework. The longer-term goal is for these
tools to work with **any candidate projection pursuit index**, not only
scagnostics.

## Relationship with `tourr`

The [`tourr`](https://github.com/ggobi/tourr) package provides methods
for exploring high-dimensional data using tours, including projection
pursuit guided tours. `bilbyr` is intended to sit **before and alongside
`tourr`**:

Before an index is used in a guided tour, `bilbyr` helps investigate
whether it has the properties required of a useful PPI. Once the index
is used in `tourr`, `bilbyr` can also help evaluate optimisation results
and compare recovered projections with known structure.

This reflects an important principle:

> A good two-dimensional statistic is not necessarily a good projection
> pursuit index. Its statistical and optimisation behaviour should be
> investigated before it is trusted to guide a high-dimensional search.

## Optimisation and high-dimensional diagnostics

Initial work has explored several optimisation strategies available
through `tourr`, including `search_better`, `search_better_random`, and
Jellyfish optimisation.

Repeated simulations can be used to track quantities such as:

- the best index value found;
- the corresponding projection basis;
- variability between repeated searches;
- distance from a known optimal projection; and
- changes in performance as dimensionality increases.

A useful benchmark design is to embed a known two-dimensional signal
inside increasingly high-dimensional data by adding noise variables.
Because the true informative projection is known, the ability of an
index and optimiser to recover the structure can be assessed directly.

## Vignettes

A major goal of `bilbyr` is to provide reproducible explanations and
examples in addition to functions.

Planned vignettes include:

1.  **Choosing a projection pursuit index**
2.  **Signal versus noise**
3.  **Null distributions and index calibration**
4.  **Diagnosing the stringy index**
5.  **Diagnosing the skinny index**
6.  **Using scagnostic indices with `tourr`**
7.  **Diagnosing guided-tour optimisation**
8.  **Projection pursuit as dimensionality increases**

These vignettes will combine conceptual explanations, simulations,
visualisations, and examples using packages such as `tourr`,
`cassowaryr`, `spinebil`, and `ferrn`.

## Background

`bilbyr` grew from research on developing scagnostic-based projection
pursuit indices for [`tourr`](https://github.com/ggobi/tourr).

This work includes investigations of:

- PPI suitability;
- Gaussian-noise baselines;
- sample-size effects;
- index calibration and rescaling;
- guided-tour optimisation; and
- recovery of known structures in increasingly high-dimensional data.

## Installation

`bilbyr` is currently under development and is not yet available on
CRAN.

The development version can be installed from GitHub with:

``` r
# install.packages("pak")
pak::pak("Tinarj/bilbyr")
```

## Acknowledgements

The ideas behind `bilbyr` grew from research on projection pursuit,
scagnostics, guided tours, and diagnostic tools in the R visualisation
ecosystem, particularly the work surrounding `tourr`, `cassowaryr`,
`spinebil`, and `ferrn`.
