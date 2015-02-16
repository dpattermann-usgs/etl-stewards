show user;
select * from global_name;
set timing on;
set serveroutput on;
whenever sqlerror exit failure rollback;
whenever oserror exit failure rollback;
select 'build summary tables start time: ' || systimestamp from dual;

begin
   etl_helper.create_summaries('stewards');
end;
/

select 'build summary tables end time: ' || systimestamp from dual;