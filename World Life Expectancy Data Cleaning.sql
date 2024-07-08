# World Life Expectancy Project (Data Cleaning)

select *
from world
;

#identifying duplicates
select Country, Year, concat(Country, Year), count(concat(Country, Year))
from world
group by Country, Year, concat(Country, Year)
Having count(concat(Country, Year)) > 1
;

select *
from (
	Select row_id,
	concat(Country, Year),
	row_number() over(partition by concat(Country, Year) order by concat(Country, Year)) as row_num
	from world
    ) as row_table
where row_num > 1
;

#removing the duplicates
Delete from world
where 
	row_id in (
	select row_id
from (
	Select row_id,
	concat(Country, Year),
	row_number() over(partition by concat(Country, Year) order by concat(Country, Year)) as row_num
	from world
    ) as row_table
where row_num > 1
)
;

# identifying null values in status field
select *
from world
where status is null
;

select distinct(status)
from world
where status <> ''
;

select distinct(Country)
from world
where status = 'Developing'
;

#filling in the null values for the status field
update world t1
join world t2
on t1.country = t2.country
set t1.status = 'Developing'
where t1.status = ''
and t2.status <> ''
and t2.status = 'Developing'
;

update world t1
join world t2
on t1.country = t2.country
set t1.status = 'Developed'
where t1.status = ''
and t2.status <> ''
and t2.status = 'Developed'
;

#identifying null values in the life expectancy field
select country, Year, `life expectancy`
from world
where `Life expectancy` = ''
;

#filling the null values in the life expectancy column with the average of the previous year and year after
select t1.country, t1.Year, t1.`life expectancy`,
t2.country, t2.Year, t2.`life expectancy`,
t3.country, t3.Year, t3.`life expectancy`,
round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
from world t1
join world t2
	on t1.country = t2.country
    and t1.Year = t2.Year - 1
join world t3
	on t1.country = t3.country
    and t1.Year = t3.Year + 1
where t1.`Life expectancy` = ''    
;

update world t1
join world t2
	on t1.country = t2.country
    and t1.Year = t2.Year - 1
join world t3
	on t1.country = t3.country
    and t1.Year = t3.Year + 1
set t1.`Life expectancy` = round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
where t1.`Life expectancy` = ''
;
