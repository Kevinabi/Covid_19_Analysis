
use covid19

select * from covid_death_rates

---1----



select top 1 Jurisdiction_residence,total_deaths from  (select Jurisdiction_residence, sum(covid_deaths) as total_deaths from covid_death_rates group by Jurisdiction_residence  ) as t order by total_deaths desc


----2----


 with cte as(

 select sum(crude_covid_rate) as cal, DATEPART(week,data_period_end) as weeks,DATEPART(year,data_period_end) as years, groups,Jurisdiction_residence from covid_death_rates 
 
 group by groups,Jurisdiction_residence,DATEPART(year,data_period_end),DATEPART(week,data_period_end)
 )

 select a.cal,a.groups, a.weeks,a.years,a.Jurisdiction_residence, (cast((b.cal)-(a.cal) as float) / a.cal) * 100 AS 'WOW_Change'

from cte a

left join cte b on 
      (a.groups = b.groups and
	   a.jurisdiction_residence = b.jurisdiction_residence
	   and a.weeks+1= b.weeks
	   and a.years = b.years
	   )
order by WOW_Change desc
 ----------------------------------------------------------------------------------------------------------------

  with cte as(

 select sum(crude_covid_rate) as cal, DATEPART(week,data_period_end) as weeks, groups,Jurisdiction_residence from covid_death_rates group by groups,Jurisdiction_residence,DATEPART(week,data_period_end)
 )

 select a.cal,a.groups, a.weeks,a.Jurisdiction_residence, (cast((b.cal)-(a.cal) as float) / a.cal) * 100 AS 'WOW_Change'

from cte a

left join cte b on 
      (a.groups = b.groups and
	   a.jurisdiction_residence = b.jurisdiction_residence
	   and a.weeks+1= b.weeks 
	   )

-----------------------------------------------------------------------------------------------------------------------------------

select * from covid_death_rates;

Ans - Q3)

select top 5 Jurisdiction_residence, (sum(aa_covid_rate) - sum(crude_covid_rate)) / sum(crude_covid_rate) * 100 as cruderate from covid_death_rates where data_period_end = (select max(data_period_end) from covid_death_rates ) 
group by Jurisdiction_residence order by cruderate desc

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4.	Calculate the average COVID deaths per week for each jurisdiction residence and group, for the latest 4 data period end dates.

select * from covid_death_rates;


select   (sum(covid_deaths) / 53) as average_deaths,  Jurisdiction_residence, groups  from covid_death_rates 

where data_period_end in ( select  distinct top 4 data_period_end from covid_death_rates order by data_period_end desc) and covid_deaths <> 0
group by Jurisdiction_residence, groups 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---5. Retrieve the data for the latest data period end date, but exclude any jurisdictions that had zero COVID deaths and have missing values in any other column.

select * from covid_death_rates where data_period_end = 
(select max(data_period_end) from covid_death_rates) and covid_deaths > 0 
and pct_change_wk is not null and 
pct_diff_wk is not null and 
aa_covid_rate is not null and 
footnote is not null
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---6. Calculate the week-over-week percentage change in COVID_pct_of_total for all jurisdictions and groups, but only for the data period start dates after March 1, 2020.

with cte2 as (

select DATEPART(week,data_period_end) as weeks,DATEPART(year,data_period_end) as years,sum(covid_pct_of_total) as pct_total, Jurisdiction_residence, groups 

from covid_death_rates where covid_pct_of_total > 0 and covid_pct_of_total is not null

group by Jurisdiction_residence, groups, data_period_end 

			)

			select a.weeks,a.years,a.jurisdiction_residence,a.groups, round(((a.pct_total - b.pct_total) / a.pct_total),2,1 )as wow

			from cte2 a

			left join cte2 b on 

			a.weeks = b.weeks+1 and
			a.years = b.years and
			a.jurisdiction_residence = b.jurisdiction_residence and
			a.groups=b.groups

			order by a.years, a.jurisdiction_residence,a.groups,a.weeks

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---7.	Group the data by jurisdiction residence and calculate the cumulative COVID deaths for each jurisdiction, but only up to the latest data period end date.


select *, sum(totaldeaths) over (order by jurisdiction_residence) as cumsum from (

select jurisdiction_residence, sum(covid_deaths) as totaldeaths from covid_death_rates where data_period_end = 
																											  (select max(data_period_end) from covid_death_rates)  
																																group by jurisdiction_residence) abc


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---8.	Identify the jurisdiction with the highest percentage increase in COVID deaths from the previous week, and provide the actual numbers of deaths for each week. 
---hint-----This would require a subquery to calculate the previous week's deaths.

with cte as(

 select sum(crude_covid_rate) as cal, DATEPART(week,data_period_end) as weeks,DATEPART(year,data_period_end) as years, groups,Jurisdiction_residence from covid_death_rates 
 
 group by groups,Jurisdiction_residence,DATEPART(year,data_period_end),DATEPART(week,data_period_end)
 )

 select a.cal,a.groups, a.weeks,a.years,a.Jurisdiction_residence, (cast((b.cal)-(a.cal) as float) / a.cal) * 100 AS 'WOW_Change'

from cte a

left join cte b on 
      (a.groups = b.groups and
	   a.jurisdiction_residence = b.jurisdiction_residence
	   and a.weeks+1= b.weeks
	   and a.years = b.years
	   )

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

9.	Compare the crude COVID death rates for different age groups, but only for jurisdictions where the total number of deaths exceeds a certain threshold (e.g. 100). 




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
10.	Implementation of Function & Procedure-"Create a stored procedure that takes in a date  range and calculates the average weekly percentage change in COVID deaths for each jurisdiction. 
The procedure should return the average weekly percentage change along with the jurisdiction and date range as output.








11. Additionally, create a user-defined function that takes in a 
jurisdiction as input and returns the average crude COVID rate for that jurisdiction over the entire dataset. 
Use both the stored procedure and the user-defined function to compare the average weekly percentage change in COVID deaths for each jurisdiction to the average crude COVID rate for that jurisdiction.



select * from covid_death_rates

select year(data_period_end),DATEPART(week,data_period_end) as weeks, sum(crude_covid_rate) from covid_death_rates group by year(data_period_end), DATEPART(week,data_period_end)