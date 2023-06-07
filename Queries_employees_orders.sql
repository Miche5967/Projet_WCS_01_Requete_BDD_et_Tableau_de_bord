USE toys_and_models;

SELECT YEAR(o.orderDate) as year,
		MONTH(o.orderDate) AS months,  
        SUM(d.quantityOrdered * d.priceEach) AS order_amount,
        c.salesRepEmployeeNumber,
        e.lastName,
        e.firstName
FROM orders AS o
LEFT JOIN orderdetails AS d ON d.orderNumber = o.orderNumber
RIGHT JOIN customers AS c ON o.customerNumber = c.customerNumber
RIGHT JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY year, months, c.salesRepEmployeeNumber, e.lastName, e.firstName
ORDER by 1 desc, 2 desc ,3 desc;

SELECT e.employeeNumber, e.lastName, e.firstName, e.jobTitle, c.customerNumber,
       o.orderNumber, o.orderDate, o.status, YEAR(o.orderDate) as year, MONTH(o.orderDate) AS month
FROM employees AS e
	LEFT JOIN customers AS c ON e.employeeNumber = c.salesRepEmployeeNumber
    RIGHT JOIN orders AS o ON c.customerNumber = o.customerNumber
WHERE e.jobTitle = "sales Rep";
    #AND o.orderNumber IS NULL;
    #AND e.employeeNumber IN (1286, 1702)
    #AND c.customerNumber IN (168, 376);
    
SELECT *
FROM employees AS e
	LEFT JOIN customers AS c ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE e.jobTitle = "sales rep"
	AND c.customerNumber IS NULL;

# Mois, année, n° de client des commandes passées
SELECT DISTINCT YEAR(o1.orderDate) AS orderYear, MONTH(o1.orderDate) AS orderMonth, o1.customerNumber
FROM orders AS o1;

# Les n° de client
SELECT c.customerNumber
FROM customers AS c;

# Mois, année, n° de client commandes
SELECT orderMonth, orderYear, c.customerNumber
FROM customers AS c
     LEFT JOIN (SELECT MONTH(o1.orderDate) AS orderMonth, YEAR(o1.orderDate) AS orderYear, o1.customerNumber
          FROM orders AS o1) AS o ON c.customerNumber = o.customerNumber;

# Année, mois, n° client et montant commande
SELECT DISTINCT YEAR(o1.orderDate) AS orderYear, MONTH(o1.orderDate) AS orderMonth, o1.customerNumber,
                SUM(od.quantityOrdered * od.priceEach) AS orderAmount
FROM orders AS o1
     INNER JOIN orderdetails AS od ON o1.orderNumber = od.orderNumber
     #INNER JOIN customers AS c1 ON o1.customerNumber = c1.customerNumber
GROUP BY orderYear, orderMonth, customerNumber
ORDER BY orderYear, orderMonth, customerNumber;

# Tous les années, mois, n° client
SELECT DISTINCT YEAR(o1.orderDate) AS orderYear, MONTH(o1.orderDate) AS orderMonth, c.customerNumber
FROM orders AS o1
     JOIN customers AS c
ORDER BY orderYear, orderMonth, c.customerNumber;

# Query : order amount for each year, each month and each customer number with salesRepNumber
SELECT DISTINCT YEAR(o1.orderDate) AS orderYear, MONTH(o1.orderDate) AS orderMonth, c.customerNumber,
                c.salesRepEmployeeNumber AS salesRepNb, e.lastName, e.firstName,
                (CASE WHEN o.orderAmount IS NULL THEN 0 ELSE o.orderAmount END) AS orderAmount
FROM orders AS o1
     JOIN customers AS c
     LEFT JOIN (SELECT DISTINCT YEAR(o2.orderDate) AS orderYear, MONTH(o2.orderDate) AS orderMonth,
                                o2.customerNumber, SUM(od.quantityOrdered * od.priceEach) AS orderAmount
                FROM orders AS o2
                     INNER JOIN orderdetails AS od ON o2.orderNumber = od.orderNumber
                GROUP BY orderYear, orderMonth, customerNumber) AS o ON c.customerNumber = o.customerNumber
                                                                        AND YEAR(o1.orderDate) = o.orderYear
                                                                        AND MONTH(o1.orderDate) = o.orderMonth
	 LEFT JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber
ORDER BY orderYear, orderMonth, c.customerNumber;

# Customers n'ayant pas commandé certains mois
SELECT o.o_year, o.o_month, c.customerNumber
FROM customers AS c
     LEFT JOIN (SELECT DISTINCT MONTH(o1.orderDate) AS o_month, YEAR(o1.orderDate) AS o_year, o1.customerNumber
FROM orders AS o1) AS o ON c.customerNumber = o.customerNumber
WHERE o_year IS NULL or o_month IS NULL
ORDER BY o.o_year ASC, o.o_month ASC, c.customerNumber ASC;