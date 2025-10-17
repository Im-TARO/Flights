SET @DAY := '2010-01-15';

-- Airlines with the most cancelations YTD
WITH cte_cancelations AS
  (SELECT row_number() OVER (PARTITION BY DAY(flight_date) ORDER BY flight_date, avg(f.dep_delay) DESC) AS ranking,
			 f.flight_date,
          f.airline_code, a.airline_name,
          avg(f.dep_delay) avg_dep_delay
   FROM flights.flights f JOIN flights.airlines a ON f.airline_code = a.airline_code
   WHERE f.flight_date BETWEEN date_format(@DAY, '%Y-%m-01') AND @DAY
   GROUP BY flight_date,
            airline_code
   ORDER BY flight_date,
            ranking)
SELECT 'ranking', 'Flight_date', 'airline_code', 'airline_name','avg_dep_delay'
UNION            
SELECT *
FROM cte_cancelations
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/Airline_AvgDepatureDelay_results.csv' 
FIELDS TERMINATED BY ',';