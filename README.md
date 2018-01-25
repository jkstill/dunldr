
# dunldr - data unloader for Oracle

The dunldr script will unload data from a table/tables/schema and dump to a .txt file.
sqlldr and parameter files will be created for each table as well.

Please use dunldr -help to see all the options


## test schema

If the demo account 'scott' is available, use the script scott-test.sql to create two tables, one with a LONG and the other with a CLOB.

``` text


SYS@oravm AS SYSDBA> @scott-test

Table dropped.


Table dropped.


Table created.


2676 rows created.


Array fetch/bind size is 15. (arraysize is 15)
Will commit when done. (copycommit is 0)
Maximum long size is 80. (long is 80)
Table LONG_TEST created.

   2676 rows selected from DEFAULT HOST connection.
   2676 rows inserted into LONG_TEST.
   2676 rows committed into LONG_TEST at scott@//192.168.1.44/oravm.jks.com.

```

Next use dunldr to unload the tables.

``` text
./dunldr -database oravm -username scott -password tiger -owner scott -dateformat 'yyyy-mm-dd hh24:mi:ss' -schemadump -bincol lob_test=lob_col -bincol long_test=long_col
Table: EMP
Table: DEPT
Table: SALGRADE
Table: LOB_TEST
Table: EMPLOYEE
Table: LONG_TEST
Table: P1
Table: P2
Table: BONUS
```

Now take a look at one of the tables with lob/long - the data is in hex.

```text
$ head scott.dump/lob_test.txt
"SYS","USER$","ASTATUS","3020"
"SYS","USER$","LCOUNT","3020"
"SYSTEM","DEF$_PROPAGATOR","CREATED","5359534441544520"
"SYSTEM","DEF$_ORIGIN","CATCHUP","27303027"
"SYSTEM","DEF$_PUSHED_TRANSACTIONS","LAST_TRAN_ID","30"
"SYSTEM","DEF$_PUSHED_TRANSACTIONS","DISABLED","274627"
"SYSTEM","REPCAT$_REPCAT","GOWNER","275055424C494327"
"SYSTEM","REPCAT$_REPCAT","FLAG","273030303030303030270A"
"SYSTEM","REPCAT$_FLAVORS","GOWNER","275055424C494327"
"SYSTEM","REPCAT$_FLAVORS","CREATION_DATE","53595344415445"
```

The sqlldr control file will use the to_hex() function to load that column:

```text
EATION_DATE","53595344415445"
jkstill@poirot ~/oracle/dunldr $ cat scott.dump/lob_test.ctl
load data
infile 'lob_test.txt'
into table LOB_TEST
fields terminated by ',' optionally enclosed by '"'
(
   OWNER,
   TABLE_NAME,
   COLUMN_NAME,
   LOB_COL "hex_to_raw(:LOB_COL)"
)

```

There is also a parameter file per table:

```text
$ cat scott.dump/lob_test.par
userid = scott
control = lob_test.ctl
log = lob_test.log
bad = lob_test.bad
```


