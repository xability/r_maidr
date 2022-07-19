accessible <- function(x) {
    UseMethod("accessible")
}


accessible.ggplot <- function(x) {
    # see `BrailleR::VI()` function
    # check x == ggplot
    ## if so, check if x == geom_bar
    ### then export x as an svg using gridSVG
    ### interweave this svg with JS by using tempdir, usethis, and serve the live html
}

# to do
## study s3 and s4 to generalize this process depending on graph type.
