/*
Lab 4 report <Thijs Quast (thiqu264), Lennart Schilling (lensc874)>
*/

/*
Drop all user created tables / procedures that have been created when solving the lab.
*/

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS year CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS weekday CASCADE;
DROP TABLE IF EXISTS year_weekday CASCADE;
DROP TABLE IF EXISTS weekly_schedule CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS contact CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS passenger_reservation CASCADE;
DROP TABLE IF EXISTS passenger_ticket CASCADE;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

DROP VIEW IF EXISTS allFlights;

SET FOREIGN_KEY_CHECKS = 1;

/*
#####################################################################################################################################
Q2: CREATING TABLES
#####################################################################################################################################
*/

CREATE TABLE IF NOT EXISTS airport(
    airport_code VARCHAR(3),
    airport_name VARCHAR(30),
    country VARCHAR(30),
    constraint pk_airport
        primary key (airport_code)
);

CREATE TABLE IF NOT EXISTS year(
    year INTEGER,
    profit_factor DOUBLE,
    constraint pk_year
        primary key (year)
);

CREATE TABLE IF NOT EXISTS route(
    airport_arrival VARCHAR(3),
    airport_departure VARCHAR(3),
    year INTEGER,
    route_price DOUBLE,
    constraint pk_route
        primary key (airport_arrival, airport_departure, year),
    constraint fk_route__airport_arrival
        FOREIGN KEY (airport_arrival) references airport(airport_code),
    constraint fk_route__airport_departure
        FOREIGN KEY (airport_departure) references airport(airport_code),
    constraint fk_route__year
        FOREIGN KEY (year) references year(year)
);

CREATE TABLE IF NOT EXISTS weekday(
    weekday VARCHAR(10),
    constraint pk_weekday
        primary key (weekday)
);

CREATE TABLE IF NOT EXISTS year_weekday(
    year INTEGER,
    weekday VARCHAR(10),
    weekday_factor DOUBLE,
    constraint pk_year_weekday
        primary key (year, weekday),
    constraint fk_year_weekday__year
        FOREIGN KEY (year) references year(year),
    constraint fk_year_weekday__weekday
        FOREIGN KEY (weekday) references weekday(weekday)
);

CREATE TABLE IF NOT EXISTS weekly_schedule(
    wFlight_id INTEGER NOT NULL AUTO_INCREMENT,
    airport_arrival VARCHAR(3),
    airport_departure VARCHAR(3),
    dpt_time TIME,
    weekday VARCHAR(10),
    year INTEGER,
    constraint weekly_schedule
        primary key (wFlight_id),
    constraint fk_weekly_schedule__airport_arrival
        FOREIGN KEY (airport_arrival) references route(airport_arrival),
    constraint fk_weekly_schedule__airport_departure
        FOREIGN KEY (airport_departure) references route(airport_departure),
    constraint fk_weekly_schedule__weekday
        FOREIGN KEY (weekday) references weekday(weekday),
    constraint fk_weekly_schedule__year
        FOREIGN KEY (year) references route(year)
);

CREATE TABLE IF NOT EXISTS flight(
    flight_no INTEGER NOT NULL AUTO_INCREMENT,
    wFlight_id INTEGER,
    week INTEGER,
    constraint pk_flight
        primary key (flight_no),
    constraint fk_flight__wFlight_id
        FOREIGN KEY (wFlight_id) references weekly_schedule(wFlight_id)
);

CREATE TABLE IF NOT EXISTS passenger(
    passp_no INTEGER,
    name VARCHAR(30),
    constraint pk_passenger
        primary key (passp_no)
);

CREATE TABLE IF NOT EXISTS contact(
    passp_no INTEGER,
    phone_no BIGINT,
    email VARCHAR(30),
    constraint pk_contact
        primary key (passp_no),
    constraint fk_contact__passp_no
        FOREIGN KEY (passp_no) references passenger(passp_no)
);

CREATE TABLE IF NOT EXISTS reservation(
    res_no INTEGER NOT NULL AUTO_INCREMENT,
    flight_no INTEGER,
    contact_passp_no INTEGER,
    no_seats INTEGER,
    passengers_added INTEGER DEFAULT 0,
    constraint pk_reservation
        primary key (res_no),
    constraint fk_reservation__flight_no
        FOREIGN KEY (flight_no) references flight(flight_no),
    constraint fk_reservation__contact_passp_no
        FOREIGN KEY (contact_passp_no) references contact(passp_no)
);

