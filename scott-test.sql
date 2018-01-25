
/*

SYS@oravm AS SYSDBA> desc all_tab_columns
 Name                                               Null?    Type
 -------------------------------------------------- -------- ----------------------------------
 OWNER                                              NOT NULL VARCHAR2(30)
 TABLE_NAME                                         NOT NULL VARCHAR2(30)
 COLUMN_NAME                                        NOT NULL VARCHAR2(30)
 DATA_TYPE                                                   VARCHAR2(106)
 DATA_TYPE_MOD                                               VARCHAR2(3)
 DATA_TYPE_OWNER                                             VARCHAR2(30)
 DATA_LENGTH                                        NOT NULL NUMBER
 DATA_PRECISION                                              NUMBER
 DATA_SCALE                                                  NUMBER
 NULLABLE                                                    VARCHAR2(1)
 COLUMN_ID                                                   NUMBER
 DEFAULT_LENGTH                                              NUMBER
 DATA_DEFAULT                                                LONG
 NUM_DISTINCT                                                NUMBER
 LOW_VALUE                                                   RAW(32)
 HIGH_VALUE                                                  RAW(32)
 DENSITY                                                     NUMBER
 NUM_NULLS                                                   NUMBER
 NUM_BUCKETS                                                 NUMBER
 LAST_ANALYZED                                               DATE
 SAMPLE_SIZE                                                 NUMBER
 CHARACTER_SET_NAME                                          VARCHAR2(44)
 CHAR_COL_DECL_LENGTH                                        NUMBER
 GLOBAL_STATS                                                VARCHAR2(3)
 USER_STATS                                                  VARCHAR2(3)
 AVG_COL_LEN                                                 NUMBER
 CHAR_LENGTH                                                 NUMBER
 CHAR_USED                                                   VARCHAR2(1)
 V80_FMT_IMAGE                                               VARCHAR2(3)
 DATA_UPGRADED                                               VARCHAR2(3)

*/

drop table scott.long_test purge;
drop table scott.lob_test purge;

create table scott.lob_test (
	owner             varchar2(30),
	table_name        varchar2(30),
	column_name       varchar2(30),
	lob_col           clob
)
/


insert /*+ append */ into scott.lob_test
select owner, table_name, column_name, to_lob(data_default)
from all_tab_columns
where data_default is not null
/


copy to scott/tiger@//192.168.1.44/oravm.jks.com  -
create long_test ( -
   owner -
   , table_name -
   , column_name -
   , long_col -
) -
using -
select -
   owner -
   , table_name -
   , column_name -
   , data_default long_col -
from all_tab_columns -
where data_default is not null;

