

- l'utilisateur peut créer une table sans avoir besoin du quota sur la tablespace
- CREATE TABLE mytble(xxxx): 
	ajoute le nom de la table dans all_tables, mais pas dans dba_segments (par ce que oracle n'as pas encore allouer les extents pour cette table)
	c'est le INSERT VALUES qui ajoute le nom de la table dans la vue dba_segments.
- chaque nouveau utilisateur hérite le role PUBLIC

1. DDL pour Data Definition Language:
	- CREATE, ALTER, DROP et TRUNCATE
2. DML pour Data Manipulation Language:
	- SELECT, INSERT, DELETE et UPDATE
3. DCL pour Data Control Language:
	- GRANT et ROVOKE
4. TCL pour Transaction Control Language:
	- COMMIT et ROLLBACK

1. difference entre DELETE, TRUNCATE et DROP:
	- DELETE:
		- DML
		- utilisé pour supprimer les rows avec l'option WHERE
		- DELETE without WHERE -> supprime tout les records
		- ne supprime pas la structure de la table

	- TRUNCATE:
		- cannot be used to delete a single row
		- delete all rows of a table
		- Integrity constraints will not be removed with the TRUNCATE command
		- ne supprime pas la structure de la table
	- DROP:
		- cannot be used to delete a single row
		- delete all rows of a table
		- delete columns
		- Integrity constraints will be removed with the TRUNCATE command
		- supprime la structure de la table

- All DML commands can rollback ,if not committed..While DDL commands cannot rollback..

- Oracle instance stages: https://www.oracletutorial.com/oracle-administration/oracle-startup/

- le nommage des colonnes:
	- evite de nomer les colonnes avec des types predefinie -> SELECT trans_date AS DATE from table -> error
	- evite les '-', ou bien met les - entre "" comme "custom-id" -> SELECT custom_id custom-id from table -> error
	- column alias in a WHERE clause doesn't work

- SYSDATE is a SQL function that returns the current date and time set for the operating system of the database server. 
- CURRENT_DATE returns the current date in the session time zone
	```
	select current_timestamp from dual;
	select current_date from dual;
	select sysdate from dual;
	08-AUG-21 02.00.13.303335 AM US/PACIFIC
	08-AUG-2021 02:00:15
	08-AUG-2021 09:00:17
	```


# MONTHS_BETWEEN

	select MONTHS_BETWEEN(SYSDATE, '25/01/2023') from dual; -> 1
	sysdate - '25/01/2023'

	select SYSDATE-4 from dual; -> fait la soustraction de 4 jours -> rettourne une date
	PROMO_BEGIN_DATE - SYSDATE -> will return a number.
