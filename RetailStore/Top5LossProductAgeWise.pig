alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

prodtxn = FOREACH alltxn GENERATE prod as product, sales, cost, TRIM(age) as age;

grouped = GROUP prodtxn BY (product,age);

--describe grouped;
--grouped: {group: (product: chararray,age: chararray),prodtxn: {(product: chararray,sales: double,cost: double,age: chararray)}}


allloss = FOREACH grouped GENERATE group, (SUM(prodtxn.cost) - SUM(prodtxn.sales)) as loss;

--describe allviable;
--allviable: {group: (product: chararray,age: chararray),loss: double}

newallloss = FOREACH allloss GENERATE FLATTEN(group), $1;

--describe newallviable;
--newallviable: {group::product: chararray,group::age: chararray,loss: double}

--------------------------------------------------------------------------------------------------------------------------------

Afilter = FILTER newallloss BY $2>0 and $1 == 'A';

finallossA = LIMIT (ORDER Afilter BY $2 DESC) 5;
--------------------------------------------------------------------------------------------------------------------------------

Bfilter = FILTER newallloss BY $2>0 and $1 == 'B';

finallossB = LIMIT (ORDER Bfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Cfilter = FILTER newallloss BY $2>0 and $1 == 'C';

finallossC = LIMIT (ORDER Cfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Dfilter = FILTER newallloss BY $2>0 and $1 == 'D';

finallossD = LIMIT (ORDER Dfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Efilter = FILTER newallloss BY $2>0 and $1 == 'E';

finallossE = LIMIT (ORDER Efilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Ffilter = FILTER newallloss BY $2>0 and $1 == 'F';

finallossF = LIMIT (ORDER Ffilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Gfilter = FILTER newallloss BY $2>0 and $1 == 'G';

finallossG = LIMIT (ORDER Gfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Hfilter = FILTER newallloss BY $2>0 and $1 == 'H';

finallossH = LIMIT (ORDER Hfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Ifilter = FILTER newallloss BY $2>0 and $1 == 'I';

finallossI = LIMIT (ORDER Ifilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------


Jfilter = FILTER newallloss BY $2>0 and $1 == 'J';

finallossJ = LIMIT (ORDER Jfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

Kfilter = FILTER newallloss BY $2>0 and $1 == 'K';

finallossK = LIMIT (ORDER Kfilter BY $2 DESC) 5;

--------------------------------------------------------------------------------------------------------------------------------

top5lossproductagewise = UNION finallossA,finallossB,finallossC,finallossD,finallossE,finallossF,finallossG,finallossH,finallossI,finallossJ,finallossK;

DUMP top5lossproductagewise;
--(4714981010038,H,5812.0)
--(4719090900065,H,2455.0)
--(4711271000014,H,2132.0)
--(4710265849066,H,1482.0)
--(4712425010712,H,796.0)
--(4714981010038,K,3788.0)
--(4710265849066,K,1218.0)
--(4710683100015,K,852.0)
--(4719090900065,K,747.0)
--(4711271000014,K,680.0)
--(4714981010038,C,17215.0)
--(4711271000014,C,6008.0)
--(4719090900065,C,5867.0)
--(4710265849066,C,4966.0)
--(4710908110232,C,3002.0)
--(4714981010038,A,6947.0)
--(4711271000014,A,2194.0)
--(4710265849066,A,1875.0)
--(4719090900065,A,1845.0)
--(4712425010712,A,986.0)
--(2110119000377,G,11638.0)
--(4714981010038,G,10290.0)
--(4711271000014,G,4185.0)
--(4719090900065,G,3559.0)
--(4710265849066,G,3335.0)
--(4714981010038,J,10196.0)
--(4710265849066,J,3388.0)
--(4719090900065,J,3180.0)
--(4711271000014,J,2703.0)
--(4710060000099,J,1180.0)
--(4714981010038,E,21157.0)
--(4719090900065,E,8667.0)
--(4711271000014,E,7989.0)
--(4710265849066,E,6645.0)
--(4712425010712,E,2917.0)
--(4714981010038,I,5354.0)
--(4710265849066,I,2114.0)
--(4711271000014,I,2038.0)
--(4719090900065,I,1926.0)
--(4719090900058,I,1084.0)
--(4714981010038,D,23550.0)
--(4711271000014,D,8739.0)
--(4719090900065,D,7248.0)
--(4710265849066,D,6406.0)
--(2110119000377,D,5819.0)
--(4714981010038,B,9237.0)
--(4711271000014,B,3425.0)
--(4719090900065,B,2554.0)
--(4710265849066,B,2080.0)
--(4712425010712,B,1490.0)
--(4714981010038,F,17456.0)
--(4719090900065,F,6283.0)
--(4711271000014,F,6120.0)
--(4710265849066,F,5460.0)
--(4710265847666,F,2315.0)

