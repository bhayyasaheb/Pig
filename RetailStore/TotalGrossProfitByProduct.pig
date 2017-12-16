

alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--describe alltxn;
--alltxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP alltxn;
--(2001-02-28 00:00:00,02161389  ,A ,F ,500210,4712425010255,2,174.0,192.0)
--(2001-02-28 00:00:00,02015088  ,E ,H ,100324,4713754987607,2,40.0,58.0)
--------------------------------------------------------------------------------------------------------------------------------------------

product = FOREACH alltxn GENERATE prod,cost,sales;

--DESCRIBE product;
--product: {prod: chararray,cost: double,sales: double}

--DUMP product;
--(4712425010255,174.0,192.0)
--(4713754987607,40.0,58.0)
--------------------------------------------------------------------------------------------------------------------------------------------

prodfilter = FILTER product BY cost>0 and sales>0;

--DESCRIBE prodfilter;
--prodfilter: {prod: chararray,cost: double,sales: double}

--DUMP prodfilter;
--(4711258004004,101.0,120.0)
--(4712425010255,174.0,192.0)
-----------------------------------------------------------------------------------------------------------------------------------------

prodgroup = GROUP prodfilter BY prod;

--DESCRIBE prodgroup;
--prodgroup: {group: chararray,prodfilter: {(prod: chararray,cost: double,sales: double)}}

--DUMP prodgroup;
--(9789579967617,{(9789579967617,166.0,214.0),(9789579967617,166.0,204.0),(9789579967617,166.0,203.0),(9789579967617,166.0,203.0)})
---------------------------------------------------------------------------------------------------------------------------------------

grossprofit = FOREACH prodgroup GENERATE group,(SUM(prodfilter.sales) - SUM(prodfilter.cost)) as profit;

--DESCRIBE grossprofit;
--grossprofit: {group: chararray,profit: double}

--DUMP grossprofit;
--(9789579909341,172.0)
--(9789579967617,160.0)
-------------------------------------------------------------------------------------------------------------------------------------

prodgrossprofit = LIMIT (ORDER grossprofit BY $1 DESC) 5;

--DESCRIBE prodgrossprofit;
--prodgrossprofit: {group: chararray,profit: double}

DUMP prodgrossprofit;
--(4909978112950,71312.0)
--(8712045008539,46586.0)
--(20564100     ,38699.0)
--(4710628131012,34429.0)
--(0729238191921,33645.0)


