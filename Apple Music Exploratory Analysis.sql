-- Statistical Models

-- Identifying the Average Minutes
select AVG([Play Duration Minutes]) as [Average Minutes Played] 
from music

-- Identifying Average Play Count
select AVG([Play Count]) as [Average Play Count] 
from music

-- Identifying the Median
-- Since SQL Server doesn't have a built in function for Median we'll have to utilize the Percentile_Cont (.5) function which will help identify the median
select [Play Duration Minutes],
PERCENTILE_CONT(0.5) within group (order by [Play Duration Minutes]) over () as Median
from music

select [Play Count],
PERCENTILE_CONT(0.5) within group (order by [Play Count]) over () as Median
from music

-- Identifying the Mode
-- SQL Server also doesn't have a built in function for Mode so we can use the formula below to assist
select top 5 [Play Duration Minutes], count(*) as Mode
from music
group by [Play Duration Minutes]
order by Mode desc;

select top 5 [Play Count], count(*) as Mode
from music
group by [Play Count]
order by Mode desc;

-- Identifying the Variance
select ROUND(VAR([Play Duration Minutes]),2) as [Variance Minutes]
from music

select ROUND(VAR([Play Count]),2) as [Variance Play Count]
from music

-- Identifying the Standard Deviation
select ROUND(STDEV([Play Duration Minutes]),2) as [Standard Deviation]
from music

select ROUND(STDEV([Play Count]),2) as [Standard Deviation]
from music

-- Identifying the months with the most minutes and the year it occurred in order
select [Year],[Month],SUM([Play Duration Minutes]) as [Total Minutes],
RANK() over(partition by [Year], [Month] order by SUM([Play Duration Minutes]) desc) as [Rank]
from music
group by [Year],[Month]
order by [Total Minutes] desc

-- Shows the top song for each month, the year it occurred in and how much the song was played
With [Ranked Song] as (
select [Year],[Month],[Artist],[Song Name],SUM([Play Duration Minutes]) as [Total Minutes],
RANK() over(partition by [Year], [Month] order by SUM([Play Duration Minutes]) desc) as [Rank]
from music
group by [Year],[Month],[Artist],[Song Name]
)
Select [Year],[Month],[Artist],[Song Name],[Total Minutes]
from [Ranked Song]
where [Rank] = 1
order by [Total Minutes] desc

-- Shows the Top 5 songs for each year ordered from most minutes to least
With [Ranked Songs] as (
select [Year],Artist,[Song Name],SUM([Play Duration Minutes]) as [Total Minutes],
RANK() OVER(partition by [year] order by SUM([Play Duration Minutes]) desc) as [Rank]
from music
group by [Year], Artist, [Song Name]
)
Select [Year],Artist,[Song Name],[Total Minutes]
from [Ranked Songs]
where [Rank] <= 5
order by [Year],[Rank];
	
-- Shows the most played songs in order with the total minutes, total play count and late date played
select Artist,[Song Name],SUM([Play Duration Minutes]) as [Total Minutes Played], SUM([Play Count]) as [Total Play Count], MAX([Date Played]) as [Last Date Played]
from music
group by [Song Name], Artist
order by [Total Minutes Played] desc; 

-- shows the most featured artist in our dataset
select [Song Name], Features, Count(*) as [Feature Count]
from music
where Features != 'No Feature'
group by [Song Name], Features
order by [Feature Count] desc

-- Shows the top 5 artist for each year ordered by rank
With [Ranked Artist] as (
select [Year],Artist,SUM([Play Duration Minutes]) as [Total Minutes],
RANK() OVER(partition by [year] order by SUM([Play Duration Minutes]) desc) as [Rank]
from music
group by [Year], Artist
)
Select [Year],Artist,[Total Minutes]
from [Ranked Artist]
where [Rank] <= 5
order by [Year],[Rank];

-- Top 5 Most Listened to 
select top 5 Artist, SUM([Play Duration Minutes]) as [Total Minutes]
from music
group by Artist
order by [Total Minutes] desc

-- Most listened to artist ordered by minutes
select Artist, SUM([Play Duration Minutes]) as [Total Minutes]
from music
group by Artist
order by [Total Minutes] desc


-- Top 5 Songs from my top 5 most listened to artist
with [Ranked Artist] as (
select Artist,[Song Name],SUM([Play Duration Minutes]) as [Total Minutes],
RANK() OVER(partition by Artist order by SUM([Play Duration Minutes]) desc) as [Rank]
from music
where Artist in ('Babyface Ray','CEO Trayle','Baby Smoove', 'Mariah Carey','G Herbo')
group by Artist, [Song Name]
)
select Artist, [Song Name], [Total Minutes], [Rank]
from [Ranked Artist]
where [Rank] <= 5
order by Artist desc, [Rank] asc, [Total Minutes] desc
