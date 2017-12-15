
dectxn = LOAD '/home/hduser/retail/D12' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE dectxn;
--dectxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP dectxn;
--(2000-12-31 00:00:00,01720495  ,J ,E ,100405,4710043980714,1,137.0,158.0)
--(2000-12-31 00:00:00,01753820  ,B ,C ,500707,4933776441288,1,80.0,120.0)
--(2000-12-31 00:00:00,01862263  ,C ,F ,110507,4710172020015,1,19.0,23.0)
----------------------------------------------------------------------------------------------------------------------------------------

dec = FOREACH dectxn GENERATE TRIM(cid) as custid,sales,SUBSTRING(tdate,0,10) as date;

--DESCRIBE dec;
--dec: {custid: chararray,sales: double,date: chararray}

--DUMP dec;
--(01720495,158.0,2000-12-31)
--(01753820,120.0,2000-12-31)
--(01862263,23.0,2000-12-31)
--------------------------------------------------------------------------------------------------------------------------------------

orderdecbysales = ORDER dec by sales DESC;

--DESCRIBE orderdecbysales;
--orderdecbysales: {custid: chararray,sales: double,date: chararray}

--DUMP orderdecbysales;
--(01844030,4.0,2000-12-12)
--(00116206,4.0,2000-12-25)
--(00565660,4.0,2000-12-17)
--(02164403,1.0,2000-12-13)
-------------------------------------------------------------------------------------------------------------------------------------

decmaxsales = LIMIT orderdecbysales 2;

--DESCRIBE decmaxsales;
--decmaxsales: {custid: chararray,sales: double,date: chararray}

DUMP decmaxsales;
--(02131221,70589.0,2000-12-27)
--(02134819,70589.0,2000-12-27)

-------------------------------------------------------------------------------------------------------------------------------------

