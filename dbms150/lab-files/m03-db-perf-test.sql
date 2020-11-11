-- drop the table in case it already exists
drop table perf_test;

-- create a table to populate with random data
create table perf_test (
   row_id number not null,
   id1     number not null,
   id2     number not null
);

-- generate and insert a bunch of random data
insert into perf_test
select row_id.n, gen.x, ceil(dbms_random.value(0, 100)) 
from 
	(
	select 
		level - 1 n
	from 
		dual
	connect by level < 100) row_id 
	-- change the above value higher or lower as-needed, don't go over 300!!
	-- value of 100 generates about 14.5 million rows which is more than enough
	, 
	(
	select 
		level x
	from 
		dual
	connect by level < 900000
	) gen
where 
	gen.x <= row_id.n * 3000;
 
-- create an index so the query against the table runs, and to create server load
create index ix_perf_slow on perf_test (row_id, id1, id2);

-- force a stats gather to build a query plan
begin
     dbms_stats.gather_table_stats(null, 'perf_test' 
                                       , cascade => true);
end;
/

-- create a package so we can call random data
create or replace package pkg_perf_test is
  type piped_output is record ( row_id  number
                              , seconds  number
                              , cnt_rows number);
  type piped_output_table is table of piped_output;

  function run(sql_txt in varchar2, n in number)
    return pkg_perf_test.piped_output_table pipelined;
end;
/

create or replace package body pkg_perf_test
is
  type tmp is table of piped_output index by pls_integer;

  function run(sql_txt in varchar2, n in number)
    return pkg_perf_test.piped_output_table pipelined
  is
    rec  pkg_perf_test.tmp;
    r    pkg_perf_test.piped_output;
    iter number;
    sec  number;
    strt number;
    exec_txt varchar2(4000);
    cnt  number;
  begin
    exec_txt := 'select count(*) from (' || sql_txt || ')';
    iter := 0;
    while iter <= n loop
      sec := 0;
      while sec < 300 loop
        if iter = 0 then
           rec(sec).seconds  := 0;
           rec(sec).row_id  := sec;
           rec(sec).cnt_rows := 0;
        end if;
        strt := dbms_utility.get_time;
        execute immediate exec_txt into cnt using sec;
        rec(sec).seconds := rec(sec).seconds 
                          + (dbms_utility.get_time - strt)/100;
        rec(sec).cnt_rows:= rec(sec).cnt_rows + cnt;
        if iter = n then
          pipe row(rec(sec));
        end if;
        sec := sec +1;
      end loop;
      iter := iter +1;
    end loop;
    return;
  end;
end pkg_perf_test;
/

-- this can be used to select random data from the table and genrate some server load
select *
  from table(pkg_perf_test.run(
       'select * ' 
      || 'from perf_test '
      ||'where row_id=:1 '
      ||  'and id2=ceil(dbms_random.value(1,100))', 10));