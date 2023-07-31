#' @export

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

                    const x = {x};

      const {{err}} = c2mChart({{
        type: \"{type}\",
        title: \"{stringr::str_to_title(type)} chart showing the relationship between {x_label} and {y_label}.\",
        element: document.getElementById('{id}'),
        cc: document.getElementById(\"screenreader-caption\"),
        data: {data},
            axes: {{
                x: {{
                    label: \"{x_label}\",
                    format: (index) => x[index]
                }},
                y: {{
                    label: \"{y_label}\"

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
        x = jsonlite::toJSON(lubridate::as_date(ggplot2::layer_data(g)$x)),
        x_label = g$labels$x,
        y_label = g$labels$y,
        # data = paste0(ggplot2::ggplot_build(g)$data[[1]]$y, collapse = ", ")
        data = jsonlite::toJSON(ggplot2::layer_data(g)[, c("x", "y")])
      )
    ))
  )

  print(a11y_result, browse = TRUE)
}
