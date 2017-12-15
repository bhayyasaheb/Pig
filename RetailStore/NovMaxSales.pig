novtxn = LOAD '/home/hduser/retail/D11' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE novtxn;
--novtxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP novtxn;
--(2000-11-30 00:00:00,01815788  ,D ,F ,500301,4711254012027,1,69.0,89.0)
--(2000-11-30 00:00:00,01629606  ,B ,F ,740303,20530921     ,1,60.0,80.0)
--(2000-11-30 00:00:00,01726299  ,D ,F ,100205,4710035369510,1,66.0,71.0)
--(2000-11-30 00:00:00,01986242  ,B ,F ,100515,4710946507599,1,30.0,39.0)
---------------------------------------------------------------------------------------------------------------------------------------

nov = FOREACH novtxn GENERATE TRIM(cid) as custid,sales,SUBSTRING(tdate,0,10) as date;

--DESCRIBE nov;
--nov: {custid: chararray,sales: double,date: chararray}

--DUMP nov;
--(01629606,80.0,2000-11-30)
--(01726299,71.0,2000-11-30)
--(01986242,39.0,2000-11-30)
----------------------------------------------------------------------------------------------------------------------------------------

ordernovbysales = ORDER nov by sales DESC;

--DESCRIBE ordernovbysales;
--ordernovbysales: {custid: chararray,sales: double,date: chararray}

--DUMP ordernovbysales;
--(01338287,4.0,2000-11-20)
--(01853674,4.0,2000-11-04)
---------------------------------------------------------------------------------------------------------------------------------------

novmaxsales = LIMIT ordernovbysales 1;

--DESCRIBE novmaxsales;
--novmaxsales: {custid: chararray,sales: double,date: chararray}

DUMP novmaxsales;
--(02119083,62688.0,2000-11-28)
--------------------------------------------------------------------------------------------------------------------------------------

