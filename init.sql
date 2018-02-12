CREATE DATABASE "ariDB"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

DROP TABLE IF EXISTS pilots_aircrafts;
DROP TABLE IF EXISTS pilots;
DROP TABLE IF EXISTS aircrafts;

CREATE TABLE pilots (
    pilot_id SERIAL PRIMARY KEY,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    age varchar(255) NOT NULL
);

CREATE TABLE aircrafts (
    aircraft_id SERIAL PRIMARY KEY,
    aircraft_name varchar(255)
);

CREATE TABLE pilots_aircrafts (
    PRIMARY KEY (pilot_id, aircraft_id),
    pilot_id int REFERENCES pilots(pilot_id) ON UPDATE CASCADE,
    aircraft_id int REFERENCES aircrafts(aircraft_id) ON UPDATE CASCADE
);


DROP FUNCTION IF EXISTS get_nth_oldest_pilot;

CREATE FUNCTION get_nth_oldest_pilot(int) RETURNS varchar(255) AS $$
    DECLARE full_name varchar(255);

    BEGIN
        SELECT first_name::text || ' ' || last_name::text INTO full_name
		FROM pilots
		ORDER BY age DESC
		LIMIT 1 OFFSET $1-1;
		
		RETURN full_name;
    END;
    $$
    LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS get_oldest_pilot;

CREATE FUNCTION get_oldest_pilot() RETURNS varchar AS $$
    BEGIN
        RETURN get_nth_oldest_pilot(1);
    END;
    $$
    LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS get_most_experienced_pilot;

CREATE FUNCTION get_most_experienced_pilot() RETURNS varchar(255) AS $$
    DECLARE full_name varchar(255);
    BEGIN
        SELECT (first_name::text || ' ' || last_name::text) INTO full_name
        FROM pilots p
        LEFT JOIN pilots_aircrafts pa
        ON p.pilot_id = pa.pilot_id
        GROUP BY first_name, last_name
		ORDER BY COUNT(pa.pilot_id) DESC
        LIMIT 1;

        RETURN full_name;
    END;
    $$
    LANGUAGE plpgsql;




DROP FUNCTION IF EXISTS get_least_experienced_pilot;

CREATE FUNCTION get_least_experienced_pilot() RETURNS varchar(255) AS $$
    DECLARE full_name varchar(255);
    BEGIN
        SELECT (first_name::text || ' ' || last_name::text) INTO full_name
        FROM pilots p
        LEFT JOIN pilots_aircrafts pa
        ON p.pilot_id = pa.pilot_id
        GROUP BY first_name, last_name
		ORDER BY COUNT(pa.pilot_id) ASC
        LIMIT 1;

        RETURN full_name;
    END;
    $$
    LANGUAGE plpgsql;