/*
Example based on DML statement trigger 1 from OA Lecture Slides 
"DML Triggers-1" page 15 utilizing fast food schema created in previous
assignment
*/
--create a log table based on staffs table
create table f_staffs_log as 
    select 
        * 
    from 
        f_staffs
    where 
        rownum < 1;

--add audit columns to new table
alter table f_staffs_log
    add 
        (
        user_changed    varchar2(50),
        date_changed    timestamp
        );
  
--create a trigger that logs user inserting new employee records
create or replace trigger tg_log_emp
after insert on f_staffs
for each row
begin
    insert into f_staffs_log
        --usage of :new.<column_name> is to pull value being inserted and log
        values (:new.id, :new.first_name, :new.last_name, :new.birthdate,
                :new.salary, :new.overtime_rate, :new.training, :new.staff_type,
                :new.manager_id, :new.manager_budget, :new.manager_target,
                user, sysdate);
end;
/

--insert a new shift manager
insert into f_staffs
values(18,'Kimmy','Schmidt',to_date('01/09/1988','MM/DD/YYYY'),40,null,'Order Taker','2nd Shift Manager',19,20000,40000);

--insert a new 2nd shift cook with Monique as manager
insert into f_staffs
values(22,'Tony','Benson',to_date('08/10/1992','MM/DD/YYYY'),12,null,'Grill','2nd Shift Cook',19,null,null);

/*
create a trigger that logs user who updated record for a staff member and
records the old values
*/
create or replace trigger tg_log_emp_upd
after update on f_staffs
for each row
begin
    insert into f_staffs_log
        --usage of :old.<column_name> is to pull value before update and log
        values (:old.id, :old.first_name, :old.last_name, :old.birthdate,
                :old.salary, :old.overtime_rate, :old.training, :old.staff_type,
                :old.manager_id, :old.manager_budget, :old.manager_target,
                user, sysdate);
                

end;
/

--update new employee, set manager to new shift manager
update f_staffs
set manager_id = 18
where id = 22;


--show the before and after for inserted and updated values
select
    o.id as new_emp_id,
    o.first_name,
    o.last_name,
    o.manager_id as old_mgr_id,
    l.manager_id as new_mgr_id,
    l.user_changed,
    l.date_changed
from
    f_staffs o
    join f_staffs_log l
        on l.id = o.id
order by
    l.date_changed desc;