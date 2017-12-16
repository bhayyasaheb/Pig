alltxn = LOAD '/home/hduser/retail' USING PigStorage(';') AS (tdate:chararray,cid:chararray,age:chararray,add:chararray,cat:chararray,prod:chararray,qty:int,cost:double,sales:double);

cattxn = FOREACH alltxn GENERATE cat as category, sales, cost, TRIM(age) as age;

grouped = GROUP cattxn BY (category,age);

--describe grouped;
--grouped: {group: (category: chararray,age: chararray),cattxn: {(category: chararray,sales: double,cost: double,age: chararray)}}

allloss = FOREACH grouped GENERATE group, (SUM(cattxn.cost) - SUM(cattxn.sales)) as loss;

--describe allloss;
--allloss: {group: (category: chararray,age: chararray),loss: double}

newallloss = FOREACH allloss GENERATE FLATTEN(group), $1;

--describe newallloss;
--newallloss: {group::category: chararray,group::age: chararray,loss: double}

---------------------------------------------------------------------------------------------------------------------------------

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

top5losscategoryagewise = UNION finallossA,finallossB,finallossC,finallossD,finallossE,finallossF,finallossG,finallossH,finallossI,finallossJ,finallossK;

DUMP top5losscategoryagewise;
--(130315,H,5462.0)
--(110217,H,4294.0)
--(110106,H,1513.0)
--(711501,H,400.0)
--(100608,H,137.0)
--(130315,K,3527.0)
--(110217,K,1874.0)
--(110106,K,409.0)
--(110110,K,155.0)
--(340101,K,48.0)
--(130315,C,16124.0)
--(110217,C,11841.0)
--(110106,C,4141.0)
--(530411,C,885.0)
--(340101,C,682.0)
--(130315,A,6797.0)
--(110217,A,3598.0)
--(110106,A,1968.0)
--(720507,A,623.0)
--(500202,A,417.0)
--(711409,G,11102.0)
--(130315,G,9752.0)
--(110217,G,8434.0)
--(110106,G,3189.0)
--(720507,G,895.0)
--(130315,J,9922.0)
--(110217,J,6409.0)
--(110106,J,2031.0)
--(530407,J,849.0)
--(340101,J,384.0)
--(130315,E,19254.0)
--(110217,E,16222.0)
--(110106,E,5283.0)
--(713901,E,1224.0)
--(340101,E,1192.0)
--(130315,I,4883.0)
--(110217,I,4609.0)
--(110106,I,1548.0)
--(714601,I,203.0)
--(720507,I,161.0)
--(130315,D,21697.0)
--(110217,D,12562.0)
--(110106,D,5784.0)
--(711409,D,4859.0)
--(340101,D,538.0)
--(130315,B,8691.0)
--(110217,B,4870.0)
--(110106,B,2467.0)
--(530411,B,68.0)
--(780102,B,16.0)
--(130315,F,16523.0)
--(110217,F,12510.0)
--(110106,F,4413.0)
--(340101,F,702.0)
--(710703,F,309.0)

