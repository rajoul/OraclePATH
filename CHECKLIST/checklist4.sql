SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST4: Gestion de stockage  |*********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/


 SELECT owner, table_name, tablespace_name, blocks, empty_blocks FROM dba_tables where table_name = 'ORDERS';

SELECT segment_name,segment_type, bytes, tablespace_name, extents, blocks FROM dba_segments WHERE segment_name ='TEST';

 SELECT * FROM dba_extents WHERE segment_name LIKE '%BRANDS%'; 

SELECT file_name, tablespace_name, bytes FROM dba_data_files;


analyze table abdel.brands compute statistics;



/* Get the space total*/
SELECT   TABLESPACE_NAME, ROUND (SUM (BYTES) / 1048576) TOTALSPACE
        FROM     DBA_DATA_FILES
        GROUP BY TABLESPACE_NAME;

/* Get the used space */
SELECT   TABLESPACE_NAME, ROUND (SUM (BYTES) / (1024 )) "TOTALUSEDSPACE in KB"
        FROM     DBA_SEGMENTS
        GROUP BY TABLESPACE_NAME


/* Check indetails the size of ABDEL SCHEMA */

 SELECT segment_type, sum(bytes) FROM (SELECT OWNER,segment_name, segment_type, bytes FROM dba_segments where tablespace_name='USERS' and owner='ABDEL') group by segment_type ;