SET @DAY := '2010-01-15';

-- Airlines with the most cancelations YTD
WITH cte_flight_distance AS
  (SELECT row_number() OVER (PARTITION BY DAY(flight_date) ORDER BY flight_date, avg(f.distance) DESC) AS ranking,
			 f.flight_date,
          f.airline_code, a.airline_name,
          avg(f.distance) avg_distince
   FROM flights.flights f JOIN flights.airlines a ON f.airline_code = a.airline_code
   WHERE f.flight_date BETWEEN date_format(@DAY, '%Y-%m-01') AND @DAY
   GROUP BY flight_date,
            airline_code
   ORDER BY flight_date,
            ranking)
SELECT 'ranking', 'Flight_date', 'airline_code', 'airline_name','avg_distance'
UNION            
SELECT *
FROM cte_flight_distance
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/Airline_AvgDistance_results.csv' 
FIELDS TERMINATED BY ',';