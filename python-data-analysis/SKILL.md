---
name: python-data-analysis
description: Working with data in Python using pandas, numpy, and matplotlib — loading, cleaning, exploring, and visualizing datasets. Use when a task involves analyzing CSV/JSON data, computing statistics, or producing charts.
---

# Python Data Analysis

## Standard Workflow

1. **Load & inspect.** Read data with `pandas`, then immediately check `df.shape`, `df.head()`, `df.dtypes`, and `df.describe()`.
2. **Clean.**
   - Handle missing values explicitly (`isna().sum()` first; never silently drop or fill).
   - Fix dtypes (dates to `datetime`, categories to `category`).
   - Deduplicate and validate value ranges.
3. **Explore.** Distributions, correlations (`df.corr(numeric_only=True)`), groupby aggregations, and outlier checks.
4. **Analyze.** State the question, compute the answer, and sanity-check the result against a known subset.
5. **Visualize.** Use `matplotlib` for charts; always label axes and title figures.
6. **Report.** Summarize findings with the specific numbers and code that produced them.

## Conventions

- Assume `pandas as pd`, `numpy as np`, and `matplotlib.pyplot as plt` imports.
- Prefer vectorized operations over Python loops.
- Never modify the raw source data — work on copies (`df.copy()`).
- Seed any randomness (`np.random.seed(42)`) so results are reproducible.

## References

- See `references/` for a pandas cheat sheet and data-cleaning checklist.
