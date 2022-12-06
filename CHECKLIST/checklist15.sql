SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST15:  SYNONYMS     |***************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
create user abdel identified by abdel;

grant myrole to abdel;
grant select on dba_segments to abdel;
grant create synonym to abdel;
grant create public synonym to abdel;
alter user abdel quota unlimited on users;
conn abdel/abdel;

/*
deux types de synonyms:
  private synonym in your own schema, you must have the CREATE SYNONYM system privilege.
  private synonym in another user's schema, you must have the CREATE ANY SYNONYM system privilege.
  PUBLIC synonym, you must have the CREATE PUBLIC SYNONYM system privilege.
CREATE [OR REPLACE] [PUBLIC] SYNONYM schema.synonym_name FOR schema.object;
*/

-- synonym privé, sa scope est seulement abdel schema
create synonym jobs for hr.jobs;
select * from jobs;
select synonym_name, table_owner, table_name from user_synonyms;

conn sys/oracle as sysdba;
select * from jobs;

create public synonym jobs for hr.jobs;
select * from jobs;
select synonym_name, table_owner, table_name from user_synonyms;