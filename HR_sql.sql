create database HR ;
select * from `wa_fn-usec_-hr-employee-attrition` as h_r ; 
rename table `wa_fn-usec_-hr-employee-attrition` to HR;

select * from HR;

alter table  HR
drop column EmployeeCount,
drop column EmployeeNumber,
drop column  Over18,
drop column StandardHours; 

select * from HR;

-- How many employees are there in total, and how many have left the company?
alter table hr change  column `ï»¿Age` Age  int ; 

-- handeling null valuse , encod attrition 
select 
count(case when attrition ='yes' then 1 end) as yess,
count(case when attrition ='no' then 1 end) as noo,
count(case when attrition is null then 1 end) as NUll_val
from hr; 


select count(Age) as totla_employee,
sum(case when attrition= 'yes' then 1 else 0 end) as employee_left 
from HR;


-- What is the overall attrition rate (in percentage)?
select (sum(case when Attrition= 'yes' then 1 else 0 end )/ sum(case when Attrition = 'yes' then 1 else 1 end))*100  as Attrition_percentage
from HR; 

-- How many departments are there, and how many employees are in each department?
select count(distinct department) as total_departmnt, count(*) as total_employee_in_each_department 
from hr;

-- What is the gender distribution in the company?
select (sum(case when gender='male' then 1 else 0 end)) as TotalMale, (sum(case when gender='female' then 1 else 0 end )) as TotlaFemale from hr;

-- What are the minimum, maximum, and average ages of employees?
 select min(age) as MinimunAge, max(age) as MaximumAge, round(avg(age),2) as AverageAge
 from hr; 
 
 -- Which department has the highest attrition rate?
 select Department, count(case when attrition='yes'then 1 else 0 end ) as Highest_attrition from hr
 where attrition = 'yes'
 group by Department;
 
 -- Which job roles show the highest attrition?
 select jobrole , count(case when attrition='yes' then 1 else 0 end) as HighestAttrition
 from hr  where Attrition='yes'
 group by jobrole order by HighestAttrition desc;
 
 -- What is the attrition rate for males vs females?
 select gender ,count(case when Attrition='yes' then 1 else 0 end ) as TotalAttrition
 from hr 
 group by gender; 
 
 -- Does overtime impact attrition? (Compare attrition for overtime = Yes vs No)
select overtime,
count(*) as total_employee ,
sum(case when attrition='yes' then 1 else 0 end) as Overtime_impact,
sum(case when attrition='no' then 1 else 0 end) as Overtime_not_impact
from hr 
group by Overtime order by Overtime_not_impact desc ;
 
 -- How does attrition vary across business travel frequency?
SELECT 
    BusinessTravel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS employees_stayed,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_percent
FROM hr
GROUP BY BusinessTravel
ORDER BY attrition_rate_percent DESC;

-- What is the average age of employees who left vs those who stayed?
SELECT 
    attrition,
    COUNT(*) AS employee_count,
    ROUND(AVG(age), 2) AS average_age
FROM hr
GROUP BY attrition;

-- What is the attrition rate by age group (e.g., <20, 20–30, 31–40, 41–50, 50+)?
select 
 (count(case when age < 20  and attrition = 'yes' then 1 end)) as attritionof20, 
 (count(case when age between 21 and 30 and attrition = 'yes ' then 1 end)) as attritionBet21and30,
 (count(case when age between 31 and 40 and attrition = 'yes' then 1 end)) as attritionBet31and40, 
 (count(case when age between 41 and 50 and attrition = 'yes' then 1 end)) as attritionBet41and50, 
 (count(case when age >50 and attrition = 'yes' then 1 end))as attritionAbove50
from hr ;
  
-- EDA (creating a view as well) for attrition% , dept , age ,OverTime
create view VW_attrition as 
select department , count(*) as Total_employee, age , OverTime,
sum(case when attrition = 'yes' then 1 else 0 end) as attrition_count,
round(100.0* sum(case when attrition='yes' then 1 else 0 end)/ count(*),2) as AttritionRtate
from hr
group by department, age , OverTime;
select * from vw_attrition;

-- for easey to count the attrition 
alter table hr 
add column IntAttrition int ;

set sql_safe_updates = 0 ;
update hr 
set IntAttrition = 
case 
 when attrition = 'yes' then 1
 when attrition = 'no' then 0
 else 0 
end 
;

select distinct department from hr; 