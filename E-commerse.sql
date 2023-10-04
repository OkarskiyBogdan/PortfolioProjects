ALTER TABLE ecommerce_customer_data_large
DROP COLUMN `Customer Age`;

   -- droping duplicate column to get more clear data
   
SELECT *
FROM ecommerce_customer_data_large;

-- get clean table to work with

With CusFinInfo(`Customer ID`,TotalTransaction,TotalUnit,TotalPrice,AverageOrderValue,MinProfitMargin,PurchaseFruequency,CustomerValue) 
as 
(
SELECT 
    `Customer ID`,
    COUNT(`Customer Name`) AS TotalTransaction,
    SUM(`Quantity`) AS TotalUnit,
    MAX(`Total Purchase Amount`) AS TotalPrice,
    AVG(Quantity * `Product Price`) AS AverageOrderValue,
    MAX(`Total Purchase Amount`) * 0.05 AS MinProfitMargin,
    COUNT(`Customer Name`) / (SELECT 
            COUNT((`Customer ID`))
        FROM
            ecommerce_customer_data_large) AS PurchaseFruequency,
    COUNT(`Customer Name`) / (SELECT 
            COUNT((`Customer ID`))
        FROM
            ecommerce_customer_data_large) * AVG(Quantity * `Product Price`) AS CustomerValue
FROM
    ecommerce_customer_data_large
WHERE
    Returns != 1
GROUP BY `Customer ID`
)
SELECT *, CASE WHEN CustomerValue > 1 THEN 'S'
			    WHEN CustomerValue > 0.8 THEN 'A' 
                WHEN CustomerValue > 0.6 THEN 'B'
                WHEN CustomerValue > 0.4 THEN 'C'
                WHEN CustomerValue > 0.2 THEN 'D'
                ELSE 'F'
                END as Segmentation 
FROM CusFinInfo;

-- Get info about customers value and Segmentation customers
  
SELECT 
    `Product Category`,
    (SELECT 
            COUNT(DISTINCT (Gender))
        FROM
            ecommerce_customer_data_large
        WHERE
            Gender = 'Male') / COUNT(DISTINCT (Gender)) * 100 AS PercentMale,
    (SELECT 
            COUNT(DISTINCT (Gender))
        FROM
            ecommerce_customer_data_large
        WHERE
            Gender = 'Female') / COUNT(DISTINCT (Gender)) * 100 AS PercentFemale,
    AVG(Age) AS AvgAGE
FROM
    ecommerce_customer_data_large
GROUP BY `Product Category`;

-- Get persentage of gender and average age for each product category

SELECT YEAR(`Purchase Date`) as 'Year',COUNT(`Customer Name`) as TotalOrders,SUM(`Quantity`) AS TotalUnitSold,SUM(`Total Purchase Amount`) AS TotalPriceByYear,SUM(`Total Purchase Amount`)*0.05 AS ProfitByYear
FROM ecommerce_customer_data_large
WHERE
    Returns != 1
GROUP BY YEAR(`Purchase Date`)
ORDER BY YEAR(`Purchase Date`);

-- Get statistics of e-commerce by years

SELECT DATE_FORMAT(`Purchase Date`, '%Y-%m') as YearAndMonth,SUM(CASE WHEN Returns = 1 THEN 1 ELSE 0 END) as Returns,Count(Returns) as Purchase, SUM(CASE WHEN Returns = 1 THEN 1 ELSE 0 END)/Count(Returns)*100 as Percent 
FROM ecommerce_customer_data_large
GROUP BY DATE_FORMAT(`Purchase Date`, '%Y-%m')
ORDER BY DATE_FORMAT(`Purchase Date`, '%Y-%m');

-- Get statistics of Returns by Month



