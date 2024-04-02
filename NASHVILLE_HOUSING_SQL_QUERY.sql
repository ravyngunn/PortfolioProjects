
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM [NashvilleHousing.xlsx - Sheet1]

---------

ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
ADD PropertySplitAddress Nvarchar(255);

Update [NashvilleHousing.xlsx - Sheet1]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
ADD PropertySplitCity Nvarchar(255);

Update [NashvilleHousing.xlsx - Sheet1]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-------------------------------------


SELECT *
FROM [NashvilleHousing.xlsx - Sheet1]

SELECT OwnerAddress
FROM [NashvilleHousing.xlsx - Sheet1]

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
FROM [NashvilleHousing.xlsx - Sheet1]


---------------------------------------------


ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
ADD OwnerSplitAddress Nvarchar(255);

Update [NashvilleHousing.xlsx - Sheet1]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
ADD OwnerSplitCity Nvarchar(255);

Update [NashvilleHousing.xlsx - Sheet1]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)


ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
ADD OwnerSplitState Nvarchar(255);

Update [NashvilleHousing.xlsx - Sheet1]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

--------------------------------------------
WITH RowNumCTE AS ( 
SELECT *, 
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference 
                     ORDER BY
                        UniqueID
    ) row_num

FROM [NashvilleHousing.xlsx - Sheet1]
--ORDER BY ParcelID
)

--DELETE
SELECT *
FROM [RowNumCTE]
WHERE row_num > 1
--Order By PropertyAddress


SELECT * 
FROM [NashvilleHousing.xlsx - Sheet1]

ALTER TABLE [NashvilleHousing.xlsx - Sheet1]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

-----------------------------------------

