# 05_publication_bias.R
# Publication bias diagnostics for Objective 1 and Objective 2 models.
# Note: funnel-plot-based methods (Egger's test, trim-and-fill) assume
# independent effect sizes; metafor's regtest/trimfill work on rma() fits.
# Here we fit an aggregate (mean-per-study) rma() alongside the rma.mv model
# specifically for these diagnostics, and report both as recommended practice
# when the primary model is multilevel (Fernandez-Castilla et al., 2021).

source("analysis/scripts/00_setup.R")
dat <- readRDS(file.path(paths$results_dir, "prepped_data.rds"))

run_bias_diagnostics <- function(data, label) {
  # Aggregate to one effect size per study (simple mean) for funnel/Egger/trim-fill
  agg <- aggregate(data, cluster = study_id, struct = "ID")
  simple_model <- rma(yi = es_value, vi = es_variance, data = agg, method = "REML")

  png(file.path(paths$results_dir, paste0("funnel_", label, ".png")), width = 800, height = 600)
  funnel(simple_model, main = paste("Funnel plot -", label))
  dev.off()

  egger <- regtest(simple_model, model = "lm")
  trimfill_result <- trimfill(simple_model)

  # PET-PEESE: regress effect size on SE (PET) and SE^2 (PEESE)
  pet <- lm(es_value ~ sqrt(es_variance), data = agg, weights = 1 / es_variance)
  peese <- lm(es_value ~ es_variance, data = agg, weights = 1 / es_variance)

  list(
    simple_model = simple_model,
    egger = egger,
    trimfill = trimfill_result,
    pet = summary(pet),
    peese = summary(peese)
  )
}

cog <- dat %>% filter(outcome_family == "cognitive")
noncog <- dat %>% filter(outcome_family == "noncognitive")

bias_cognitive <- if (nrow(cog) > 0) run_bias_diagnostics(cog, "objective1_cognitive") else NULL
bias_noncognitive <- if (nrow(noncog) > 0) run_bias_diagnostics(noncog, "objective2_noncognitive") else NULL

sink(file.path(paths$results_dir, "publication_bias_summary.txt"))
cat("=== Objective 1 (cognitive) ===\n")
if (!is.null(bias_cognitive)) {
  print(bias_cognitive$egger); print(bias_cognitive$trimfill)
  print(bias_cognitive$pet); print(bias_cognitive$peese)
}
cat("\n=== Objective 2 (non-cognitive) ===\n")
if (!is.null(bias_noncognitive)) {
  print(bias_noncognitive$egger); print(bias_noncognitive$trimfill)
  print(bias_noncognitive$pet); print(bias_noncognitive$peese)
}
sink()

cat("Publication bias diagnostics saved to results/publication_bias_summary.txt and funnel_*.png\n")
