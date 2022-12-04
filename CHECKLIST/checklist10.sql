SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: CHECK DATE TYPES |*******************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

/*
The datetime data types are DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, and TIMESTAMP WITH LOCAL TIME ZONE
*/


drop user abdel cascade;
create user abdel identified by abdel;
/* MYROLE
create role myrole;
grant create session to myrole;
grant create table to myrole;
grant create any sequence to myrole;
grant select any sequence to myrole;
*/

grant myrole to abdel;

alter user abdel quota unlimited on users;
show parameter NLS_DATE_FORMAT;

conn abdel/abdel;
-- Inserting Data into a TIME Column
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
CREATE TABLE table_dt (c_id NUMBER, c_dt DATE);
INSERT INTO table_dt VALUES(1, '01-01-2003');
INSERT INTO table_dt VALUES(2, DATE '2003-02-01');
INSERT INTO table_dt VALUES(3, TIMESTAMP '2003-03-01 00:00:00 America/Los_Angeles');
INSERT INTO table_dt VALUES(4, TO_DATE('01-12-2003', 'DD-MM-YYYY'));
SELECT * FROM table_dt;
-- timestamp and timezone are dropped


-- Inserting Data into a TIMESTAMP Column
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='DD-MM-YY HH:MI:SSXFF';
CREATE TABLE table_ts(c_id NUMBER, c_ts TIMESTAMP);
INSERT INTO table_ts VALUES(1, '01-01-2003 2:00:00');
INSERT INTO table_ts VALUES(2, TIMESTAMP '2003-01-01 2:00:34.23432');
INSERT INTO table_ts VALUES(3, TIMESTAMP '2003-01-01 2:23:00 -08:00');
SELECT * FROM table_ts;


-- Inserting Data into the TIMESTAMP WITH TIME ZONE Data Type
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT='DD-MM-RR HH:MI:SSXFF AM TZR';
ALTER SESSION SET TIME_ZONE='-7:00';
CREATE TABLE table_tstz (c_id NUMBER, c_tstz TIMESTAMP WITH TIME ZONE);
INSERT INTO table_tstz VALUES(1, '01-01-2003 2:00:00 AM -07:00');
INSERT INTO table_tstz VALUES(2, TIMESTAMP '2003-01-01 2:00:00');
INSERT INTO table_tstz VALUES(3, TIMESTAMP '2003-01-01 2:00:00 -8:00');
SELECT * FROM table_tstz;
/*
1 01-01-03 02:00:00,000000 AM -07:00
2 01-01-03 02:00:00,000000 AM -07:00
3 01-01-03 02:00:00,000000 AM -08:00
 */

-- Inserting Data into the TIMESTAMP WITH LOCAL TIME ZONE Data Type
ALTER SESSION SET TIME_ZONE='-02:00';
SELECT SESSIONTIMEZONE FROM dual;
SELECT LOCALTIMESTAMP, CURRENT_TIMESTAMP FROM dual;
CREATE TABLE table_tsltz (c_id NUMBER, c_tsltz TIMESTAMP WITH LOCAL TIME ZONE);
INSERT INTO table_tsltz VALUES(1, '01-01-2003 2:00:00');
INSERT INTO table_tsltz VALUES(2, TIMESTAMP '2003-01-01 2:00:00');
INSERT INTO table_tsltz VALUES(3, TIMESTAMP '2003-01-01 2:39:00 -04:00');
SELECT * FROM table_tsltz;
/*
3 01/01/03 04:39:00,000000 
la valeur affiché est : timezone- (-4) => 2 => 2003-01-01 4:39:00
time zone is applied when the value is retrieved, not stored.
*/
conn sys/oracle as sysdba;