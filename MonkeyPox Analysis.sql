SELECT * FROM dbo.M_PoxCases

---Country with the highest Confirmed Cases to deploy emergency plan for MP eradication
SELECT Country, Confirmed_Cases 
FROM dbo.M_PoxCases
---WHERE Country like '%Nigeria%'
group by Country, Confirmed_Cases
order by 2 desc

---How many countries have zero case of MonkeyPox
SELECT COUNT(Country) as Countries_with_no_Case--,Confirmed_Cases
FROM dbo.M_PoxCases
WHERE Confirmed_Cases = 0

---Country with the highest Suspected Cases 
SELECT Country, Suspected_Cases 
FROM dbo.M_PoxCases
---WHERE Country like '%Nigeria%'
group by Country, Suspected_Cases
order by 2 desc

--How many countries have zero case of Suspected Cases
SELECT COUNT(Country) as Countries_with_no_Case
FROM dbo.M_PoxCases
WHERE Suspected_Cases = 0

---Country with the highest number of Hospitalized Cases 
SELECT Country, Hospitalized 
FROM dbo.M_PoxCases
---WHERE Country like '%Nigeria%'
group by Country, Hospitalized
order by 2 desc

---Country with the Confirmed Cases but no suspected cases
SELECT Country, Confirmed_Cases, Suspected_Cases 
FROM dbo.M_PoxCases
WHERE Suspected_Cases = 0
group by Country, Confirmed_Cases, Suspected_Cases 
order by 2 desc


---Country with the highest Travel History
SELECT Country, Confirmed_Cases, Travel_History_Yes, Travel_History_No
FROM dbo.M_PoxCases
order by 3 desc

---Country with the lowest Travel History
SELECT Country, Confirmed_Cases, Travel_History_Yes, Travel_History_No
FROM dbo.M_PoxCases
order by 4 desc

---Creating a table for ranking comfirmed cases 
DROP TABLE IF EXISTS Ranking
CREATE TABLE Ranking
(Country varchar(50),
confirmed_cases int,
ranking int);

INSERT INTO Ranking 
SELECT Country, Confirmed_Cases, DENSE_RANK() OVER (ORDER BY Confirmed_Cases ASC)  as [RANK]
FROM dbo.M_PoxCases
group by  Country,Confirmed_Cases


---Filtering by rank
SELECT Country,ranking, confirmed_cases
FROM Ranking
--WHERE ranking >= 100 
WHERE ranking <= 100 
---We have from rank 1 to rank 113. The countries with high rank show high number of confirmed cases and otherwise. 
---This can be use to filter per rank


---Using cte to answer the question above (alternative and faster)
with cte as 
(select 
Country, Confirmed_Cases,
DENSE_RANK () Over( order by Confirmed_Cases ASC) as Ranking
FROM dbo.M_PoxCases) 

select * from cte
where Ranking <= 100 

---2nd Table
SELECT * FROM dbo.[M_Pox Daily_Confirmed_Cases]


---Which day and what country has the highest Cases
SELECT Daily.Country, Daily.Date, Daily.Value
FROM dbo.[M_Pox Daily_Confirmed_Cases] as Daily
ORDER BY 3 DESC
--We see that United States has the highest cases of 1410 on the 8th of August, 2022

--What country has the highest Cases by Date
SELECT Daily.Country, Daily.Date, Daily.Value, SUM(Daily.Value) OVER (PARTITION BY Daily.Date) DailyTotal
FROM dbo.[M_Pox Daily_Confirmed_Cases] as Daily
--WHERE  Daily.Date = '2022-08-08' --and Daily.Country like '%Nigeria%'
ORDER BY 4 DESC

SELECT SUM(Daily.Value)
from dbo.[M_Pox Daily_Confirmed_Cases] as Daily
WHERE  Daily.Date = '2022-08-08'

---Total Cases by Country
SELECT Daily.Country, SUM(Daily.Value) Total
FROM dbo.[M_Pox Daily_Confirmed_Cases] as Daily
--WHERE Daily.Country like '%Nigeria%'
GROUP BY Daily.Country--, SUM(Daily.Value) OVER (PARTITION BY Daily.Country) DailyTotal 
ORDER BY 2 DESC

---Total Cases
SELECT SUM(Daily.Value) Total
FROM dbo.[M_Pox Daily_Confirmed_Cases] as Daily

---Case Detection Timeline
SELECT * FROM dbo.[M_Pox Case_Detection_Timeline]

SELECT Daily.Country, Daily.Age,Daily.Symptoms, Daily.Hospitalised_Y_N_NA
FROM dbo.[M_Pox Case_Detection_Timeline] as Daily
WHERE Daily.Age is not null 

SELECT DISTINCT (Daily.Age)
FROM dbo.[M_Pox Case_Detection_Timeline] as Daily

