#' @export
NULL

plot.numeric <- function(...) {
    s <- svglite::svgstring(standalone = FALSE, id = "plot")
    plot.default(...)
    svg <- s()
    dev.off()

    file <- create_wave(...)

    print(html_tag_audio(file), browse = TRUE)
}




#' helper function saving sonified data as temp wav file
create_wave <- function(...) {
    suppressWarnings(
        wav <- sonify::sonify(..., play = FALSE)
    )
    file <- tempfile(fileext = ".wav")
    tuneR::writeWave(wav, filename = file)
    invisible(file)
}

#' helper function for creating html audio tag
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


# Very high positive (negative) correlation
# strength <- "very high"

corr_coef <- cor(...)
abs(corr_coef)


# direction <- ifelse(x > 0, "positive", "negative")
# sign(x)

direction <- function(x) {
    switch(sign(x),
        1 ~ "positive",
        0 ~ "no",
        -1 ~ "negative"
    )
}
