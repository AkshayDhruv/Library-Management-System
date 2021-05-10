select * from historical_data;
select * from master_data;
select * from summary;
drop table historical_data;
drop table master_data;

TRUNCATE TABLE historical_data;

CREATE TABLE historical_data (
    MEMBER_ID INT NOT NULL,
    ITEM_ID INT NOT NULL,
    ITEM_STATUS CHAR(1000),
    ITEM_TYPE CHAR(1000),
    BORROW_DATETIME DATE,
    DUE_DATETIME DATE,
    RETURN_DATETIME DATE,
    TITLE CHAR(1000),
    AUTHOR CHAR(1000),
    CURRENT_DATETIME DATE
);

CREATE TABLE master_data (
    ITEM_ID INT NOT NULL,
    ITEM_TYPE CHAR(1000) NOT NULL,
    TITLE CHAR(1000),
    AUTHOR CHAR(1000),
    PUBLISHER CHAR(1000),
    PUBLICATION_YEAR INT,
    PUBLICATION_EDITION INT,
    SUBJECT CHAR(1000)
);

BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE DBUser.master_data';
EXCEPTION
      WHEN OTHERS THEN NULL;
END;

BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE historical_data';
EXCEPTION
      WHEN OTHERS THEN NULL;
END;

select * from master_data;
DROP TABLE master_data;
--INSERT INTO master_data (ITEM_ID, ITEM_TYPE, TITLE, AUTHOR, PUBLISHER, PUBLICATION_YEAR, PUBLICATION_EDITION, SUBJECT)

SELECT
   *
FROM
   all_tables;
WHERE
   table_name = 'DBUser.historical_data';
select 1 from tables where table_name = 'system.historical_data';


--table space---
  
CREATE TEMPORARY TABLESPACE tbs_temp_01
  TEMPFILE 'tbs_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;
    
CREATE TABLESPACE tbs_perm_01
  DATAFILE 'tbs_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE UNDO TABLESPACE tbs_temp_01
  DATAFILE 'tbs_undo_01.f'
    SIZE 10M 
    AUTOEXTEND ON
  RETENTION GUARANTEE;
  
DROP TABLESPACE tbs_temp_01
   INCLUDING CONTENTS AND DATAFILES;
   
--schema--
CREATE USER DBUser
  IDENTIFIED BY akshay14
  DEFAULT TABLESPACE tbs_perm_01
  TEMPORARY TABLESPACE tbs_temp_01
  QUOTA 20M on tbs_perm_01;
  
GRANT create session TO DBUser;
GRANT create table TO DBUser;
GRANT create view TO DBUser;
GRANT create any trigger TO DBUser;
GRANT create any procedure TO DBUser;
GRANT create sequence TO DBUser;
GRANT create synonym TO DBUser;

---------------------------------

select * from historical_data;
select DISTINCT item_type, count(borrow_datetime) as borrowed,  count() as overdue from historical_data group by item_type desc;

-------top 10 authors-------
select author,item_type from (select author,item_type from historical_data
GROUP BY author,item_type ORDER BY COUNT(author) DESC) where ROWNUM <=10;
----top 10 read books------
select title from (select title from historical_data where item_type='Book' 
GROUP BY title ORDER BY COUNT(title) DESC) where ROWNUM <=10;
-----top 5 read journals-----------
select title from (select title from historical_data where item_type='Journal' 
GROUP BY title ORDER BY COUNT(title) DESC) where ROWNUM <=5;
----------summary-------------------
SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type order by count(item_type) desc;
SELECT SUM(count(item_type)) grand_total FROM master_data group by item_type order by count(item_type) desc;

SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc;
SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc;
SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc;
SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc;


SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc);

select  q1.item_type, q1.borrowed, q2.overDue from 
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type 
order by q1.item_type asc;

----master 1 start-------
select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.overdue, q2.borrowed from 
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a1.item_type asc;
----master 1 end-------

-----master 2 start---------
SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc);
-----master 2 end-----------

----master 3 start---------
select item_type, borrowed, overdue, total_count from(
select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.overdue, q2.borrowed from 
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a2.total_count asc)
UNION
select item_type, borrowed, overdue, total_count from 
    (SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
    (SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
    (SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))
order by total_count asc);
------master 3 end------


---------master 4 start---------
CREATE TABLE SUMMARY 
AS (select item_type, borrowed, overdue, total_count from 
(select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.overdue, q2.borrowed from 
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a1.item_type asc)
UNION
select item_type, borrowed, overdue, total_count from 
(SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))order by total_count asc));
--------master 4 end--------

select * from master_data;
drop table summary;


