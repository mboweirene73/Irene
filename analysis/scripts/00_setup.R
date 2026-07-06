# 00_setup.R
# Installs/loads packages needed for the whole pipeline. Run once per machine.

required_packages <- c(
  "metafor",      # core meta-analysis engine (rma.mv, escalc, funnel, regtest)
  "clubSandwich", # robust variance estimation for dependent effect sizes
  "dplyr",        # data wrangling
  "readr",        # csv IO
  "ggplot2",      # plotting (forest/funnel exports)
  "stringr"       # text cleanup during data prep
)

installed <- rownames(installed.packages())
to_install <- setdiff(required_packages, installed)
if (length(to_install) > 0) install.packages(to_install, repos = "https://cloud.r-project.org")

invisible(lapply(required_packages, library, character.only = TRUE))

# Project paths (relative to repo root; run scripts with working dir = repo root)
paths <- list(
  extraction_csv = "data_extraction/extraction_template.csv",
  results_dir    = "results"
)

if (!dir.exists(paths$results_dir)) dir.create(paths$results_dir, recursive = TRUE)

cat("Setup complete. Packages loaded:", paste(required_packages, collapse = ", "), "\n")
