Write a query to display the number of flight services between locations in a month. 
The Query should display From Location, To _Location, Month as "Month_Name" 
and number of flight services as "No_of Services is
•⁠  ⁠Hint: The Number of Services can be calculated from the number of scheduled departure dates of a flight.
•⁠  ⁠The records should be displayed in ascending order based on From Location and then by 
To _Location and then by month name.
•⁠  ⁠Column Name: from location, to location, Month_Name, No of Services

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    from_location VARCHAR(100) NOT NULL,
    to_location VARCHAR(100) NOT NULL,
    scheduled_departure_date DATE NOT NULL
);

INSERT INTO flights (from_location, to_location, scheduled_departure_date) VALUES
('Chennai', 'Delhi', '2025-01-05'),
('Chennai', 'Delhi', '2025-01-12'),
('Chennai', 'Delhi', '2025-02-01'),
('Delhi', 'Mumbai', '2025-01-10'),
('Delhi', 'Mumbai', '2025-01-20'),
('Delhi', 'Mumbai', '2025-02-15'),
('Bangalore', 'Chennai', '2025-01-03');

SELECT 
    from_location,
    to_location,
    TO_CHAR(scheduled_departure_date, 'Month') AS Month_Name,
	--CONCAT(UPPER(SUBSTRING(TO_CHAR(scheduled_departure_date, 'Month'), 1, 1)), 
	--LOWER(SUBSTRING(TO_CHAR(scheduled_departure_date, 'Month'), 2))) AS Month_Name,

    COUNT(*) AS No_of_Services
FROM flights
GROUP BY 
    from_location, 
    to_location, 
    TO_CHAR(scheduled_departure_date, 'Month'),
    EXTRACT(MONTH FROM scheduled_departure_date) -- For correct month ordering
	--STRFTIME('%Y-%m', scheduled_departure_date) = '2025-08'
ORDER BY 
    from_location ASC,
    to_location ASC,
    EXTRACT(MONTH FROM scheduled_departure_date) ASC;
