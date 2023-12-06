#' @name commit
#' @title `commit.R`
#' @author Tim Fraser, PhD
#' @description Helpful script for speedy committing of ALL changes to github. 
#' Note: BE CAREFUL! Not always a good idea.

# This script commits to github.
require(gert)

# Add all files changed to git commit 
gert::git_add(dir(all.files = TRUE))
# Commit all the files added, with this message.
gert::git_commit_all(message = "....")
# Push all changes to Github
gert::git_push()
