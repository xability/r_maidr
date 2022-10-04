
# New print.numeric s3 method

if (interactive()) {
    # Helper function to retrieve x ticks borrowed from {BrailleR}
    ## Also need to copy y tick helper function to handle coord_flip
    .getGGXTicks <- function(x, xbuild, layer) {
        # The location of this item is changing in an upcoming ggplot version
        if ("panel_ranges" %in% names(xbuild$layout)) {
            return(xbuild$layout$panel_ranges[[layer]]$x.labels) # ggplot 2.2.1
        } else {
            xlabs <- xbuild$layout$panel_params[[1]]$x$get_labels()
            return(xlabs[!is.na(xlabs)])
        }
    }

    print.ggplot <- function(g, ...) {
        type <- stringr::str_to_lower(stringr::str_extract(class(g$layers[[1]]$geom)[[1]], "(?<=Geom).*"))


        # svgpath <- htmltools::capturePlot(
        #     ggplot2:::print.ggplot(g, ...),
        #     tempfile(fileext = ".svg"),
        #     svglite::svglite,
        #     width = 8, height = 3.75
        # )
        s <- svglite::svgstring(standalone = FALSE, id = "plot")
        ggplot2:::print.ggplot(g, ...)
        svg <- s()
        dev.off()

        a11y_result <- htmltools::tags$main(
            htmltools::tags$script(src = "https://cdn.jsdelivr.net/npm/chart2music"),
            # htmltools::tags$object(
            #     data = svgpath,
            #     type = "image/svg+xml", id = "plot", width = "800",
            #     height = "800"
            # ),
            htmltools::HTML(svg),
            htmltools::div(id = "screenreader-caption"),
            htmltools::tags$script(htmltools::HTML(
                glue::glue("

                    const x = [{x}];

      const {{err}} = c2mChart({{
        type: \"{type}\",
        title: \"{stringr::str_to_title(type)} chart showing the relationship between {x_label} and {y_label}.\",
        element: document.getElementById('{id}'),
        cc: document.getElementById(\"screenreader-caption\"),
        data: [{data}],
            axes: {{
                x: {{
                    label: \"{x_label}\",
                    format: (index) => x[index]
                }},
                y: {{
                    label: \"{y_label}\",
                    minimum: {ymin}
                }}
            }},
// TODO: Need to add visual syncing by using fallback
options: {{
                onFocusCallback: ({{index}}) => {{
                    Array.from(document.querySelectorAll('#{id} rect')).slice(5).forEach((elem) => {{
                        elem.style.fill = '#595959';
                    }})
                    document.querySelectorAll('#{id} rect')[index+5].style.fill = 'cyan';
                }}
            }}
        }});

if (err) {{
    console.error(err);
}}
      ",
                    id = "plot",
                    x = paste0("'", paste0(.getGGXTicks(g, ggplot2::ggplot_build(g), 1), collapse = "', '"), "'"),
                    x_label = g$labels$x,
                    y_label = g$labels$y,
                    ymin = min(ggplot2::ggplot_build(g)$data[[1]]$ymin),
                    data = paste0(ggplot2::ggplot_build(g)$data[[1]]$y, collapse = ", ")
                )
            ))
        )

        print(a11y_result, browse = TRUE)
    }
}



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