------reference--------------
CREATE TABLE SUMMARY 
AS (select item_type, borrowed, overdue, total_count from 
(select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.overdue, q2.borrowed from 
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a1.item_type asc)
UNION
select item_type, borrowed, overdue, total_count from 
(SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))order by total_count asc));
---------------------------------
















----------------------new---------------------
select * from historical_data;
select * from master_data;
select * from summary;
drop table historical_data;
drop table master_data;

TRUNCATE TABLE historical_data;

CREATE TABLE historical_data (
    MEMBER_ID NUMBER,
    ITEM_ID NUMBER,
    ITEM_STATUS VARCHAR2(1000),
    ITEM_TYPE VARCHAR2(1000),
    BORROW_DATETIME VARCHAR2(1000),
    DUE_DATETIME VARCHAR2(1000),
    RETURN_DATETIME VARCHAR2(1000),
    TITLE VARCHAR2(1000),
    AUTHOR VARCHAR2(1000),
    CURRENT_DATETIME VARCHAR2(1000)
);

CREATE TABLE master_data (
    ITEM_ID NUMBER NOT NULL,
    ITEM_TYPE VARCHAR2(1000) NOT NULL,
    TITLE VARCHAR2(1000),
    AUTHOR VARCHAR2(1000),
    PUBLISHER VARCHAR2(1000),
    PUBLICATION_YEAR NUMBER,
    PUBLICATION_EDITION NUMBER,
    SUBJECT VARCHAR2(1000)
);

--BEGIN
--      EXECUTE IMMEDIATE 'DROP TABLE DBUser.master_data';
--EXCEPTION
--      WHEN OTHERS THEN NULL;
--END;
--
--BEGIN
--      EXECUTE IMMEDIATE 'DROP TABLE historical_data';
--EXCEPTION
--      WHEN OTHERS THEN NULL;
--END;

select * from master_data;
DROP TABLE master_data;
--INSERT INTO master_data (ITEM_ID, ITEM_TYPE, TITLE, AUTHOR, PUBLISHER, PUBLICATION_YEAR, PUBLICATION_EDITION, SUBJECT)

--SELECT
--   *
--FROM
--   all_tables;
--WHERE
--   table_name = 'DBUser.historical_data';
--select 1 from tables where table_name = 'system.historical_data';


--table space---
  
CREATE TEMPORARY TABLESPACE tbs_temp_01
  TEMPFILE 'tbs_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;
    
CREATE TABLESPACE tbs_perm_01
  DATAFILE 'tbs_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE UNDO TABLESPACE tbs_temp_01
  DATAFILE 'tbs_undo_01.f'
    SIZE 10M 
    AUTOEXTEND ON
  RETENTION GUARANTEE;
  
DROP TABLESPACE tbs_temp_01
   INCLUDING CONTENTS AND DATAFILES;
   
--schema--
--CREATE USER DBUser
--  IDENTIFIED BY akshay14
--  DEFAULT TABLESPACE tbs_perm_01
--  TEMPORARY TABLESPACE tbs_temp_01
--  QUOTA 20M on tbs_perm_01;
  
--GRANT create session TO DBUser;
--GRANT create table TO DBUser;
--GRANT create view TO DBUser;
--GRANT create any trigger TO DBUser;
--GRANT create any procedure TO DBUser;
--GRANT create sequence TO DBUser;
--GRANT create synonym TO DBUser;

---------------------------------

select * from historical_data;
select DISTINCT item_type, count(borrow_datetime) as borrowed,  count() as overdue from historical_data group by item_type desc;

-------top 10 authors-------
select author,item_type from (select author,item_type from historical_data
GROUP BY author,item_type ORDER BY COUNT(author) DESC) where ROWNUM <=10;
----top 10 read books------
select title from (select title from historical_data where item_type='Book' 
GROUP BY title ORDER BY COUNT(title) DESC) where ROWNUM <=10;
-----top 5 read journals-----------
select title from (select title from historical_data where item_type='Journal' 
GROUP BY title ORDER BY COUNT(title) DESC) where ROWNUM <=5;
----------summary-------------------
SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type order by count(item_type) desc;
SELECT SUM(count(item_type)) grand_total FROM master_data group by item_type order by count(item_type) desc;

SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc;
SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc;
SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc;
SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc;


SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc);

select  q1.item_type, q1.borrowed, q2.overDue from 
(SELECT rn.item_type, NVL(borrowed, 0) borrowed
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) borrowed 
from historical_data where item_status = 'Borrowed'
group by item_type)n on n.item_type = rn.item_type)q1 
INNER JOIN
(SELECT rn.item_type, NVL(overdue, 0) overdue
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) overdue 
from historical_data where item_status = 'Over Due'
group by item_type)n on n.item_type = rn.item_type)q2 
ON q1.item_type = q2.item_type 
order by q1.item_type asc;


