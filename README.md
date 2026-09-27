# ART regimens and metabolic outcomes in people living with HIV: systematic review and meta-analysis

[![DOI](https://img.shields.io/badge/DOI-10.1111%2Fhiv.70260-blue)](https://doi.org/10.1111/hiv.70260)
[![PROSPERO](https://img.shields.io/badge/PROSPERO-CRD42024540553-green)](https://www.crd.york.ac.uk/prospero/display_record.php?RecordID=540553)
![R](https://img.shields.io/badge/R-4.4.1-276DC3)
[![License: MIT](https://img.shields.io/badge/code-MIT-lightgrey)](LICENSE)

Analysis code for:

> **Mahanani MR**, Chit M, Mohr S, Cama i Gibernau E, Hetjens S, Winkler V, Steffen HM, Neuhann F.
> Temporal shifts in antiretroviral therapy regimens and metabolic outcomes in people living with HIV:
> A systematic review and meta-analysis. *HIV Medicine*. 2026. https://doi.org/10.1111/hiv.70260

## Summary

We systematically reviewed non-randomised observational studies comparing ART-treated and ART-naïve
adults living with HIV, and pooled the odds of metabolic outcomes using random-effects meta-analysis.
Temporal patterns in ART classes and reported outcomes were summarised by publication year.

| | |
|---|---|
| Records screened | 5,942 (after deduplication) |
| Studies included | 39 (24,632 people living with HIV, 1998–2025) |
| Metabolic syndrome | 6 studies · pooled OR 2.16 (95% CI 1.33–3.52) · I² = 79.6% |
| Type 2 diabetes | 5 studies · pooled OR 1.37 (95% CI 0.65–2.90) · I² = 69.2% |
| Certainty of evidence (GRADE) | Low |

<!-- Optional: to show the forest plot here, upload the PNG to a folder such as docs/
     (output/ is git-ignored) and link it, e.g. ![Forest plot](docs/fig5_forest_metabolic_syndrome.png) -->

## Repository structure

```
├── R/
│   ├── 00_setup.R                # packages, paths, settings, helper functions
│   ├── 01_metabolic_syndrome.R   # meta-analysis + forest plot (Fig. 5)
│   ├── 02_type2_diabetes.R       # meta-analysis + forest plot (Fig. 6)
│   ├── 03_publication_bias.R     # funnel plots (Fig. 7), Egger's test
│   └── 04_sensitivity.R          # restricted study set (Fig. S1-S2), leave-one-out
├── data/
│   ├── codebook.md               # expected input: sheets and columns
│   └── extraction_template.xlsx  # empty template with the same layout
├── output/
│   ├── figures/                  # PNG (300 dpi) and PDF figures
│   └── results/                  # model summaries as text files
├── run_all.R                     # runs all scripts in order
├── art-metabolic-meta-analysis.Rproj
└── CITATION.cff
```

## Running the analysis

The extracted dataset is not included in this repository (see [Data](#data)). To run the code:

1. Open `art-metabolic-meta-analysis.Rproj` in RStudio, so paths resolve from the project folder.
2. Install the packages: `install.packages(c("meta", "readxl"))`
3. Save the dataset as `data/extraction_counts.xlsx`, in the layout described in
   [`data/codebook.md`](data/codebook.md).
4. Run everything with `source("run_all.R")`, or run a single script from `R/`.

Figures are written to `output/figures/` and model output to `output/results/`.

## Methods in brief

- **Protocol:** PROSPERO CRD42024540553; reported following PRISMA
- **Databases:** PubMed/MEDLINE, CINAHL, Academic Search Complete, ProQuest, Web of Science,
  WHO Global Health Library, Global Index Medicus (inception to 31 March 2025)
- **Effect measure:** study-specific odds ratios from 2×2 counts, pooled with a random-effects model
  (fixed-effect for comparison); heterogeneity by χ² and I²
- **Robustness:** leave-one-out analysis; restriction to cross-sectional designs
- **Publication bias:** funnel plots and Egger's regression test
- **Risk of bias:** ROBINS-I v2, visualised with `robvis`; certainty rated with GRADE
- **Software:** R 4.4.1, `meta` (analyses), `robvis` (risk-of-bias figures)

## Data

This repository contains code only. The analyses used aggregate study-level counts extracted
from the 39 published studies cited in the paper; no individual participant data were
collected or used. As stated in the article, the extracted dataset is available from the
corresponding author upon reasonable request. The expected input format is documented in
[`data/codebook.md`](data/codebook.md) and [`data/extraction_template.xlsx`](data/extraction_template.xlsx).

## Citation

If you use this code, please cite the paper above. GitHub's **"Cite this repository"**
button provides the reference in APA and BibTeX format.

## License

Code: MIT.
