--q6 my own (do not use) PL/SQL block
declare
    c_start_date date;
    v_final_months number;
    v_max_date date;
begin
    select
        start_date into c_start_date
    from
        date_sample
    where
        date_id = (select min(date_id) from date_sample);
    
    --begin nested loop
    declare
        c_end_date date;
    begin
        select
            start_date into c_end_date
        from
            date_sample
        where
            date_id = (select max(date_id) from date_sample);
    
        --set variable for later use in outer block
        v_max_date := c_end_date;
        
        --begin inner nested loop
        declare
            v_months_between number;
        begin
            select
                months_between
                       (c_end_date,
                        c_start_date 
                ) into v_months_between
            from dual;
            
            v_final_months := v_months_between;

        end;
        --end inner nested loop
    end;
    --end nested loop   
    
    dbms_output.put_line('There are ' || v_final_months || 
                ' months between ' || c_start_date || chr(10) || 
                    ' and ' || v_max_date || ' in the date_sample table.');
end;
/