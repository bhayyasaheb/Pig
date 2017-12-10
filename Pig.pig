

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

	2) Top ten customers from sales data along with their full details.

	
	A. Load transaction records:-
	---------------------------
	txn  =  LOAD  '/home/hduser/txns1.txt'  USING PigStorage(',')  AS
	( txnid, date, custid, amount:double, category, product, city, state, type);

	DESCRIBE txn;

	DESCRIBE txn;

	output is:-
	txn: {txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,product: bytearray,city: bytearray,
	state: bytearray,type: bytearray}

	----------------------------------------------------------------------------

	B. Group transactions by customer:-
	---------------------------------

	txnbycust = GROUP txn BY custid;

	DESCRIBE txnbycust;

	output is:-
	txnbycust: {group: bytearray,txn: {(txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,
	product: bytearray,city: bytearray,state: bytearray,type: bytearray)}}

	DUMP txnbycust;

	output is:-
	(4009983,{(00012377,05-21-2011,4009983,163.58,Winter Sports,Bobsledding,Charlotte,North Carolina,credit),
		  (00032007,07-19-2011,4009983,8.67,Water Sports,Swimming,Atlanta,Georgia,credit)...})

	----------------------------------------------------------------------------------------------------------------------------------------------

	C. Sum total amount spent by each customer:-
	------------------------------------------

	spendbycust = FOREACH  txnbycust  GENERATE group as customer_id,  ROUND_TO(SUM(txn.amount ),2) as totalsales;

	DESCRIBE spendbycust;

	output is:-
	spendbycust: {customer_id: bytearray,totalsales: double}

	DUMP spendbycust;

	output is:-
	(4009994,461.04)
	(4009995,455.13)
	(4009996,836.12)
	(4009997,486.19)
	.
	.
	(4009998,665.7)

	---------------------------------------------------------------------------------------------------------------------------------------------

	D. Order the customer records beginning from highest spender:-
	------------------------------------------------------------

	custorder = ORDER spendbycust BY $1 DESC;

	DESCRIBE custorder;

	output is:-
	custorder: {customer_id: bytearray,totalsales: double}

	DUMP custorder;

	output is:-
	(4007518,9.12)
	(4006547,8.72)
	(4000590,8.46)
	(4002513,6.92)
	(4005196,6.66)

	---------------------------------------------------------------------------------------------------------------------------------------------

	E. Select only top 10 customers:-
	-------------------------------

	top10cust = LIMIT custorder 10;

	DESCRIBE top10cust;

	output is:-
	top10cust: {customer_id: bytearray,totalsales: double}

	DUMP top10cust;

	output is:-
	(4009485,1973.3)
	(4006425,1732.09)
	(4000221,1671.47)
	(4003228,1640.63)
	(4006606,1628.94)
	(4006467,1605.95)
	(4004927,1576.71)
	(4008321,1560.79)
	(4000815,1557.82)
	(4001051,1488.67)

	-------------------------------------------------------------------------------------------------------------------------------------------
	
	F. Load customer records:-
	---------------------------
	cust = LOAD '/home/hduser/custs' USING PigStorage(',') AS 
	(custid, firstname, lastname, age:long, profession);
	
	DESCRIBE cust;

	output is:-
	cust: {custid: bytearray,firstname: bytearray,lastname: bytearray,age: long,profession: bytearray}

	DUMP cust;

	output is:-
	(4009989,Lori,Richards,39,Chemist)
	(4009990,Stacey,Rouse,21,Actor)
	(4009991,Paul,Mullins,47,Reporter)
	(4009992,Erin,Blackwell,33,Electrician)
	.
	.
	(4009993,Becky,Wolfe,67,Musician)

	------------------------------------------------------------------------------------------------------------------------------------------
	

	G. Join the transactions with customer details:-
	----------------------------------------------

	top10join = JOIN top10cust BY $0,cust BY $0;

	or 

	top10join = JOIN top10cust by custid, cust by custid;

	DESCRIBE top10join;

	output is:-
	top10join: {top10cust::customer_id: bytearray,top10cust::totalsales: double,cust::custid: bytearray,cust::firstname: bytearray,
	cust::lastname: bytearray,cust::age: long,cust::profession: bytearray}
	
	DUMP top10join;

	output is:-
	(4000221,1671.47,4000221,Glenda,Boswell,28,Civil engineer)
	(4000815,1557.82,4000815,Julie,Galloway,53,Actor)
	(4001051,1488.67,4001051,Arlene,Higgins,62,Police officer)
	(4003228,1640.63,4003228,Elsie,Newton,54,Accountant)
	(4004927,1576.71,4004927,Joan,Lowry,30,Librarian)
	(4006425,1732.09,4006425,Joe,Burns,30,Economist)
	(4006467,1605.95,4006467,Evelyn,Monroe,37,Financial analyst)
	(4006606,1628.94,4006606,Jackie,Lewis,66,Recreation and fitness worker)
	(4008321,1560.79,4008321,Paul,Carey,64,Human resources assistant)
	(4009485,1973.3,4009485,Stuart,House,58,Teacher)

	----------------------------------------------------------------------------------------------------------------------------------------------

	H. Select the required fields from the join  for final output:-
	-------------------------------------------------------------

	top10 = FOREACH top10join GENERATE $0, $3, $4, $5, $6, $1;

	or

	top10 = FOREACH top10join GENERATE custid, firstname, lastname, age, profession, totalsales;


	DESCRIBE top10;

	output is:-
	top10: {cust::custid: bytearray,cust::firstname: bytearray,cust::lastname: bytearray,cust::age: long,
	cust::profession: bytearray,top10cust::totalsales: double}

	DUMP top10;

	output is:-
	(4000221,Glenda,Boswell,28,Civil engineer,1671.47)
	(4000815,Julie,Galloway,53,Actor,1557.82)
	(4001051,Arlene,Higgins,62,Police officer,1488.67)
	(4003228,Elsie,Newton,54,Accountant,1640.63)
	(4004927,Joan,Lowry,30,Librarian,1576.71)
	(4006425,Joe,Burns,30,Economist,1732.09)
	(4006467,Evelyn,Monroe,37,Financial analyst,1605.95)
	(4006606,Jackie,Lewis,66,Recreation and fitness worker,1628.94)
	(4008321,Paul,Carey,64,Human resources assistant,1560.79)
	(4009485,Stuart,House,58,Teacher,1973.3)


	top10order = ORDER top10 BY $5 DESC;

	DESCRIBE top10order;

	output is:-
	top10order: {cust::custid: bytearray,cust::firstname: bytearray,cust::lastname: bytearray,cust::age: long,
	cust::profession:bytearray,top10cust::totalsales: double}

	DUMP top10order;

	output is:-
	(4009485,Stuart,House,58,Teacher,1973.3)
	(4006425,Joe,Burns,30,Economist,1732.09)
	(4000221,Glenda,Boswell,28,Civil engineer,1671.47)
	(4003228,Elsie,Newton,54,Accountant,1640.63)
	(4006606,Jackie,Lewis,66,Recreation and fitness worker,1628.94)
	(4006467,Evelyn,Monroe,37,Financial analyst,1605.95)
	(4004927,Joan,Lowry,30,Librarian,1576.71)
	(4008321,Paul,Carey,64,Human resources assistant,1560.79)
	(4000815,Julie,Galloway,53,Actor,1557.82)
	(4001051,Arlene,Higgins,62,Police officer,1488.67)

