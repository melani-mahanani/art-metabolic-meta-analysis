# =============================================================================
# 00_setup.R
# Shared settings and helper functions, sourced by every analysis script.
#
# Project : ART regimens and metabolic outcomes in people living with HIV
# Paper   : Mahanani MR et al. HIV Medicine 2026. doi:10.1111/hiv.70260
#
# All paths are relative to the project root. Open the .Rproj file in RStudio
# (or setwd() to the repository folder) before running any script.
# =============================================================================

suppressPackageStartupMessages({
  library(meta)
  library(readxl)
})

# ---- Paths ------------------------------------------------------------------
# The extracted dataset is not part of the public repository. Place your copy
# at the path below; the expected layout is described in data/codebook.md.
data_file   <- file.path("data", "extraction_counts.xlsx")
fig_dir     <- file.path("output", "figures")
results_dir <- file.path("output", "results")

# Sheet names inside the data file
sheets <- list(
  ms        = "ms",                     # metabolic syndrome, all studies
  t2dm      = "t2dm_after_review",      # type 2 diabetes, all studies
  ms_sens   = "ms_sens_after_review2",  # metabolic syndrome, sensitivity set
  t2dm_sens = "t2dm_sens_after_review"  # type 2 diabetes, sensitivity set
)

if (!file.exists(data_file)) {
  stop("Data file not found: ", data_file,
       "\nRun the scripts from the project root and see data/codebook.md.",
       call. = FALSE)
}
dir.create(fig_dir,     recursive = TRUE, showWarnings = FALSE)
dir.create(results_dir, recursive = TRUE, showWarnings = FALSE)

# ---- Analysis settings ------------------------------------------------------
label_art   <- "ART"
label_naive <- "Naïve"

# Egger's test: meta::metabias() skips the test when k < 10 (default k.min).
# Each outcome here has 5-6 studies, so the threshold is lowered to run the
# test; results are underpowered and are reported as such in the paper.
egger_k_min <- 3

# ---- Helper functions -------------------------------------------------------

#' Read one outcome sheet and round event counts to whole numbers
#' (some counts were derived from reported percentages).
read_outcome <- function(sheet) {
  d <- read_excel(data_file, sheet = sheet)
  required <- c("Studie", "event1", "total1", "event2", "total2")
  missing  <- setdiff(required, names(d))
  if (length(missing) > 0) {
    stop("Sheet '", sheet, "' is missing columns: ",
         paste(missing, collapse = ", "), call. = FALSE)
  }
  d$event1 <- round(d$event1)
  d$event2 <- round(d$event2)
  d
}

#' Random-effects meta-analysis of odds ratios (ART-treated vs ART-naive).
#' Inverse-variance pooling, REML estimate of between-study variance.
#' Pass `subgroup` as a column of `data` (e.g. data$Criteria) or leave NULL.
fit_or <- function(data, subgroup = NULL) {
  args <- list(
    event.e = data$event1, n.e = data$total1,
    event.c = data$event2, n.c = data$total2,
    studlab = data$Studie,
    sm = "OR", method = "Inverse", method.tau = "REML",
    common = FALSE, random = TRUE
  )
  if (!is.null(subgroup)) args$subgroup <- subgroup
  do.call(metabin, args)
}

#' Save a base-graphics or grid plot as both PNG (300 dpi) and PDF.
#' `plot_fun` is a function with no arguments that draws the plot.
save_plot <- function(name, plot_fun, width = 7, height = 6) {
  png(file.path(fig_dir, paste0(name, ".png")),
      width = width, height = height, units = "in", res = 300)
  plot_fun()
  dev.off()

  pdf(file.path(fig_dir, paste0(name, ".pdf")), width = width, height = height)
  plot_fun()
  dev.off()

  message("Saved: ", file.path(fig_dir, name), ".png / .pdf")
}

#' Forest plot in RevMan5 layout, sized to the number of rows.
save_forest <- function(m, name, subgroup = FALSE, width = 11, ...) {
  n_sub  <- if (subgroup && !is.null(m$subgroup)) length(unique(m$subgroup)) else 0
  height <- 2.5 + 0.28 * (m$k + 4 * n_sub)
  save_plot(name, width = width, height = height, plot_fun = function() {
    forest(m,
           layout      = "RevMan5",
           digits      = 2,
           label.e     = label_art,
           label.c     = label_naive,
           text.random = "Random-effects model",
           subgroup    = subgroup,
           print.subgroup.labels = subgroup,
           ...)
  })
}

#' Funnel plot on the odds-ratio scale.
save_funnel <- function(m, name, main = NULL) {
  save_plot(name, width = 7, height = 6, plot_fun = function() {
    funnel(m,
           xlab       = "Odds ratio",
           backtransf = TRUE,
           cex        = 1.2,
           cex.axis   = 1.2,
           cex.lab    = 1.4)
    if (!is.null(main)) title(main = main, cex.main = 1.4)
  })
}

#' Write captured console output to a text file in output/results/.
#' Use as: save_text("name", capture.output(summary(m), ...))
save_text <- function(name, lines) {
  file <- file.path(results_dir, paste0(name, ".txt"))
  writeLines(lines, file)
  message("Saved: ", file)
}
