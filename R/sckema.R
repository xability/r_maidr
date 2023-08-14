# bar_schema <- function() {
#   library(jsonlite)

#   # Define the list structure
#   json_structure <- list(
#     type = "bar",
#     id = "barplot1",
#     title = "The Number of Diamonds by Cut.",
#     elements = 'document.querySelectorAll(\'g[id^="geom_rect"] > rect\')', # Stored as a string
#     axes = list(
#       x = list(
#         label = "Cut",
#         format = c("Fair", "Good", "Very Good", "Premium", "Ideal")
#       ),
#       y = list(
#         label = "Count"
#       )
#     ),
#     data = c(1610, 4906, 12082, 13791, 21551)
#   )

#   # Convert the list to JSON

#   json_output <- toJSON(json_structure, auto_unbox = TRUE, pretty = TRUE)

#   # Print the JSON
#   cat(json_output)
# }



# # Create a scatterplot
# library(tidyverse)
# library(svglite)
# g <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
#   geom_point() +
#   geom_smooth(method = "lm") +
#   labs(title = "Iris Dataset", x = "Sepal Length", y = "Sepal Width")

# g




# g <- ggplot(diamonds, aes(cut)) +
#   geom_bar()

# g <- g +
#   labs(title = "hello")

# x <- maidr.ggplot(g)
# # browsable(x$svg)
# class(x)
# # xticklabels <- .getGGTicks(g, ggplot_build(g), 1, "x")
# # xticklabels

# # layers <- .buildLayers(g, suppressMessages(ggplot2::ggplot_build(g)), 1)
# # type1 <- layers[[1]]$type
# # str(layers)


# # diamonds %>%
# #   count(cut) %>%
# #   gt::gt()
# # g1 <- ggplot(mpg, aes(class)) +

# # g1 <- g1+labs(title="test")  geom_bar()
# # maidr.ggplot(g1)
