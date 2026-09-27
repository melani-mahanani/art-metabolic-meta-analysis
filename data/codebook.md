# Codebook

The extracted dataset is **not included** in this repository. It is available from the
corresponding author on reasonable request.

The scripts expect one Excel file, `data/extraction_counts.xlsx`, with four sheets.
`extraction_template.xlsx` in this folder has the same sheets and columns, without data.

## Sheets

| Sheet | Content | Used in |
|---|---|---|
| `ms` | Metabolic syndrome, all eligible studies | `01_metabolic_syndrome.R`, `03_publication_bias.R`, `04_sensitivity.R` (leave-one-out) |
| `t2dm_after_review` | Type 2 diabetes mellitus, all eligible studies | `02_type2_diabetes.R`, `03_publication_bias.R`, `04_sensitivity.R` (leave-one-out) |
| `ms_sens_after_review2` | Metabolic syndrome, restricted study set for sensitivity analysis | `04_sensitivity.R` |
| `t2dm_sens_after_review` | Type 2 diabetes mellitus, restricted study set for sensitivity analysis | `04_sensitivity.R` |

Sheet names are set in one place, `R/00_setup.R` (`sheets`).

## Columns (one row per study)

| Column | Type | Description |
|---|---|---|
| `Studie` | text | Study label shown in plots, e.g. `Tesfaye et al. 2014` |
| `event1` | number | Participants with the outcome, ART-treated group |
| `total1` | number | Total participants, ART-treated group |
| `event2` | number | Participants with the outcome, ART-naïve group |
| `total2` | number | Total participants, ART-naïve group |
| `Combination` | text | ART combination, e.g. `2 NRTIs + 1 NNRTI` |
| `Criteria` | text | Diagnostic criteria for metabolic syndrome, e.g. `IDF`, `NCEP ATP III` (metabolic syndrome sheets) |

Event counts are rounded to whole numbers on import, because some were derived from
reported percentages.
