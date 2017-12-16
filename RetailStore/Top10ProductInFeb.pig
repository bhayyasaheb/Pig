
febtxn = LOAD '/home/hduser/retail/D02' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--DESCRIBE febtxn;
--febtxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP febxn;
--(2001-02-28 00:00:00,02127637  ,B ,F ,110505,4711258004004,1,101.0,120.0)
--(2001-02-28 00:00:00,02161389  ,A ,F ,500210,4712425010255,2,174.0,192.0)
--(2001-02-28 00:00:00,02015088  ,E ,H ,100324,4713754987607,2,40.0,58.0)
-----------------------------------------------------------------------------------------------------------------------------------

febprod = FOREACH febtxn GENERATE prod,sales;

--DESCRIBE febprod;
--febprod: {prod: chararray,sales: double}

--DUMP febprod;
--(4710047502677,84.0)
--(4711258004004,120.0)
--(4712425010255,192.0)
--(4713754987607,58.0)
----------------------------------------------------------------------------------------------------------------------------------------

groupfebprod = GROUP febprod BY prod;

--DESCRIBE groupfebprod;
--groupfebprod: {group: chararray,febprod: {(prod: chararray,sales: double)}}

--DUMP groupfebprod;
--(9789579821599,{(9789579821599,179.0),(9789579821599,179.0),(9789579821599,162.0)})
--(9789579863278,{(9789579863278,162.0),(9789579863278,162.0)})
--(9789579909341,{(9789579909341,239.0)})
--(9789579967617,{(9789579967617,204.0),(9789579967617,203.0),(9789579967617,203.0)})
-------------------------------------------------------------------------------------------------------------------------------------

febsumsales = FOREACH groupfebprod GENERATE group as prod, SUM(febprod.sales) as totalsales;

--DESCRIBE febsumsales;
--febsumsales: {prod: chararray,totalsales: double}

--DUMP febsumsales;
--(9789579821599,520.0)
--(9789579863278,324.0)
--(9789579909341,239.0)
--(9789579967617,610.0)
------------------------------------------------------------------------------------------------------------------------------------

febtop10prod = LIMIT (ORDER febsumsales BY $1 DESC) 10;

--DESCRIBE febtop10prod;
--febtop10prod: {prod: chararray,totalsales: double}

DUMP febtop10prod;
--(4711588210441,444000.0)
--(0022972004664,213803.0)
--(4710036003581,210339.0)
--(4710265849066,194669.0)
--(4710114128038,147813.0)
--(4710114362029,130475.0)
--(4719864060056,124580.0)
--(4710036008562,122794.0)
--(4712162000038,122762.0)
--(4710114105046,116787.0)
------------------------------------------------------------------------------------------------------------------------------------

