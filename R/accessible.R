accessible <- function(x) {
  UseMethod("accessible")
}


accessible.ggplot <- function(x) {
  # see `BrailleR::VI()` function
  ## check if x == geom_bar
  ### then export x as an svg using gridSVG
  ### interweave this svg with JS by using tempdir, usethis, and serve the live html
  ### Or, use htmltools::tags$object() to embed when in Rmd output.
}

# to do
## study s3 and s4 to generalize this process depending on graph type.


print.ggplot <- function(...) {
  if (interactive()) {
    svgpath <- htmltools::plotTag(
      ggplot2:::print.ggplot(...), "Plot object",
      device = svglite::svglite,
      mimeType = "image/svg+xml",
      attribs = list(id = "my-chart")
    )

    print(svgpath)
  }
}
