-- step 1 calculate the duration ?
-- Solution uses day calculation + ceiling function

-- ceiling() is used to return the value after rounded up any positive or negative decimal value as greater than the argument. For example, CEILING(2.57) will return 3


-- duration is in fractional year (=number of days between two dates over 365)
with projects_durations as
(select id, title, budget, (DATEDIFF(DAY, start_date, end_date)* 1.0)/365 as duration
from linkedin_projects
),

-- step 2: connect employee info to project duration info. aggregate duration
employee_duration as
(select lep.emp_id, lep.project_id, sum(pdm.duration) as total_duration
from linkedin_emp_projects lep
join linkedin_employees le
on le.id = lep.emp_id
join projects_durations pdm
on pdm.id = lep.project_id
group by  lep.emp_id, lep.project_id)

-- step 3 & 4 : calculate prorated salary for each employee then aggregate on project title level
select lp.title, lp.budget, ceiling(sum(temp.prorated_salary)) as budget_estimate
from
(select le.id, edm.project_id, edm.total_duration, le.salary * total_duration as prorated_salary
from employee_duration edm
join linkedin_employees le
on le.id = edm.emp_id) as temp
join linkedin_projects lp
on lp.id = temp.project_id
group by lp.title, lp.budget
having ceiling(sum(temp.prorated_salary)) > budget
order by title
