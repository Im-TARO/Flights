/***************************************************************************************************************/
/************************************************** flights ****************************************************/
/***************************************************************************************************************/ 

/*** Create flights table ***/
DROP TABLE IF EXISTS flights.flights;
CREATE TABLE flights.flights (
    transaction_id INT PRIMARY KEY,
    flight_date DATE,
    airline_code CHAR(2) ,
    tail_num VARCHAR(10),
    flight_num INT,
    orgin_airport CHAR(3),
    dest_airport CHAR(3),
    sched_deptime TIME,
    dep_time TIME,
    dep_delay INT,
    taxi_out INT,
    wheels_off TIME,
    wheels_on TIME,
    taxi_in INT,
    sched_arr_time TIME,
    arr_time TIME,
    arr_delay INT,
    sched_elasped_time INT,
    act_elasped_time INT,
    cancelled BOOLEAN,
    diverted BOOLEAN,
    distance INT
);

/*** Insert into flights ***/
/* 
+--------------------------------------+
| flights.airlines - column cleaned    | 
+--------------------------------------+
| flight_date - cast as DATE           |
| sched_deptime -convert to TIME       |
| dep_time - convert to TIME           |
| wheels_off - convert to TIME         |
| wheels_on - convert to TIME          |
| sched_arr_time - convert to TIME     |
| arr_time - convert to TIME           |
| cancelled_flag - convert to BOOLEAN  |
| diverted - convert to BOOLEAN        |
| distance - remove the word miles     |
+--------------------------------------+
*/
INSERT INTO flights.flights
SELECT CAST(TRANSACTIONID AS UNSIGNED) TRANSACTIONID,
       CAST(FLIGHTDATE AS DATE) FLIGHTDATE,
       AIRLINECODE,
       TAILNUM,
       CAST(FLIGHTNUM AS UNSIGNED) FLIGHTNUM,
       ORIGINAIRPORTCODE,
       DESTAIRPORTCODE,
       CASE
           WHEN LENGTH(CRSDEPTIME) = 3 THEN STR_TO_DATE(LPAD(CRSDEPTIME, 4, '0'), '%H%i')
           WHEN LENGTH(CRSDEPTIME) = 4 AND CRSDEPTIME != '2400' THEN STR_TO_DATE(CRSDEPTIME, '%H%i')
           WHEN LENGTH(CRSDEPTIME) = 4 AND CRSDEPTIME = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(CRSDEPTIME)
       END CRSDEPTIME,
       CASE
           WHEN LENGTH(DEPTIME) = 3 THEN STR_TO_DATE(LPAD(DEPTIME, 4, '0'), '%H%i')
           WHEN LENGTH(DEPTIME) = 4 AND DEPTIME != '2400' THEN STR_TO_DATE(DEPTIME, '%H%i')
           WHEN LENGTH(DEPTIME) = 4 AND DEPTIME = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(DEPTIME)
       END DEPTIME,
       CAST(IFNULL(DEPDELAY, 0) AS SIGNED) DEPDELAY,
       CAST(IFNULL(TAXIOUT, 0) AS SIGNED) TAXIOUT,
       CASE
           WHEN LENGTH(WHEELSOFF) = 3 THEN STR_TO_DATE(LPAD(WHEELSOFF, 4, '0'), '%H%i')
           WHEN LENGTH(WHEELSOFF) = 4 AND WHEELSOFF != '2400' THEN STR_TO_DATE(WHEELSOFF, '%H%i')
           WHEN LENGTH(WHEELSOFF) = 4 AND WHEELSOFF = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(WHEELSOFF)
       END WHEELSOFF,
       CASE
           WHEN LENGTH(WHEELSON) = 3 THEN STR_TO_DATE(LPAD(WHEELSON, 4, '0'), '%H%i')
           WHEN LENGTH(WHEELSON) = 4 AND WHEELSON != '2400' THEN STR_TO_DATE(WHEELSON, '%H%i')
           WHEN LENGTH(WHEELSON) = 4 AND WHEELSON = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(WHEELSON)
       END WHEELSON,
       CAST(NULLIF(TAXIIN, '') AS UNSIGNED) TAXIIN,
       CASE
           WHEN LENGTH(CRSARRTIME) = 3 THEN STR_TO_DATE(LPAD(CRSARRTIME, 4, '0'), '%H%i')
           WHEN LENGTH(CRSARRTIME) = 4 AND CRSARRTIME != '2400' THEN STR_TO_DATE(CRSARRTIME, '%H%i')
           WHEN LENGTH(CRSARRTIME) = 4 AND CRSARRTIME = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(CRSARRTIME)
       END CRSARRTIME,
       CASE
           WHEN LENGTH(ARRTIME) = 3 THEN STR_TO_DATE(LPAD(ARRTIME, 4, '0'), '%H%i')
           WHEN LENGTH(ARRTIME) = 4 AND ARRTIME != '2400' THEN STR_TO_DATE(ARRTIME, '%H%i')
           WHEN LENGTH(ARRTIME) = 4 AND ARRTIME = '2400' THEN STR_TO_DATE('000000', '%H%i%s')
           ELSE TIME(ARRTIME)
       END ARRTIME,
       CAST(IFNULL(ARRDELAY, 0) AS SIGNED) ARRDELAY,
       CAST(CRSELAPSEDTIME AS UNSIGNED) CRSELAPSEDTIME,
       CAST(ACTUALELAPSEDTIME AS UNSIGNED) ACTUALELAPSEDTIME,
       CASE
           WHEN UPPER(CANCELLED) IN ('F', 'FALSE') THEN FALSE
           WHEN UPPER(CANCELLED) IN ('T', 'TRUE') THEN TRUE
           ELSE CANCELLED
       END CANCELLED,
       CASE
           WHEN UPPER(DIVERTED) IN ('F', 'FALSE') THEN FALSE
           WHEN UPPER(DIVERTED) IN ('T', 'TRUE') THEN TRUE
           ELSE DIVERTED
       END DIVERTED,
       SUBSTRING_INDEX(DISTANCE, ' ', 1) DISTANCE
