#' Create a scatterplot schema
#'
#' This function creates a schema for a scatterplot with customizable parameters.
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
#' @return A json object containing the schema for the scatterplot.
#'
#' @export
create_scatterplot_schema <- function(id, title, xlabel, ylabel, layers) {
  # Drop NA first from layers' data
  layers[[1]]$data <- tidyr::drop_na(dplyr::select(layers[[1]]$data, x, y))

  layers[[2]]$data <- tidyr::drop_na(dplyr::select(layers[[2]]$data, x, y))


  # Create the list that represents your JSON structure
  json_data <- list(
    type = c("scatter", "line"),
    id = id,
    title = title,
    name = title,
    elements = list(
      sprintf("document.querySelectorAll('svg#%s circle')", id),
      sprintf("document.querySelector('svg#%s g:nth-last-of-type(2) > polyline:nth-last-of-type(1)')", id)
    ),
    axes = list(
      x = list(label = xlabel),
      y = list(label = ylabel)
    ),
    data = list(
      # scatter point layer
      mapply(function(x, y) list(x = x, y = y), layers[[1]]$data$x, layers[[1]]$data$y, SIMPLIFY = FALSE),
      # line layer
      mapply(function(x, y) list(x = x, y = y), layers[[2]]$data$x, layers[[2]]$data$y, SIMPLIFY = FALSE) # line layer
    )
  )

  # # Convert the list to a JSON object
  json_object <- jsonlite::toJSON(json_data, auto_unbox = TRUE, pretty = TRUE)

  # Unquote the element selector
  #   json_object <- base::gsub('(?<="elements": )"(.*?)"', "\\1", json_object, perl = TRUE)

  # Pattern to match quoted document.querySelector and document.querySelectorAll
  pattern_select_all <- "\"document\\.querySelectorAll\\(('[^']+')\\)\""
  pattern_select_one <- "\"document\\.querySelector\\(('[^']+')\\)\""

  # Use gsub to replace the patterns
  json_object <- base::gsub(pattern_select_all, "document.querySelectorAll(\\1)", json_object)
  json_object <- base::gsub(pattern_select_one, "document.querySelector(\\1)", json_object)

  # Print the JSON object
  return(json_object)
}

# plot.numeric <- function(...) {
#   s <- svglite::svgstring(standalone = FALSE, id = "plot")
#   plot.default(...)
#   svg <- s()
#   dev.off()

#   file <- create_wave(...)

#   print(html_tag_audio(file), browse = TRUE)
# }




# #' helper function saving sonified data as temp wav file
# create_wave <- function(...) {
#   suppressWarnings(
#     wav <- sonify::sonify(..., play = FALSE)
#   )
#   file <- tempfile(fileext = ".wav")
#   tuneR::writeWave(wav, filename = file)
#   # invisible(file)
# }

# #' helper function for creating html audio tag
# html_tag_audio <- function(file, type = c("wav")) {
#   type <- match.arg(type)
#   htmltools::tags$audio(
#     controls = "",
#     htmltools::tags$source(
#       src = file,
#       type = glue::glue("audio/{type}", type = type)
#     )
#   )
# }


# # Very high positive (negative) correlation
# # strength <- "very high"

# corr_coef <- cor(...)
# abs(corr_coef)


# # direction <- ifelse(x > 0, "positive", "negative")
# # sign(x)

# direction <- function(x) {
#   switch(sign(x),
#     1 ~ "positive",
#     0 ~ "no",
#     -1 ~ "negative"
#   )
# }
