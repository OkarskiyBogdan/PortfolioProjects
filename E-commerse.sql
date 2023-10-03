ALTER TABLE ecommerce_customer_data_large
DROP COLUMN `Customer Age`;


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
ORDER BY TotalPrice DESC

  
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
GROUP BY `Product Category`


SELECT YEAR(`Purchase Date`),COUNT(`Customer Name`) as TotalOrders,SUM(`Quantity`) AS TotalUnitSold,SUM(`Total Purchase Amount`) AS TotalPriceByYear,SUM(`Total Purchase Amount`)*0.05 AS ProfitByYear
FROM ecommerce_customer_data_large
WHERE
    Returns != 1
GROUP BY YEAR(`Purchase Date`)
ORDER BY YEAR(`Purchase Date`)


SELECT *
FROM ecommerce_customer_data_large