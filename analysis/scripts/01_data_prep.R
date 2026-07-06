# 01_data_prep.R
# Reads the populated extraction sheet, computes Hedges' g + variance per row
# from whichever raw statistic is available, and saves a cleaned dataset for
# the objective-specific model scripts.

source("analysis/scripts/00_setup.R")

dat <- read_csv(paths$extraction_csv, show_col_types = FALSE)

if (nrow(dat) == 0) {
  stop("extraction_template.csv has no data rows yet. Populate it via the ",
       "screening + data-extraction pipeline before running this script.")
}

# --- Compute effect sizes row-by-row based on which raw stat is reported ---
# Rows with means_sd: standard SMD-from-means-and-SDs formula (bias-corrected -> Hedges' g)
means_sd_rows <- dat %>% filter(stat_type_reported == "means_sd")
es_means_sd <- escalc(
  measure = "SMD",
  m1i = mean_treatment, sd1i = sd_treatment, n1i = n_treatment,
  m2i = mean_control,   sd2i = sd_control,   n2i = n_control,
  data = means_sd_rows
)

# Rows reported only as t-values: convert via metafor's SMD-from-t formula
t_rows <- dat %>% filter(stat_type_reported == "t_value")
es_t <- escalc(
  measure = "SMD",
  ti = t_or_f_value, n1i = n_treatment, n2i = n_control,
  data = t_rows
)

# F-values (2-group ANOVA F == t^2): take sqrt(F) as |t| before conversion.
# Sign must be checked manually against reported direction of effect (see `notes` column).
f_rows <- dat %>% filter(stat_type_reported == "f_value")
if (nrow(f_rows) > 0) {
  f_rows <- f_rows %>% mutate(t_or_f_value = sqrt(t_or_f_value))
  es_f <- escalc(
    measure = "SMD",
    ti = t_or_f_value, n1i = n_treatment, n2i = n_control,
    data = f_rows
  )
} else {
  es_f <- f_rows
}

# Correlation-reported outcomes handled separately if/when needed (measure = "COR" / "ZCOR");
# not populated by default — extend here if primary studies report r-based outcomes only.

dat_prepped <- bind_rows(es_means_sd, es_t, es_f) %>%
  rename(es_value = yi, es_variance = vi) %>%
  mutate(es_metric = "hedges_g")

saveRDS(dat_prepped, file.path(paths$results_dir, "prepped_data.rds"))
write_csv(dat_prepped, file.path(paths$results_dir, "prepped_data.csv"))

cat("Prepped", nrow(dat_prepped), "effect sizes from", n_distinct(dat_prepped$study_id), "studies.\n")
cat("Cognitive (Obj 1):", sum(dat_prepped$outcome_family == "cognitive", na.rm = TRUE), "\n")
cat("Non-cognitive (Obj 2):", sum(dat_prepped$outcome_family == "noncognitive", na.rm = TRUE), "\n")