----master 1 start-------
select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.borrowed, q2.overDue from 
(SELECT rn.item_type, NVL(borrowed, 0) borrowed
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) borrowed 
from historical_data where item_status = 'Borrowed'
group by item_type)n on n.item_type = rn.item_type)q1 
INNER JOIN
(SELECT rn.item_type, NVL(overdue, 0) overdue
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) overdue 
from historical_data where item_status = 'Over Due'
group by item_type)n on n.item_type = rn.item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a1.item_type asc;
----master 1 end-------

-----master 2 start---------
SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc);
-----master 2 end-----------

----master 3 start---------
select item_type, borrowed, overdue, total_count from(
select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.borrowed, q2.overDue from 
(SELECT rn.item_type, NVL(borrowed, 0) borrowed
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) borrowed 
from historical_data where item_status = 'Borrowed'
group by item_type)n on n.item_type = rn.item_type)q1 
INNER JOIN
(SELECT rn.item_type, NVL(overdue, 0) overdue
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) overdue 
from historical_data where item_status = 'Over Due'
group by item_type)n on n.item_type = rn.item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type 
order by a2.total_count asc)
UNION
select item_type, borrowed, overdue, total_count from 
(SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))
order by total_count asc);
------master 3 end------


---------master 4 start---------
CREATE TABLE SUMMARY 
AS (select item_type, borrowed, overdue, total_count from(
select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.borrowed, q2.overDue from 
(SELECT rn.item_type, NVL(borrowed, 0) borrowed
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) borrowed 
from historical_data where item_status = 'Borrowed'
group by item_type)n on n.item_type = rn.item_type)q1 
INNER JOIN
(SELECT rn.item_type, NVL(overdue, 0) overdue
from ( 
select 'Reference Book' as item_type from dual 
union all 
select 'CD' from dual 
union all 
select 'Journal' from dual 
union all 
select 'Book' from dual 
union all 
select 'Conference Procedings' from dual)rn 
LEFT JOIN (SELECT  item_type, count(item_type) overdue 
from historical_data where item_status = 'Over Due'
group by item_type)n on n.item_type = rn.item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type 
order by a2.total_count asc)
UNION
select item_type, borrowed, overdue, total_count from 
(SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))
order by total_count asc));
--------master 4 end--------

select * from summary;
drop table summary;


