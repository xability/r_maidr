#' @export
maidr <- function(x, ...) {
  UseMethod("maidr")
}


#' @export
maidr.ggplot <- function(g, ...) {
  # Extract graph elements from ggplot
  gbuild <- suppressMessages(ggplot2::ggplot_build(g))
  nlayers <- .getGGLayerCount(g, gbuild)
  panels <- .buildPanels(g, gbuild)
  npanels <- length(panels)
  layers <- .buildLayers(g, gbuild, 1)
  type1 <- layers[[1]]$type
  ymax <- layers[[1]]$scaledata$max
  title <- .getGGTitle(g)
  xlabel <- .getGGAxisLab(g, gbuild, "x")
  ylabel <- .getGGAxisLab(g, gbuild, "y")

  if (!.getGGScaleFree(g, gbuild)) { # Can talk about axis ticks at top level unless scale_free
    samescale <- TRUE
    xticklabels <- .getGGTicks(g, gbuild, 1, "x")
    yticklabels <- .getGGTicks(g, gbuild, 1, "y")
  } else {
    samescale <- NULL
    xticklabels <- NULL
    yticklabels <- NULL
  }

  # Create a string id combining type1 and current datetime
  id <- paste0(type1, "_", format(Sys.time(), "%Y%m%d_%H%M%S"))

  if (type1 == "bar" && npanels == 1) {
    json_schema <- create_barplot_schema(type1, id, title, xlabel, ylabel, xticklabels, yticklabels, ymax)
    svg <- print_svg(g, id)
    maidr_object <- list(svg = svg, json_schema = json_schema)
    maidr_object$maidr_widget <- maidr_widget(svg = maidr_object$svg, json_schema = maidr_object$json_schema)
    print(maidr_object$maidr_widget)

    class(maidr_object) <- c("maidr", class(maidr_object))
    return(invisible(maidr_object))
  } else if (type1 == "point" && npanels == 1 && nlayers == 2) {
    json_schema <- create_scatterplot_schema(id, title, xlabel, ylabel, layers)
    svg <- print_svg(g, id)
    maidr_object <- list(svg = svg, json_schema = json_schema)
    maidr_object$maidr_widget <- maidr_widget(svg = maidr_object$svg, json_schema = maidr_object$json_schema)
    print(maidr_object$maidr_widget)

    class(maidr_object) <- c("maidr", class(maidr_object))
    return(invisible(maidr_object))
    # return(layers)
  } else {
    warning("The plot is not supported in MAIDR.")
  }
}


maidr_dependency <- function() {
  htmltools::htmlDependency(
    name = "maidr",
    version = "0.0.9",
    src = "htmlwidgets/lib/maidr-0.0.9",
    package = "maidr",
    script = c(
      "js/audio.js",
      "js/barplot.js",
      "js/boxplot.js",
      "js/constants.js",
      "js/display.js",
      "js/heatmap.js",
      # "maidr.js",
      "js/scatterplot.js",
      "js/controls.js",
      "js/init.js"
    ),
    stylesheet = "css/styles.css",
    all_files = TRUE
  )
}


maidr_widget <- function(svg, json_schema) {
  content <- htmltools::tagList(
    htmltools::div(
      class = c("container", "mt-3"),
      htmltools::div(
        id = "container",
        htmltools::div(svg),
        htmltools::br()
      )
    ),
    htmltools::tags$script(htmltools::HTML(sprintf(
      "var maidr = %s;", json_schema
    )))
  )

  maidr_browsable <- htmltools::browsable(htmltools::attachDependencies(content, maidr_dependency()))
  return(maidr_browsable)
}
