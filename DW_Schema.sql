-- Create DW

DROP DATABASE IF EXISTS Airbnb;
CREATE DATABASE Airbnb;

-- Create Dimensions (Change Database at this point)

CREATE TABLE Location (
    LOCATION_ID SERIAL PRIMARY KEY NOT NULL,
    STREET CHAR(40) UNIQUE NOT NULL ,
    PARISH CHAR(20) NOT NULL,
    COUNTY CHAR(20) NOT NULL,
    ZIP_CODE CHAR(8) NOT NULL,
    COASTAL_AREA CHAR(20) CHECK (COASTAL_AREA in ('Coastal Area', 'Not Coastal Area'))
);

CREATE TABLE Host (
    HOST_ID SERIAL PRIMARY KEY NOT NULL,
    HOST_NAME CHAR(40) NOT NULL ,
    HOST_SINCE date,
    HOST_LOCATION CHAR(10),
    HOST_CONTINENT CHAR(20) CHECK (HOST_CONTINENT in ('Asia', 'Africa', 'Europe', 'North America', 'South America', 'Oceania', 'Antarctica')) NOT NULL,
    PIB CHAR(20) CHECK (PIB in ('Poor', 'Medium', 'Rich')) NOT NULL,
    HOST_RESPONSE_TIME CHAR(20) CHECK (HOST_RESPONSE_TIME in ('a few days or more', 'within a day', 'within a few hours', 'within an hour')) NOT NULL,
    HOST_IS_SUPERHOST CHAR(20) CHECK (HOST_IS_SUPERHOST in ('Superhost', 'Not Superhost')) NOT NULL,
    HOST_IDENTITY_VERIFIED CHAR(20) CHECK (HOST_IDENTITY_VERIFIED in ('Weekend', 'Not Weekend')) NOT NULL
);

CREATE TABLE Review (
    REVIEW_ID SERIAL PRIMARY KEY NOT NULL,
    RATING CHAR(15) CHECK (RATING in ('Very Good', 'Good', 'OK', 'Bad', 'Very Bad')) NOT NULL,
    ACCURACY CHAR(15) CHECK (ACCURACY in ('Accurate', 'Not Accurate')) NOT NULL,
    CLEANLINESS CHAR(15) CHECK (CLEANLINESS in ('Clean', 'Not Clean')) NOT NULL,
    COMMUNICATION CHAR(25) CHECK (COMMUNICATION in ('Good Communication', 'Average Communication', 'Bad Communication')) NOT NULL,
    LOCATION CHAR(20) CHECK (LOCATION in ('Good Location', 'Bad Location')) NOT NULL
);

CREATE TABLE Date (
    DATE_ID SERIAL PRIMARY KEY NOT NULL,
    DAY INT NOT NULL,
    WEEK INT NOT NULL,
    MONTH INT NOT NULL,
    YEAR INT NOT NULL,
    SEASON CHAR(20) CHECK(SEASON in ('Spring', 'Summer', 'Autumn', 'Winter')) NOT NULL,
    HOLIDAY CHAR(10) CHECK (HOLIDAY in ('Holiday', 'Not Holiday')) NOT NULL,
    WEEKEND CHAR(10) CHECK (WEEKEND in ('Weekend', 'Not Weekend')) NOT NULL
);

CREATE TABLE Property (
    PROPERTY_ID SERIAL PRIMARY KEY NOT NULL,
    PROPERTY_TYPE CHAR(30) CHECK (PROPERTY_TYPE in ('Apartment', 'GuestHouse', 'House', 'Hostel', 'Room')) NOT NULL,
    ROOM_TYPE CHAR(30) CHECK (ROOM_TYPE in ('Entire Property', 'Private Room', 'Hotel Room', 'Shared Room')) NOT NULL,
    ACCOMMODATES CHAR(10) CHECK (ACCOMMODATES in ('0-2','2-4','4-6','>6')) NOT NULL,
    BATHROOMS CHAR(10) CHECK (BATHROOMS in ('0','1','2','3','>=4')) NOT NULL,
    BEDROOMS CHAR(10) CHECK (BEDROOMS in ('T0','T1','T2','T3','T>=4')) NOT NULL,
    BEDS CHAR(10) CHECK (BATHROOMS in ('0','1','2','3','>=4')) NOT NULL,
    BED_TYPE CHAR(30) CHECK (BED_TYPE in ('Real Bed', 'Pull-out Sofa', 'Futton', 'Couch', 'Airbed')) NOT NULL,
    PRICE_SRQT CHAR(10) CHECK (PRICE_SRQT in ('Expensive', 'Medium', 'Cheap')) NOT NULL
);

-- Create Facts Tables

CREATE TABLE Listings (
    LICENSE_ID INT PRIMARY KEY NOT NULL,
    HOST_ID INT REFERENCES Host(HOST_ID),
    DATE_ID INT REFERENCES Date(DATE_ID),
    LOCATION_ID INT REFERENCES Location(LOCATION_ID),
    PROPERTY_ID INT REFERENCES Property(PROPERTY_ID),
    REVIEW_ID INT REFERENCES Review(REVIEW_ID),
    PRICE INT CHECK (PRICE >= 0) NOT NULL
);

CREATE TABLE Bookings (
    LICENSE_ID INT REFERENCES Listings(LICENSE_ID),
    DATE_ID INT REFERENCES Date(DATE_ID),
    PRIMARY KEY (LICENSE_ID, DATE_ID),
    PRICE INT CHECK (PRICE >= 0) NOT NULL,
    NUMBER_NIGHTS INT CHECK (PRICE >= 0) NOT NULL
);