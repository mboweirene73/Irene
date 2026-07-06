# Analysis pipeline

Run in order, from the repository root (`Rscript analysis/scripts/0X_....R`), once `data_extraction/extraction_template.csv` has real rows in it:

1. `00_setup.R` — installs/loads `metafor`, `clubSandwich`, `dplyr`, `readr`, `ggplot2`.
2. `01_data_prep.R` — computes Hedges' g + variance per row from whichever raw statistic was extracted (means/SDs, t, or F); writes `results/prepped_data.rds`.
3. `02_objective1_cognitive_model.R` — three-level random-effects model + robust variance estimation for cognitive outcomes.
4. `03_objective2_noncognitive_model.R` — same for non-cognitive outcomes.
5. `04_objective3_moderators.R` — meta-regression per candidate moderator, for both outcome families.
6. `05_publication_bias.R` — funnel plots, Egger's test, trim-and-fill, PET-PEESE.
7. `06_forest_funnel_plots.R` — forest plots for both objective models.

All outputs land in `results/` (models as `.rds`, summaries as `.txt`, plots as `.png`) — nothing in `results/` should be hand-edited; regenerate by re-running the scripts.

These scripts assume the codebook fields in `data_extraction/codebook.md` are followed exactly (column names are hard-coded). If you add moderators or outcome subtypes, update the codebook first, then extend `04_objective3_moderators.R`'s `moderators` vector.
