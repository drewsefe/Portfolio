select * from dbo.coviddata

-- updating the date to more standardized format
select converted_date, convert(date,Date) from dbo.coviddata

update coviddata set date = convert(date,Date)

alter table coviddata add converted_date date

update coviddata set converted_date = convert(date,Date)

-- dropping unused columns
select * from dbo.coviddata

alter table coviddata drop column date

-- updating blank continents within the dataset to the correct continent/location
select continent, location from dbo.coviddata where continent = ' '

update coviddata set continent = location where continent = ' '

update coviddata set continent = 'Europe' where continent = 'European Union' 

select continent from dbo.coviddata group by continent 

-- number of people fully vaccinated against covid-19 globally
select max(people_fully_vaccinated) as num_fully_vaccinated from dbo.coviddata

-- number of people partially vaccinated against covid-19 globally
select max(people_vaccinated) as num_partially_vaccinated from dbo.coviddata

-- percentage of people fully vaccinated over population globally
select max(people_fully_vaccinated)/max(population)*100 as share_fully_vaccinated from dbo.coviddata

-- percentage of people partially vaccinated over population globally
select max(People_Vaccinated)/max(population)*100 as share_fully_vaccinated from dbo.coviddata

-- contient with the most number of cases ordered from greatest to least
select continent, max(total_cases) as num_of_cases from dbo.coviddata group by continent order by num_of_cases desc

-- countries with the most number of cases ordered from greatest to least
select location, max(total_cases) as num_of_cases from dbo.coviddata group by location order by num_of_cases desc

-- comparing the number of cases in the US between the years 2020 and 2021
select converted_date, location, sum(total_cases) as num_of_cases
from dbo.coviddata where converted_date < '2020-12-31' and location = 'United States'
group by converted_date, location order by num_of_cases desc

select converted_date, location, sum(total_cases) as num_of_cases
from dbo.coviddata where converted_date > '2020-12-31' and location = 'United States'
group by converted_date, location order by num_of_cases desc

-- checking the number of cases by dates to see the spikes between the number of cases
select converted_date, location, total_cases from dbo.coviddata
where location = 'United States' order by total_cases desc

select * from dbo.coviddata
