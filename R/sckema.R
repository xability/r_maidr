create_skema <- function() {
  # Create the list that represents your JSON structure
  json_data <- list(
    type = "barplot",
    title = "The Total Population of Each Continent in 2007.",
    elements = 'document.querySelectorAll(\'g[id^="geom_rect"] > rect\')',
    axes = list(
      x = list(
        label = "Continent",
        format = c("Africa", "Americas", "Asia", "Europe", "Oceania")
      ),
      y = list(
        label = "Total Population"
      )
    ),
    data = c(929539693, 898871185, 3811953828, 586098530, 24549948)
  )

  # Convert the list to a JSON object
  json_object <- jsonlite::toJSON(json_data, auto_unbox = TRUE, pretty = TRUE)

  # Print the JSON object
  print(json_object)
}
