SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST16:  TEMPORARY TABLE  |***********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
create user abdel identified by abdel;

grant myrole to abdel;
grant select on dba_segments to abdel;

alter user abdel quota unlimited on users;
conn abdel/abdel;

/*
Oracle support two types of temporary tables.
	Global Temporary Tables:
		data are stored on disk
		table's definition are visible to all sessions connected to the DB but not the data
	Private Temporary Tables: 
		should start with the prefix "ORA$PTT_"
		data are stored in memory
		each temporary table's definition is only visible to the session which created it

The ON COMMIT DELETE ROWS clause indicates the data should be deleted at the end of the transaction.
the ON COMMIT PRESERVE ROWS clause indicates that rows will only be removed at the end of the session.
*/

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('**********************| CHECKLIST16:  GLOBAL TEMPORARY TABLE  |***********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/ 

CREATE GLOBAL TEMPORARY TABLE temp_table (id NUMBER, description  VARCHAR2(20)) ON COMMIT DELETE ROWS;
INSERT INTO temp_table VALUES (1, 'description1');
INSERT INTO temp_table VALUES (2, 'description2');
INSERT INTO temp_table VALUES (3, 'description3');

SELECT COUNT(*) FROM temp_table;
COMMIT;
SELECT COUNT(*) FROM temp_table; 
DROP TABLE temp_table PURGE;
CREATE GLOBAL TEMPORARY TABLE temp_table (id NUMBER, description  VARCHAR2(20)) ON COMMIT PRESERVE ROWS;
INSERT INTO temp_table VALUES (1, 'description1');
INSERT INTO temp_table VALUES (2, 'description2');
INSERT INTO temp_table VALUES (3, 'description3');

COMMIT;
SELECT COUNT(*) FROM temp_table;
conn abdel/abdel
SELECT COUNT(*) FROM temp_table;
DROP TABLE temp_table PURGE;
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('**********************| CHECKLIST16:  PRIVATE TEMPORARY TABLE  |**********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/ 
CREATE PRIVATE TEMPORARY TABLE ora$ptt_temp_table (id NUMBER, description  VARCHAR2(20)) ON COMMIT DROP DEFINITION;
INSERT INTO ora$ptt_temp_table VALUES (1, 'description1');
INSERT INTO ora$ptt_temp_table VALUES (2, 'description2');
INSERT INTO ora$ptt_temp_table VALUES (3, 'description3');

SELECT COUNT(*) FROM ora$ptt_temp_table;
COMMIT;
SELECT COUNT(*) FROM ora$ptt_temp_table; -- return ERROR

CREATE PRIVATE TEMPORARY TABLE ora$ptt_temp_table (id NUMBER, description  VARCHAR2(20)) ON COMMIT PRESERVE DEFINITION;
INSERT INTO ora$ptt_temp_table VALUES (1, 'description1');
INSERT INTO ora$ptt_temp_table VALUES (2, 'description2');
INSERT INTO ora$ptt_temp_table VALUES (3, 'description3');

COMMIT;
SELECT COUNT(*) FROM ora$ptt_temp_table;
conn abdel/abdel
SELECT COUNT(*) FROM ora$ptt_temp_table; -- return ERROR

conn sys/oracle as sysdba;
