SELECT 
    strftime('%Y', order_date) AS order_year,
    strftime('%m', order_date) AS order_month,
    
    SUM(CAST(gross_amount AS REAL)) AS total_gross_revenue,
    SUM(CAST(discount_applied AS REAL)) AS total_discounts_given,
    
    COUNT(DISTINCT order_id) AS order_volume,
    COUNT(DISTINCT customer_id) AS unique_customers_this_month
FROM 
    retail_sales

WHERE 
    order_date >= '2025-01-01' AND order_date <= '2025-12-31'

GROUP BY 
    order_year, 
    order_month

ORDER BY 
    order_year ASC, 
    order_month ASC;