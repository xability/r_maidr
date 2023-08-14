# #' @export

# print.ggplot <- function(g, ...) {
#   type <- stringr::str_to_lower(stringr::str_extract(class(g$layers[[1]]$geom)[[1]], "(?<=Geom).*"))


#   svgpath <- htmltools::capturePlot(
#     ggplot2:::print.ggplot(g, ...),
#     tempfile(fileext = ".svg"),
#     svglite::svglite,
#     width = 8, height = 3.75
#   )
#   s <- svglite::svgstring(standalone = FALSE, id = "plot")
#   ggplot2:::print.ggplot(g, ...)
#   svg <- s()
#   dev.off()

#   a11y_result <- htmltools::tags$main(
#     htmltools::tags$script(src = "https://cdn.jsdelivr.net/npm/chart2music"),
#     htmltools::tags$object(
#       data = svgpath,
#       type = "image/svg+xml", id = "plot", width = "800",
#       height = "800"
#     ),
#     # htmltools::HTML(svg),
#     htmltools::div(id = "screenreader-caption"),
#     htmltools::tags$script(htmltools::HTML(
#       glue::glue("

#                     const x = {x};

#       const {{err}} = c2mChart({{
#         type: \"{type}\",
#         title: \"{stringr::str_to_title(type)} chart showing the relationship between {x_label} and {y_label}.\",
#         element: document.getElementById('{id}'),
#         cc: document.getElementById(\"screenreader-caption\"),
#         data: {data},
#             axes: {{
#                 x: {{
#                     label: \"{x_label}\",
#                     format: (index) => x[index]
#                 }},
#                 y: {{
#                     label: \"{y_label}\"

#                 }}
#             }},
# // TODO: Need to add visual syncing by using fallback
# options: {{
#                 onFocusCallback: ({{index}}) => {{
#                     Array.from(document.querySelectorAll('#{id} rect')).slice(5).forEach((elem) => {{
#                         elem.style.fill = '#595959';
#                     }})
#                     document.querySelectorAll('#{id} rect')[index+5].style.fill = 'cyan';
#                 }}
#             }}
#         }});

# if (err) {{
#     console.error(err);
# }}
#       ",
#         id = "plot",
#         x = jsonlite::toJSON(lubridate::as_date(ggplot2::layer_data(g)$x)),
#         x_label = g$labels$x,
#         y_label = g$labels$y,
#         # data = paste0(ggplot2::ggplot_build(g)$data[[1]]$y, collapse = ", ")
#         data = jsonlite::toJSON(ggplot2::layer_data(g)[, c("x", "y")])
#       )
#     ))
#   )

#   print(a11y_result, browse = TRUE)
# }

library(tidyverse)
library(svglite())
library(htmltools)


#' Print an SVG file
#'
#' This function prints an SVG from a plot object.
#'
#' @param g A plot2 object.
#' @param id A character string specifying the ID of the SVG element.
#' @param width A numeric value specifying the width of the SVG element in inches.
#' @param height A numeric value specifying the height of the SVG element in inches.
#' @param ... Additional arguments to be passed to the \code{\link[grDevices]{svg}} function.
#'
#' @return SVG object
#'
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point()
#' print_svg(p, id = "myplot", width = 10, height = 5, browse = TRUE)
#'
#' @export
print_svg <- function(g, id = "plot", width = 8, height = 3.75, ...) {
  s <- svglite::svgstring(standalone = FALSE, id = id, width = width, height = height)
  print({
    g
  })
  svg <- s()
  dev.off()
  svg <- htmltools::HTML(svg)
  # if (isTRUE(browse)) {
  # svg <- htmltools::browsable()
  # }
  return(svg)
}
