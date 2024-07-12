-- Creating an Automation for Data Cleaning

select * 
from housing

-- Creating the Automation

delimiter $$
drop procedure if exists copy_and_clean_data()
create procedure copy_and_clean_data()
begin

	CREATE TABLE if not exists `housing_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `timestamp` timestamp default null
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copying Data into the New Table    
    Insert into housing_cleaned
    select *, current_timestamp
    from housing;
    
    -- Data Cleaning Steps

-- 1. Removing Duplicates
Delete from housing_cleaned
where
	row_id in (
    select row_id
from (
	Select row_id,id
		row_number() over (
			partition by id, `timestamp`
            order by id, `timestamp`) as row_num
	from 
		housing
) duplicates
where 
	row_num > 1
); 

-- 2. Standardization
update housing_cleaned
set state_name = 'Georgia'
where state_name = 'georgia';

update housing_cleaned
set county = Upper(county);

update housing_cleaned
set city = upper(city);

update housing_cleaned
set place = upper(place);

update housing_cleaned
set state_name = upper(state_name);

update housing_cleaned
set `type` = 'CDP'
where `type` = 'CDP';

update housing_cleaned
set `type` = 'Borough'
where `type` = 'Borough';

    
end $$
delimiter ;

Call copy_and_clean_data();

-- Creating the Event for the Automation
create event run_data_cleaning
	on schedule every 30 Day
    do call copy_and_clean_data()

-- Creating Trigger

Delimiter $$
create trigger transfer_clean_data
	after insert on housing
    for each row
begin
Call copy_and_clean_data();
end $$
Delimiter ; 


