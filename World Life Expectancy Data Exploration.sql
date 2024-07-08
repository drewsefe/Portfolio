# World Life Expectancy Project (Data Analysis Exploration)

select * 
from world
;

#identiying countries with the highest and lowest life expectancy, also a calcualation of the increase of life expectancy
select country, 
min(`life expectancy`), 
max(`life expectancy`),
round(max(`life expectancy`) - min(`life expectancy`),1) as life_increase
from world
group by country
having min(`life expectancy`) <> 0
and max(`life expectancy`) <> 0
order by life_increase desc
;

select Year, round(avg(`life expectancy`),2)
from world
where `life expectancy` <> 0
and `life expectancy` <> 0
group by Year
order by Year
;


select country, round(avg(`life expectancy`),1) as life_exp, round(avg(GDP),1) as GDP
from world
group by country
having life_exp > 0
and GDP > 0
order by GDP desc
;

#identifying countries with a high life expectancy and GDP
select 
sum(case when GDP >= 1500 then 1 else 0 end) high_GDP_count,
avg(case when GDP >= 1500 then `life expectancy` else null end) high_GDP_life_expectancy,
sum(case when GDP <= 1500 then 1 else 0 end) low_GDP_count,
avg(case when GDP <= 1500 then `life expectancy` else null end) low_GDP_life_expectancy
from world
;

#identifying the life expectancy for Delevopled countries vs developing countries
select status, count(distinct country), round(avg(`life expectancy`),1)
from world
group by status
;

#identifying the number of deaths each year in comparison to the life expectancy
select country,
Year,
`life expectancy`,
`adult mortality`,
sum(`adult mortality`) over(partition by country order by Year) as rolling_total
from world
where country like '%United%'
;
