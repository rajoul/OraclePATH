SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST4: Gestion de stockage  |*********************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/


 select owner, table_name, tablespace_name, blocks, empty_blocks from dba_tables where table_name = 'ORDERS';

select segment_name,segment_type, bytes, tablespace_name, extents, blocks from dba_segments WHERE segment_name ='TEST';

 select * from dba_extents WHERE segment_name LIKE '%BRANDS%'; 

select file_name, tablespace_name, bytes from dba_data_files;


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

 select segment_type, sum(bytes) from (select OWNER,segment_name, segment_type, bytes from dba_segments where tablespace_name='USERS' and owner='ABDEL') group by segment_type ;