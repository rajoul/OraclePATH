SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST5:  INDEX MANAGEMENT |************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

drop user abdel cascade;
drop role plustrace;
create user abdel identified by abdel;

grant myrole to abdel;

create role plustrace;
grant select on v_$sesstat to plustrace;
-- grant select on v_$statname to plustrace;
-- grant select on v_$mystat to plustrace;

grant select on dba_segments to abdel;
grant plustrace to abdel with admin option;
alter user abdel quota unlimited on users;
conn abdel/abdel;

CREATE TABLE user_data (
 id          NUMBER(10)    NOT NULL,
 first_name  VARCHAR2(40)  NOT NULL,
 last_name   VARCHAR2(40)  NOT NULL,
 gender      VARCHAR2(1),
 dob         DATE
);

BEGIN
  FOR cur_rec IN 1 .. 20000 LOOP
    IF MOD(cur_rec, 2) = 0 THEN
      INSERT INTO user_data 
      VALUES (cur_rec, 'John' || cur_rec, 'Doe', 'M', SYSDATE);
    ELSE
      INSERT INTO user_data 
      VALUES (cur_rec, 'Jayne' || cur_rec, 'Doe', 'F', SYSDATE);
    END IF;
    COMMIT;
  END LOOP;
END;
/

set autotrace on;
SELECT * from user_data where first_name='John196';
CREATE INDEX first_name_idx ON user_data (first_name);
SELECT * from user_data where first_name='John196';
set autotrace off;
select segment_name, segment_type, extents  from dba_segments where owner='ABDEL';
set autotrace on;
SELECT * from user_data where UPPER(first_name)='JOHN196' AND gender='M';
CREATE INDEX first_gender_idx ON user_data (gender, UPPER(first_name), dob) TABLESPACE USERS;
SELECT * from user_data where UPPER(first_name)='JOHN196' AND gender='M';

set autotrace off;
select segment_name, segment_type, extents  from dba_segments where owner='ABDEL';

/*            WHEN DROPPING TABLE
drop table user_data;
-- les index aussi sont supprimées mais tout est dans recyclebin

show recyclebin;
flashback table user_data to before drop;
select segment_name, segment_type, extents  from dba_segments where owner='ABDEL';
-- indexes are restored but you should rename them
alter index "BIN$Hi3djesbSgat3NiloK40zA==$1" rename to first_name_idx;
*/

/*          INVISIBLE INDEX
Pour tester l'impact d'un index avant de le supprimer : rend le invisible
ALTER INDEX index_name INVISIBLE;

To make an index visible:

ALTER INDEX index_name VISIBLE;
*/

/*          UNUSABLE INDEX
ALTER INDEX my_index UNUSABLE;
les segments correspond à cet index seront supprimés, pour réutiliser cet index il fallait:
  le recontruire
  drop it et le recréer

*/
set autotrace on;
alter index first_name_idx invisible;
SELECT * from user_data where first_name='John196';
alter index first_name_idx visible;
SELECT * from user_data where first_name='John196';


SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****************************| CHECKLIST14:  INDEX TYPES     |************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
/*
B-TREE Index: est un arbre équilibré utilisé pour stockées les données d'une BD
    
                                            100
                                        50                  150
                                25              75      125         175
                            id0     id25  
                            id1     id26
                            .         .
                            id24     id49

Bitmap index est utilisé lorsque la cardinalité est inférieur à 1%
cardinalité = nombre de valeur distincte d'une colonne / nombre totale des row

Bitmap sont utilisable lorsqu'il s'agit des colonnes gender ou nom des pays
        
                      gender M          gender F
            row0        1                   0
            row1        1                   0
            row2        0                   1

*/

create bitmap index bit_idx on user_data (gender);
select substr(segment_name,1,30) segment_name, bytes/1024 "Size in KB" from user_segments where segment_name in ('USER_DATA','BIT_IDX');
drop index bit_idx;
create index bit_idx on user_data (gender);
select substr(segment_name,1,30) segment_name, bytes/1024 "Size in KB" from user_segments where segment_name in ('USER_DATA','BIT_IDX');
/*
la taille des deux index est differente => gender le type d'index correspondant est bitmap
*/

conn sys/oracle as sysdba;