CREATE TABLE IF NOT EXISTS credit_card(
    card_no BIGINT,
    holder_name VARCHAR(30),
    constraint pk_credit_card
        primary key (card_no)
);

CREATE TABLE IF NOT EXISTS booking(
    res_no INTEGER,
    price DOUBLE,
    payment_card BIGINT,
    constraint pk_booking
        primary key (res_no),
    constraint fk_booking__res_no
        FOREIGN KEY (res_no) references reservation(res_no),
    constraint fk_booking__payment_card
        FOREIGN KEY (payment_card) references credit_card(card_no)
);

CREATE TABLE IF NOT EXISTS passenger_reservation(
    passp_no INTEGER,
    res_no INTEGER,
    constraint pk_passenger_reservation
        primary key (passp_no, res_no),
    constraint fk_passenger_reservation__passp_no
        FOREIGN KEY (passp_no) references passenger(passp_no),
    constraint fk_passenger_reservation__res_no
        FOREIGN KEY (res_no) references reservation(res_no)
);

CREATE TABLE IF NOT EXISTS passenger_ticket(
    passp_no INTEGER,
    res_no INTEGER,
    ticket_no INTEGER,
    constraint pk_passenger_ticket
        primary key (passp_no, res_no),
    constraint fk_passenger_ticket__passp_no
        FOREIGN KEY (passp_no) references passenger(passp_no),
    constraint fk_passenger_ticket__res_no
        FOREIGN KEY (res_no) references booking(res_no)
);

/*
#####################################################################################################################################
Q3: Writing procedures.
#####################################################################################################################################
*/

/*
##########################################
a) Insert a year.
##########################################
*/

delimiter //

CREATE PROCEDURE addYear(IN year INTEGER, IN factor DOUBLE)
BEGIN
INSERT INTO year VALUES (year, factor);
END //

/*
##########################################
b) Insert a day.
##########################################
*/

/* Since we have the table "weekday" in additon, we add the weekday to both tables. 
That is why running the test code returns "Query OK, 2 rows affected (0.00 sec)".
This is not a problem though, just based on a slighlty different database schema.*/

CREATE PROCEDURE addDay(IN year INTEGER, IN day VARCHAR(10), IN factor DOUBLE)
BEGIN
INSERT INTO weekday VALUES (day);
INSERT INTO year_weekday VALUES (year, day, factor);
END //

/*
##########################################
c) Insert a destination.
##########################################
*/

CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN airport_name VARCHAR(30), IN country VARCHAR(30))
BEGIN   
INSERT INTO airport VALUES (airport_code, airport_name, country);
END //

/*
##########################################
d) Insert a route.
##########################################
*/

CREATE PROCEDURE addRoute(IN airport_departure VARCHAR(3), IN airport_arrival VARCHAR(3), IN year INTEGER, IN route_price DOUBLE)
BEGIN   
INSERT INTO route VALUES (airport_arrival, airport_departure, year, route_price);
END //

/*
##########################################
e) Insert a weekly flight.
##########################################
*/

CREATE PROCEDURE addFlight(IN airport_departure VARCHAR(3), IN airport_arrival VARCHAR(3), IN year INTEGER, IN day VARCHAR(10), IN dpt_time TIME)
BEGIN   
/* For the input, a weekly schedule id (wFlight_id) is generated using the command AUTO_INCREMENT. It automatically increases the id by one if adding a new row to the table.
The id has to be declared at first.
By using LAST_INSERT_ID() afterwards, we can extract the last id which has been added to the table (see https://www.w3schools.com/sql/func_mysql_last_insert_id.asp). 
This one has to be extracted because we have to use it within the insert process for the flight table afterwards.
The weekly schedule id is then used within our flight table again. Since we assume 52 weeks per year, we have to have 52 entries for this weekly schedule id in flight.
For every entry, we need a different flight_id though. This one is again generated with AUTO_INCREMENT. As a consequence, we need a loop. The counter for the loop is again declared at the beginning.*/
DECLARE wFlight_id INT;
DECLARE counter INT DEFAULT 0;
INSERT INTO weekly_schedule VALUES (wFlight_id, airport_arrival, airport_departure, dpt_time, day, year);
SET wFlight_id = LAST_INSERT_ID();
WHILE counter < 52 DO
SET counter = counter + 1;
INSERT INTO flight VALUES (flight_no, wFlight_id, counter);
END WHILE;
END //

