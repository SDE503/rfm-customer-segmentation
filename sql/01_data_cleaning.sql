/*
=================================================================
UCI Online Retail Dataset - Data Cleaning Script
=================================================================
Author: Sherif Ejiwunmi
Date: Mar 2026
Dataset: UCI Online Retail Dataset

CLEANING STEPS:
1. Remove NULL CustomerIDs (required for RFM)
2. Remove invalid prices and quantities
3. Remove non-product stock codes
4. Flag cancellations for analysis

RESULT: ~820K clean transactions from 5,894 customers
=================================================================
*/

CREATE VIEW vw_OnlineRetail_Cleaned AS
SELECT 
    InvoiceNo,
    CASE 
        WHEN InvoiceNo LIKE 'C%' THEN 1 
        ELSE 0 
    END AS IsCancellation,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    Quantity * UnitPrice AS TotalSales,
    CustomerID,
    Country
FROM OnlineRetail
WHERE 1=1
    AND CustomerID IS NOT NULL
    AND UnitPrice > 0
    AND Quantity != 0
    AND Description IS NOT NULL
    AND StockCode NOT IN ('POST', 'D', 'C2', 'M', 'BANK CHARGES', 'AMAZONFEE', 'PADS', 'DOT');