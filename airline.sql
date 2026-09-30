create database airline
Use airline;
create table airline_booking(
Booking_Id varchar(10) primary key,
Passenger_ID varchar(10),
Passenger_Name varchar(50),
Flight_Number varchar(20),
Origin varchar(30),
Destination varchar(50),
Booking_date date,
Travel_date date,
Fare_class varchar(20),
Fare_Amount decimal(10,2),
Booking_channel varchar(50),
Booking_status varchar(20));
select * from airline_booking;
select count(*) as total_rows from airline_booking;
USE airline_analysis;

--- 1. Which routes and flights generate the highest revenue and booking volume?
--- Route
SELECT Origin, Destination, COUNT(*) AS Booking_Volume,
SUM(Fare_Amount) AS Total_Revenue
FROM airline_booking
GROUP BY Origin, Destination
ORDER BY Total_Revenue DESC;
--- Fligt
SELECT Flight_Number, COUNT(*) AS Booking_Volume, SUM(Fare_Amount) AS Total_Revenue
FROM airline_booking
GROUP BY Flight_Number
ORDER BY Total_Revenue DESC;

--- 2. What are the peak booking periods?
--- Month
SELECT MONTH(Booking_Date) AS Booking_Month,COUNT(*) AS Total_Bookings
FROM airline_booking
GROUP BY MONTH(Booking_Date)
ORDER BY Booking_Month;
---- Day
SELECT DAYNAME(Booking_Date) AS Booking_Day, COUNT(*) AS Total_Bookings
FROM airline_booking
GROUP BY DAYNAME(Booking_Date)
ORDER BY Total_Bookings DESC;

--- 3.How do cancellation and no-show rates vary?
--- Fare class
SELECT Fare_Class,COUNT(*) AS Total_Bookings,
SUM(Booking_Status = 'Cancelled') AS Cancelled,
SUM(Booking_Status = 'No-show') AS No_Show
FROM airline_booking
GROUP BY Fare_Class;
---- Booking channel
SELECT Booking_Channel,COUNT(*) AS Total_Bookings,
SUM(Booking_Status = 'Cancelled') AS Cancelled,
SUM(Booking_Status = 'No-show') AS No_Show
FROM airline_booking
GROUP BY Booking_Channel;

--- 4. Which customer segments contribute most revenue?
SELECT Passenger_ID, COUNT(*) AS Total_Bookings, SUM(Fare_Amount) AS Total_Revenue
FROM airline_booking
GROUP BY Passenger_ID
ORDER BY Total_Bookings DESC;

--- 5.Average fare and load factor by flight class?
SELECT Fare_Class, AVG(Fare_Amount) AS Average_Fare FROM airline_booking GROUP BY Fare_Class;

ALTER TABLE airline_booking
ADD COLUMN Seat_Capacity INT;
UPDATE airline_booking
SET Seat_Capacity = 180
WHERE Booking_Id >= 'B0001';
select * from airline_booking;
describe airline_booking;
SELECT Booking_Id,Flight_Number,Seat_Capacity
FROM airline_booking
LIMIT 10;

SELECT Flight_Number,COUNT(*) AS Booked_Seats,
MAX(Seat_Capacity) AS Seat_Capacity,
ROUND(COUNT(*) * 100.0 / MAX(Seat_Capacity),2) AS Load_Factor_Percentage
FROM airline_booking
GROUP BY Flight_Number
ORDER BY Load_Factor_Percentage DESC;

SELECT Fare_Class,COUNT(*) AS Booked_Seats, MAX(Seat_Capacity) AS Seat_Capacity,
ROUND(COUNT(*) * 100.0 / MAX(Seat_Capacity),2) AS Load_Factor_Percentage,
ROUND(AVG(Fare_Amount), 2) AS Average_Fare
FROM airline_booking
GROUP BY Fare_Class
ORDER BY Load_Factor_Percentage DESC;

