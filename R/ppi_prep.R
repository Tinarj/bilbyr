#' Preprocess high-dimensional data using scagnostics
#'
#' Computes a selected scagnostic for every pair of numeric variables
#' and ranks the pairs in descending order of their index values.
#'
#' @param data A data frame or numeric matrix.
#' @param scag Scagnostic to calculate, e.g. "stringy05" or "skinny".
#' @param rescale Logical. Apply rescaling if supported. Defaults to FALSE.
#' @param ... Additional arguments passed to the scagnostic function.
#'
#' @return An object of class `bilby_preprocess` containing:
#'   \itemize{
#'     \item `pair_scores`: variable pairs, scagnostic values, and ranks.
#'     \item `index`: the scagnostic used.
#'   }
#'
#' @examples
#' scag_preprocess(
#'   simple_stringy,
#'   scag = "stringy05",
#'   rescale = TRUE
#' )
#'
#' scag_preprocess(
#'   hidden_stringy,
#'   scag = "stringy05",
#'   rescale = TRUE
#' )
#'
#'
#' @export
scag_preprocess <- function(data,
                            scag = "stringy05",
                            rescale = FALSE,
                            ...) {

  # Prepare data
  data <- data |>
    tibble::as_tibble() |>
    dplyr::select(dplyr::where(is.numeric))

  if (ncol(data) < 2) {
    stop("At least two numeric variables are required.")
  }

  # Select scagnostic
  scag_fun <- getExportedValue(
    "cassowaryr",
    paste0("sc_", scag)
  )

  args <- list(...)

  if (rescale) {
    args$rescale <- TRUE
  }

  # Generate all variable pairs
  pairs <- utils::combn(names(data), 2)

  # Calculate scagnostic and rank pairs
  pair_scores <- tibble::tibble(
    var1 = pairs[1, ],
    var2 = pairs[2, ]
  ) |>
    dplyr::mutate(
      value = purrr::map2_dbl(
        var1,
        var2,
        \(a, b) {
          do.call(
            scag_fun,
            c(
              list(
                x = data[[a]],
                y = data[[b]]
              ),
              args
            )
          )
        }
      )
    ) |>
    dplyr::arrange(dplyr::desc(value)) |>
    dplyr::mutate(
      rank = dplyr::min_rank(dplyr::desc(value))
    )

  # Return results
  structure(
    list(
      pair_scores = pair_scores,
      index = scag
    ),
    class = "bilby_preprocess"
  )
}