delimiter ;

/*
#####################################################################################################################################
Q4: Writing help functions.
#####################################################################################################################################
*/

/*
##########################################
a) Calculate the number of available seats for a certain flight.
##########################################
*/
delimiter //

CREATE FUNCTION calculateFreeSeats(flightnumber INTEGER)
RETURNS INTEGER
BEGIN
DECLARE booked_seats INTEGER;
DECLARE free_seats INTEGER;

/* Extracting number of booked seats.*/
SELECT sum(r.no_seats) INTO booked_seats
FROM reservation r, booking b
WHERE r.flight_no = flightnumber
AND r.res_no = b.res_no;

IF booked_seats IS NULL
THEN SELECT 0 INTO booked_seats;
END IF;

/* Extracting number of free seats.*/
SELECT (40 - booked_seats) INTO free_seats;

/* Return number of free seats. */
RETURN free_seats;
END //

delimiter ;

/*
##########################################
b) Calculate the price of the next seat on a flight.
##########################################
*/

delimiter //

CREATE FUNCTION calculatePrice(flightnumber INTEGER)
RETURNS DOUBLE
BEGIN
DECLARE route_price DOUBLE;
DECLARE weekday_factor DOUBLE;
DECLARE booked_passengers DOUBLE;
DECLARE profit_factor DOUBLE;
DECLARE calculated_price DOUBLE;

/* Extracting route price*/
SELECT r.route_price INTO route_price 
FROM flight f, weekly_schedule ws, route r
WHERE f.flight_no = flightnumber
AND f.wFlight_id = ws.wFlight_id
AND ws.airport_arrival = r.airport_arrival
AND ws.airport_departure = r.airport_departure
AND ws.year = r.year;

/* Extracting weekday_factor */
SELECT yw.weekday_factor INTO weekday_factor 
FROM flight f, weekly_schedule ws, year_weekday yw
WHERE f.flight_no = flightnumber
AND f.wFlight_id = ws.wFlight_id
AND ws.year = yw.year
AND ws.weekday = yw.weekday;

/* Extracting booked_passengers */
SELECT sum(r.no_seats) INTO booked_passengers 
FROM reservation r, booking b
WHERE r.flight_no = flightnumber
AND r.res_no = b.res_no;

IF 
booked_passengers IS NULL THEN SELECT 0 INTO booked_passengers;
END IF;

/* Extracting profit_factor */
SELECT y.profit_factor INTO profit_factor 
FROM flight f, weekly_schedule ws, year y
WHERE f.flight_no = flightnumber
AND f.wFlight_id = ws.wFlight_id
AND ws.year = y.year;

/* Calculating price */
SELECT route_price * weekday_factor * (booked_passengers + 1) / 40 * profit_factor INTO calculated_price;

/* Returning rounded price */
RETURN round(calculated_price, 3);
END //

delimiter ;

/*
#####################################################################################################################################
Q5: Creating a trigger.
#####################################################################################################################################
*/

/*
As the random generated number is a float between 0 and 1, we multiply it by 1000000 and take the floor to get an integer value
*/

delimiter //

CREATE TRIGGER tickettrigger
BEFORE INSERT ON passenger_ticket
FOR EACH ROW
BEGIN
SET NEW.ticket_no = floor(rand()*10000000);
END // 

delimiter ;

/*
Ideally, in this trigger one would want to run through the previously generated random numbers and assess that 
the "newly" generated random number was not generated and assigned as a ticket_no previously already
*/

/*
#####################################################################################################################################
Q6: Writing stored procedures.
#####################################################################################################################################
*/

/*
##########################################
a) Create a reservation on a specific flight.
##########################################
*/

delimiter //

