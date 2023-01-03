SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST17:  SEQUENCE  |******************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
create user abdel identified by abdel;

grant myrole to abdel;

grant create sequence to abdel;

alter user abdel quota unlimited on users;
conn abdel/abdel;

CREATE SEQUENCE customers_seq START WITH 1000 INCREMENT BY 50 MAXVALUE 1100 CYCLE;
SELECT customers_seq.nextval from dual;
SELECT customers_seq.currval from dual;
SELECT customers_seq.nextval from dual;
SELECT customers_seq.nextval from dual;
SELECT customers_seq.nextval from dual;

-- after maxvalue reached the sequence starts with 1 then 51

DROP SEQUENCE customers_seq;
CREATE SEQUENCE customers_seq START WITH 1000 INCREMENT BY 20 MAXVALUE 1100;
SELECT customers_seq.nextval from dual;
SELECT customers_seq.currval from dual;
savepoint a;
SELECT customers_seq.nextval from dual;
SELECT customers_seq.nextval from dual;
rollback to savepoint a;
SELECT customers_seq.nextval from dual;
-- rollback doesn't reset the sequence to where it was before
DROP SEQUENCE customers_seq;
CREATE SEQUENCE myseq START WITH 1 INCREMENT BY 1 MAXVALUE 1000;
CREATE TABLE ord_items(ord_no NUMBER(4) DEFAULT myseq.NEXTVAL NOT NULL, item_no NUMBER(3));
INSERT INTO ord_items(item_no) VALUES(1);
INSERT INTO ord_items(item_no) VALUES(2);
INSERT INTO ord_items(item_no) VALUES(3);
INSERT INTO ord_items(item_no) VALUES(4);
INSERT INTO ord_items(item_no) VALUES(5);
select * from ord_items;

/*  IF SEQUENCE IS DROPPED -> les valeurs de la colonne ord_no vont rester
drop sequence myseq;
select * from ord_items;
    ORD_NO    ITEM_NO
---------- ----------
         1          1
         2          2
         3          3
         4          4
         5          5
*/

drop table ord_items;
CREATE TABLE ord_items(ord_no NUMBER(4) DEFAULT myseq.NEXTVAL NOT NULL, item_no NUMBER(3));
INSERT INTO ord_items(item_no) VALUES(1);
INSERT INTO ord_items(item_no) VALUES(2);
INSERT INTO ord_items(item_no) VALUES(3);
select * from ord_items;
/*
    ORD_NO    ITEM_NO
---------- ----------
         6          1
         7          2
         8          3
*/


conn sys/oracle as sysdba;