------reference--------------
CREATE TABLE SUMMARY 
AS (select item_type, borrowed, overdue, total_count from 
(select item_type, borrowed, overdue, total_count from 
(select a1.item_type, a1.overdue, a1.borrowed, a2.total_count from
(select  q1.item_type, q1.overdue, q2.borrowed from 
(SELECT DISTINCT item_type, count(item_status) overDue FROM historical_data where item_status = 'Over Due' group by item_type)q1 
INNER JOIN
(SELECT DISTINCT item_type, count(item_status) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type)q2 
ON q1.item_type = q2.item_type)a1
INNER JOIN
(SELECT DISTINCT item_type, count(item_type) total_count FROM master_data group by item_type)a2
ON a1.item_type = a2.item_type
order by a1.item_type asc)
UNION
select item_type, borrowed, overdue, total_count from 
(SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' group by item_type order by count(item_status) desc),
(SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' group by item_type order by count(item_status) desc), 
(SELECT SUM(count(item_type)) total_count FROM master_data group by item_type order by count(item_type) desc))order by total_count asc));
---------------------------------

-------master final-------------------
CREATE TABLE SUMMARY AS (SELECT item_type, borrowed, overdue, total_count FROM (SELECT item_type, borrowed, overdue, total_count FROM (SELECT a1.item_type, a1.overdue, a1.borrowed, a2.total_count FROM (SELECT  q1.item_type, q1.borrowed, q2.overDue FROM (SELECT rn.item_type, NVL(borrowed, 0) borrowed FROM (SELECT 'Reference Book' as item_type FROM dual UNION ALL SELECT 'CD' FROM dual UNION ALL SELECT 'Journal' FROM dual UNION ALL SELECT 'Book' FROM dual UNION ALL SELECT 'Conference Procedings' FROM dual)rn LEFT JOIN (SELECT  item_type, count(item_type) borrowed FROM historical_data where item_status = 'Borrowed' GROUP BY item_type)n on n.item_type = rn.item_type)q1 INNER JOIN (SELECT rn.item_type, NVL(overdue, 0) overdue FROM (SELECT 'Reference Book' as item_type FROM dual UNION ALL SELECT 'CD' FROM dual UNION ALL SELECT 'Journal' FROM dual UNION ALL SELECT 'Book' FROM dual UNION ALL SELECT 'Conference Procedings' FROM dual)rn LEFT JOIN (SELECT  item_type, count(item_type) overdue FROM historical_data where item_status = 'Over Due' GROUP BY item_type)n on n.item_type = rn.item_type)q2 ON q1.item_type = q2.item_type)a1 INNER JOIN (SELECT DISTINCT item_type, count(item_type) total_count FROM master_data GROUP BY item_type)a2 ON a1.item_type = a2.item_type ORDER BY a2.total_count asc) UNION SELECT item_type, borrowed, overdue, total_count FROM (SELECT * FROM (SELECT 'Grand Total' as item_type FROM DUAL),(SELECT SUM(count(item_status)) overDue FROM historical_data where item_status = 'Over Due' GROUP BY item_type ORDER BY count(item_status) desc), (SELECT SUM(count(item_status)) borrowed FROM historical_data where item_status = 'Borrowed' GROUP BY item_type ORDER BY count(item_status) desc), (SELECT SUM(count(item_type)) total_count FROM master_data GROUP BY item_type ORDER BY count(item_type) desc)) ORDER BY total_count asc));
---------------------------------------

select distinct member_id, item_id, item_type, due_datetime, title, author from historical_data where item_status='Over Due';
select * from (select current_datetime from historical_data) where rownum = 1;
select * from (select distinct member_id, item_id, item_type, due_datetime, title, author from historical_data where item_status='Over Due' order by member_id asc),
(select * from (select current_datetime from historical_data) where rownum = 1);

select * from (select distinct member_id, item_id, item_type, due_datetime, title, author from historical_data where item_status='Over Due' and member_id = 600001), (select * from (select current_datetime from historical_data) where rownum = 1);

-----------------------------------------------------
select user_password from ( select user_password from login_data where user_name='Akshay' and user_email_id='ahd123@gmail.com' and user_security_answer='Cake' 
group by user_password order by max(ROWNUM) desc) where rownum=1;

select * from  login_data where ROWNUM = (select max(ROWNUM) from login_data where user_name='Akshay' and user_email_id='ahd123@gmail.com' and user_security_answer='Cake');
drop table login_data;
delete from login_data where User_name='Test123';
--------------login-----------------------
CREATE TABLE login_data (
    USER_NAME CHAR(50) NOT NULL,
    USER_EMAIL_ID CHAR(50)  NOT NULL,
    USER_PASSWORD CHAR(50) NOT NULL,
    USER_SECURITY_ANSWER CHAR(50) NOT NULL
);

INSERT INTO login_data (USER_NAME, USER_EMAIL_ID, USER_PASSWORD, USER_SECURITY_ANSWER) VALUES ('Admin123', 'admin123@gmail.com', 'admin@123', 'Pizza');
INSERT INTO login_data (USER_NAME, USER_EMAIL_ID, USER_PASSWORD, USER_SECURITY_ANSWER) VALUES ('Test123', 'test123@gmail.com', 'test@123', 'Pasta');

select * from login_data where user_email_id = 'admin123@gmail.com'
select * from login_data where user_email_id = 'admin123@gmail.com'

------------------update currentdate----------------------------------
SELECT * FROM historical_data;
--update historical_date set item_status='Over Due' where 
select * from (SELECT member_id, item_id, item_status, due_datetime, return_datetime FROM historical_data),(select current_datetime from historical_data where rownum = 1);
SELECT member_id, item_id, item_status FROM historical_data  order by member_id asc;
select current_datetime from historical_data where rownum = 1;
--update historical_data set current_datetime = '06/21/2020 11:00 PM' where rownum = 1;


--update historical_data set item_status = 'Over Due' where current_date = '' 
select item_status,from historical_data where current_datetime = ;


---------------------end-----------------------------------
SELECT * FROM dba_tables where table_name = 'login_data';
select * from login_data;
SELECT count(*) FROM SYS.ALL_TABLES where table_name = 'LOGIN_DATA';
SELECT count(*) FROM LOGIN_DATE where user_email_id='admin123@gmail.com' and user_password='admin@123';

select user_password from login_data where user_name= 'Admin123' and user_email_id= 'admin123@gmail.com' and user_security_answer = 'Pizza' group by user_password;

select sum(overDue) as overDue from (SELECT count(item_status) as overDue FROM historical_data where item_status = 'Over Due' GROUP BY item_type ORDER BY count(item_status)) AS k;
select sum(borrowed) as borrowed from (SELECT count(item_status) as borrowed FROM historical_data where item_status = 'Borrowed' GROUP BY item_type ORDER BY count(item_status)) ;
select sum(total_count) as total_count from (SELECT count(item_type) as total_count FROM master_data GROUP BY item_type ORDER BY count(item_type)) as m;