FROM flights_raw;

SELECT 
    'transaction_id',
    'flight_date',
    'airline_code',
    'tail_num',
    'flight_num',
    'orgin_airport',
    'dest_airport',
    'sched_deptime',
    'dep_time',
    'dep_delay',
    'taxi_out',
    'wheels_off',
    'wheels_on',
    'taxi_in',
    'sched_arr_time',
    'arr_time',
    'arr_delay',
    'sched_elasped_time',
    'act_elasped_time',
    'cancelled',
    'diverted',
    'distance'
UNION SELECT 
    transaction_id,
    flight_date,
    airline_code,
    ifnull(tail_num,''),
    flight_num,
    orgin_airport,
    dest_airport,
    sched_deptime,
    ifnull(dep_time,''),
    ifnull(dep_delay,''),
    ifnull(taxi_out,''),
    ifnull(wheels_off,''),
    ifnull(wheels_on,''),
    ifnull(taxi_in,''),
    ifnull(sched_arr_time,''),
    ifnull(arr_time,''),
    ifnull(arr_delay,''),
    ifnull(sched_elasped_time,''),
    ifnull(act_elasped_time,''),
    cancelled,
    diverted,
    distance
FROM
    flights.flights INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/flights.csv' FIELDS TERMINATED BY ',';

/**************************************************************************************************************/
/************************************************* airports ***************************************************/
/**************************************************************************************************************/

/*** Create airports table ***/
DROP TABLE IF EXISTS flights.airports;
CREATE TABLE flights.airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    airport_city VARCHAR(50),
    airport_state CHAR(2)
);

/*** Insert into airports ***/
/* 
+-----------------------------------------------------------------------------+
| airports - columns cleaned                                          | 
+-----------------------------------------------------------------------------+
| airport_name - remove city & state                                          |
| airport_city - use the first city                                           |
| airport_state - if the state is missing get the state from the airport_name |
+-----------------------------------------------------------------------------+
*/
INSERT INTO flights.airports
SELECT ORIGINAIRPORTCODE,
       TRIM(SUBSTRING_INDEX(ORIGAIRPORTNAME, ':', -1)) airport_name,  
       SUBSTRING_INDEX(ORIGINCITYNAME, '/', 1) airport_city, 
       CASE WHEN NULLIF(TRIM(ORIGINSTATE), '') IS NULL THEN RIGHT(SUBSTRING_INDEX(ORIGAIRPORTNAME, ':', 1), 2) ELSE ORIGINSTATE END airport_state 
FROM
  (SELECT ORIGINAIRPORTCODE,
          ORIGAIRPORTNAME,
          ORIGINCITYNAME,
          ORIGINSTATE
   FROM flights.flights_raw
   UNION SELECT DESTAIRPORTCODE,
                DESTAIRPORTNAME,
                DESTCITYNAME,
                DESTSTATE
   FROM flights.flights_raw) a
ORDER BY 1;

SELECT 'airport_code', 'airport_name', 'airport_city', 'airport_state'
UNION SELECT 
    airport_code, airport_name, airport_city, airport_state
FROM flights.airports
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/airports.csv' 
FIELDS TERMINATED BY ',';

/**************************************************************************************************************/
/************************************************* airlines ***************************************************/
/**************************************************************************************************************/

/*** Create airlines table ***/
DROP TABLE IF EXISTS flights.airlines;
CREATE TABLE flights.airlines (
    airline_code CHAR(2) PRIMARY KEY,
    airline_name VARCHAR(100)
);

/*** Insert into airlines ***/
/* 
+--------------------------------------+
| flights.airlines - column cleaned    | 
+--------------------------------------+
| airline_name - remove air line code  |
+--------------------------------------+
*/
INSERT INTO flights.airlines
SELECT DISTINCT
    AIRLINECODE, SUBSTRING_INDEX(AIRLINENAME, ':', 1) AIRLINENAME
FROM
    flights.flights_raw;

SELECT 'airline_code', 'airline_name'
UNION
SELECT airline_code, airline_name
FROM flights.airlines
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/airlines.csv' 
FIELDS TERMINATED BY ',';  

ALTER TABLE flights.flights 
	ADD CONSTRAINT airline_fk FOREIGN KEY (airline_code) REFERENCES airlines (airline_code),
	ADD CONSTRAINT origin_airport_fk FOREIGN KEY (orgin_airport) REFERENCES airports (airport_code),
   ADD CONSTRAINT dest_airport_fk FOREIGN KEY (dest_airport) REFERENCES airports (airport_code);
         




