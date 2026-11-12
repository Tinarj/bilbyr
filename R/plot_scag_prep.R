#' Interactive scree plot of pairwise scagnostic scores
#'
#' Visualizes the ranked pairwise scagnostic scores obtained from
#' `scag_preprocess()`. Variable pairs are ordered from highest
#' to lowest scagnostic value, and a dashed vertical line marks
#' the largest consecutive gap used for variable selection.
#'
#' Hovering over each point displays the variable pair, its rank,
#' scagnostic value, and whether the pair was selected.
#' Selected pairs are highlighted, while the remaining pairs
#' are shown in a different colour.
#'
#' @param x An object of class `bilby_preprocess` returned by
#'   `scag_preprocess()`.
#'
#' @return An interactive `plotly` scree plot.
#'
#' @examples
#' \dontrun{
#' result <- scag_preprocess(
#'   simple_stringy,
#'   scag = "stringy05",
#'   rescale = TRUE
#' )
#'
#' plot_scag_scree(result)
#' }
#'
#' @export
plot_scag_scree <- function(x) {

  if (!inherits(x, "bilby_preprocess")) {
    stop("Input must be an object returned by scag_preprocess().")
  }

  plot_data <- x$pair_scores |>
    dplyr::mutate(
      position = dplyr::row_number(),
      pair = paste(var1, var2, sep = " - "),
      selected = ifelse(
        position <= nrow(x$top_pairs),
        "Selected",
        "Not selected"
      ),
      hover = paste0(
        "Pair: ", pair,
        "<br>Rank: ", rank,
        "<br>Stringy05: ", round(value, 4),
        "<br>Status: ", selected
      )
    )

  # Position of the cutoff
  cutoff <- nrow(x$top_pairs) + 0.5

  plotly::plot_ly(
    data = plot_data,
    x = ~position,
    y = ~value,
    color = ~selected,
    colors = c(
      "Selected" = "#0D9488",
      "Not selected" = "#94A3B8"
    ),
    type = "scatter",
    mode = "markers",
    marker = list(size = 7),
    text = ~hover,
    hoverinfo = "text"
  ) |>
    plotly::add_lines(
      x = ~position,
      y = ~value,
      line = list(color = "#64748B"),
      showlegend = FALSE,
      inherit = FALSE,
      data = plot_data
    ) |>
    plotly::layout(
      title = "Pairwise scagnostic scree plot",
      xaxis = list(title = "Ranked pair position"),
      yaxis = list(title = x$index),
      shapes = list(
        list(
          type = "line",
          x0 = cutoff,
          x1 = cutoff,
          y0 = 0,
          y1 = 1,
          yref = "paper",
          line = list(
            color = "red",
            dash = "dash"
          )
        )
      )
    )
}
