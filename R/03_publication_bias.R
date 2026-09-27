# =============================================================================
# 03_publication_bias.R
# Small-study effects for both main models.
#
# - Funnel plots   -> output/figures/fig7a_funnel_metabolic_syndrome.png/.pdf
#                     output/figures/fig7b_funnel_type2_diabetes.png/.pdf
# - Egger's test   -> output/results/publication_bias.txt
#
# With fewer than 10 studies per outcome, Egger's test is underpowered
# (see egger_k_min in 00_setup.R).
# =============================================================================

source(file.path("R", "00_setup.R"))

m_ms   <- fit_or(read_outcome(sheets$ms))
m_t2dm <- fit_or(read_outcome(sheets$t2dm))

# Figure 7
save_funnel(m_ms,   "fig7a_funnel_metabolic_syndrome", main = "(a) Metabolic syndrome")
save_funnel(m_t2dm, "fig7b_funnel_type2_diabetes",     main = "(b) Type 2 diabetes mellitus")

# Egger's regression test
egger_ms   <- metabias(m_ms,   method.bias = "linreg", k.min = egger_k_min)
egger_t2dm <- metabias(m_t2dm, method.bias = "linreg", k.min = egger_k_min)

save_text("publication_bias", capture.output(
  cat("== Egger's test: metabolic syndrome ==\n"),
  print(egger_ms),
  cat("\n== Egger's test: type 2 diabetes mellitus ==\n"),
  print(egger_t2dm)
))
