# Credit_risk_executive_dashboard
An end-to-end data analytics project exploring loan default risks using Python, MySQL, and Tableau to support risk-based pricing strategies.


## 📌 Project Overview
In the banking and lending industry, accurately assessing credit risk is critical for maintaining a healthy loan portfolio. This project is an end-to-end data analytics workflow designed to explore the correlation between borrower characteristics (annual income, loan purpose) and loan performance (default rates). The ultimate goal is to provide data-driven insights that support **Risk-Based Pricing** strategies.

**Live Dashboard:** [https://public.tableau.com/views/CreditRiskExecutiveDashboard/CreditRiskExecutiveDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]

## 🎯 Business Objective
To evaluate whether historical loan data justifies adjusting interest rates based on borrower income bands and credit risk categories, aiming to minimize Non-Performing Loans (NPL) while maximizing profitable lending opportunities.

## 🧰 Tech Stack & Tools
- **Data Extraction (ETL):** Python (Pandas) for filtering and reducing a 1.16 GB raw dataset.
- **Data Storage & Cleaning:** MySQL 8.0 for bulk ingestion, handling missing values, and data type casting.
- **Exploratory Data Analysis (EDA):** MySQL (Aggregations, `CASE WHEN` logic, `GROUP BY`, `HAVING`).
- **Data Visualization & BI:** Tableau Public for building an interactive executive dashboard.

## 📊 Dataset
- **Source:** Lending Club Loan Data
- **Volume:** ~2.26 Million rows
- **Key Features Analyzed:** `loan_status`, `annual_inc`, `int_rate`, `purpose`

## 🛠️ Methodology & Workflow
1. **Extraction:** Used Python to extract 4 essential columns out of 140+ columns from the original 1.16 GB CSV, producing a lightweight 89 MB dataset.
2. **Ingestion & Cleaning (SQL):** 
   - Overcame `secure-file-priv` restrictions and loaded 2.26M rows into MySQL using `LOAD DATA INFILE`.
   - Addressed `Error 1265 (Data Truncated)` by utilizing a `VARCHAR` Staging Table.
   - Cleansed NULL values and cast columns to `FLOAT` for accurate mathematical aggregation.
3. **Data Aggregation (SQL):** 
   - Categorized 9 different loan statuses into a binary "Good Loan" vs. "Bad Loan" metric using `CASE WHEN`.
   - Exported an aggregated summary dataset (`summary_loan_risk.csv`) to optimize visualization performance.
4. **Visualization (Tableau):** Designed an interactive dashboard with calculated fields, dynamic filters, and color-coded risk indicators.

## 💡 Key Business Insights
1. **Income vs. Risk Correlation:** Borrowers in the lowest income bracket (Under $30K) exhibit the highest Bad Loan Rate (15.51%), whereas those earning $150K+ show significantly better repayment behavior (9.29% Bad Loan Rate).
2. **Interest Rate Impact:** High-interest loans (25%+) suffer from a massive default rate of 29.23%. This indicates that while risk-based pricing is active, excessive interest burdens may be accelerating defaults among high-risk borrowers.

## 📁 Repository Structure
- `01_LendingClub_Data_Cleaning_and_EDA.sql` : The SQL script containing table creation, data cleaning, and aggregation logic.
- `summary_loan_risk.csv` : The aggregated, clean dataset used for the Tableau dashboard.
- *(Optional)* `extract_script.py` : Python script used for initial data extraction.
