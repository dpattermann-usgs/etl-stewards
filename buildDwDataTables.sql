show user;
select * from global_name;
set timing on;
set serveroutput on;
whenever sqlerror exit failure rollback;
whenever oserror exit failure rollback;
select 'build dw data tables start time: ' || systimestamp from dual;

begin
  declare new_suffix varchar2(6 char);

begin
  select '_' || to_char(nvl(max(to_number(substr(table_name, length('RESULT_') + 1))) + 1, 1), 'fm00000')
    into new_suffix
    from user_tables
   where translate(table_name, '0123456789', '0000000000') = 'RESULT_00000';
  dbms_output.put_line('new suffix:' || new_suffix); 
  
  execute immediate 'create table organization' || new_suffix || ' as select * from organization_temp';
  execute immediate 'alter table organization' || new_suffix || ' add constraint organization' || new_suffix || '_pk primary key (code_value)';
  dbms_output.put_line('created table organization' || new_suffix);
  
  execute immediate 'create table station' || new_suffix || ' as select * from station_temp';
  execute immediate 'alter table station' || new_suffix || ' add constraint station' || new_suffix || '_pk primary key (station_pk)';
  execute immediate 'alter table station' || new_suffix || ' add constraint station' || new_suffix || '_org foreign key (organization_id) references organization' ||
                     new_suffix || ' (code_value) disable';
  dbms_output.put_line('created table station' || new_suffix);

  execute immediate 'create table activity' || new_suffix || ' as select * from activity_temp';
  execute immediate 'alter table activity' || new_suffix || ' add constraint activity' || new_suffix || '_pk primary key (activity_pk)';
  execute immediate 'alter table activity' || new_suffix || ' add constraint activity' || new_suffix || '_station foreign key (station_pk) references station' ||
                     new_suffix || ' (station_pk) disable';
  dbms_output.put_line('created table activity' || new_suffix);

  execute immediate 'create table result' || new_suffix || ' as select * from result_temp';
  execute immediate 'alter table result' || new_suffix || ' add constraint result' || new_suffix || '_pk primary key (result_pk)';
  execute immediate 'alter table result' || new_suffix || ' add constraint result' || new_suffix || '_station foreign key (station_pk) references station' ||
                     new_suffix || ' (station_pk) disable';
  execute immediate 'alter table result' || new_suffix || ' add constraint result' || new_suffix || '_activity foreign key (activity_pk) references activity' ||
                     new_suffix || ' (activity_pk) disable';
  dbms_output.put_line('created table result' || new_suffix);

end;
end;
/

select 'build dw data tables end time: ' || systimestamp from dual;