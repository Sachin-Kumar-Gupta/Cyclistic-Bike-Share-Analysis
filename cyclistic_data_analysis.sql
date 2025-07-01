-- Viewing dataset
select * from merged_cyclistic_data
limit 5;

--Now, let's check for duplicate ride_id
select ride_id , count(ride_id) as counts
from merged_cyclistic_data
group by ride_id
having count(ride_id) > 1;
--Conclusion : We don't have any duplicate ride_id in dataset.

--Checking for any anomaly in time
select *,extract(epoch from ended_at - started_at) as time_dur  
from merged_cyclistic_data
where extract(epoch from ended_at - started_at) <=0
--Conclusion : There are 43 rows having negative time duration which is not possible. 

--Droping columns having negative time duration
DELETE FROM merged_cyclistic_data
WHERE EXTRACT(EPOCH FROM ended_at - started_at) <= 0;

--E.D.A.

--Unique rideables
select rideable_type,count(rideable_type) as counts
from merged_cyclistic_data
group by rideable_type
--Conclusion : Peoples prefer electric bike more than classic bike followed by electric scooter.

--Total ridersby user type
select member_casual, count(member_casual) as total_riders
from merged_cyclistic_data
group by member_casual
--Conclusion : We have more member riders than casual riders in a year.

--Avg ride duration by user type:
SELECT member_casual, 
ROUND(AVG(EXTRACT(EPOCH FROM ended_at - started_at)/60), 2) AS avg_duration_mins
FROM merged_cyclistic_data
GROUP BY member_casual;
--Conclusion :On average, casual riders spend more time per ride (24.11 minutes) compared to members (12.30 minutes).

--Rides by day of week:
SELECT member_casual,
       TO_CHAR(started_at, 'Day') AS weekday,
       COUNT(*) AS ride_count
FROM merged_cyclistic_data
GROUP BY member_casual, weekday
ORDER BY member_casual, weekday;

/*Member users show peak activity on weekdays, especially midweek (Wed: 565k), 
while casual users ride most during weekends, with the highest on Saturday (425k).
*/

--Rides by hour of day:
SELECT member_casual,
       EXTRACT(HOUR FROM started_at) AS hour_of_day,
       COUNT(*) AS rides
FROM merged_cyclistic_data
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

--Top 10 start stations for casual users:
SELECT start_station_name, COUNT(*) AS rides
FROM merged_cyclistic_data
WHERE member_casual = 'casual' and start_station_name is not null
GROUP BY start_station_name
ORDER BY rides DESC
LIMIT 10;

-- Bike Type Preferences
SELECT member_casual, rideable_type, COUNT(*) AS ride_count
FROM merged_cyclistic_data
GROUP BY member_casual, rideable_type
order by member_casual asc ,count(*) desc;

--Conclusion : Both casual and member riders prefer electric bikes over classic bikes, with electric scooters being the least used among all rideable types.