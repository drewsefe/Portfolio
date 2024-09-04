-- Creating the table and importing the data for cleaning

create table music
(
Track_Description varchar(255), 
Country varchar(255),
Track_Identifier int, 
Media_type varchar(255),
Date_Played date, 
Hours text,
Play_Duration_Milliseconds int,
End_Reason_Type varchar(255),
Source_Type varchar(255),
Play_Count int,
Skip_Count int,
Ignore_For_Recommendations varchar(255)
);

-- Import statement (I find this easier rather than using import wizard)

BULK
INSERT music
FROM 'C:\Users\drews\OneDrive\Documents\Apple Music - Play History Daily Tracks.csv'
WITH
(
FORMAT='csv',
FIRSTROW=2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)

-- Removing the unecessary columns

alter table music
drop column country, [media type], [hours], [end reason type], [source type], [ignore for recommendations];

-- For more accurate data we'll need to delete all the queries where we have no time listened to the following songs in the statement below

select [Track Description], [Play Duration Milliseconds], [Play Count]
from music
order by [Play Duration Milliseconds];

delete from music
where [Play Duration Milliseconds] = 0 and [Play Count] = 0; 

-- Separating the artist and the song name in "Track Description" column

Select [Song Description],
Substring([Song Description],1,CHARINDEX('-',[Song Description])) as Artist
from music

-- Alternate Method

select [Song  Description],
LEFT([Song  Description], CHARINDEX('-',[Song  Description])) as Artist
from music

alter table music add Artist varchar(255)

Update music set Artist = Substring([Song  Description],1,CHARINDEX('-',[Song  Description]))

update music set artist = replace(Artist, '-','')

-- Song Name

alter table music add [Song Name] varchar(255);

select [Song Description],
RIGHT([Song Description], LEN([Song Description]) - charindex('-',[Song Description]))
from music

Update music set [Song Name] = RIGHT([Song Description], LEN([Song Description]) - charindex('-',[Song Description]))

-- Creating new columns to show the play duration in seconds and minutes

alter table music add [Play Duration Seconds] int, [Play Duration Minutes] int;

update music set [Play Duration Seconds] = [Play Duration Milliseconds]/(1000)

update music set [Play Duration Minutes] = [Play Duration Seconds]/(60)

-- Separating the date played field and creating columns for both the year and the date top expand our data

alter table music add [Year] varchar(255), [Month] varchar(255);

select [Date Played],YEAR([Date Played]), DATENAME(MONTH,[Date Played])
from music

update music set [Year] = YEAR([Date Played])

update music set [Month] = DATENAME(MONTH,[Date Played])


-- Creating a new column that contains the artists that were featured 

alter table music add Features varchar(255)

update music
set Features = 
Case when [Song Name] like '%feat.%' then RIGHT([Song Name], LEN([Song Name]) - charindex('.',[Song Name])) Else 'No Feature' end; 

update music set Features = REPLACE([Features],')','')

update music set Features = TRIM(Features)

-- Removing the last bit of the data where the Artist is null
delete from music
Where Artist = ''





