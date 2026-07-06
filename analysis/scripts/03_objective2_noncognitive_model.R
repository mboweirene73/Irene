# 03_objective2_noncognitive_model.R
# Objective 2: pooled effect of AI interventions on NON-COGNITIVE learning
# outcomes (motivation, engagement, self-efficacy, attitudes, anxiety, etc.).
# Same three-level + robust-variance approach as Objective 1, kept as a
# separate model since these outcomes are conceptually distinct.

source("analysis/scripts/00_setup.R")
dat <- readRDS(file.path(paths$results_dir, "prepped_data.rds"))

noncog <- dat %>% filter(outcome_family == "noncognitive")
if (nrow(noncog) == 0) stop("No non-cognitive-outcome effect sizes found yet.")

m2_noncognitive <- rma.mv(
  yi = es_value, V = es_variance,
  random = ~ 1 | study_id/effect_id,
  data = noncog,
  method = "REML"
)
print(summary(m2_noncognitive))

rve_noncognitive <- clubSandwich::coef_test(
  m2_noncognitive, vcov = "CR2", cluster = noncog$study_id
)
print(rve_noncognitive)

i2_noncognitive <- var.comp(m2_noncognitive)
print(i2_noncognitive)

# Optional: subgroup breakdown by outcome_subtype (motivation vs engagement vs
# self-efficacy, etc.) if k is sufficient per subgroup (>=4 studies recommended)
subtype_counts <- noncog %>% count(outcome_subtype, sort = TRUE)
print(subtype_counts)

saveRDS(m2_noncognitive, file.path(paths$results_dir, "model_objective2_noncognitive.rds"))
sink(file.path(paths$results_dir, "objective2_noncognitive_summary.txt"))
print(summary(m2_noncognitive)); print(rve_noncognitive); print(i2_noncognitive); print(subtype_counts)
sink()

cat("Objective 2 model fit on", nrow(noncog), "effect sizes from",
    n_distinct(noncog$study_id), "studies.\n")
