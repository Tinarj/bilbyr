#' Bilby example data
#'
#' A simulated 10-dimensional dataset containing a bilby-shaped pattern
#' in the `x3` and `x8` variables. The remaining variables are noise.
#'
#' @format A data frame with 3000 rows and 10 variables.
#' @source Simulated data.
#'
#' @examples
#' data("bilby", package = "bilbyr")
#' bilby |>
#' slice_head(n = 1500) |>
#'  ggplot(aes(x3, x8)) +
#'  geom_point(size = 0.5) +
#'  theme_minimal()
#'
"bilby"


#' Simple stringy example data
#'
#' A simulated 4-dimensional dataset with a sine-shaped pattern
#' in `x1` and `x2`. Variables `x3` and `x4` are independent
#' Gaussian noise.
#'
#' @format A data frame with 500 rows and 4 variables.
#' @source Simulated data.
"simple_stringy"


#' Hidden stringy example data
#'
#' A simulated 10-dimensional dataset with a 2D stringy pattern
#' hidden across `x1` to `x4`. Variables `x5` to `x10` are
#' independent Gaussian noise.
#'
#' @format A data frame with 500 rows and 10 variables.
#' \describe{
#'   \item{x1-x4}{Variables containing the hidden structured signal.}
#'   \item{x5-x10}{Independent Gaussian noise variables.}
#' }
#'
#' @source Simulated data.
"hidden_stringy"

