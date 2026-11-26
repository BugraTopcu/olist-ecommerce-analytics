# Olist E-Commerce Sales & Customer Analytics

An end-to-end data analytics project analysing approximately 100,000 Brazilian e-commerce orders using SQL, Python and Power BI to identify revenue trends, customer retention challenges and the relationship between delivery performance and customer satisfaction.

## Business Objective

The objective of this project is to answer three key business questions:

- How has Olist's sales performance developed over time?
- How effectively does Olist retain its customers?
- How is delivery performance associated with customer satisfaction, and where should operational improvements be prioritised?

## Key Findings

- **Revenue growth:** Monthly revenue increased by 672.6% between January 2017 and August 2018, reaching a peak of R$1.15 million in November 2017, coinciding with Black Friday.
- **Low customer retention:** Approximately 3% of customers made a repeat purchase, indicating a heavy reliance on new customer acquisition.
- **Delivery performance:** Late deliveries received an average review score of 2.57/5, compared with 4.29/5 for on-time deliveries — a difference of 1.72 stars (p < 0.001).
- **Customer dissatisfaction:** Late deliveries were approximately 5.9 times as likely to receive a 1–2 star review as on-time deliveries.
- **Regional delivery challenges:** Alagoas (23.87%), Maranhão (19.55%) and Piauí (15.97%) recorded the highest late delivery rates among states with at least 100 eligible orders.

## Power BI Dashboard

The interactive Power BI report consists of three pages covering sales performance, customer behaviour and operational efficiency.

### 1. Executive Overview

- Revenue, orders, average order value and customer KPIs
- Monthly revenue trends
- Top 10 product categories by revenue
- Geographic distribution of customers
- Interactive year filter

![Executive Overview](dashboard/executive_overview.png)

### 2. Customer Analytics

- RFM customer segmentation
- Customer spending by segment
- Monthly cohort retention analysis
- Repeat customer rate

![Customer Analytics](dashboard/customers.png)

### 3. Delivery & Reviews

- Average review scores by delivery status
- Late delivery rates by Brazilian state
- Monthly delivery performance trends
- Statistical findings on customer satisfaction

![Delivery and Reviews](dashboard/delivery_reviews.png)

[Download the Power BI dashboard](dashboard/olist_dashboard.pbix)

## Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL (DuckDB) | Data cleaning, transformation, modelling and business analysis |
| Python | Statistical analysis and data manipulation |
| Pandas | Data processing |
| SciPy | Statistical hypothesis testing |
| Power BI | Interactive dashboards and data visualisation |
| DAX | Dynamic business metrics and KPIs |
| Jupyter Notebook | Exploratory analysis and reproducibility |
| Git & GitHub | Version control and project documentation |

## Dataset

The project uses the publicly available Brazilian E-Commerce Public Dataset by Olist, containing approximately 100,000 orders placed between 2016 and 2018.

The dataset includes customer, order, product, payment, review, seller and geographic information.

**Source:** [Olist Brazilian E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Data Model

The raw relational data was transformed into a star schema consisting of four dimension tables and two fact tables.

### Dimension Tables

- `dim_customer` — Unique customers and geographic information
- `dim_product` — Product information and categories
- `dim_seller` — Seller information
- `dim_date` — Calendar attributes for time-based analysis

### Fact Tables

- `fact_orders` — Order-level revenue, delivery performance and review scores
- `fact_order_items` — Item-level sales, product and seller information

Separate fact tables preserve the correct level of granularity and prevent duplicated order-level metrics.

Additional analytical tables were created for RFM segmentation and cohort retention.

![Data Model](dashboard/data_model.png)

## Data Quality & Cleaning

The following data quality issues were identified and addressed:

- Duplicate order reviews: retained the latest review per order.
- Customer identifier inconsistencies: used `customer_unique_id` to identify individual customers.
- Non-delivered orders: excluded from delivered-order revenue calculations.
- Missing delivery dates: excluded from delivery performance calculations.
- Missing product categories: classified as unknown.
- Incomplete reporting months: restricted monthly trend analysis to January 2017–August 2018.
- Geographic inconsistencies: filtered invalid coordinates and aggregated geolocation data by postal code prefix.

Detailed documentation is available in the [Data Quality Log](docs/data_quality_log.md).

## Analytical Methodology

The project includes eight SQL-based business analyses:

1. Monthly revenue, order volume and average order value
2. Month-over-month revenue growth
3. Product category revenue and Pareto analysis
4. Repeat customer rate
5. RFM customer segmentation
6. Cohort retention analysis
7. Relationship between delivery delays and customer reviews
8. Regional delivery performance

Statistical hypothesis testing was conducted using the Mann–Whitney U test and chi-square test to evaluate differences in customer reviews between late and on-time deliveries.

## Business Recommendations

1. **Prioritise regional logistics improvements:** Investigate delivery bottlenecks in Alagoas, Maranhão and Piauí.
2. **Improve delivery estimates:** Use historical delivery performance to provide more realistic promised delivery dates.
3. **Increase customer retention:** Introduce targeted second-purchase campaigns for newly acquired customers.

A one-page executive memo summarising the findings and recommendations is available below:

[Read the Executive Memo (PDF)](docs/memo.pdf)

## How to Run the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/BugraTopcu/olist-ecommerce-analytics.git
   cd olist-ecommerce-analytics
   ```

2. Download the Olist dataset from Kaggle and place the CSV files in `data/raw/`.

3. Install the required Python libraries:

   ```bash
   pip install duckdb pandas scipy jupyter ipykernel
   ```

4. Open the analysis notebook and execute the SQL scripts in the following order:

   - `01_load_raw.sql`
   - `02_quality_checks.sql`
   - `03_star_schema.sql`
   - `04_analysis.sql`
   - `06_customer_geo.sql`
   - `05_export.sql`

5. Import the exported CSV files into Power BI or open the existing Power BI dashboard.

## Repository Structure

```text
olist-ecommerce-analytics/
├── data/
│   ├── raw/
│   └── export/
├── sql/
│   ├── 01_load_raw.sql
│   ├── 02_quality_checks.sql
│   ├── 03_star_schema.sql
│   ├── 04_analysis.sql
│   ├── 05_export.sql
│   └── 06_customer_geo.sql
├── notebooks/
├── dashboard/
│   ├── olist_dashboard.pbix
│   ├── executive_overview.png
│   ├── customers.png
│   ├── delivery_reviews.png
│   └── data_model.png
├── docs/
│   ├── data_quality_log.md
│   ├── findings.md
│   ├── memo.md
│   └── memo.pdf
├── .gitignore
└── README.md
```

Raw data, generated CSV exports and local database files are excluded from version control.

## Limitations

- The dataset covers Brazil between 2016 and 2018 and may not reflect current market conditions.
- Review scores may also be influenced by product quality, seller performance and customer service.
- Statistical associations do not establish causation.
- Customer retention estimates are limited by the available observation period.
- Regional comparisons exclude states with fewer than 100 eligible orders.

## About the Project

This independent portfolio project demonstrates practical skills in SQL, Python, data cleaning, dimensional modelling, statistical analysis, customer segmentation, business intelligence and data storytelling.