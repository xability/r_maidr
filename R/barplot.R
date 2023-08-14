#' Create a barplot schema
#'
#' This function creates a schema for a barplot with customizable parameters.
#'
#' @param type1 A character string indicating the type of the plot.
#' @param id An integer indicating the ID of the plot.
#' @param title A character string indicating the title of the plot.
#' @param xlabel A character string indicating the label for the x-axis.
#' @param ylabel A character string indicating the label for the y-axis.
#' @param xticklabels A character vector containing the labels for the x-axis ticks.
#' @param yticklabels A character vector containing the labels for the y-axis ticks.
#' @param ymax A numeric value indicating the maximum value for the y-axis.
#'
#' @return A json object containing the schema for the barplot.
#'
#' @export
create_barplot_schema <- function(type1, id, title, xlabel, ylabel, xticklabels, yticklabels, ymax) {
  # Create the list that represents your JSON structure
  json_data <- list(
    type = type1,
    id = id,
    title = title,
    elements = sprintf("svg#%s g:nth-last-of-type(2) > rect:not(:first-child)", id),
    axes = list(
      x = list(
        label = xlabel,
        format = xticklabels
      ),
      y = list(
        label = ylabel
      )
    ),
    data = ymax
  )

  # Convert the list to a JSON object
  json_object <- jsonlite::toJSON(json_data, auto_unbox = TRUE, pretty = TRUE)

  # Print the JSON object
  return(json_object)
}