------------------------------------------------------------------------------------------------------------------------------------------------------
	3.find
		1) total sales 
		2) total cash sales with %
		3) total credit card sales with %

	A.LOAD the transaction records into bag:-
	---------------------------------------

	txn  =  LOAD  '/home/hduser/txns1.txt'  USING PigStorage(',')  AS  ( txnid, date, custid, amount:double, category, product, city, state, type);

	DESCRIBE txn;
	txn: {txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,product: bytearray,city: bytearray,
	state: bytearray,type: bytearray}

	DUMP txn;
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B.GROUP txansaction records by type of transcation:-
	---------------------------------------------------
	txnbytype = GROUP txn BY type;

	DESCRIBE txnbytype;
	txnbytype: {group: bytearray,txn: {(txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,
	product: bytearray,city: bytearray,state: bytearray,type: bytearray)}}

	DUMP txnbytype;
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C.Find total amount spend by each type:-
	--------------------------------------

	spendbytype = foreach  txnbytype  generate group as type,  ROUND_TO(SUM(txn.amount ),2) as typesales;

	DESCRIBE spendbytype;
	spendbytype: {type: bytearray,typesales: double}

	DUMP spendbytype;
	(cash,187685.61)
	(credit,4923134.93)
	-----------------------------------------------------------------------------------------------------------------------------------------------
	
	D.GROUP the credit and cash amount:-
	--------------------------------------

	groupall = group spendbytype all;

	DESCRIBE groupall;
	groupall: {group: chararray,spendbytype: {(type: bytearray,typesales: double)}}

	DUMP groupall;
	(all,{(credit,4923134.93),(cash,187685.61)})
	-----------------------------------------------------------------------------------------------------------------------------------------------
	
	E.Find total sales amount:-
	-------------------------
	totalsales = foreach groupall generate ROUND_TO(SUM(spendbytype.typesales),2) as totsales;

	DESCRIBE totalsales;
	totalsales: {totsales: double}

	DUMP totalsales;
	(5110820.54)
	----------------------------------------------------------------------------------------------------------------------------------------------

	F.Total cash sales with % & total credit card sales with %:-
	----------------------------------------------------------

	final = foreach spendbytype generate $0, $1, ROUND_TO(($1/totalsales.totsales)*100,2);

	DESCRIBE final;                                                                       
	final: {type: bytearray,typesales: double,double}


	DUMP final; 
	(cash,187685.61,3.67)
	(credit,4923134.93,96.33)

-------------------------------------------------------------------------------------------------------------------------------------------------------


