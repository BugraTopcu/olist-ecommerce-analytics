
# Olist Data Quality Log

## Data Quality Findings

| Check | Found | Decision |
|---|---|---|
| Duplicate reviews per order | ___ orders | Keep latest review per order |
| Non-delivered orders | ___ orders | Exclude from revenue; keep in order counts by status |
| Delivered but no delivery date | ___ orders | Exclude from delivery analysis only |
| Thin months at start/end | ___ months | Use Jan 2017 – Aug 2018 for trends |
| Products with no category | ___ products | Label them `unknown` |
| customer_id vs real customers | ___ vs ___ | Use `customer_unique_id` for distinct customer counts |

## Additional Validation

- Row counts checked: ___
- Unique order IDs: ___
- Duplicate order IDs: ___

