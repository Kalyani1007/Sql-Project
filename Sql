Create table applestore_description_combined as 

Select * from appleStore_description1

union all 

Select * from appleStore_description2

union all 

Select * from appleStore_description3

union all 

Select * from appleStore_description4


** Exploratory Data analysis **

-- What is the number of unique apps in both tables Appstore

select count(DISTINCT id ) AS UniqueAppIDs
from AppleStore;

select count(DISTINCT id ) AS UniqueAppIDs
from applestore_description_combined;

-- Is there any missing values in key fields ?

select count(*) AS MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

select count(*) AS MissingValues
from applestore_description_combined
where app_desc is null

-- Find out the number of apps per genre

select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

---Get an overview of the apps rating

select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore


*** Data analysis ***

--Determine whether paid apps have higher rating than free apps

select CASE
           when price > 0 then 'Paid'
           else 'Free'
       end as App_Type,
       avg(user_rating) as Avg_Rating 
from AppleStore
group by App_Type

---- Check if apps with more supported languages have higher ratings

select CASE
           when lang_num < 10 then '< 10 languages'
           when lang_num between 10 and 30 then '10-30 languages'
           else '> 10 languages'
       end as language_bucket,
       avg(user_rating) as Avg_Rating 
from AppleStore
group by language_bucket
order by Avg_Rating desc
           
           
----Check genres with low ratings

select prime_genre,
        avg(user_rating) as Avg_Rating 
from AppleStore
group by prime_genre
order by Avg_Rating asc
limit 10


---check if there is a correaltion between the length of the app description and user rating 

select CASE
            when length(b.app_desc) < 500 then 'short'
            when length(b.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
            end as Description_length_bucket,
            avg(a.user_rating) as average_Rating 
            
from  
     AppleStore as A
join 
    applestore_description_combined as B
On 
   a.id = b.id 
group by Description_length_bucket
order by average_Rating desc
            
