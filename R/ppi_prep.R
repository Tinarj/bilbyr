#' Preprocess high-dimensional data using scagnostics
#'
#' Computes and ranks pairwise scagnostic scores.
#' Selects high-scoring pairs using the largest consecutive
#' score gap and retains all variables appearing in those pairs.
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
#'     \item{index}{The scagnostic used.}
#'   }
#'
#' @examples
#' scag_preprocess(
#'   simple_stringy,
#'   scag = "stringy05",
#'   rescale = TRUE
#' )
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

  structure(
    list(
      pair_scores = pair_scores,
      top_pairs = top_pairs,
      selected_vars = selected_vars,
      index = scag
    ),
    class = "bilby_preprocess"
  )
}
