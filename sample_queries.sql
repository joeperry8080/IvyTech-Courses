-- Get top 5 exam marks (Oracle 12c and higher)
SELECT 
    STUDENT_ID, 
    EXAM_ID, 
    MARKS
FROM 
    AD_EXAM_RESULTS
ORDER BY MARKS DESC
FETCH FIRST 5 ROWS ONLY;

-- Get top 5 exam marks (Oracle 11g and lower)
SELECT
    *
FROM
    (
    SELECT 
        STUDENT_ID, 
        EXAM_ID, 
        MARKS
    FROM 
        AD_EXAM_RESULTS
    order by
        marks desc
    )
WHERE
    ROWNUM < 6;
	
-- concatenation example
select
    course_id || ' [' || course_name as course_name
from
    ad_course;
    
-- math as parcent example
select
    student_id,
    exam_id,
    marks / 100 as grade_percent, -- computed column example
    marks / exam_id as example_not_rounded,
    round(marks / exam_id, 2) as example_rounded
from
    ad_exam_results;
    
-- where clause with logical operators

-- using gt logic
select
    *
from
    ad_exam_results
where
    -- using gt logic
    marks > 90; 
 
	
-- using between logic	
select
    *
from
    ad_exam_results
where
    marks between 90 and 100;

-- using gt with lt logic	
select
    *
from
    ad_exam_results
where
    marks >= 90
    or marks < 60;
    
-- where clause with and as well as like
select
    *
from
    ad_course
where
    course_name like 'C%'
    and session_id = 200;
    
-- order by
select
    *
from    
    ad_student
order by
    student_reg_year desc, -- Z-A OR 9-0
    first_name asc; -- A-Z OR 0-9
    
	
-- aggregates 1

select
    crs.course_name
    ,count(st.student_id) as student_count
    ,round(avg(exr.marks / 100),2) as exam_average_pct
    ,round(
        sum(
            sat.no_of_working_days / 
                sat.no_of_days_off
            ) / 100 ,2
        ) 
        as student_pct_days_missed
from
    ad_course crs
    inner join ad_student_course sc
        on sc.course_id = crs.course_id
    inner join ad_student st
        on st.student_id = sc.student_id
    inner join ad_exam_results exr
        on exr.course_id = crs.course_id
            and exr.student_id = st.student_id
    inner join ad_student_attendance sat
        on sat.student_id = st.student_id
where
    crs.department_id = 10
group by
    crs.course_name
having
    count(st.student_id) > 2
    or count(st.student_id) <= 1
    and avg(exr.marks / 100) > .25
order by
    crs.course_name asc;
	
-- aggregates 2
select
    dep.department_name,
    sum(emp.salary) as total_salary_sum,
    sum(emp.bonus) as total_bonus_sum,
    avg(emp.commission_pct) as commission_avg,
    min(emp.salary) as minimum_salary,
    max(emp.salary) as maximumm_salary,
    count(emp.employee_id) as employee_count
from
    employees emp
    inner join departments dep
        on dep.department_id = emp.department_id
where
    emp.hire_date > to_date('2012-01-01','YYYY-MM-DD')
group by
    dep.department_name
having
    sum(emp.bonus) is not null
    or sum(emp.commission_pct) is not null
order by
    dep.department_name;