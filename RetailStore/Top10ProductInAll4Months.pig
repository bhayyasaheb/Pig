
alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE alltxn;
--alltxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP alltxn;
--(2001-01-31 00:00:00,02124032  ,D ,F ,120107,4716759020133,1,110.0,140.0)
--(2001-02-28 00:00:00,02127637  ,B ,F ,110505,4711258004004,1,101.0,120.0)
--(2000-11-30 00:00:00,01815788  ,D ,F ,500301,4711254012027,1,69.0,89.0)
--(2000-12-31 00:00:00,01862263  ,C ,F ,110507,4710172020015,1,19.0,23.0)
-----------------------------------------------------------------------------------------------------------------------------------------

tprod = FOREACH alltxn GENERATE prod,sales;

--DESCRIBE tprod;
--tprod: {prod: chararray,sales: double}

--DUMP tprod;
--(4933776441288,120.0)
--(4710172020015,23.0)
----------------------------------------------------------------------

groupprod = GROUP tprod BY prod;

--DESCRIBE groupprod;
--groupprod: {group: chararray,tprod: {(prod: chararray,sales: double)}}

--DUMP groupprod;
--(9789579909341,{(9789579909341,239.0),(9789579909341,252.0),(9789579909341,239.0)})
--(9789579967617,{(9789579967617,214.0),(9789579967617,203.0),(9789579967617,204.0),(9789579967617,203.0)})
--------------------------------------------------------------------------------------------------------------------------------------

sumsales = FOREACH groupprod GENERATE group as prod,SUM(tprod.sales);

--DESCRIBE sumsales;
--sumsales: {prod: chararray,double}

--DUMP sumsales;
--(9789579909341,730.0)
--(9789579967617,824.0)
----------------------------------------------------------------------------------------------------------------------------------------

top10product = LIMIT (ORDER sumsales BY $1 DESC) 10;

--DESCRIBE top10product;
--top10product: {prod: chararray,double}

DUMP top10product;
--(8712045008539,1540503.0)
--(4710628131012,675112.0)
--(4710114128038,514601.0)
--(4711588210441,491292.0)
--(20553418     ,470501.0)
--(4710628119010,433380.0)
--(4909978112950,432596.0)
--(8712045000151,428530.0)
--(7610053910787,392581.0)
--(4719090900065,385626.0)
------------------------------------------------------------------------------------------------------------------------------------

