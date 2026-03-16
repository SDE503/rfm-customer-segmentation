/*
=================================================================
Customer Segmentation - Final RFM Table
=================================================================
Creates 11 customer segments based on RFM scores + Other
Output: Customer_RFM_Segmentation table
=================================================================
*/

DROP TABLE IF EXISTS Customer_RFM_Segmentation;

WITH CustomerRFM AS (
    SELECT 
        CustomerID,
        DATEDIFF(DAY, MAX(InvoiceDate), '2011-12-09') AS Recency,
        MAX(InvoiceDate) AS Last_Purchase_Date,
        MIN(InvoiceDate) AS First_Purchase_Date,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(TotalSales) AS Monetary,
        MAX(Country) AS Country
    FROM vw_OnlineRetail_Cleaned
    WHERE IsCancellation = 0
    GROUP BY CustomerID
),
RFM_Scores AS (
    SELECT 
        CustomerID,
        Recency,
        Last_Purchase_Date,
        First_Purchase_Date,
        Frequency,
        Monetary,
        Country,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CustomerRFM
)
SELECT 
    CustomerID,
    Recency,
    Last_Purchase_Date,
    First_Purchase_Date,
    Frequency,
    Monetary,
    Country,
    R_Score,
    F_Score,
    M_Score,
    CAST(R_Score AS VARCHAR) + CAST(F_Score AS VARCHAR) + CAST(M_Score AS VARCHAR) AS RFM_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 4 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score >= 2 AND F_Score <= 3 THEN 'Potential Loyalists'
        WHEN R_Score >= 4 AND F_Score <= 2 THEN 'Recent Customers'
        WHEN R_Score >= 3 AND R_Score <= 4 AND F_Score <= 2 THEN 'Promising'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Need Attention'
        WHEN R_Score >= 2 AND R_Score <= 3 AND F_Score <= 3 AND M_Score <= 3 THEN 'About to Sleep'
        WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4 THEN 'At Risk'
        WHEN R_Score <= 1 AND F_Score >= 4 THEN 'Cannot Lose Them'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Hibernating'
        WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Lost'
        ELSE 'Other'
    END AS Customer_Segment,
    DATEDIFF(DAY, First_Purchase_Date, Last_Purchase_Date) AS Customer_Lifetime_Days
INTO Customer_RFM_Segmentation
FROM RFM_Scores;

-- Verify segment distribution
SELECT 
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS Percentage,
    AVG(Monetary) AS Avg_Revenue_Per_Customer
FROM Customer_RFM_Segmentation
GROUP BY Customer_Segment
ORDER BY COUNT(*) DESC;