show user;
select * from global_name;
set timing on;
set serveroutput on;
whenever sqlerror exit failure rollback;
whenever oserror exit failure rollback;
select 'build ookups start time: ' || systimestamp from dual;

begin
   etl_helper.create_code_tables('stewards');
end;
/

select 'build lookups end time: ' || systimestamp from dual;