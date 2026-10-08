library(tidyverse)

set.seed(946)
n <- 500
theta <- pi / 6

hidden_stringy <- tibble(
  s1 = seq(-1, 1, length.out = n),
  s2 = sin(pi * s1) + rnorm(n, 0, 0.05),

  n1 = rnorm(n, 0, 0.2),
  n2 = rnorm(n, 0, 0.2),

  x5  = rnorm(n),
  x6  = rnorm(n),
  x7  = rnorm(n),
  x8  = rnorm(n),
  x9  = rnorm(n),
  x10 = rnorm(n)
) |>
  transmute(
    x1 =  cos(theta) * s1 + sin(theta) * n1,
    x3 = -sin(theta) * s1 + cos(theta) * n1,

    x2 =  cos(theta) * s2 + sin(theta) * n2,
    x4 = -sin(theta) * s2 + cos(theta) * n2,

    x5, x6, x7, x8, x9, x10
  )

usethis::use_data(
  hidden_stringy,
  overwrite = TRUE
)
