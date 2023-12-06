#' @name make_data.R
#' @description Script for data generation
#' @note These roxygen2 comments are just for kicks. Not needed anywhere except the /R folder.

library(dplyr)

# Make a data folder in your package directory.
dir.create("data")

# Make the data, and give it an easy to use name (that's what users will call it when coding with it)
helper = tibble(x = 1, y = 2, z = 3)
# Alternatively, read it in from somewhere, eg.
# helper = readr::read_csv("z/helper.csv") # a hypothetical file

# Save it as an .rda file in the `/data` folder
save(helper, file = "data/helper.rda")

# Test it
remove(helper);
load("data/helper.rda")
helper

# Remove all
rm(list = ls())
