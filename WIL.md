

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

#   What is remaining ?

1. inner and outer join -> Outer joins can be used between multiple tables per query
2. Enterprise Manager Database Express
3. ADR
4. DBMS_PRIVILEGE_CAPTURE 
5. Oracle Net Services
6. service show unknown status
7. DB_CREATE_FILE_DEST 
8. non-equijoin
9. trace files produced by the Oracle Database server
10. OS_AUTHENT_PREFIX 
11. V$TABLESPACE
12. Oracle Data Dictionary -> 38
13. ADD_MONTH and NEXT_DAY
14. implicit and explicit conversion -> 44
15. STOP_JOB=immediate
16. Oracle database space management features will work with both Dictionary and Locally managed tablespaces?
17. new transaction always start? -> 55
18. PMON background process
19. multitenant
20. ASSM
21. unsed column
22. dispatchers in a shared server configuration
23. dvanced connection options supported by Oracle Net
24. 
25.
