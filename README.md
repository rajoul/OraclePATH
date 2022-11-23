### Installation 

1. download zip file
2. extract the zip file
3. run setup.exe


# Table of Contents
1. [checklist1: create a user and grant priviledge](#checklist1)
2. [checklist2: Gestion des schemas](#checklist2)
3. [checklist3: Gestion des roles](#checklist3)
3. [checklist4: Gestion de stockage](#checklist4)
6. [checklist6: Gestion des tablespace UNDO](#checklist6)


go check: https://localhost:5500/em/login
or 
```bash
# sqlplus user/password@database as sysdba
# sqlplus sys/oracle as sysdba
SQL> select instance_name from v$instance;
INSTANCE_NAME
--------------------------
orcl
```

### Oracle commands

```sh
# startup nomount/mount/open
# shutdown
```

```sql
> SELECT view_name from all_views where view_name like 'DBA_%';
DBA_USERS
DBA_TABLES
DBA_TABLESPACES
DBA_ROLES

# select * from dba_tables;
# select table_name from all_tables;
# select * from dba_tablespaces;
```

1. formattage d'affichage
```bash
# column col_name format a10
# show linesize
# set pagesize 30 : pagesize est le nombre de line a partir duquelle on a un header avec les noms des columnes
# set pagesize 3
TABLE_NAME             TABLESPACE_NAME
UTL_RECOMP_SORTED              SYSTE

TABLE_NAME             TABLESPACE_NAME
UTL_RECOMP_SORTED              SYSTE
```

2. create a user

```sql
> create user abdel identified by abdel
> select username, profile, default_tablespace from dba_users;

abdel has by default the tablespace users, every table i will create will be assigned to users TBS.
```


### SQL

```SQL
# drop table if exits sales; => doesn't exist in oracle
  <=>
DECLARE cnt NUMBER;
BEGIN
SELECT COUNT(*) INTO cnt FROM user_tables WHERE table_name = 'SALES';
IF cnt <> 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE sales';
END IF;
END;

```

| user_tables        | all_tables           | dba_tables  |
| ------------------ |:-------------:| -----:|
| liste des tables que l'user logged in is the owner      | liste des tables dont j'ai accès | liste des tables de la base de donnée |


#### priviledge


get the session_role
```sql
# select * from session_roles;
# set role all

```


### HELP

```SQL
# help show

```


# checklist1 
## create a user and grant priviledge

```SQL
# CREATE USER abdel IDENTIFIED BY password
# conn abdel/password
ORA-01045: user DATA_OWNER lacks CREATE SESSION privilege; logon denied

# show user
USER is ""

# grant create session to abdel;
# conn abdel/abdel
Ok
```

- verification des privileges associé a abdel:
```SQL
SQL> select * FROM USER_SYS_PRIVS;
USERNAME      PRIVILEDGE      ADM COM INH
abdel         CREATE SESSION
```

- grant create table
```SQL
SQL> grant create table to abdel
SQL> select * FROM USER_SYS_PRIVS;
USERNAME      PRIVILEDGE      ADM COM INH
abdel         CREATE TABLE
abdel         CREATE SESSION
```

- create a table
```SQL
SQL> 
create table customers ( 
  customer_id integer not null primary key,
  customer_name varchar2(100) not null
);

SQL> insert into customers values ( 1, 'First customer!' );
ORA-01950: no privileges on tablespace 'USERS'
```

- Get the default table space:
```SQL
SQL>  select default_tablespace from DBA_USERS where username='ABDEL';
USERS
```

- define unlimited quota to user

```SQL
SQL> alter user abdel quota unlimited on users;
SQL> insert into customers values ( 1, 'First customer!' );
OK
```

- select tables created by me
```SQL
SQL> select table_name from user_tables;
customers
```


- update table 
```SQL
SQL> update customers set customer_name ='test' where custome_id=1;
SQL> drop table customers;
```

- attribute select from any tables 
```SQL
SQL> grant select any table to abdel;
OK
SQL> select * from hr.regions;
data
```







# Checklist2

Gestion des accès

le privilege CREATE TABLE: contient le droit d'insert/update/drop dans le schema de l'utilisateur

le privilege CREATE ANY TABLE: permet de créer/insert/update/drop la table sur n'importe quel schema
```SQL
SQL> select * from hr.schema;
```

```SQL
SQL> create table abdel.test(id int primary key, name varchar(255) not null);
OK
```
par contre CREATE TABLE permet de créer la table sur ton propre schema

```SQL
SELECT DISTINCT OWNER, OBJECT_NAME 
  FROM ALL_OBJECTS
 WHERE OBJECT_TYPE = 'TABLE'
   AND OWNER = 'ABDEL'
```

- we have two users: abdel and user1 => I need to give user1 privilege to select a table from abdel
```SQL
SQL> grant select on abdel.TEST to user1 
OK

SQL> conn user1/user
SQL> select * from abdel.TEST;
OK
SQL> select * from dba_tab_privs where grantee ='USER1';
```
Ou bien donner un privilege un peu large (GRANT SELECT ANY TABLE to user1)





### Graphs

```
    ALL_USERS                                                           DBA_SYS_PRIVS (contient all privs for all user)
        |                                                                       |
    DBA_USERS (more details)                                            DBA_TAB_PRIVS (contient les privs grantee et grantor)
                                                                                |
                                                                        USER_SYS_PRIVS (contient les privs du CURRENT_USER)
```
```
                        DBA_ROLES (contient tous les roles)
                            |
                        DBA_ROLE_PRIVS ( User a quel role)
                            |
                        ROLE_SYS_PRIVS (le role a quel privilege)   select * from role_sys_privs where role = 'DBA';  <=> select * from user_sys_privs;


```

# checklist3
Gestion des roles

- create a role and grant privileges
```SQL
SQL> create role myrole identified by pass;
SQL> grant create table to myrole;
SQL> select * from role_sys_privs where role ='MYROLE';
ROLE                      PRIVILEGE                 ADMIN_OPTI COMMON   INHERITED
------------------------- ------------------------- ---------- -------- ----------
MYROLE                    SELECT ANY TABLE          NO         NO       NO
MYROLE                    CREATE TABLE              NO         NO       NO
MYROLE                    CREATE SESSION            NO         NO       NO

SQL> grant myrole to user1;
SQL> select grantee, role, privilege from dba_role_privs inner join role_sys_privs on granted_role = role where grantee = 'USER1';
GRANTEE         ROLE                      PRIVILEGE
--------------- ------------------------- -------------------------
USER1           MYROLE                    SELECT ANY TABLE
USER1           MYROLE                    CREATE TABLE
USER1           MYROLE                    CREATE SESSION

SQL> revoke create table from myrole;
SQL> select grantee, role, privilege from dba_role_privs inner join role_sys_privs on granted_role = role where grantee = 'USER1';
GRANTEE         ROLE                      PRIVILEGE
--------------- ------------------------- -------------------------
USER1           MYROLE                    SELECT ANY TABLE
USER1           MYROLE                    CREATE SESSION
```


# checklist4
  Gestion de stockage

```
SELECT * from dba_data_files;
                          file1.dbf      file2.dbf     file3.dbf ....... filen.dbf
                              |               |             |               |
                              +---------------------------------------------+
                                                    |
                                              tablespace (USERS)
                                                    |
                          +--------------------------------------------------------+
                          |                     |             |                    |         
                          segment1(table)    segment2      segment3            segmentn    (dba_segments)
        select segment_name,segment_type, bytes, tablespace_name, extents, blocks, min_extents, max_extents, max_size from dba_segments WHERE segment_name ='ORDERS';   
                            |
            +-----------------------------------------------+
          extent1       extent2                           extentn          select * from dba_extents WHERE segment_name ='ORDERS';                
            |
    +------------------------------------------+
    block1   block2    block3    block4      block8   chaque block contient 8192 bytes
```

une fois je fais le permier insert in a table (segment) => Oracle allow un seul extent(8 block) une fois j'insère 65536 bytes (extent1 est rempli) il alloue un deuxième extent


# checklist6
  Gestion des tables spaces UNDO

```
When we execute an operations that needs to allocate undo space:

Allocate an extent in an undo segment which has no active transaction. Why in other segment? Because Oracle tries to distribute transactions over all undo segments.
  If no undo segment was found then oracle tries to online an off-line undo segment and use it to assign the new extent..
  If no undo segments was possible to online, then Oracle creates a new undo segment and use it.
  If the free space doesn't permit creation of undo segment, then Oracle tries to reuse an expired extent from the current undo segments.
  If failed, Oracle tries to reuse an expired extent from another undo segment.
  If failed, Oracle tries to autoextend a datafile (if autoextensible=yes)
  If failed, Oracle tries to reuse an unexpired extent from the current undo segment.
  If failed, Oracle tries to reuse an unexpired extent from another undo segment.
  If failed, then the operation will fail.

  ```