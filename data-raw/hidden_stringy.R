
gen_hidden_stringy <- function(
    n = 500,
    p = 10,
    pattern = "cubic",
    theta = pi / 4,
    seed = 825
) {

  pattern <- match.arg(
    pattern,
    c("cubic", "quartic", "sine", "two_moons")
  )

  set.seed(seed)

  # Generate structure
  if (pattern == "two_moons") {

    group <- sample(rep(1:2, length.out = n))
    angle <- runif(n, 0, pi)

    s1 <- ifelse(
      group == 1,
      cos(angle),
      1 - cos(angle)
    )

    s2 <- ifelse(
      group == 1,
      sin(angle),
      0.5 - sin(angle)
    )

  } else {

    t <- rnorm(n)

    s1 <- t

    if (pattern == "cubic") {
      s2 <- poly(t, degree = 3)[, 3]
    } else if (pattern == "quartic") {
      s2 <- poly(t, degree = 4)[, 4]
    } else if (pattern == "sine") {
      s2 <- sin(pi * t)
    }
  }

  # Standardise structure variables
  s1 <- as.numeric(scale(s1))
  s2 <- as.numeric(scale(s2))

  # Independent nuisance variables
  n1 <- rnorm(n, sd = 1)
  n2 <- rnorm(n, sd = 1)

  # Mix structure and nuisance variables
  x1 <-  cos(theta) * s1 + sin(theta) * n1
  x3 <- -sin(theta) * s1 + cos(theta) * n1

  x2 <-  cos(theta) * s2 + sin(theta) * n2
  x4 <- -sin(theta) * s2 + cos(theta) * n2

  hidden_stringy <- tibble(
    x1 = x1,
    x2 = x2,
    x3 = x3,
    x4 = x4
  )

  # Add irrelevant Gaussian noise variables
  if (p > 4) {

    extra_noise <- matrix(
      rnorm(n * (p - 4), sd = 1),
      nrow = n,
      ncol = p - 4
    )

    colnames(extra_noise) <- paste0("x", 5:p)

    hidden_stringy <- bind_cols(
      hidden_stringy,
      as_tibble(extra_noise)
    )
  }

  return(hidden_stringy)
}


hidden_stringy <- gen_hidden_stringy()

usethis::use_data(
  hidden_stringy,
  overwrite = TRUE
)