CREATE PROCEDURE addReservation(
IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), 
IN year INTEGER, IN week VARCHAR(10), IN day VARCHAR(10), IN time TIME, 
IN number_of_passengers INTEGER, OUT output_reservation_nr INTEGER)
BEGIN
DECLARE flight_number INTEGER;
DECLARE res_no INTEGER;
/* Extracting the flight number. */
SELECT f.flight_no INTO flight_number
FROM weekly_schedule ws, flight f
WHERE ws.wFlight_id = f.wFlight_id
AND ws.airport_arrival = arrival_airport_code
AND ws.airport_departure = departure_airport_code
AND ws.dpt_time = time
AND ws.weekday = day
AND ws.year = year
AND f.week = week;

/* Flight number has to exist. Checking for availability of seats. If available, proceed with reservation.*/
IF flight_number IS NULL
THEN SELECT "FLIGHT DOES NOT EXIST";
ELSEIF calculateFreeSeats(flight_number) >= number_of_passengers 
THEN INSERT INTO reservation VALUES(res_no, flight_number, NULL, number_of_passengers, 0);
SET output_reservation_nr = LAST_INSERT_ID();
ELSE SELECT "NOT ENOUGH SEATS AVAILABLE ON THE PLANE. TRY TO TAKE THE TRAIN!";
END IF;
END //

delimiter ;

/*
##########################################
b) Add a passenger to a reservation.
##########################################
*/

delimiter //

CREATE PROCEDURE addPassenger(
IN reservation_nr INTEGER, IN passport_number INTEGER, IN name VARCHAR(30))
BEGIN
DECLARE passenger_passp_no INTEGER;
DECLARE reservation_no INTEGER;
DECLARE added_passengers_for_reservation INTEGER;
DECLARE seats_for_reservation INTEGER;

/*Check if reservation has already been paid. */
IF (SELECT res_no FROM booking WHERE res_no = reservation_nr) IS NOT NULL
THEN SELECT "RESERVATION HAS ALREADY BEEN PAID! NO MORE PASSENGERS CAN BE ADDED!";
END IF;

IF (SELECT res_no FROM booking WHERE res_no = reservation_nr) IS NULL
THEN

/* Check if reservation number exists. */
SELECT res_no INTO reservation_no FROM reservation WHERE res_no = reservation_nr;
IF reservation_no IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT EXIST!";
END IF;

IF reservation_no IS NOT NULL
THEN
/* Extract relating passport no in passenger. If passenger not in table yet, add it.*/
SELECT p.passp_no INTO passenger_passp_no
FROM passenger p
WHERE p.passp_no = passport_number;
IF passenger_passp_no IS NULL 
THEN INSERT INTO passenger VALUES(passport_number, name);
END IF;
/* Add passenger to passenger_reservation. */
INSERT INTO passenger_reservation VALUES(passport_number, reservation_nr);
/* Increase passengers_added by 1 for reservation. */
UPDATE reservation SET passengers_added = passengers_added + 1 WHERE res_no = reservation_nr;
/* Increase no_seats by 1 for reservation if passengers_added > no_seats in reservation. */
SELECT passengers_added INTO added_passengers_for_reservation FROM reservation WHERE res_no = reservation_nr;
SELECT no_seats INTO seats_for_reservation FROM reservation WHERE res_no = reservation_nr;
IF added_passengers_for_reservation > seats_for_reservation
THEN UPDATE reservation SET no_seats = no_seats + 1 WHERE res_no = reservation_nr;
END IF;

END IF;
END IF;
END //

delimiter ;

/*
##########################################
c) Add a contact.
##########################################
*/

delimiter //

CREATE PROCEDURE addContact(
IN reservation_nr INTEGER, IN passport_number INTEGER, IN email VARCHAR(30), IN phone BIGINT)

BEGIN

/* Check if reservation number exists. */
IF (SELECT res_no FROM reservation WHERE res_no = reservation_nr) IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT EXIST!";
END IF;

/* If it exists, proceed. */
IF (SELECT res_no FROM reservation WHERE res_no = reservation_nr) IS NOT NULL
THEN

/* Check if person is passenger on the reservation. */
IF (SELECT res_no FROM passenger_reservation pr WHERE pr.passp_no = passport_number AND pr.res_no = reservation_nr) IS NULL
THEN SELECT "person is not passenger of the reservation.";
END IF;

/* If true, proceed.*/
IF (SELECT res_no FROM passenger_reservation pr WHERE pr.passp_no = passport_number AND pr.res_no = reservation_nr) IS NOT NULL
THEN

