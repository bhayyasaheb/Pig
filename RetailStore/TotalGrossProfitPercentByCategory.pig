
alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

--describe alltxn;
--alltxn: {tdate: chararray,cid: chararray,age: chararray,add: chararray,cat: chararray,prod: chararray,qty: int,cost: double,sales: double}

--DUMP alltxn;
--(2001-02-28 00:00:00,02161389  ,A ,F ,500210,4712425010255,2,174.0,192.0)
--(2001-02-28 00:00:00,02015088  ,E ,H ,100324,4713754987607,2,40.0,58.0)
--------------------------------------------------------------------------------------------------------------------------------------------

category = FOREACH alltxn GENERATE cat,cost,sales;

--DESCRIBE category;
--category: {cat: chararray,cost: double,sales: double}

--DUMP category;
--(500711,123.0,175.0)
--(100405,137.0,158.0)
-----------------------------------------------------------------------------------------------------------------------------------------

catfilter = FILTER category BY cost>0 and sales>0;

--DESCRIBE catfilter;
--catfilter: {cat: chararray,cost: double,sales: double}

--DUMP catfilter;
--(500711,123.0,175.0)
--(100405,137.0,158.0)
----------------------------------------------------------------------------------------------------------------------------------------

catgroup = GROUP catfilter BY cat;

--DESCRIBE catgroup;                
--catgroup: {group: chararray,catfilter: {(cat: chararray,cost: double,sales: double)}}

--DUMP catgroup;
--(780507,{(780507,174.0,250.0)})
--(780508,{(780508,100.0,139.0),(780508,38.0,75.0)})
-------------------------------------------------------------------------------------------------------------------------------------

catgrosspercent =  FOREACH catgroup GENERATE group,ROUND_TO((SUM(catfilter.sales) - SUM(catfilter.cost))/SUM(catfilter.cost)*100,2) as margin;

--DESCRIBE catgrosspercent;
--catgrosspercent: {group: chararray,margin: double}

--DUMP catgrosspercent;
--(780509,23.16)
--(780510,40.63)
---------------------------------------------------------------------------------------------------------------------------------------------

catgrossprofitpercent = LIMIT (ORDER catgrosspercent BY $1 DESC) 5;

--DESCRIBE catgrossprofitpercent;
--catgrossprofitpercent: {cat: chararray,margin: double}

DUMP catgrossprofitpercent;
--(760112,116.62)
--(590106,94.78)
--(751207,93.2)
--(590105,87.66)
--(520423,84.43)
----------------------------------------------------------------------------------------------------------------------------------

