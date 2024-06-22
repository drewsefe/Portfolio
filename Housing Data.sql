-- Standardize Date Format
select SaleDate, CONVERT(date,SaleDate)
from dbo.housing

Update housing
set SaleDate = CONVERT(date,SaleDate)

alter table housing
add SaleDateConverted date; 

Update housing
set SaleDateConverted = CONVERT(date,SaleDate)

-- Populate Property Address
select * 
from dbo.housing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.housing a 
join dbo.housing b 
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.housing a 
join dbo.housing b 
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

-- Breaking out Address in Individual Columns (Address, City, State) 
select PropertyAddress
from dbo.housing

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as address,
CHARINDEX(',',PropertyAddress)
from dbo.housing

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) address
from dbo.housing

alter table housing
add PropertySplitAddress nvarchar(255); 

Update housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table housing
add PropertySplitCity nvarchar(255); 

Update housing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

select PARSENAME(replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from dbo.housing

alter table housing
add OwnerSplitAddress nvarchar(255); 

Update housing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

alter table housing
add OwnerSplitCity nvarchar(255); 

Update housing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

alter table housing
add OwnerSplitState nvarchar(255); 

Update housing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

-- Change Y and N to Yes and No in 'Sold as Vacant' Field
select distinct(SoldAsVacant), count(SoldAsVacant)
from dbo.housing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from dbo.housing

Update housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

-- Remove Duplicates
with RowNumCTE as(
select *,
	row_number() over(
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by 
					UniqueID
					) row_num
from dbo.housing
)
Delete
from RowNumCTE
where row_num > 1

-- Delete Unused Columns
Alter table housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

select * 
from dbo.housing