/* Insert contact into contact table */
IF (SELECT passp_no FROM contact WHERE passp_no = passport_number) IS NULL
THEN INSERT INTO contact VALUES(passport_number, phone, email);
END IF;
/* Updating contact attribute in reservation table. */
UPDATE reservation r SET contact_passp_no = passport_number WHERE r.res_no = reservation_nr;

END IF;
END IF;

END //

delimiter ;

/*
##########################################
d) Add a payment.
##########################################
*/

delimiter //

CREATE PROCEDURE addPayment(
IN reservation_nr INTEGER, IN cardholder_name VARCHAR(30), IN credit_card_number BIGINT)
BEGIN
DECLARE flight_number INT;
DECLARE price DOUBLE;

/* Check if reservation number exists. */
IF (SELECT res_no FROM reservation WHERE res_no = reservation_nr) IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT EXIST!";
ELSE

/* Checking if reservation has a contact. */
IF (SELECT contact_passp_no FROM reservation WHERE res_no = reservation_nr) IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT HAVE A CONTACT!";
ELSE

/* Check if reservation has been already paid. */
IF (SELECT payment_card FROM booking WHERE res_no = reservation_nr) IS NOT NULL
THEN SELECT "RESERVATION HAS ALREADY BEEN PAID!";
ELSE

/* Determine flight number for reservation.*/
SELECT distinct(res.flight_no) INTO flight_number FROM reservation res where res.res_no =  reservation_nr;

/* Check if there are enough unpaid seats. */
IF calculateFreeSeats(flight_number) < (SELECT sum(res.no_seats) FROM reservation res WHERE res.res_no = reservation_nr)
THEN SELECT "NOT ENOUGH UNPAID SEATS AVAILABLE";
ELSE

/* Calculating the price. */
SELECT calculatePrice(flight_number) INTO price;

/* Adding price and card information. */
INSERT INTO credit_card VALUES(credit_card_number, cardholder_name);
INSERT INTO booking VALUES(reservation_nr, price, credit_card_number);

END IF;
END IF;
END IF;
END IF; 

END //

delimiter ;

/*
#####################################################################################################################################
Q7: Creating a view allFlights.
#####################################################################################################################################
*/

CREATE VIEW allFlights AS 
    SELECT 
	a2.airport_name as departure_city_name, 
	a1.airport_name as destination_city_name, 
	ws.dpt_time as departure_time,
	ws.weekday as departure_day, 
	f.week as departure_week, 
	ws.year as departure_year, 
	calculateFreeSeats(f.flight_no) as nr_of_free_seats, 
	calculatePrice(f.flight_no) as current_price_per_seat
    FROM weekly_schedule ws 
        JOIN flight f ON f.wFlight_id = ws.wFlight_id
        JOIN route r ON (r.airport_departure = ws.airport_departure AND r.airport_arrival = ws.airport_arrival AND r.year = ws.year)
        JOIN airport a1 ON (a1.airport_code = r.airport_arrival)
        JOIN airport a2 ON (a2.airport_code = r.airport_departure);

/*
#####################################################################################################################################
Q8: Answering theoretical questions.
#####################################################################################################################################
*/

/*
##########################################
a) How can you protect the credit card information in the database from hackers?
##########################################
*/

/*
	Encrypting; this is probably the most relevant for this question. Encrypting means that the database system tranforms, in this case the credit card data, into another data format or code. Now only someone who has the decryption key can decript this data into the right format again and read it. (source: https://digitalguardian.com/blog/what-data-encryption) 

    Physical security; this means that one should keep the physical database system in a protected place where only authorized people can access it. But in addition, one should also keep the database system as much as possible disconnected from other machines that run apps or are connected to the internet.  

    Firewalls; this means that by default access to the database is denied, except if it comes from specific apps or web servers that are allowed to, and need to, access the data. 

    Harden the database; this means that one should remove all features from the database that are not needed. And that all the security checks for the database system are on. 

    Monitor database activity; this means that one monitors who logs into the database and all the attempts to login. By monitoring this, one can notice suspicious behaviour. 

(Source: https://www.esecurityplanet.com/network-security/6-database-security-best-practices.html) 
*/

