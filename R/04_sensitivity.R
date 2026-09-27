# =============================================================================
# 04_sensitivity.R
# Sensitivity analyses for both outcomes.
#
# 1. Restricted study set (non-cross-sectional designs excluded)
#    -> output/figures/figS1_sensitivity_metabolic_syndrome.png/.pdf
#    -> output/figures/figS2_sensitivity_type2_diabetes.png/.pdf
# 2. Leave-one-out analysis (each study omitted in turn)
#    -> output/figures/loo_metabolic_syndrome.png/.pdf
#    -> output/figures/loo_type2_diabetes.png/.pdf
# All model output -> output/results/sensitivity.txt
# =============================================================================

source(file.path("R", "00_setup.R"))

# ---- 1. Restricted study set ------------------------------------------------
ms_sens   <- read_outcome(sheets$ms_sens)
t2dm_sens <- read_outcome(sheets$t2dm_sens)

m_ms_sens   <- fit_or(ms_sens, subgroup = ms_sens$Criteria)
m_t2dm_sens <- fit_or(t2dm_sens)

save_forest(m_ms_sens,   "figS1_sensitivity_metabolic_syndrome", subgroup = TRUE)
save_forest(m_t2dm_sens, "figS2_sensitivity_type2_diabetes")

# ---- 2. Leave-one-out -------------------------------------------------------
m_ms   <- fit_or(read_outcome(sheets$ms))
m_t2dm <- fit_or(read_outcome(sheets$t2dm))

loo_ms   <- metainf(m_ms,   pooled = "random")
loo_t2dm <- metainf(m_t2dm, pooled = "random")

save_plot("loo_metabolic_syndrome", width = 9, height = 2.5 + 0.3 * m_ms$k,
          plot_fun = function() forest(loo_ms, digits = 2))
save_plot("loo_type2_diabetes",     width = 9, height = 2.5 + 0.3 * m_t2dm$k,
          plot_fun = function() forest(loo_t2dm, digits = 2))

# ---- Results ----------------------------------------------------------------
save_text("sensitivity", capture.output(
  cat("== Restricted set: metabolic syndrome ==\n"),
  summary(m_ms_sens),
  cat("\n== Restricted set: type 2 diabetes mellitus ==\n"),
  summary(m_t2dm_sens),
  cat("\n== Leave-one-out: metabolic syndrome ==\n"),
  print(loo_ms),
  cat("\n== Leave-one-out: type 2 diabetes mellitus ==\n"),
  print(loo_t2dm)
))
