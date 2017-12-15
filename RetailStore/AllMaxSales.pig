
alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE alltxn;
--alltxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP alltxn;
--(2001-01-31 00:00:00,02124032  ,D ,F ,120107,4716759020133,1,110.0,140.0)
--(2001-02-28 00:00:00,02127637  ,B ,F ,110505,4711258004004,1,101.0,120.0)
--(2000-11-30 00:00:00,01815788  ,D ,F ,500301,4711254012027,1,69.0,89.0)
--(2000-12-31 00:00:00,01862263  ,C ,F ,110507,4710172020015,1,19.0,23.0)
-----------------------------------------------------------------------------------------------------------------------------------------

txn = FOREACH alltxn GENERATE TRIM(cid) as custid,sales,SUBSTRING(tdate,0,10) as date;

--DESCRIBE txn;
--txn: {custid: chararray,sales: double,date: chararray}

--DUMP txn;
--(01720495,158.0,2000-12-31)
--(01753820,120.0,2000-12-31)
--(01862263,23.0,2000-12-31)
----------------------------------------------------------------------------------------------------------------------------------------

orderallbysales = ORDER txn by sales DESC;

--DESCRIBE orderallbysales;
--orderallbysales: {custid: chararray,sales: double,date: chararray}

--DUMP orderallbysales;
--(02127842,4.0,2000-11-29)
--(02164403,1.0,2000-12-13)
--(00900997,1.0,2001-02-11)
-------------------------------------------------------------------------------------------------------------------------------------

allmaxsales = LIMIT orderallbysales 1;

--DESCRIBE allmaxsales;
--allmaxsales: {custid: chararray,sales: double,date: chararray}
DUMP allmaxsales;
--(01622362,444000.0,2001-02-17)
---------------------------------------------------------------------------------------------------------------------------------------
