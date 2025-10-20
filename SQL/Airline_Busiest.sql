SET @DAY := '2010-01-15';

-- Busiest airline by flights YTD 
WITH cte_busiest AS
   (SELECT row_number() OVER (PARTITION BY DAY(flight_date) ORDER BY flight_date, SUM(f.transaction_id) DESC) AS ranking,
           f.flight_date,
           f.airline_code,
           a.airline_name,
           count(*) total_flights
    FROM flights.flights f
    JOIN flights.airlines a ON f.airline_code = a.airline_code
    WHERE f.flight_date BETWEEN date_format(@DAY, '%Y-%m-01') AND @DAY
		AND f.cancelled = false
    GROUP BY flight_date,
             airline_code
    ORDER BY flight_date,
             ranking)
SELECT 'ranking',
       'flight_date',
       'airline_code',
       'airline_name',
       'total_flights'
UNION
SELECT *
FROM cte_busiest INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/Airline_Busiest_results.csv' FIELDS TERMINATED BY ',';


