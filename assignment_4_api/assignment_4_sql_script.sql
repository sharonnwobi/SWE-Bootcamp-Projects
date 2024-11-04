DROP DATABASE theatre;
CREATE DATABASE theatre;
USE theatre;
CREATE TABLE plays(
show_name VARCHAR(200) PRIMARY KEY,
genre VARCHAR(200),
show_date DATE,
standing_tickets INT,
standing_price FLOAT(2),
seating_tickets INT,
seating_price FLOAT(2),
audio_description BOOLEAN NOT NULL 

);
ALTER TABLE plays
ADD CONSTRAINT increased_seat_price CHECK (seating_price >= standing_price);

DELIMITER //
CREATE PROCEDURE plays_sproc(
show_name VARCHAR(200),
genre VARCHAR(200),
show_date DATE,
standing_tickets INT,
standing_price FLOAT(2),
seating_tickets INT,
seating_price FLOAT(2),
audio_description BOOLEAN)
BEGIN 
	INSERT INTO plays(
    show_name, genre, show_date, standing_tickets, standing_price, seating_tickets, seating_price, audio_description)
    VALUES 
    (show_name, genre, show_date, standing_tickets, standing_price, seating_tickets, seating_price, audio_description);
END//
DELIMITER ;


CALL plays_sproc('ROMEO AND JULIET', 'tragedy', '2024-12-01', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('TAMING OF THE SHREW', 'comedy', '2024-12-01', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('TEMPEST', 'comedy', '2024-12-02', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('PERICLES', 'history', '2024-12-03', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('OTHELLO', 'tragedy', '2024-12-05', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('MACBETH', 'tragedy', '2024-12-02', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('ANTHONY AND CLEOPATRA', 'tragedy', '2024-12-06', 10, 45.00, 5, 100.00, TRUE);
CALL plays_sproc('HAMLET', 'tragedy', '2024-12-10', 10,  45.00, 5, 100.00, TRUE);
CALL plays_sproc('HENRY VIII', 'history', '2024-12-03', 10, 45.00, 5, 100.00, TRUE);

SELECT show_name FROM plays WHERE show_date = '2024-12-01';

USE theatre;

CREATE TABLE bookings (
booking_number INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
show_name VARCHAR(200),
seating_tickets INT,
standing_tickets INT,
full_name VARCHAR (200) NOT NULL,
email_address VARCHAR(200),
booking_date DATE,
FOREIGN KEY(show_name) REFERENCES plays(show_name)
); 
ALTER TABLE bookings AUTO_INCREMENT=1000; 
-- settng auto increment to start at the 1000, as this is the format of their order numbers :)
ALTER TABLE bookings ADD CONSTRAINT booking_limit
CHECK (seating_tickets + standing_tickets <= 5);

ALTER TABLE bookings ADD CONSTRAINT booking_limit_b
CHECK (seating_tickets <= 5);
ALTER TABLE bookings ADD CONSTRAINT booking_limit_c
CHECK (standing_tickets <= 5);


-- ALTER TABLE bookings ADD CONSTRAINT standing_constraint
-- FOREIGN KEY (standing_tickets) REFERENCES plays(standing_tickets);

-- MAKING A STORED PROCEEDURE TO INPUT DATA INTO MY TABLE
USE theatre
DELIMITER //
CREATE PROCEDURE bookings_sproc
	(
show_name VARCHAR(200),
seating_tickets VARCHAR(200),
standing_tickets VARCHAR(200),
full_name VARCHAR (200),
email_address VARCHAR(200),
booking_date DATE)
BEGIN 
	INSERT INTO bookings 
    (show_name, seating_tickets, standing_tickets, full_name, email_address, booking_date)
    VALUES 
    (show_name, seating_tickets, standing_tickets, full_name, email_address, booking_date);
END//
DELIMITER ;

CALL bookings_sproc('ROMEO AND JULIET', 1, 1, 'Mary Myers', 'mm@gmail.com', '2024-11-01' );
SELECT * FROM bookings;