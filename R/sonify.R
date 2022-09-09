#' chart2music
#'
#' Slide tone plays a subtle sound when you change slides.The tones increase in
#' pitch for each slide from a low C to a high C note. The tone pitch stays the
#' same for incremental slides.
#'
#' @section Usage: To add chart2music to your ggplot, add the
#'   following code chunk to your R Markdown file.
#'
#'   ````markdown
#'   ```{r data11y-chart2music, echo=FALSE}
#'   data11y::use_chart2music()
#'   ```
#'   ````
#' @examples
#' use_chart2music()
#'
#' @return An `htmltools::tagList()` with the chart2music dependencies, or an
#'   [htmltools::htmlDependency].
#'
#' @references [chart2music](https://chart2music.com)
#' @name chart2music
NULL

#' @describeIn chart2music Adds sonification to your ggplot.
#' @export
use_chart2music <- function() {
  htmltools::tagList(
    html_dependency_chart2music()
  )
}

#' @describeIn chart2music Returns an [htmltools::htmlDependency] with the 
#'   chart2music dependencies. Most users will want to use `use_chart2music()`.
#' @export
html_dependency_chart2music <- function() {
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "tone",
      version = "1.3.0",
      package = "data11y",
      src = "js/chart2music",
      script = "chart2music.js",
      all_files = FALSE
    )
  )
}
