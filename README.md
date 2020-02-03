
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# gs4template

Project templates are provided via R packages.R packages aren’t actually
all that scary, you just need to know which boxes to fill. `usethis`
makes it super easy and we will lean on that\!

## Project Setup

``` r
usethis::create_package("gs4template")
```

This will create a project (from a template\!). Now we need to set up
some basic infrastructure. We will create an MIT license (or whatever
you’d like), a README, and a NEWS document. From the console run the
below.

``` r
use_mit_license("Package Creator")
use_readme_rmd()
use_news_md()
```

We now have the barebones for our package.

## Creating the template

For the purposes of this template we will create a project with a
`.Rprofile` and a `.secrets` already populated. You can create the
folders however you’d like. I’ll include the R code to do so below if
that is how you’d like to go about it. Due to the weird nature of
`.Rprofile`s, I will create it as `Rprofile` and prepend the period,
once the file has been copied. This will be done later. We will also
have a `test-script.Rmd` which will be opened up once the project is
created.

``` r
# set the dir resource path
template_dir <- "inst/rstudio/templates/project/resources"

# create the resource directory
dir.create(template_dir, recursive = TRUE)

# create the .secrets directory and a fake key
dir.create(file.path(template_dir, ".secrets"))
file.create(file.path(template_dir, ".secrets", "super-fancy-secret-secret.key"))

# create the Rprofile
file.create(file.path(template_dir, "Rprofile"))

# create the test-script.Rmd
file.create(file.path(template_dir, "test-script.Rmd"))
```

### Modifying the `Rprofile` to ease authentication

We want to authenticate automatically without interactivity for
googlesheets4 and also use our own custom theme\! Put something similar
to the below code in your `Rprofile`.

``` r
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = "josiah@example.com"
)
```

I also like having my own custom theme set automatically. So I put this
is in my `Rprofile` as well.

``` r
library(ggplot2)

theme_bari <- function() {
  theme_minimal() +
    theme(
      panel.grid.major.y = element_line(
        size = .75
      ),
      panel.grid = element_line(),
      panel.border = element_rect(size = .5, fill = NA, color = "#524d4d"),
      text = element_text(family = "HelveticaNeue-CondensedBold"),
      plot.title = element_text(color = "#241c1c", size = 22),
      plot.subtitle = element_text(color = "#2e2828", size = 18),
      plot.caption = element_text(
        color = "#524d4d", size = 8,
        hjust = 1,
        margin = margin(t = 10),
        family = "Avenir Next Condensed Medium"
      )
    )
  
}

theme_set(theme_bari())
```

Remember that `Rprofile` will be changed to `.Rprofile` at a later
point.

## Template Creation Function

  - document and build and install the package

In order to have a project template, we need to create a function which
will copy over the files for us. This will be a function we put into our
package. To create the R script we will use, we will use `usethis`. This
will create an R file for us in the `R` directory.

``` r
usethis::use_r("gs4_skeleton")
```

We’re going to create two functions:

1.  A function for finding the template directory. We will call this
    `template_dir()`.
2.  A function for copying the files from the teplate directory to the
    new project path.

Let’s start with the first one. We’re going to using the function
`system.file()` to find the directory within the `gs4template` package.
The dots lets us pass any number of character strings to it.
`system.file()` will put these together into a file path for us.

``` r
template_dir <- function(...) {
  system.file(..., package = "gs4template")
}

template_dir("rstudio", "templates", "project", "resources")
#> [1] "/Users/Josiah/Library/R/3.6/library/gs4template/rstudio/templates/project/resources"
```

Now that we have a function that can tell us where on a system to look
for the files, we can create another function which lists all of the
files we have in our project template and copies them over to the new
project.

The function does a few things internally:

1.  Creates the new directory
2.  Identifies the project template files
3.  Lists all of the files
4.  Creates the full file paths of the template files
5.  Creates file paths for all of the files for where they will end up
    (new project path)
6.  Creates the `.secrets` directory
7.  Copies the files over
8.  Changes the name of the `Rprofile` to `.Rprofile`

<!-- end list -->

``` r
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
```

## Configuring the template for RStudio

Now we’ve got most of the pieces in place\! As mentioned previously, we
need to create a `dcf` to let RStudio know that we’ve created a project
template. This file will live in the `studio/templates/project`
directory.

Name the `.dcf` file something similar to the function or the file used
to copy the files over. In this case, I will name it `gs4_skeleton.dcf`.

``` r
file.create("inst/rstudio/templates/project/gs4_skeleton.dcf")
```

We can open the new `gs4_skeleton.dcf` file and edit a few line. There
are only two mandatory fields we need to fille out `Title` and
`Binding`. We have the option to specify which files are opened once the
project is. If you would like to do this, write them after `OpenFiles:`
separated by commas. We will add the below lines to our dcf file. Note
that the binding has to be the name of the function we used to copy the
files over\!

    Title: googlesheets4 template
    Binding: gs4_skeleton
    OpenFiles: test-script.Rmd

  - Document, build, install, restart R
  - Create a new
    project\!

### Resources:

  - <https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html>
  - <https://www.hvitfeldt.me/blog/usethis-workflow-for-package-development/>
