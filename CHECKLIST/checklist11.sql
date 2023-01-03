SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****| CHECKLIST11: Conversion Functions and Conditional Expressions |****************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/


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


SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*****| CHECKLIST11: NVL: nvl(expr1, expr2) |******************************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/


/*
NVL lets you replace null (returned as a blank) with a string in the results of a query
NVL(expr1, expr2) <=> 
		CASE
		    WHEN expr1 IS NOT NULL
		    THEN expr1
		    ELSE expr2
		  END
NVL2(expr1, expr2, expr3) <=> 
		CASE
		    WHEN expr1 IS NOT NULL
		    THEN expr2
		    ELSE expr3
		 END 
expr1 et expr2 et expr3 should have the same datatype => 
SQL> select nvl(to_char(12), 'non') from dual;
12
*/


/* 			NULLIF
The NULLIF(expr1, expr2) function returns NULL if two expressions are equal, otherwise it returns the first expression.
select nullif(2,3) from dual; => return 2

			COALESCE()
The COALESCE() function returns the first non-null value in a list.
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com'); => return "W3Schools.com"

			TO_CHAR()
convert number to varchar2
			TO_DATE
select TO_DATE('23/04/49','DD/MM/YY') from dual;


			ROUND
select round(17.284, -1) from dual; => 20
select round(17.284, 1) from dual; => 17.3
select round(17.284, 2) from dual; => 17.28
select round(17.285, 2) from dual; => 17.29

*/

conn sys/oracle as sysdba;