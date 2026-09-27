# =============================================================================
# 01_metabolic_syndrome.R
# Meta-analysis of metabolic syndrome prevalence, ART-treated vs ART-naive.
#
# - Random-effects model (main analysis), subgrouped by diagnostic criteria
# - Common-effect model for comparison
# - Forest plot  -> output/figures/fig5_forest_metabolic_syndrome.png/.pdf
# - Model output -> output/results/metabolic_syndrome.txt
# =============================================================================

source(file.path("R", "00_setup.R"))

ms <- read_outcome(sheets$ms)

# Main model: random effects, subgroups by diagnostic criteria (IDF, NCEP ATP III)
m_ms <- fit_or(ms, subgroup = ms$Criteria)

# Same model with the common-effect estimate added, for comparison
m_ms_both <- update(m_ms, common = TRUE)

save_text("metabolic_syndrome", capture.output(
  cat("Studies per diagnostic criterion\n"),
  print(table(ms$Criteria)),
  cat("\n== Random- and common-effect models, subgrouped by criteria ==\n"),
  summary(m_ms_both)
))

# Figure 5
save_forest(m_ms, "fig5_forest_metabolic_syndrome", subgroup = TRUE)
