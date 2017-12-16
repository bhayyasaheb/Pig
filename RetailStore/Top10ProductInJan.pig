
jantxn = LOAD '/home/hduser/retail/D01' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--describe jantxn;
--jantxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP jantxn;
--(2001-01-31 00:00:00,02124032  ,D ,F ,120107,4716759020133,1,110.0,140.0)
--(2001-01-31 00:00:00,01814002  ,J ,G ,100311,4710022101208,1,197.0,198.0)
-----------------------------------------------------------------------------------------------------------------------------------------

janprod = FOREACH jantxn GENERATE prod,sales;

--DESCRIBE janprod;
--janprod: {prod: chararray,sales: double}

--DUMP janprod;
--(4710980000056,58.0)
--(4710088436207,19.0)
--(4716759020133,140.0)
--(4710022101208,198.0)
----------------------------------------------------------------------------------------------------------------------------------------

groupjanprod = GROUP janprod BY prod;

--DESCRIBE groupjanprod;
--groupjanprod: {group: chararray,janprod: {(prod: chararray,sales: double)}}

--DUMP groupjanprod;
--(9789579821537,{(9789579821537,179.0)})
--(9789579821551,{(9789579821551,358.0),(9789579821551,179.0)})
--(9789579909341,{(9789579909341,239.0),(9789579909341,252.0)})
--(9789579967617,{(9789579967617,214.0)})
-------------------------------------------------------------------------------------------------------------------------------------

jansumsales = FOREACH groupjanprod GENERATE group as prod, SUM(janprod.sales) as totalsales;

--DESCRIBE jansumsales;
--jansumsales: {prod: chararray,totalsales: double}

--DUMP jansumsales;
--(9789579821537,179.0)
--(9789579821551,537.0)
--(9789579909341,491.0)
--(9789579967617,214.0)
------------------------------------------------------------------------------------------------------------------------------------

jantop10prod = LIMIT (ORDER jansumsales BY $1 DESC) 10;

--DESCRIBE jantop10prod;
--jantop10prod: {prod: chararray,totalsales: double}

DUMP jantop10prod;
--(8712045008539,611874.0)
--(4710628119010,278230.0)
--(4710628131012,227840.0)
--(4719090900065,225456.0)
--(4710174053691,180273.0)
--(0300086780026,179569.0)
--(4909978112950,178544.0)
--(4712425010712,138601.0)
--(4710265849066,132550.0)
--(4710043552102,118297.0)
-----------------------------------------------------------------------------------------------------------------------------------

