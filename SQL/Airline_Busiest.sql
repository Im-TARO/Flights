SET @YEAR := '2010';

-- Busiest airline by flights per month
WITH cte_cancelations AS (
	SELECT row_number() OVER (PARTITION BY MONTH(flight_date) ORDER BY SUM(f.cancelled) DESC) AS ranking,
			 YEAR(f.flight_date) YEAR,
          MONTH(f.flight_date) MONTH,
          f.airline_code, a.airline_name,
          count(*) total_flights
   FROM flights.flights f JOIN flights.airlines a ON f.airline_code = a.airline_code
   WHERE YEAR(f.flight_date) = @YEAR 
   GROUP BY YEAR,
            MONTH,
            airline_code
   ORDER BY YEAR,
            MONTH,
            ranking)
SELECT 
    'ranking',
    'year',
    'month',
    'airline_code',
    'airline_name',
    'total_flights'
UNION SELECT *
FROM cte_cancelations 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/Airline_Busiest_2010_results.csv' FIELDS TERMINATED BY ',';