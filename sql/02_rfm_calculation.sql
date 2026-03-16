/*
=================================================================
RFM Metrics Calculation
=================================================================
Calculates Recency, Frequency, Monetary per customer
Uses NTILE(5) to score customers 1-5 on each dimension
=================================================================
*/

WITH CustomerRFM AS (
    SELECT 
        CustomerID,
        DATEDIFF(DAY, MAX(InvoiceDate), '2011-12-09') AS Recency,
        MAX(InvoiceDate) AS Last_Purchase_Date,
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
        Frequency,
        Monetary,
        Country,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CustomerRFM
)
SELECT TOP 100 *
FROM RFM_Scores
ORDER BY Monetary DESC;