febtxn = LOAD '/home/hduser/retail/D02' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE febtxn;
--febtxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP febxn;
--(2001-02-28 00:00:00,02127637  ,B ,F ,110505,4711258004004,1,101.0,120.0)
--(2001-02-28 00:00:00,02161389  ,A ,F ,500210,4712425010255,2,174.0,192.0)
--(2001-02-28 00:00:00,02015088  ,E ,H ,100324,4713754987607,2,40.0,58.0)
-----------------------------------------------------------------------------------------------------------------------------------

feb = FOREACH febtxn GENERATE TRIM(cid) as custid,sales,SUBSTRING(tdate,0,10) as date;

--DESCRIBE feb;
--feb: {custid: chararray,sales: double,date: chararray}

--DUMP feb;
--(02127637,120.0,2001-02-28)
--(02161389,192.0,2001-02-28)
--(02015088,58.0,2001-02-28)
------------------------------------------------------------------------------------------------------------------------------------

orderfebbysales = ORDER feb by sales DESC;

--DESCRIBE orderfebbysales;
--orderfebbysales: {custid: chararray,sales: double,date: chararray}

--DUMP orderfebbysales;
--(00818711,5.0,2001-02-01)
--(02057316,4.0,2001-02-21)
--(00760904,4.0,2001-02-17)
-----------------------------------------------------------------------------------------------------------------------------------

febmaxsales = LIMIT orderfebbysales 1;

--DESCRIBE febmaxsales;
--febmaxsales: {custid: chararray,sales: double,date: chararray}

DUMP febmaxsales;
--(01622362,444000.0,2001-02-17)

----------------------------------------------------------------------------------------------------------------------------------

