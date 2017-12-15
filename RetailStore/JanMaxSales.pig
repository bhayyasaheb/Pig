
jantxn = LOAD '/home/hduser/retail/D01' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--describe jantxn;
--jantxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP jantxn;
--(2001-01-31 00:00:00,02124032  ,D ,F ,120107,4716759020133,1,110.0,140.0)
--(2001-01-31 00:00:00,01814002  ,J ,G ,100311,4710022101208,1,197.0,198.0)
-----------------------------------------------------------------------------------------------------------------------------------------

jan = FOREACH jantxn GENERATE TRIM(cid) as custid,sales,SUBSTRING(tdate,0,10) as date;

--DESCRIBE jan;
--jan: {custid: chararray,sales: double,date: chararray}

--DUMP jan;
--(02146263,19.0,2001-01-31)
--(02124032,140.0,2001-01-31)
--(01814002,198.0,2001-01-31)
----------------------------------------------------------------------------------------------------------------------------------------

orderjanbysales = ORDER jan by sales DESC;

--DESCRIBE orderjanbysales;
--orderjanbysales: {custid: chararray,sales: double,date: chararray}

--DUMP orderjanbysales;
--(01846072,4.0,2001-01-18)
--(02087931,4.0,2001-01-13)
--(01973747,4.0,2001-01-18)
---------------------------------------------------------------------------------------------------------------------------------------

janmaxsales = LIMIT orderjanbysales 1;

--DESCRIBE janmaxsales;
--janmaxsales: {custid: chararray,sales: double,date: chararray}

DUMP janmaxsales;
--(01062489,45554.0,2001-01-03)

--------------------------------------------------------------------------------------------------------------------------------------------

