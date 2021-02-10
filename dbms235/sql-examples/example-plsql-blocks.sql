--anonymous block
declare
    v_date varchar2(30);
    v_tomorrow_date varchar2(30);
begin
    select
        to_char(sysdate, 'YYYY-MM-DD'),
        to_char(sysdate + 1, 'YYYY-MM-DD')
    into
        v_date,v_tomorrow_date
    from
        dual;
        
    dbms_output.put_line('The date today is: ' || v_date || ' tomorrow is: ' || v_tomorrow_date);
end;
/
--named block
--this creates a procedure that will be saved for exec later
create or replace procedure print_date is
    v_date varchar2(30);
    v_tomorrow_date varchar2(30);
	v_yesterday_date varchar2(30);
begin
    select
        to_char(sysdate, 'YYYY-MM-DD'),
        to_char(sysdate + 1, 'YYYY-MM-DD'),
    	to_char(sysdate - 1, 'YYYY-MM-DD')
    into
        v_date,v_tomorrow_date,v_yesterday_date
    from
        dual;
        
    dbms_output.put_line('Today is: ' || v_date || ', yesterday was: ' || v_yesterday_date
        || ', tomorrow is: ' || v_tomorrow_date);
end;
/
--exec named procedure
begin
    print_date;
end;
/