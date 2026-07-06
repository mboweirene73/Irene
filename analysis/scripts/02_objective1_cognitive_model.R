# 02_objective1_cognitive_model.R
# Objective 1: pooled effect of AI interventions on COGNITIVE learning outcomes.
# Three-level random-effects model (effect sizes nested in studies) with
# robust variance estimation as a check on the dependency structure.

source("analysis/scripts/00_setup.R")
dat <- readRDS(file.path(paths$results_dir, "prepped_data.rds"))

cog <- dat %>% filter(outcome_family == "cognitive")
if (nrow(cog) == 0) stop("No cognitive-outcome effect sizes found yet.")

# Three-level model: level 2 = effect sizes within study, level 3 = between studies
m1_cognitive <- rma.mv(
  yi = es_value, V = es_variance,
  random = ~ 1 | study_id/effect_id,
  data = cog,
  method = "REML"
)
print(summary(m1_cognitive))

# Robust variance estimation (cluster = study_id) as a check on the multilevel model
rve_cognitive <- clubSandwich::coef_test(
  m1_cognitive, vcov = "CR2", cluster = cog$study_id
)
print(rve_cognitive)

# Heterogeneity breakdown by level (I^2 at each level, per Cheung 2014 decomposition)
i2_cognitive <- var.comp(m1_cognitive)
print(i2_cognitive)

saveRDS(m1_cognitive, file.path(paths$results_dir, "model_objective1_cognitive.rds"))
sink(file.path(paths$results_dir, "objective1_cognitive_summary.txt"))
print(summary(m1_cognitive)); print(rve_cognitive); print(i2_cognitive)
sink()

cat("Objective 1 model fit on", nrow(cog), "effect sizes from",
    n_distinct(cog$study_id), "studies.\n")
