# Data Source

This project uses the **UCI Online Retail Dataset**.

## Download the Dataset

The dataset can be downloaded from:
- [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail)
- [Kaggle](https://www.kaggle.com/datasets/lakshmi25npathi/online-retail-dataset)

## Dataset Details

- **Size:** 1,067,372 rows
- **Period:** December 2010 - December 2011
- **Columns:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

## Setup Instructions

1. Download the CSV file from one of the sources above
2. Import into SQL Server using the schema defined in the project
3. Run the SQL scripts in order:
   - `01_data_cleaning.sql`
   - `02_rfm_calculation.sql`
   - `03_customer_segmentation.sql`