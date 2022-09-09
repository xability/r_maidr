
# New print.numeric s3 method
plot.numeric <- function(...) {
  plot(...)

  # Need to create sonification for numeric values
  create_wave <- function(...) {
    suppressWarnings(
      wav <- sonify::sonify(..., play = FALSE)
    )
    file <- tempfile(fileext = ".wav")
    tuneR::writeWave(wav, filename = file)
    invisible(file)

    file <- create_wave(...)
    html_tag_audio <- function(file, type = c("wav")) {
      type <- match.arg(type)
      htmltools::tags$audio(
        controls = "",
        htmltools::tags$source(
          src = file,
          type = glue::glue("audio/{type}", type = type)
        )
      )
    }

html_tag_audio(file)
}