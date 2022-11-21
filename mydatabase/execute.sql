

drop user abdel cascade;
create user abdel identified by abdel;
grant create session to abdel;
grant create table to abdel;
grant create any sequence to abdel;
grant select any sequence to abdel;

alter user abdel quota unlimited on users;

conn abdel/abdel

@OraclePATH/mydatabase/createTables.sql
@OraclePATH/mydatabase/loadDataIntoTables.sql

conn sys/oracle as sysdba;