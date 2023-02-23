SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*******************| CHECKLIST18: Primary and Foreign keys  |*************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
/*
 	- Primary key doit être non null et unique
	- Le nombre et le type des colonnes contraintes doivent correspondre au nombre et au type des colonnes référencées.
			FOREIGN KEY (b, c) REFERENCES autre_table (c1, c2)
*/


conn abdel/abdel;


CREATE TABLE supplier
( supplier_id numeric(10) not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE products
( product_id numeric(10) not null,
  supplier_id numeric(10) not null,
  CONSTRAINT fk_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
);
INSERT INTO supplier VALUES (10, 'test1', 'contact1');
INSERT INTO supplier VALUES (20, 'test2', 'contact2');
INSERT INTO supplier VALUES (30, 'test3', 'contact3');

INSERT INTO products VALUES (100, 10);
INSERT INTO products VALUES (200, 20);
INSERT INTO products VALUES (300, 30);

col supplier_id format a20
col supplier_name format a20
col contact_name format a20
SELECT * FROM supplier;
SELECT * FROM products;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('*************| Echec de suppression de la table parente et ses enregistrements  |*****');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

DROP TABLE supplier;
DELETE FROM supplier WHERE supplier_id=10;

/* Deux solutions:
	1. supprimer la contrainte
	2. supprimer la table enfant
*/
ALTER TABLE products
DROP CONSTRAINT fk_supplier;
DELETE FROM supplier WHERE supplier_id=10; # -> OK

SELECT * FROM products WHERE supplier_id=10; # -> return record
/*
	Pour ajouter la contrainte à la table enfant, il faut supprimer l'enregistrement qui apparait dans la TB enfant mais pas dans la TB parent
*/

delete from products where supplier_id=10;
ALTER TABLE products ADD CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id);

DROP TABLE products;
DROP TABLE supplier;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('**| Ajout de contrainte avec les options au cas de suppression: ON DELETE CASCADE  |***');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/
CREATE TABLE supplier
( supplier_id numeric(10) not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE products
( product_id numeric(10) not null,
  supplier_id numeric(10) not null,
  CONSTRAINT fk_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
    ON DELETE CASCADE
);
INSERT INTO supplier VALUES (10, 'test1', 'contact1');
INSERT INTO supplier VALUES (20, 'test2', 'contact2');
INSERT INTO supplier VALUES (30, 'test3', 'contact3');

INSERT INTO products VALUES (100, 10);
INSERT INTO products VALUES (200, 20);
INSERT INTO products VALUES (300, 30);

DELETE FROM supplier WHERE supplier_id=10;
SELECT * FROM products; 
/* -> record for 10 is deleted */

DROP TABLE supplier; 
/* tu ne peux pas la supprimer par ce que il contient des records referencé dans la table enfant */
DROP TABLE products;
DROP TABLE supplier;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('**********************************| ON DELETE SET NULL  |*****************************');
    DBMS_OUTPUT.PUT_LINE('**************************************************************************************');
END;
/

CREATE TABLE supplier
( supplier_id numeric(10) not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE products
( product_id numeric(10) not null,
  supplier_id numeric(10),
  CONSTRAINT fk_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
    ON DELETE SET NULL
);
INSERT INTO supplier VALUES (10, 'test1', 'contact1');
INSERT INTO supplier VALUES (20, 'test2', 'contact2');
INSERT INTO supplier VALUES (30, 'test3', 'contact3');

INSERT INTO products VALUES (100, 10);
INSERT INTO products VALUES (200, 20);
INSERT INTO products VALUES (300, 30);

DELETE FROM supplier WHERE supplier_id=10;
SELECT * FROM products; 
/* -> record for 10 is set to null */

DROP TABLE products;
DROP TABLE supplier;
conn sys/oracle as sysdba;
