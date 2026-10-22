
# Required libraries
library(cassowaryr)
library(tidyverse)


#  Get parameters
args <- commandArgs(trailingOnly = TRUE)

pattern   <- args[1]
n         <- as.integer(args[2])
rep_start <- as.integer(args[3])
rep_end   <- as.integer(args[4])
base_seed <- as.integer(args[5])
flname    <- args[6]

noise_levels <- as.numeric(
  strsplit(args[7], ",")[[1]]
)

print(paste("Pattern:", pattern))
print(paste("Sample size:", n))
print(paste("Repetitions:", rep_start, "to", rep_end))
print(paste("Seed:", base_seed))
print(paste("Noise levels:", paste(noise_levels, collapse = ", ")))
print(paste("Filename:", flname))

#  Generate original structure once
# Use a separate seed for generating the structure
set.seed(base_seed)

if (pattern == "two_moons") {

  group <- sample(rep(1:2, length.out = n))
  theta <- runif(n, 0, pi)

  x <- ifelse(
    group == 1,
    cos(theta),
    1 - cos(theta)
  )

  y <- ifelse(
    group == 1,
    sin(theta),
    0.5 - sin(theta)
  )

} else {

  t <- rnorm(n, mean = 0, sd = 1)

  x <- t

  if (pattern == "cubic") {

    y <- poly(t, degree = 3)[, 3]

  } else if (pattern == "quartic") {

    y <- poly(t, degree = 4)[, 4]

  } else if (pattern == "sine") {

    y <- sin(pi * t)

  }
}

# Standardise both structure variables
x_true <- as.numeric(scale(x))
y_true <- as.numeric(scale(y))


write_csv(
  tibble(
    pattern = character(),
    n = integer(),
    noise_sd = numeric(),
    repetition = integer(),
    seed = integer(),
    stringy = numeric()
  ),
  flname
)


# Run noise simulations
for (sigma in noise_levels) {
  for (rep in rep_start:rep_end) {

    seed <- base_seed + rep

    set.seed(seed)

    noise_x <- rnorm(n, mean = 0, sd = sigma)
    noise_y <- rnorm(n, mean = 0, sd = sigma)

    # Add noise to the structure
    x_noisy <- x_true + noise_x
    y_noisy <- y_true + noise_y

    # Calculate rescaled Stringy05
    stringy <- cassowaryr::sc_stringy05(
      x_noisy,
      y_noisy,
      rescale = TRUE
    )

    # Store simulation result
    result <- tibble(
      pattern = pattern,
      n = n,
      noise_sd = sigma,
      repetition = rep,
      seed = seed,
      stringy = as.numeric(stringy)
    )

    # Append after every completed simulation
    write_csv(
      result,
      flname,
      append = TRUE
    )

    print(paste(
      "Finished:",
      pattern,
      "| SD:", sigma,
      "| Repetition:", rep,
      "| Seed:", seed,
      "| Stringy:", round(stringy, 4)
    ))
  }
}

print("All simulations finished!")
