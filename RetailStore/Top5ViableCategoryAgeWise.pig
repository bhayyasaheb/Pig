

alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

cattxn = FOREACH alltxn GENERATE cat as category, sales, cost,TRIM(age) as age;
---------------------------------------------------------------------------------------------------------------------------

grouped = GROUP cattxn BY (category,age);
--describe grouped;
--grouped: {group: (category: chararray,age: chararray),cattxn: {(category: chararray,sales: double,cost: double,age: chararray)}}

allviable = FOREACH grouped GENERATE group, (SUM(cattxn.sales) - SUM(cattxn.cost)) as viable;

--describe allloss;
--allloss: {group: (category: chararray,age: chararray),viable: double}

newallviable = FOREACH allviable GENERATE FLATTEN(group), $1;

--describe newallloss;
--newallloss: {group::category: chararray,group::age: chararray,viable: double}

---------------------------------------------------------------------------------------------------------------------------

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

top5viablecategoryagewise = UNION finalviableA,finalviableB,finalviableC,finalviableD,finalviableE,finalviableF,finalviableG,finalviableH,finalviableI,finalviableJ,finalviableK;

DUMP top5viablecategoryagewise;
--(560402,H,12319.0)
--(320402,H,10255.0)
--(560201,H,7588.0)
--(500804,H,5780.0)
--(520457,H,5493.0)
--(320402,K,22023.0)
--(560201,K,7130.0)
--(320501,K,6203.0)
--(470105,K,5810.0)
--(560402,K,5732.0)
--(560201,C,95169.0)
--(560402,C,75138.0)
--(320402,C,50696.0)
--(100205,C,36280.0)
--(470105,C,31025.0)
--(320402,A,17133.0)
--(100516,A,12863.0)
--(530101,A,8923.0)
--(560402,A,7992.0)
--(560201,A,7613.0)
--(320402,G,18486.0)
--(470103,G,18135.0)
--(500804,G,13860.0)
--(100205,G,11962.0)
--(520457,G,11542.0)
--(100401,J,8023.0)
--(100205,J,6990.0)
--(560201,J,4973.0)
--(130206,J,4709.0)
--(100505,J,4507.0)
--(320402,E,70820.0)
--(560402,E,40781.0)
--(530101,E,39274.0)
--(100205,E,37936.0)
--(530110,E,33054.0)
--(560402,I,10406.0)
--(560201,I,7085.0)
--(320402,I,6120.0)
--(520457,I,6018.0)
--(110333,I,6008.0)
--(560402,D,102704.0)
--(560201,D,85341.0)
--(320402,D,63010.0)
--(100205,D,47211.0)
--(530101,D,41139.0)
--(560402,B,52282.0)
--(560201,B,50066.0)
--(320402,B,39799.0)
--(530101,B,16646.0)
--(100205,B,15262.0)
--(320402,F,55540.0)
--(530101,F,28190.0)
--(100205,F,24074.0)
--(530110,F,20874.0)
--(560402,F,20820.0)