/*
##########################################
b) Give three advantages of using stored procedures in the database (and thereby execute them on the server) instead of writing the same functions in the front-end of the system (in for example java-script on a web-page)?
##########################################
*/

/*

From slide 8 in lecture slides of Topic 7: Triggers and Stored Procedures we find that stored procedures are useful because it: 

- Reduces duplication of effort if a database program is needed by several applications  
This means that a stored procedure prevents many people from doing the same thing in possibly many different ways. By creating a stored
procedure certain computations on the data are done in the same way to extract a desired output.  

– Reduce data transfer and communication cost (assuming a client-server setting)  
This means that if a client needs certain data from the database, but in order to get the right data it needs to perform some     computations on the data. By having a stored procedure that does this, the database does not have to send all the data needed for the computation to the client, which will then later on use this data for the computation, but rather, the database system can send the computed answer directly to the client. 

– Can be used to check for complex constraints 
This makes sure that the way the data is stored in the database makes sense and that any unfeasible connections between attributes are prevented. 

*/

/*
#####################################################################################################################################
Q9: 
#####################################################################################################################################
*/

/*
##########################################
a)In session A, add a new reservation.
##########################################
*/

/*
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> CALL addReservation("HOB","MIT",2010,1,"Tuesday","10:00:00",3,@a); 
Query OK, 5 rows affected (0.01 sec)
*/

/*
##########################################
b)Is this reservation visible in session B? Why? Why not?
##########################################
*/

/*
The reservation is not seen within the other terminal. The reason for that is that transactions are treaded isolated under consideration of the ACID properties. Thus, a commit statement is needed.
*

/*
##########################################
c) What happens if you try to modify the reservation from A in B? Explain what happens and why this happens and how this relates to the concept of isolation of transactions
##########################################
*/

/*
in A:

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> CALL addReservation("HOB","MIT",2010,1,"Tuesday","10:00:00",3,@a);
Query OK, 2 rows affected (0.00 sec)

mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from reservation;
+--------+-----------+------------------+----------+
| res_no | flight_no | contact_passp_no | no_seats |
+--------+-----------+------------------+----------+
|      1 |         1 |                1 |        6 |
|      2 |        53 |             NULL |        3 |
+--------+-----------+------------------+----------+
2 rows in set (0.00 sec)


in B:

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> update reservation set no_seats = 10;
Query OK, 2 rows affected (0.00 sec)
Rows matched: 2 Changed: 2 Warnings: 0

mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from reservation;
+--------+-----------+------------------+----------+
| res_no | flight_no | contact_passp_no | no_seats |
+--------+-----------+------------------+----------+
|      1 |         1 |                1 |       10 |
|      2 |        53 |             NULL |       10 |
+--------+-----------+------------------+----------+
2 rows in set (0.00 sec)

When using the commit-command, the transaction is commited so that the database is updated in the other terminal as well.
Therefore, it is possible to alter the table of reservations. This change will then after using again a commit command lead 
to an update of the table within the other terminal as well.
*/

/*
#####################################################################################################################################
Q10: 
#####################################################################################################################################
*/

/*
##########################################
a)Did overbooking occur when the scripts were executed? If so, why? If not, why not
##########################################
*/

/*
In both termials, the following output occurred.

----------+------------------+
| Message                                                                                 | nr_of_free_seats |
+-----------------------------------------------------------------------------------------+------------------+
| Nr of free seats on the flight (should be 19 if no overbooking occured, otherwise -2):  |               19 |
+-----------------------------------------------------------------------------------------+------------------+
1 row in set (0.01 sec)

Thus, no overbooking has occured. Before performing the second payment, the implemented procedure checks for seat availability.
Since not enough seats were left after the first payment, the second payment could not be performend anymore.
*/

/*
##########################################
b) Can an overbooking theoretically occur? If an overbooking is possible, in what order must the lines of code in your procedures/functions be executed.
##########################################
*/

/*
Yes, overbooking can theroretically occur. This may be the case if both booking requests surpass the follwing part of our 
payment procedure before on of them finished the procedure:

IF calculateFreeSeats(flight_number) < (SELECT sum(res.no_seats) FROM reservation res WHERE res.res_no = reservation_nr)
THEN SELECT "NOT ENOUGH UNPAID SEATS AVAILABLE";
ELSE

If this if statetement is not FALSE, then the booking is performed. In case that the first booking request passed these lines, but
is not completed yet, the second request will also pass this line. Thus, overbooking follows. 
*/

