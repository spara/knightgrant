CREATE TABLE organization (
  organization_id INT PRIMARY KEY NOT NULL,
  organization_name VARCHAR(256) NULL,
  fein VARCHAR(64) NULL,
  aka VARCHAR(256) NULL,
  legal_status VARCHAR(256) NULL,
  year_of_incorporation TIMESTAMP NULL,
  licenses TEXT NULL,
  accreditation TEXT NULL);


CREATE TABLE location (
  location_id INT PRIMARY KEY NOT NULL,
  organization_id INT NULL,
  name VARCHAR(256) NULL,
  aka VARCHAR(256) NULL,
  accessibility TEXT NULL,
  latitude numeric,
  longitude numeric,
  description TEXT NULL,
  location_hours TEXT NULL,
  location_languages TEXT NULL,
  short_desc TEXT NULL,
  transportation TEXT NULL);

CREATE TABLE service (
  service_id INT PRIMARY KEY NOT NULL,
  organization_id INT NULL,
  location_id INT NULL,
  audience TEXT NULL,
  description TEXT NULL,
  eligibility TEXT NULL,
  fees TEXT NULL,
  keywords TEXT NULL,
  how_to_apply TEXT NULL,
  name VARCHAR(255) NULL,
  service_areas TEXT NULL,
  short_desc TEXT NULL,
  urls TEXT NULL,
  service_languages TEXT NULL,
  service_hours TEXT NULL,
  wait VARCHAR(255) NULL,
  method_of_payment TEXT NULL);

CREATE TABLE address (
  location_id INT PRIMARY KEY NOT NULL,
  type VARCHAR(45) NULL,
  attention VARCHAR(128) NULL,
  street_1 VARCHAR(45) NULL,
  street_2 VARCHAR(45) NULL,
  city VARCHAR(45) NULL,
  state VARCHAR(45) NULL,
  postal_code VARCHAR(45) NULL,
  country VARCHAR(45) NULL);

CREATE TABLE phone (
  location_id INT PRIMARY KEY NOT NULL,
  phone_number VARCHAR(45) NULL,
  phone_extension VARCHAR(45) NULL,
  phone_hours VARCHAR(45) NULL,
  phone_type VARCHAR(45) NULL,
  department VARCHAR(128) NULL,
  country_code VARCHAR(3) NULL);

CREATE TABLE contact (
  location_id INT PRIMARY KEY NOT NULL,
  organization_id INT NULL,
  contact_name VARCHAR(64) NULL,
  contact_title VARCHAR(64) NULL);

CREATE TABLE internet_resource (
  organization_id INT PRIMARY KEY NOT NULL,
  location_location_id INT NOT NULL,
  service_id INT NULL,
  resource VARCHAR(45) NULL,
  resource_type VARCHAR(45) NULL);

CREATE TABLE funding (
  organization_id INT PRIMARY KEY NOT NULL,
  service_id INT NOT NULL,
  source TEXT NULL);
 
-- Converting an iCarol resource table to HSDS tables

INSERT INTO organization(
  organization_id,
  organization_name,
  fein,
  aka,
  legal_status,
  year_of_incorporation,
  licenses,
  accreditation )
SELECT
  resourceagencynum,
  publicname,
  fein,
  alternatename,
  legalstatus,
  to_timestamp(yearincorporated,'YYYY'),
  licenseaccreditation,
  licenseaccreditation
FROM resources
WHERE resources.taxonomylevelname = 'Agency'; 

-- populate location table

INSERT INTO location(
  location_id,
  organization_id,
  name,
  aka,
  accessibility,
  latitude,
  longitude,
  location_hours,
  location_languages,
  transportation
)
SELECT
  resourceagencynum,
  parentagencynum,
  publicname,
  alternatename,
  disabilitiesaccess,
  cast(latitude AS numeric),
  cast(longitude AS numeric),
  hoursofoperation,
  languagesoffered,
  busserviceaccess
FROM resources
WHERE resources.taxonomylevelname = 'Site';


UPDATE location
SET description = resources.agencydescription
FROM resources
WHERE 
  resources.parentagencynum = location.organization_id

SELECT location_id,name,description FROM location;

-- populate program table

INSERT INTO service (
  service_id,
  organization_id,
  eligibility,
  fees,
  keywords,
  how_to_apply,
  name,
  service_areas,
  service_languages,
  service_hours,
  wait
) 
SELECT
  resourceagencynum,
  parentagencynum,
  eligibility,
  feestructuresource,
  taxonomyterm,
  applicationprocess,
  publicname,
  coveragearea,
  languagesoffered,
  hoursofoperation,
  normalwaittime
FROM resources
WHERE resources.taxonomylevelname = 'Program';

UPDATE service
SET description = resources.agencydescription
FROM resources
WHERE 
  resources.parentagencynum = service.organization_id

SELECT service_id,name,description FROM service;


