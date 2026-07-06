# 06_forest_funnel_plots.R
# Generates forest plots for Objective 1 and Objective 2 models (funnel plots
# are already produced by 05_publication_bias.R). Saves PNGs to results/.

source("analysis/scripts/00_setup.R")

m1 <- readRDS(file.path(paths$results_dir, "model_objective1_cognitive.rds"))
m2 <- readRDS(file.path(paths$results_dir, "model_objective2_noncognitive.rds"))

png(file.path(paths$results_dir, "forest_objective1_cognitive.png"), width = 900, height = 1200)
forest(m1, slab = paste(m1$data$study_id, m1$data$outcome_subtype, sep = " - "),
       main = "Objective 1: AI Interventions -> Cognitive Learning Outcomes")
dev.off()

png(file.path(paths$results_dir, "forest_objective2_noncognitive.png"), width = 900, height = 1200)
forest(m2, slab = paste(m2$data$study_id, m2$data$outcome_subtype, sep = " - "),
       main = "Objective 2: AI Interventions -> Non-Cognitive Learning Outcomes")
dev.off()

cat("Forest plots saved to results/forest_objective1_cognitive.png and results/forest_objective2_noncognitive.png\n")
