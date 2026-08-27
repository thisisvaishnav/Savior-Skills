# Pandas Cheat Sheet

## Loading & Inspecting

```python
df = pd.read_csv("data.csv", parse_dates=["created_at"])
df.shape            # (rows, cols)
df.head(10)         # first rows
df.dtypes           # column types
df.describe()       # summary stats
df.info()           # types + non-null counts
df.isna().sum()     # missing values per column
df.duplicated().sum()  # duplicate row count
```

## Cleaning

```python
df = df.copy()
df = df.drop_duplicates()
df["category"] = df["category"].astype("category")
df["value"] = df["value"].fillna(df["value"].median())  # justify imputation choice
df = df[df["value"] >= 0]   # drop invalid rows — state why
```

## Exploration

```python
df["col"].value_counts(normalize=True)          # frequency
df.groupby("group")["value"].agg(["mean", "median", "count"])
df.corr(numeric_only=True)                      # correlations
df["value"].quantile([0.01, 0.25, 0.5, 0.75, 0.99])  # outliers
```

## Quick Plot

```python
df["value"].hist(bins=30)
df.plot.scatter(x="a", y="b")
df.groupby("group")["value"].mean().plot.bar()
```

# Data Cleaning Checklist

- [ ] Loaded raw data — untouched original preserved
- [ ] Checked shape, dtypes, head, and summary stats
- [ ] Quantified missing values; decided drop vs. fill with a stated reason
- [ ] Converted dates/categories to proper types
- [ ] Removed or flagged duplicates
- [ ] Validated ranges and impossible values
- [ ] Documented every transformation in order
