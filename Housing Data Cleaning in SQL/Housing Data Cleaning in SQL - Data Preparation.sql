-- Housing Data Cleaning in SQL: Data Preparation

-- Step 1: Preprocess the 'Nashville Housing Data for Data Cleaning' CSV file
	-- replace all blank entries with \N, which semantically will be interpreted by MySQL as meaning NULL
    	-- check the data type of each column
    	-- change the dates column to the format of 'yyyy-mm-dd'
	-- enclosed the data in the field of ParcelID, LandUse, PropertyAddress, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, and TaxDistrict with double quotes

-- Step 2: Import CSV file into MySQL table using command line

/* Access MySQL Shell
1. log into MySQL and run this command: mysql -u root -p
2. set the global variables by using this command: mysql> SET GLOBAL local_infile=1;
3. quit current server: mysql> quit
4. connect to the server with local-infile system variable: mysql --local-infile=1 -u root -p 
(replace root with your username)
*/

-- Create database & table using command line

CREATE DATABASE portfolio_project_nashville_housing;

USE portfolio_project_nashville_housing;

DROP TABLE IF EXISTS nashville_housing;

CREATE TABLE nashville_housing
(
	UniqueID INT NOT NULL,
	ParcelID VARCHAR(255) NOT NULL,
	LandUse VARCHAR(255) NOT NULL,
	PropertyAddress VARCHAR(255),
	SaleDate DATETIME NOT NULL,
	SalePrice INT NOT NULL,
	LegalReference VARCHAR(255) NOT NULL,
	SoldAsVacant VARCHAR(255) NOT NULL,
	OwnerName VARCHAR(255),
	OwnerAddress VARCHAR(255),
	Acreage FLOAT,
	TaxDistrict VARCHAR(255),
	LandValue INT,
	BuildingValue INT,
	TotalValue INT,
	YearBuilt INT,
	Bedrooms INT,
	FullBath INT,
	HalfBath INT
);

-- Load CSV file into table

LOAD DATA LOCAL INFILE 'C:/Users/Yan Chyi/Data Analyst Portfolio Project/Housing/Nashville Housing Data for Data Cleaning.csv'
INTO TABLE nashville_housing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Remove Double Quotes that enclosed the fields when import from CSV file

UPDATE nashville_housing
SET 
ParcelID = TRIM(BOTH '''' FROM ParcelID),
LandUse = TRIM(BOTH '''' FROM LandUse),
PropertyAddress = TRIM(BOTH '''' FROM PropertyAddress),
LegalReference = TRIM(BOTH '''' FROM LegalReference),
SoldAsVacant = TRIM(BOTH '''' FROM SoldAsVacant),
OwnerName = TRIM(BOTH '''' FROM OwnerName),
OwnerAddress = TRIM(BOTH '''' FROM OwnerAddress),
TaxDistrict = TRIM(BOTH '''' FROM TaxDistrict)
;

-- Check the number of rows of the table in MySQL workbench and match it with the CSV file
-- To ensure the CSV file is fully loaded into the MySQL table

SELECT * FROM nashville_housing;

