SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: INTERSECT, SELECT, ORDER BY |*******************');
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
conn abdel/abdel;

CREATE TABLE Customers(ID INT PRIMARY KEY, Name VARCHAR(20), Country VARCHAR(20), City VARCHAR(20));

INSERT INTO Customers VALUES (1, 'Aakash', 'INDIA', 'Mumbai');
INSERT INTO Customers VALUES (2, 'George', 'USA', 'New York');
INSERT INTO Customers VALUES (3, 'David', 'INDIA', 'Bangalore');
INSERT INTO Customers VALUES (4, 'Leo', 'SPAIN', 'Madrid');
INSERT INTO Customers VALUES (5, 'Rahul', 'INDIA', 'Delhi');
INSERT INTO Customers VALUES (6, 'Brian', 'USA', 'Chicago');
INSERT INTO Customers VALUES (7, 'Justin', 'SPAIN', 'Barcelona');
select * from Customers;

CREATE TABLE Branches(Branch_Code INT PRIMARY KEY, Country VARCHAR(20), City VARCHAR(20));

INSERT INTO Branches VALUES (101, 'INDIA', 'Mumbai');
INSERT INTO Branches VALUES (201, 'INDIA', 'Bangalore');
INSERT INTO Branches VALUES (301, 'USA', 'Chicago');
INSERT INTO Branches VALUES (401, 'USA', 'New York');
INSERT INTO Branches VALUES (501, 'SPAIN', 'Madrid');
SELECT * FROM Branches;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: INTERSECT  |*************************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

SELECT Country, City FROM Customers INTERSECT SELECT Country, City FROM Branches ORDER BY City;
/*
Intersect elimine les duplicats dans le resultat
il fallait avoir les memes nombres de colonnes et types de colonnes dans les deux selects
*/


SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: MINUS  |*****************************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
-- lister les cities dans customers qui ne sont pas dans branches
SELECT City FROM Customers MINUS SELECT City FROM Branches ORDER BY City;
/*
il fallait avoir les memes nombres de colonnes et types de colonnes dans les deux selects
*/


SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('***********************| CHECKLIST6: DISTINCT  |**************************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

SELECT DISTINCT City FROM Customers;
/*
elmine les duplicats si je mentionne une seule colonne
elimine les duplicat de combinaiasons si je mentionne multiple columns
*/
SELECT City || ' -MA' AS City FROM Customers;
conn sys/oracle as sysdba;