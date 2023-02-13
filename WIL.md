

- l'utilisateur peut créer une table sans avoir besoin du quota sur la tablespace
- CREATE TABLE mytble(xxxx): 
	ajoute le nom de la table dans all_tables, mais pas dans dba_segments (par ce que oracle n'as pas encore allouer les extents pour cette table)
	c'est le INSERT VALUES qui ajoute le nom de la table dans la vue dba_segments.
- chaque nouveau utilisateur hérite le role PUBLIC