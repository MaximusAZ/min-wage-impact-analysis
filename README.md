# Minimum Wage Impact Analysis

This repository contains the R code and analysis conducted for the study of the impact of New Jersey's 1992 minimum wage increase on employment in the fast-food industry. The analysis uses Difference-in-Differences (DiD), fixed effects models, and other econometric techniques to estimate the Average Treatment Effect on the Treated (ATT).

## Files in the Repository

1. **`analysis.R`**: The complete R script for loading, analyzing, and visualizing the data.
2. **`README.md`**: This file, describing the project structure and analysis steps.

## Objective

The objective is to evaluate the causal impact of the minimum wage increase in New Jersey on employment, using Pennsylvania as the control group. Key methods include:
- Difference-in-Differences (DiD) estimation.
- Adding fixed effects to control for unobserved restaurant-specific characteristics.
- Testing the parallel trends assumption.
- Discussing non-parametric approaches (e.g., random forests).

## Key Results

- **ATT Estimate**: The estimated impact of the minimum wage increase is **7.75**, as shown by both standard DiD and fixed-effects models.
- **Statistical Significance**: The ATT is statistically significant, with a 95% confidence interval of **[4.35, 11.15]**.
- **Robustness**: Fixed effects and parallel trends tests support the validity of the results.

## Steps to Reproduce

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/min-wage-impact-analysis.git
