SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST18: SHRINK SEGMENT  |*************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
/*
there are three types of shrink:
	SHRINK SPACE: Recover space and adjust the high water mark (HWM). (the number of blocks reduced in case we make a delete on a table)
	SHRINK SPACE COMPACT: Recover space, but don't amend the high water mark (HWM) -> the number of blocks remain the same
	SHRINK SPACE CASCADE: Recover space for the object and all dependant objects, par example pour les index and adjust the HWM
*/

@OraclePATH\mydatabase\execute.sql

grant select on dba_segments to abdel;
conn abdel/abdel;
select count(*) from order_items;
select segment_name, bytes, extents, blocks from dba_segments where segment_name like 'ORDER_ITEM%';
savepoint a;
delete order_items where quantity=1;
select count(*) from order_items;
select segment_name, bytes, extents, blocks from dba_segments where segment_name like 'ORDER_ITEM%';

-- Enable row movement.
ALTER TABLE order_items ENABLE ROW MOVEMENT;

-- Recover space and amend the high water mark (HWM).
ALTER TABLE order_items SHRINK SPACE;

-- Recover space, but don't change the high water mark (HWM).
-- ALTER TABLE order_items SHRINK SPACE COMPACT;

-- Recover space for the object and all dependant objects, par example pour les index
-- ALTER TABLE order_items SHRINK SPACE CASCADE;

select segment_name, bytes, extents, blocks from dba_segments where segment_name like 'ORDER_ITEM%';
select count(*) from order_items;

conn sys/oracle as sysdba;