/*

##########################################
c) Try to make the theoretical case occur in reality by simulating that multiple sessions call the procedure at the same time. To specify the order in which the lines of code are executed use the MySQL query SELECT sleep(5); which makes the session sleep for 5 seconds. Note that it is not always possible to make the theoretical case occur, if not, motivate why
##########################################
*/

/*
The proceudre addPayment may be added as follows: 

delimiter //

CREATE PROCEDURE addPayment(
IN reservation_nr INTEGER, IN cardholder_name VARCHAR(30), IN credit_card_number BIGINT)
BEGIN
DECLARE flight_number INT;
DECLARE price DOUBLE;

IF (SELECT res_no FROM reservation WHERE res_no = reservation_nr) IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT EXIST!";
ELSE

IF (SELECT contact_passp_no FROM reservation WHERE res_no = reservation_nr) IS NULL
THEN SELECT "RESERVATION NUMBER DOES NOT HAVE A CONTACT!";
ELSE

IF (SELECT payment_card FROM booking WHERE res_no = reservation_nr) IS NOT NULL
THEN SELECT "RESERVATION HAS ALREADY BEEN PAID!";
ELSE

SELECT distinct(res.flight_no) INTO flight_number FROM reservation res where res.res_no =  reservation_nr;

IF calculateFreeSeats(flight_number) < (SELECT sum(res.no_seats) FROM reservation res WHERE res.res_no = reservation_nr)
THEN SELECT "NOT ENOUGH UNPAID SEATS AVAILABLE";
ELSE

SELECT sleep(5); 

SELECT calculatePrice(flight_number) INTO price;

INSERT INTO credit_card VALUES(credit_card_number, cardholder_name);
INSERT INTO booking VALUES(reservation_nr, price, credit_card_number);

END IF;
END IF;
END IF;
END IF; 

END //

delimiter ;

As a consequence, the SELECT sleep(5) query has been added between the check for available seats and then actual performance of the booking.
Running this code 

*/

/*
##########################################
d) Modify the testscripts so that overbookings are no longer possible.
##########################################
*/

/*
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",21,@a); 
CALL addPassenger(@a,00000001,"Saruman");
CALL addPassenger(@a,00000002,"Orch1");
CALL addPassenger(@a,00000003,"Orch2");
CALL addPassenger(@a,00000004,"Orch3");
CALL addPassenger(@a,00000005,"Orch4");
CALL addPassenger(@a,00000006,"Orch5");
CALL addPassenger(@a,00000007,"Orch6");
CALL addPassenger(@a,00000008,"Orch7");
CALL addPassenger(@a,00000009,"Orch8");
CALL addPassenger(@a,00000010,"Orch9");
CALL addPassenger(@a,00000011,"Orch10");
CALL addPassenger(@a,00000012,"Orch11");
CALL addPassenger(@a,00000013,"Orch12");
CALL addPassenger(@a,00000014,"Orch13");
CALL addPassenger(@a,00000015,"Orch14");
CALL addPassenger(@a,00000016,"Orch15");
CALL addPassenger(@a,00000017,"Orch16");
CALL addPassenger(@a,00000018,"Orch17");
CALL addPassenger(@a,00000019,"Orch18");
CALL addPassenger(@a,00000020,"Orch19");
CALL addPassenger(@a,00000021,"Orch20");
CALL addContact(@a,00000001,"saruman@magic.mail",080667989); 
SELECT "Making payment, supposed to work for one session and be denied for the other" as "Message";


LOCK TABLES 
booking READ, booking WRITE, 
reservation READ, reservation WRITE, 
contact READ, credit_card WRITE, 
flight READ, passenger p READ, 
passenger_reservation READ, 
weekday READ;

CALL addPayment (@a, "Sauron",7878787878);

UNLOCK TABLES;

/*
#####################################################################################################################################
Identifying secondary index.
#####################################################################################################################################
*/

/* An opportunity might be the column "name" within the airport relation.
In an alphabetical order, the airport could be also quite fast reachable via this key.
*/
