# =============================================================================
# 02_type2_diabetes.R
# Meta-analysis of type 2 diabetes prevalence, ART-treated vs ART-naive.
#
# - Random-effects model (main analysis)
# - Common-effect model for comparison
# - Subgroups by ART combination, only if at least two combinations are present
# - Forest plot  -> output/figures/fig6_forest_type2_diabetes.png/.pdf
# - Model output -> output/results/type2_diabetes.txt
# =============================================================================

source(file.path("R", "00_setup.R"))

t2dm <- read_outcome(sheets$t2dm)

# Main model: random effects
m_t2dm <- fit_or(t2dm)

# Same model with the common-effect estimate added, for comparison
m_t2dm_both <- update(m_t2dm, common = TRUE)

# Subgroups by ART combination (skipped when all studies share one combination)
n_combinations <- length(unique(t2dm$Combination))
m_t2dm_regimen <- if (n_combinations > 1) fit_or(t2dm, subgroup = t2dm$Combination)

save_text("type2_diabetes", capture.output(
  cat("Studies per ART combination\n"),
  print(table(t2dm$Combination)),
  cat("\n== Random- and common-effect models ==\n"),
  summary(m_t2dm_both),
  if (!is.null(m_t2dm_regimen)) {
    cat("\n== Random-effects model, subgrouped by ART combination ==\n")
    summary(m_t2dm_regimen)
  }
))

# Figure 6
save_forest(m_t2dm, "fig6_forest_type2_diabetes")
