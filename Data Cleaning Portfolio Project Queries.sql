/* 

Cleaning Data in SQL Queries

*/


USE portfolio_project_nashville_housing;

SELECT *
FROM nashville_housing
;


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT 
	SaleDate,
    CONVERT(SaleDate, Date)
FROM nashville_housing
;

ALTER TABLE nashville_housing
CHANGE SaleDate SaleDate DATE;


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM nashville_housing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID
;

SELECT
	a.UniqueID,
	a.ParcelID, 
	a.PropertyAddress,
    b.UniqueID,
    b.ParcelID, 
    b.PropertyAddress,
    IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashville_housing a
	JOIN nashville_housing b
		ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
;

UPDATE nashville_housing a
	JOIN nashville_housing b
		ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL
;


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


-- Split "Property Address" field

SELECT 
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, LOCATE(',',PropertyAddress)-1) AS PropertySplitAddress,
    TRIM(SUBSTRING(PropertyAddress, LOCATE(',',PropertyAddress)+1, LENGTH(PropertyAddress))) AS PropertySplitCity
FROM nashville_housing
;

ALTER TABLE nashville_housing
ADD PropertySplitAddress VARCHAR(255) AFTER PropertyAddress,
ADD PropertySplitCity VARCHAR(255) AFTER PropertySplitAddress
;

UPDATE nashville_housing
SET
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',',PropertyAddress)-1),
	PropertySplitCity = TRIM(SUBSTRING(PropertyAddress, LOCATE(',',PropertyAddress)+1, LENGTH(PropertyAddress)))
;


-- Split "Owner Address" field

SELECT
	OwnerAddress,
	SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerSplitAddress,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS OwnerSplitCity,
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS OwnerSplitState
FROM nashville_housing
;

ALTER TABLE nashville_housing
ADD OwnerSplitAddress VARCHAR(255) AFTER OwnerAddress,
ADD OwnerSplitCity VARCHAR(255) AFTER OwnerSplitAddress,
ADD OwnerSplitState VARCHAR(255) AFTER OwnerSplitCity
;

UPDATE nashville_housing
SET 
	OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1),
	OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)),
	OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1))
;


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT 
	SoldAsVacant,
    COUNT(SoldAsVacant)
FROM nashville_housing
GROUP BY 1
ORDER BY 2
;

SELECT
	SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END AS SoldAsVacant_clean
FROM nashville_housing
;

UPDATE nashville_housing
SET SoldAsVacant = (
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END)
;


--------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH row_num_cte AS (
SELECT 
	*,
	ROW_NUMBER() OVER (
	PARTITION BY
		ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
	ORDER BY
		UniqueID
	) AS row_num
FROM nashville_housing
) 
SELECT 
	UniqueID,
    row_num
FROM row_num_cte
WHERE row_num > 1
;

DELETE FROM nashville_housing
WHERE UniqueID IN (
	SELECT UniqueID
    FROM (
		SELECT 
			*,
			ROW_NUMBER() OVER (
			PARTITION BY
				ParcelID,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference
			ORDER BY
				UniqueID
			) AS row_num
		FROM nashville_housing
        ) AS t
	WHERE row_num > 1
);


--------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT * 
FROM nashville_housing;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict
;

