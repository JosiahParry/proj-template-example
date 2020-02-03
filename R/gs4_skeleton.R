template_dir <- function(...) {
  system.file(..., package = "gs4template")
}


gs4_skeleton <- function(path, ...) {
  # create the directory
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  # identify the directory with the template
  proj_dir <- template_dir('rstudio', 'templates', 'project', 'resources')

  # list all of the files
  proj_files <- list.files(proj_dir,
                           recursive = TRUE, include.dirs = FALSE,
                           all.files = TRUE,
                           no.. = TRUE)

  # create full file path of template files
  proj_file_paths <- file.path(proj_dir, proj_files)

  # use the project path to create new file locations
  new_proj_path <- file.path(path, proj_files)

  # Create .secrets directory
  dir.create(file.path(path, ".secrets"))

  # copy the files over
  file.copy(proj_file_paths, new_proj_path)

  # have to rename Rprofile to .Rprofile, due to weird naming stuff
  file.rename(file.path(path, "Rprofile"),
              file.path(path, ".Rprofile"))

}
