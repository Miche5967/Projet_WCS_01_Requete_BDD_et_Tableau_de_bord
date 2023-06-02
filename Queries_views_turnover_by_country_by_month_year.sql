USE toys_and_models;

# Query : turnover per country and per month (nb and name) and year
SELECT SUM(p.amount) AS turnover, c.country,
    CONCAT(YEAR(p.paymentDate), '-', CASE WHEN MONTH(p.paymentDate) < 10 THEN CONCAT('0', MONTH(p.paymentDate))
                                          ELSE MONTH(p.paymentDate) END) AS payment_year_month,
	MONTH(p.paymentDate) AS payment_month_nb, MONTHNAME(p.paymentDate) AS payment_month,
    YEAR(p.paymentDate) AS payment_year
FROM payments AS p
	INNER JOIN customers AS c ON p.customerNumber = c.customerNumber
GROUP BY c.country, payment_month_nb, payment_month, payment_year, payment_year_month
ORDER BY payment_year_month, c.country;

# Query : turnover by country and by month (nb and name) and year for last month
SELECT *
FROM (
	SELECT SUM(p.amount) AS turnover, c.country,
		CONCAT(YEAR(p.paymentDate), '-', CASE WHEN MONTH(p.paymentDate) < 10 THEN CONCAT('0', MONTH(p.paymentDate))
											  ELSE MONTH(p.paymentDate) END) AS payment_year_month,
		MONTH(p.paymentDate) AS payment_month_nb, MONTHNAME(p.paymentDate) AS payment_month,
		YEAR(p.paymentDate) AS payment_year
	FROM payments AS p
		INNER JOIN customers AS c ON p.customerNumber = c.customerNumber
	GROUP BY c.country, payment_month_nb, payment_month, payment_year, payment_year_month
	ORDER BY payment_year_month, c.country) AS turnover_per_country_year_month
WHERE payment_month_nb = (CASE WHEN MONTH(NOW()) > 1 THEN MONTH(NOW()) - 1
                           ELSE 12 END)
	AND payment_year = (CASE WHEN MONTH(NOW()) > 1 THEN YEAR(NOW())
                           ELSE YEAR(NOW()) - 1 END);

# Query : turnover by country and by month (nb and name) and year for 2 months ago
SELECT *
FROM (
	SELECT SUM(p.amount) AS turnover, c.country,
		CONCAT(YEAR(p.paymentDate), '-', CASE WHEN MONTH(p.paymentDate) < 10 THEN CONCAT('0', MONTH(p.paymentDate))
											  ELSE MONTH(p.paymentDate) END) AS payment_year_month,
		MONTH(p.paymentDate) AS payment_month_nb, MONTHNAME(p.paymentDate) AS payment_month,
		YEAR(p.paymentDate) AS payment_year
	FROM payments AS p
		INNER JOIN customers AS c ON p.customerNumber = c.customerNumber
	GROUP BY c.country, payment_month_nb, payment_month, payment_year, payment_year_month
	ORDER BY payment_year_month, c.country) AS turnover_per_country_year_month
WHERE payment_month_nb = (CASE WHEN MONTH(NOW()) > 2 THEN MONTH(NOW()) - 2
                               WHEN MONTH(NOW()) = 2 THEN 12
                               ELSE 11 END)
	AND payment_year = (CASE WHEN MONTH(NOW()) > 2 THEN YEAR(NOW())
                             ELSE YEAR(NOW()) - 1 END);

# View: turnover per country and per month and year
CREATE OR REPLACE VIEW turnover_per_country_year_month AS
	SELECT SUM(p.amount) AS turnover, c.country,
		CONCAT(YEAR(p.paymentDate), '-', CASE WHEN MONTH(p.paymentDate) < 10 THEN CONCAT('0', MONTH(p.paymentDate))
											  ELSE MONTH(p.paymentDate) END) AS payment_year_month,
		MONTH(p.paymentDate) AS payment_month_nb, MONTHNAME(p.paymentDate) AS payment_month,
		YEAR(p.paymentDate) AS payment_year
	FROM payments AS p
		INNER JOIN customers AS c ON p.customerNumber = c.customerNumber
	GROUP BY c.country, payment_month_nb, payment_month, payment_year, payment_year_month
	ORDER BY payment_year_month, c.country;

SELECT * FROM turnover_per_country_year_month;

# View: turnover per country of last month
CREATE OR REPLACE VIEW turnover_per_country_last_month AS
	SELECT *
	FROM (
		SELECT SUM(p.amount) AS turnover, c.country,
			CONCAT(YEAR(p.paymentDate), '-', CASE WHEN MONTH(p.paymentDate) < 10 THEN CONCAT('0', MONTH(p.paymentDate))
												  ELSE MONTH(p.paymentDate) END) AS payment_year_month,
			MONTH(p.paymentDate) AS payment_month_nb, MONTHNAME(p.paymentDate) AS payment_month,
			YEAR(p.paymentDate) AS payment_year
		FROM payments AS p
			INNER JOIN customers AS c ON p.customerNumber = c.customerNumber
		GROUP BY c.country, payment_month_nb, payment_month, payment_year, payment_year_month
		ORDER BY payment_year_month, c.country) AS turnover_per_country_year_month
	WHERE payment_month_nb = (CASE WHEN MONTH(NOW()) > 1 THEN MONTH(NOW()) - 1
							   ELSE 12 END)
		AND payment_year = (CASE WHEN MONTH(NOW()) > 1 THEN YEAR(NOW())
							   ELSE YEAR(NOW()) - 1 END);

SELECT * FROM turnover_per_country_last_month;

# View with query to get turnover by country 2 months ago
CREATE OR REPLACE VIEW turnover_per_country_2_month_ago AS
	SELECT turnover, country
	FROM turnover_per_country_per_month_year
	WHERE paymentYear = (CASE WHEN MONTH(NOW()) IN (1, 2) THEN YEAR(NOW()) - 1
							  ELSE YEAR(NOW()) END) AND
		  paymentMonth = (CASE WHEN MONTH(NOW()) = 2 THEN 12
							   WHEN MONTH(NOW()) = 1 THEN 11
							   ELSE MONTH(NOW()) - 2 END);

SELECT * FROM turnover_per_country_2_month_ago;