# =============================================================================
# run_all.R
# Runs the complete analysis in order. Run from the project root.
# Figures go to output/figures/, model output to output/results/.
# =============================================================================

scripts <- c(
  "R/01_metabolic_syndrome.R",
  "R/02_type2_diabetes.R",
  "R/03_publication_bias.R",
  "R/04_sensitivity.R"
)

for (s in scripts) {
  message("\n>>> Running ", s)
  source(s, local = new.env())
}

writeLines(capture.output(sessionInfo()), file.path("output", "results", "session_info.txt"))
message("\nDone.")
