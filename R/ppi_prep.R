#' Preprocess high-dimensional data using scagnostics
#'
#' Computes and ranks pairwise scagnostic scores.
#' Selects high-scoring pairs using the largest consecutive
#' score gap and retains all variables appearing in those pairs.
#'
#' Constructs an initial orthonormal projection basis for each
#' retained pair. Each basis has p rows and two columns, where
#' p is the number of numeric variables in the original dataset.
#' These bases can be used to initialise projection pursuit
#' searches from interesting pairwise projections.
#'
#' @param data A data frame or numeric matrix.
#' @param scag Scagnostic to calculate, e.g. "stringy05".
#' @param rescale Logical. Apply rescaling if supported. Defaults to FALSE.
#' @param ... Additional arguments passed to the scagnostic function.
#'
#' @return An object of class `bilby_preprocess` containing:
#'   \describe{
#'     \item{pair_scores}{All variable pairs, scores and ranks.}
#'     \item{top_pairs}{Pairs retained above the largest gap.}
#'     \item{selected_vars}{Variables appearing in retained pairs.}
#'      \item{initial_bases}{A list of orthonormal p by 2 projection
#'       matrices, one for each retained variable pair, ordered
#'       by decreasing scagnostic score.}
#'     \item{index}{The scagnostic used.}
#'   }
#'
#' @examples
#' result <- scag_preprocess(
#'   simple_stringy,
#'   scag = "stringy05",
#'   rescale = TRUE
#' )
#'
#' result$selected_vars
#' result$initial_bases
#'
#' @export
scag_preprocess <- function(data,
                             scag = "stringy05",
                             rescale = FALSE,
                             ...) {

  data <- data |>
    tibble::as_tibble() |>
    dplyr::select(dplyr::where(is.numeric))

  # Select scagnostic
  scag_fun <- getExportedValue(
    "cassowaryr",
    paste0("sc_", scag)
  )

  args <- list(...)

  if (rescale) {
    args$rescale <- TRUE
  }

  # score all variable pairs
  pairs <- utils::combn(names(data), 2)

  pair_scores <- tibble::tibble(
    var1 = pairs[1, ],
    var2 = pairs[2, ]
  ) |>
    dplyr::mutate(
      value = purrr::map2_dbl(
        var1, var2,
        \(a, b) {
          as.numeric(do.call(
            scag_fun,
            c(
              list(x = data[[a]], y = data[[b]]),
              args
            )
          ))
        }
      )
    ) |>
    dplyr::arrange(dplyr::desc(value)) |>
    dplyr::mutate(
      rank = dplyr::min_rank(dplyr::desc(value))
    )

  # Find the largest gap
  values <- pair_scores$value
  gaps <- -diff(values)

  if (all(gaps == 0)) {
    cutoff_position <- length(values)
  } else {
    cutoff_position <- which.max(gaps)
  }

  # Keep all pairs above the largest gap
  top_pairs <- pair_scores |>
    dplyr::filter(value >= values[cutoff_position])

  selected_vars <- unique(c(
    top_pairs$var1,
    top_pairs$var2
  ))

  # Construct initial basis for each retained pair
  initial_bases <- purrr::map2(
    top_pairs$var1,
    top_pairs$var2,
    \(a, b) {

      basis <- matrix(
        0,
        nrow = ncol(data),
        ncol = 2,
        dimnames = list(
          names(data),
          c("axis1", "axis2")
        )
      )

      basis[a, 1] <- 1
      basis[b, 2] <- 1

      basis
    }
  )

  names(initial_bases) <- paste(
    top_pairs$var1,
    top_pairs$var2,
    sep = "-"
  )

  structure(
    list(
      pair_scores = pair_scores,
      top_pairs = top_pairs,
      selected_vars = selected_vars,
      initial_bases = initial_bases,
      index = scag
    ),
    class = "bilby_preprocess"
  )
}
