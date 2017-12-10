

1) find total number of customers for each profession.


	A.Start Pig For Local mode:-
	------------------------
	pig -x local

	B.Load customer records from local file system:-
	--------------------------------------------

	bagname = LOAD 'localpath of input file' USING PigStorage(',') AS (fields name:datatypes);

	--bydefault datatype is bytearray when you want specify then use fieldname:datatype like age:long

	cust = LOAD '/home/hduser/custs' USING PigStorage(',') AS 
	(custid, firstname, lastname, age:long, profession); 

	------------------------------------------------------------------------------------------------

	C.See bag structure or To describe the schema of a bag or relation :- DESCRIBE
	------------------------------------------------------------------

	DESCRIBE bagname;

	DESCRIBE cust;

	output is:-
	cust: {custid: bytearray,firstname: bytearray,lastname: bytearray,age: long,profession: bytearray}

	---------------------------------------------------------------------------------------------------

	D. To print the contents of a bag or relation on the console:-   DUMP
	-------------------------------------------------------------

	DUMP bagname;

	DUMP cust;

	output is:-
	(4009994,Clyde,Welch,40,Photographer)
	(4009995,Rebecca,Dennis,37,Teacher)
	(4009996,Tonya,McIntosh,56,Engineering technician)
	(4009997,Ron,Grimes,36,Computer hardware engineer)
	(4009998,Tracey,Bullock,60,Computer hardware engineer)
	.
	.
	(4009999,Ray,Hewitt,64,Carpenter)
	--------------------------------------------------------------------------------------------------- 

	E. Filter data on particular Column:- FILTER
	----------------------------------

	new bagname = FILTER old bagename BY Field name = 'Value';

	teacher_bag = FILTER cust BY profession == 'Teacher';

	DUMP teacher_bag;

	output is:-
	(4000002,Paige,Chen,74,Teacher)
	(4000063,Melinda,Proctor,27,Teacher)
	(4000101,Scott,Golden,27,Teacher)
	(4000375,Norman,Lam,63,Teacher)
	.
	.
	(4009995,Rebecca,Dennis,37,Teacher)

	-----------------------------------------------------------------------------------------------------

	F. To select only 10 records:- LIMIT
	----------------------------

	new bagname = LIMIT old bagname 10;

	amt = LIMIT cust 10;

	DESCRIBE amt;

	output is:-
	{custid: bytearray,firstname: bytearray,lastname: bytearray,age: long,profession: bytearray}

	DUMP amt;

	output is:-
	(4000001,Kristina,Chung,55,Pilot)
	(4000002,Paige,Chen,74,Teacher)
	(4000003,Sherri,Melton,34,Firefighter)
	(4000004,Gretchen,Hill,66,Computer hardware engineer)
	(4000005,Karen,Puckett,74,Lawyer)
	(4000006,Patrick,Song,42,Veterinarian)
	(4000007,Elsie,Hamilton,43,Pilot)
	(4000008,Hazel,Bender,63,Carpenter)
	(4000009,Malcolm,Wagner,39,Artist)
	(4000010,Dolores,McLaughlin,60,Writer)

	----------------------------------------------------------------------------------------------------------------------------------------------

	G. Group data on Particular column:- GROUP
	----------------------------------

	new bagname = GROUP old bagname BY column or field name;
	 
	groupbyprofession = GROUP cust BY profession;

	DESCRIBE groupbyprofession;

	output is:-
	groupbyprofession: {group: bytearray,cust: {(custid: bytearray,firstname: bytearray,lastname: bytearray,age: long,profession: bytearray)}}

	DUMP groupbyprofession;

	output is:-
	(Computer hardware engineer,{(4009902,Harvey,Harris,71,Computer hardware engineer),(4002997,Lester,Osborne,66,Computer hardware engineer),...}

	----------------------------------------------------------------------------------------------------------------------------------------------

	H. Count number of customer by profession:-
	-----------------------------------------

	new bagname = FOREACH old bagname GENERATE group AS field or column name;

	countbyprofession = FOREACH groupbyprofession GENERATE group AS profession, COUNT(cust) AS headcount;

	DESCRIBE countbyprofession;

	output is:-
	countbyprofession: {profession: bytearray,headcount: long}

	DUMP countbyprofession;

	output is:-
	(Actor,196)
	(Coach,199)
	(Judge,189)
	(Nurse,191)
	(Pilot,209)

	----------------------------------------------------------------------------------------------------------------------------------------------

	I. Sorting the output by profession(column name):-
	------------------------------------------------

	For bag we use column name or index with $ sign like profession or $0
	index start with 0 in bag.

	new bagname = ORDER old bagname BY column or field name or $index number;


	orderbyprofession = ORDER countbyprofession BY $0;

	or 

	orderbyprofession = ORDER countbyprofession BY profession;


	DESCRIBE orderbyprofession;

	output is:-
	orderbyprofession: {profession: bytearray,headcount: long}

	DUMP orderbyprofession;

	output is:-
	(,83)
	(Accountant,197)
	(Actor,196)
	(Agricultural and food scientist,195)
	(Architect,202)
	(Artist,175)
	(Athlete,196)
	(Automotive mechanic,193)
	(Carpenter,180)
	(Chemist,206)

	---------------------------------------------------------------

	orderbycount = ORDER countbyprofession BY $1 desc;

	or 

	orderbycount = order countbyprofession by headcount desc;


	DESCRIBE orderbycount;

	output is:-
	orderbycount: {profession: bytearray,headcount: long}

	DUMP orderbycount;

	output is:-
	(Politician,227)
	(Computer support specialist,222)
	(Photographer,222)
	(Loan officer,221)
	(Librarian,218)
	(Firefighter,217)
	(Computer software engineer,216)

	-----------------------------------------------------------------------------------------

	J. Save file in Local file system:-
	---------------------------------

	STORE bagname INTO 'local path for saving bag';


	STORE orderbyprofession  INTO  '/home/hduser/niit2/cust_count';

	----------------------------------------------------------------------------------------

	K. To see step by step execution of a sequence of statement:-
	----------------------------------------------------

	ILLUSTRATE bagname;

	ILLUSTRATE orderbyprofession;


	------------------------------------------------------------------------------------------

	L. To get top 10 profession:-
	---------------------------

	new bagname = LIMIT old bagname 10;

	topprof = LIMIT orderbycount 10;

	DUMP topprof;

	output is:-
	(Politician,227)
	(Photographer,222)
	(Computer support specialist,222)
	(Loan officer,221)
	(Librarian,218)
	(Firefighter,217)
	(Computer software engineer,216)
	(Pharmacist,213)
	(Human resources assistant,212)
	(Social worker,212)
------------------------------------------------------------------------------------------------------------------------------------------------------


















