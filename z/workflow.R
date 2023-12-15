# Load functions straight from file
source("R/generate_stats_plots.R")


# Or use load_all() from devtools to load them as if they were a package
# devtools::load_all(".")

# Test out making new functions


# When you're happy with a function, go put it in an R script in the /R folder.

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
