# US Household Income Data Cleaning
select * from housing;

select * from statistics;

#updating the field name just for visibility purposes
alter table statistics rename column `ï»¿id` to `id`;

# identifying duplicates
select id, count(id)
from housing
group by id
having count(id) > 1;

#removing duplicates
Delete from housing
where row_id in (
	select *
	from (
		select row_id, id,
		row_number() over (partition by id order by id) row_num
		from housing
		) duplicates
	where row_num > 1)
;

# locating errors that was discovered in the state name column
select distinct State_Name
from housing
order by 1;

#updating the incorrect state name
update housing
set state_name = 'Georgia'
where state_name = 'georia';

# identifying null value for a city that 
select *
from housing
where county = 'Autauga County'
order by 1; 

update housing
set place = 'Autaugaville' 
where county = 'Autauga County'
and city = 'Vinemont'; 


