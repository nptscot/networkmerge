if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Set target options:
pkgs = packages = c(
  "rmarkdown",
  "tidyverse",
  "geos",
  "rmapshaper"
)
remotes::install_cran(pkgs)

if(TRUE){ # Repeated builds can it GitHub API limit, set to TRUE to check for package updates
  remotes::install_dev("rsgeo")
  install.packages('rsgeo', repos = c('https://josiahparry.r-universe.dev', 'https://cloud.r-project.org'))
}
