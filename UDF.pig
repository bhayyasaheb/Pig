
pigfile.txt
-----------
abcPPP
defHHHH
lower case
small
johN
User Defined functions
rajesh 5000
lower case converted to upper case
oRacle
sqL Server
---------------------------------------------------------------------------------------------------------------------


REGISTER /home/hduser/udfpig.jar;

DEFINE ConvertLowerToUpper myudfs.UPPER();

bag1 = LOAD '/home/hduser/pigfile.txt' USING PigStorage() as (name:chararray);

bag2 = FOREACH bag1 GENERATE ConvertLowerToUpper(name);

DUMP bag2;
(ABCPPP)
(DEFHHHH)
(LOWER CASE)
(SMALL)
(JOHN)
(USER DEFINED FUNCTIONS)
(RAJESH 5000)
(LOWER CASE CONVERTED TO UPPER CASE)
(ORACLE)
(SQL SERVER)
---------------------------------------------------------------------------------------------------------------------


1. Download datafu-pig-incubating-1.3.1.jar from internet


2. To see the classes in the jar file:-
----------------------------------
jar tvf datafu-pig-incubating-1.3.1.jar 

medianinput
-----------
1
2
5
9
10
15
-------------------------------------------------------------------------------------------------------------------

REGISTER datafu-pig-incubating-1.3.1.jar

DEFINE Median datafu.pig.stats.StreamingMedian();

data = LOAD '/home/hduser/medianinput' using PigStorage() as (val:int);

data1 = FOREACH (GROUP data ALL) GENERATE Median(data);

DUMP data1;
((5.0))
------------------------------------------------------------------------------------------------------------------
