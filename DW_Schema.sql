-- Create DW

-- DROP DATABASE IF EXISTS Airbnb;
-- CREATE DATABASE Airbnb;

-- Create Dimensions (Change Database at this point)

CREATE TABLE IF NOT EXISTS Location (
    LOCATION_ID SERIAL PRIMARY KEY NOT NULL,
    STREET VARCHAR(100) NOT NULL ,
    STREET_TYPE VARCHAR(40),
    PARISH VARCHAR(40) NOT NULL,
    COUNTY VARCHAR(40) NOT NULL,
    ZIP_CODE VARCHAR(8) NOT NULL,
    COASTAL_AREA VARCHAR(20) CHECK (COASTAL_AREA in ('Coastal Area', 'Not Coastal Area')),
    UNIQUE (STREET, ZIP_CODE)
);

CREATE TABLE Host (
    HOST_ID SERIAL PRIMARY KEY NOT NULL,
    HOST_NAME VARCHAR(40) NOT NULL,
    MEMBERSHIP_DURATION VARCHAR(40) CHECK (MEMBERSHIP_DURATION in ('Member for more than 10 years','Member for more than 5 years','Member for more than 2 years','Member for more than 1 year','Member for less than 1 year', 'Unknown')) NOT NULL,
    HOST_COUNTRY VARCHAR(20) NOT NULL,
    HOST_CONTINENT VARCHAR(20) CHECK (HOST_CONTINENT in ('Europe','North America','South America','Asia','Australia','Africa')) NOT NULL,
    HOST_COUNTRY_GDP VARCHAR(20) CHECK (HOST_COUNTRY_GDP in ('Below 20k','20k - 35k','35k - 50k','Above 50k')) NOT NULL,
    HOST_RESPONSE_TIME VARCHAR(20) CHECK (HOST_RESPONSE_TIME in ('within an hour','within a few hours','within a day','a few days or more','Unknown')) NOT NULL,
    HOST_IS_SUPERHOST VARCHAR(20) CHECK (HOST_IS_SUPERHOST in ('Superhost','Not Superhost')) NOT NULL,
    HOST_IS_VERIFIED VARCHAR(20) CHECK (HOST_IS_VERIFIED in ('Verified','Unverified')) NOT NULL
    );

CREATE TABLE Review (
    REVIEW_ID SERIAL PRIMARY KEY NOT NULL,
    RATING VARCHAR(30) CHECK (RATING in ('Bellow average','Average','Good','Very good','Excelent')) NOT NULL, 
    ACCURACY VARCHAR(30) CHECK (ACCURACY in ('Accurate description','Description is not accurate')) NOT NULL,
    CLEANLINESS VARCHAR(30) CHECK (CLEANLINESS in ('Clean','Not clean')) NOT NULL,
    COMMUNICATION VARCHAR(30) CHECK (COMMUNICATION in ('Good communication','Bad communication')) NOT NULL,
    LOCATION VARCHAR(30) CHECK (LOCATION in ('Good location','Bad location')) NOT NULL
    );

CREATE TABLE Date (
    DATE_ID INT PRIMARY KEY NOT NULL,
    DAY INT NOT NULL,
    WEEK INT NOT NULL,
    MONTH INT NOT NULL,
    YEAR INT NOT NULL,
    SEASON VARCHAR(10) CHECK(SEASON in ('Spring', 'Summer', 'Autumn', 'Winter')) NOT NULL,
    WEEKEND VARCHAR(11) CHECK (WEEKEND in ('Weekend', 'Work Day')) NOT NULL,
	WEEKDAY VARCHAR(10) CHECK (WEEKDAY IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')) NOT NULL,
	QUARTER VARCHAR(2) CHECK(QUARTER IN ('Q1','Q2','Q3','Q4')) NOT NULL,
	SEMESTER VARCHAR(2) CHECK(SEMESTER IN ('S1','S2')) NOT NULL,
	HOLIDAY VARCHAR(11) CHECK (HOLIDAY in ('Holiday', 'Not Holiday')) NOT NULL
);

CREATE TABLE Property (
    PROPERTY_ID SERIAL PRIMARY KEY NOT NULL,
    PROPERTY_TYPE_CATEGORY VARCHAR(30) CHECK (PROPERTY_TYPE_CATEGORY in ('Apartment', 'Guesthouse', 'House', 'Hotel/Hostel')) NOT NULL,
    PROPERTY_TYPE VARCHAR(30) CHECK (PROPERTY_TYPE in ('Apartment','Serviced apartment','Aparthotel','Loft','House','Townhouse','Villa','Dome house','Vacation home','Lighthouse','Casa particular (Cuba)','Tiny house','Farm stay','Cottage','Guesthouse','Guest suite','Hostel','Bed and breakfast','Boutique hotel','Hotel')) NOT NULL,
    ROOM_TYPE VARCHAR(30) CHECK (ROOM_TYPE in ('Entire home/apt', 'Private room', 'Hotel room', 'Shared room')) NOT NULL,
    ACCOMMODATES VARCHAR(30) CHECK (ACCOMMODATES in ('Up to 2 guests','Up to 4 guests','Up to 6 guests','Up to 7 guests or more')) NOT NULL,
    BATHROOMS VARCHAR(30) CHECK (BATHROOMS in ('No bathrooms','1 bathroom','2 bathrooms','3 bathrooms','4+ bathrooms')) NOT NULL,
    BEDROOMS VARCHAR(10) CHECK (BEDROOMS in ('T0','T1','T2','T3','T4+')) NOT NULL,
    BEDS VARCHAR(10) CHECK (BEDS in ('No beds','1 bed','2 beds','3 beds','4+ beds')) NOT NULL,
    BED_TYPE VARCHAR(30) CHECK (BED_TYPE in ('Real Bed', 'Pull-out Sofa', 'Futton', 'Couch', 'Airbed')) NOT NULL
);

-- Create Facts Tables

CREATE TABLE Listings (
    NRNAL INT PRIMARY KEY NOT NULL,
    HOST_ID INT REFERENCES Host(HOST_ID),
    DATE_ID INT REFERENCES Date(DATE_ID),
    LOCATION_ID INT REFERENCES Location(LOCATION_ID),
    PROPERTY_ID INT REFERENCES Property(PROPERTY_ID),
    REVIEW_ID INT REFERENCES Review(REVIEW_ID),
    PRICE_PER_NIGHT INT CHECK (PRICE_PER_NIGHT >= 0) NOT NULL
);

CREATE TABLE Availability (
    PROPERTY_ID INT REFERENCES Property(PROPERTY_ID),
    DATE INT REFERENCES Date(DATE_ID),
    PRIMARY KEY (PROPERTY_ID, DATE),
    HOST_ID INT REFERENCES Host(HOST_ID),
    LOCATION_ID INT REFERENCES Location(LOCATION_ID),
    PRICE_PER_NIGHT INT CHECK (PRICE_PER_NIGHT >= 0) NOT NULL
);