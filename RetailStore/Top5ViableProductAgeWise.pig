
alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

prodtxn = FOREACH alltxn GENERATE prod as product, sales, cost, TRIM(age) as age;

grouped = GROUP prodtxn BY (product,age);

--describe grouped;
--grouped: {group: (product: chararray,age: chararray),prodtxn: {(product: chararray,sales: double,cost: double,age: chararray)}}


allviable = FOREACH grouped GENERATE group, (SUM(prodtxn.sales) - SUM(prodtxn.cost)) as viable;

--describe allviable;
--allviable: {group: (product: chararray,age: chararray),viable: double}


newallviable = FOREACH allviable GENERATE FLATTEN(group), $1;

--describe newallviable;
--newallviable: {group::product: chararray,group::age: chararray,viable: double}


---------------------------------------------------------------------------------------------------------------------------------

Afilter = FILTER newallviable BY $2>0 and $1 == 'A';

finalviableA = LIMIT (ORDER Afilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Bfilter = FILTER newallviable BY $2>0 and $1 == 'B';

finalviableB = LIMIT (ORDER Bfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Cfilter = FILTER newallviable BY $2>0 and $1 == 'C';

finalviableC = LIMIT (ORDER Cfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Dfilter = FILTER newallviable BY $2>0 and $1 == 'D';

finalviableD = LIMIT (ORDER Dfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Efilter = FILTER newallviable BY $2>0 and $1 == 'E';

finalviableE = LIMIT (ORDER Efilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Ffilter = FILTER newallviable BY $2>0 and $1 == 'F';

finalviableF = LIMIT (ORDER Ffilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Gfilter = FILTER newallviable BY $2>0 and $1 == 'G';

finalviableG = LIMIT (ORDER Gfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Hfilter = FILTER newallviable BY $2>0 and $1 == 'H';

finalviableH = LIMIT (ORDER Hfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Ifilter = FILTER newallviable BY $2>0 and $1 == 'I';

finalviableI = LIMIT (ORDER Ifilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Jfilter = FILTER newallviable BY $2>0 and $1 == 'J';

finalviableJ = LIMIT (ORDER Jfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Kfilter = FILTER newallviable BY $2>0 and $1 == 'K';

finalviableK = LIMIT (ORDER Kfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

top5viableproductagewise = UNION finalviableA,finalviableB,finalviableC,finalviableD,finalviableE,finalviableF,finalviableG,finalviableH,finalviableI,finalviableJ,finalviableK;

DUMP top5viableproductagewise;
--(8712045011317,H,4706.0)
--(0300086780026,H,3254.0)
--(4909978112950,H,3148.0)
--(20421151     ,H,3135.0)
--(7610053910794,H,2037.0)
--(20564100     ,K,2340.0)
--(4902430493437,K,2172.0)
--(4711863590077,K,1980.0)
--(20563745     ,K,1583.0)
--(20456245     ,K,1577.0)
--(8712045008539,C,10153.0)
--(0729238191921,C,7840.0)
--(4909978112950,C,7386.0)
--(20564100     ,C,6530.0)
--(4902430040334,C,6528.0)
--(4711588210441,A,12025.0)
--(20559045     ,A,3290.0)
--(4973167032060,A,2163.0)
--(4973167738757,A,1854.0)
--(20556433     ,A,1776.0)
--(4909978112950,G,9370.0)
--(0729238191921,G,4190.0)
--(4710114128038,G,2704.0)
--(4711713491530,G,2478.0)
--(4710043552102,G,2365.0)
--(4710043552102,J,1460.0)
--(0041736007284,J,1459.0)
--(4710960918036,J,1377.0)
--(4902430493437,J,1312.0)
--(4712603669091,J,1284.0)
--(4909978112950,E,14628.0)
--(4710628131012,E,7810.0)
--(4901422038939,E,7317.0)
--(20564100     ,E,7008.0)
--(4710114128038,E,6863.0)
--(8712045011317,I,2291.0)
--(4909978112950,I,2142.0)
--(8712045000151,I,2096.0)
--(4710628119010,I,1890.0)
--(4710043552102,I,1501.0)
--(4909978112950,D,17612.0)
--(8712045008539,D,15155.0)
--(4710628131012,D,10462.0)
--(0729238191921,D,9905.0)
--(4902430493437,D,8735.0)
--(8712045008539,B,7318.0)
--(4710628119010,B,6827.0)
--(4902430493437,B,6419.0)
--(7610053910787,B,6344.0)
--(8712045011317,B,6072.0)
--(4909978112950,F,10276.0)
--(20556433     ,F,6388.0)
--(20564100     ,F,4770.0)
--(4901422038939,F,4301.0)
--(4710114128038,F,4246.0)

