library(tidyverse)

set.seed(946)

n <- 500

simple_stringy <- tibble(
  x1 = seq(-1, 1, length.out = n),
  x2 = sin(pi * x1) + rnorm(n, 0, 0.01),
  x3 = rnorm(n),
  x4 = rnorm(n)
)
