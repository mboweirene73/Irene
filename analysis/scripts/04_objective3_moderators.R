# 04_objective3_moderators.R
# Objective 3: moderators / mechanisms influencing AI intervention effectiveness.
# Runs meta-regression (metafor mods=) on each candidate moderator, for both
# outcome families, and reports subgroup breakdowns for categorical moderators
# with sufficient k per subgroup (>=4 studies is the usual rule of thumb).

source("analysis/scripts/00_setup.R")
dat <- readRDS(file.path(paths$results_dir, "prepped_data.rds"))

moderators <- c(
  "ai_intervention_type", "ai_adaptivity_level", "feedback_immediacy",
  "personalization_level", "education_level", "subject_domain",
  "duration_weeks", "wwc_rating", "theoretical_mechanism", "publication_year"
)

run_moderator_model <- function(data, outcome_label, moderator) {
  sub <- data %>% filter(!is.na(.data[[moderator]]))
  if (n_distinct(sub[[moderator]]) < 2 || nrow(sub) < 5) {
    cat("Skipping", moderator, "for", outcome_label, "- insufficient variation/data.\n")
    return(NULL)
  }
  form <- as.formula(paste("~", moderator))
  model <- tryCatch(
    rma.mv(
      yi = es_value, V = es_variance,
      mods = form,
      random = ~ 1 | study_id/effect_id,
      data = sub, method = "REML"
    ),
    error = function(e) { message(moderator, ": ", e$message); NULL }
  )
  model
}

results <- list()
for (fam in c("cognitive", "noncognitive")) {
  sub_fam <- dat %>% filter(outcome_family == fam)
  for (mod in moderators) {
    key <- paste(fam, mod, sep = "__")
    results[[key]] <- run_moderator_model(sub_fam, fam, mod)
  }
}

# Print + save non-null results
summary_lines <- c()
for (key in names(results)) {
  if (!is.null(results[[key]])) {
    summary_lines <- c(summary_lines, paste("====", key, "===="))
    summary_lines <- c(summary_lines, capture.output(print(summary(results[[key]]))))
  }
}
writeLines(summary_lines, file.path(paths$results_dir, "objective3_moderator_summaries.txt"))
saveRDS(results, file.path(paths$results_dir, "objective3_moderator_models.rds"))

cat("Objective 3 moderator analysis complete. See results/objective3_moderator_summaries.txt\n")
