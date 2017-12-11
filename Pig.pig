

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
	
	J. Store output in local file system:-
	-------------------------------------

	STORE bagname INTO 'local path for saving bag' USING Function name for seperation of values;	
	
	STORE orderbyprofession INTO '/home/hduser/niit/orderbyprofession' USING PigStorage();
	-----------------------------------------------------------------------------------------------

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
	
	K. Store output in local file system:-
	-------------------------------------

	STORE orderbycount INTO '/home/hduser/niit/orderbyprofessioncount' USING PigStorage();	
	-------------------------------------------------------------------------------------------

	L. To see step by step execution of a sequence of statement:-
	----------------------------------------------------

	ILLUSTRATE bagname;

	ILLUSTRATE orderbyprofession;


	------------------------------------------------------------------------------------------

	M. To get top 10 profession:-
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
	----------------------------------------------------------------------------------------------

	N. Store output in local file system:-
	-------------------------------------

	STORE topprof INTO '/home/hduser/niit/top10profession' USING PigStorage();
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

	I. Store the output in local file system:-
	
	STORE top10order INTO '/home/hduser/niit/top10customerorder' USING PigStorage();
-----------------------------------------------------------------------------------------------------------------------------------------------------
	3.find
		1) total sales 
		2) total cash sales with %
		3) total credit card sales with %

	A.LOAD the transaction records into bag:-
	---------------------------------------

	txn  =  LOAD  '/home/hduser/txns1.txt'  USING PigStorage(',')  
	AS  ( txnid, date, custid, amount:double, category, product, city, state, type);

	DESCRIBE txn;
	txn: {txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,product: bytearray,city: bytearray,
	state: bytearray,type: bytearray}

	DUMP txn;
	----------------------------------------------------------------------------------------------------------------------------------------------

	B.GROUP txansaction records by type of transcation:-
	---------------------------------------------------
	txnbytype = GROUP txn BY type;

	DESCRIBE txnbytype;
	txnbytype: {group: bytearray,txn: {(txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,
	product: bytearray,city: bytearray,state: bytearray,type: bytearray)}}

	DUMP txnbytype;
	----------------------------------------------------------------------------------------------------------------------------------------------

	C.Find total amount spend by each type:-
	--------------------------------------

	spendbytype = FOREACH  txnbytype  GENERATE group as type,  ROUND_TO(SUM(txn.amount ),2) as typesales;

	DESCRIBE spendbytype;
	spendbytype: {type: bytearray,typesales: double}

	DUMP spendbytype;
	(cash,187685.61)
	(credit,4923134.93)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	D.GROUP the credit and cash amount:-
	--------------------------------------

	groupall = GROUP spendbytype all;

	DESCRIBE groupall;
	groupall: {group: chararray,spendbytype: {(type: bytearray,typesales: double)}}

	DUMP groupall;
	(all,{(credit,4923134.93),(cash,187685.61)})
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	E.Find total sales amount:-
	-------------------------
	totalsales = FOREACH groupall GENERATE ROUND_TO(SUM(spendbytype.typesales),2) as totsales;

	DESCRIBE totalsales;
	totalsales: {totsales: double}

	DUMP totalsales;
	(5110820.54)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	F. Store the output in the local file system:-
	---------------------------------------------

	STORE totalsales INTO '/home/hduser/niit/totalsales' USING PigStorage();
	----------------------------------------------------------------------------------------------------------------------------------------------

	G.Total cash sales with % & total credit card sales with %:-
	----------------------------------------------------------

	final = FOREACH spendbytype GENERATE $0, $1, ROUND_TO(($1/totalsales.totsales)*100,2);

	DESCRIBE final;                                                                       
	final: {type: bytearray,typesales: double,double}


	DUMP final; 
	(cash,187685.61,3.67)
	(credit,4923134.93,96.33)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	H. Store the output in the local file system:-
	---------------------------------------------

	STORE final INTO '/home/hduser/niit/totalcashcreditpercent' USING PigStorage();	
------------------------------------------------------------------------------------------------------------------------------------------------------

	4.Track customers whose age is less than 50 and total purchases done more than USD 500

	A.Load the txansaction records:-
	------------------------------

	txn  =  LOAD  '/home/hduser/txns1.txt'  USING PigStorage(',') 
	AS  ( txnid, date, custid, amount:double, category, product, city, state, type);

	DESCRIBE txn;
	txn: {txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,product: bytearray,city: bytearray,
	state: bytearray,type: bytearray}

	DUMP txn;
	(00049996,10-02-2011,4007287,163.81,Games,Poker Chips & Sets,Kansas City,Missouri,credit)
	(00049997,05-03-2011,4003954,35.85,Racquet Sports,Squash,New Orleans,Louisiana,cash)
	(00049998,10-23-2011,4007843,180.41,Gymnastics,Vaulting Horses,Berkeley,California,credit)
	(00049999,12-14-2011,4001406,168.49,Team Sports,Team Handball,Rockford,Illinois,credit)
	----------------------------------------------------------------------------------------------------------------------------------------------

	B.Group the transaction records by custid:-
	-----------------------------------------

	txnbycust = GROUP txn BY custid;

	DESCRIBE txnbycust;
	txnbycust: {group: bytearray,txn: {(txnid: bytearray,date: bytearray,custid: bytearray,amount: double,category: bytearray,
	product: bytearray,city: bytearray,state: bytearray,type: bytearray)}}

	DUMP txnbycust;
	(4009999,{(00026984,05-22-2011,4009999,111.47,Water Sports,Bodyboarding,Dayton,Ohio,credit),
	   (00047083,07-20-2011,4009999,27.08,Racquet Sports,Badminton,San Diego,California,cash),..,}
	----------------------------------------------------------------------------------------------------------------------------------------------

	C. Find the total amount spend by each customer:-
	-----------------------------------------------

	spendbycust = FOREACH  txnbycust  GENERATE group as customer_id,  ROUND_TO(SUM(txn.amount ),2) as totalsales;

	DESCRIBE spendbycust;
	spendbycust: {customer_id: bytearray,totalsales: double}

	DUMP spendbycust;
	(4009994,461.04)
	(4009995,455.13)
	(4009996,836.12)
	(4009997,486.19)
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	D. Find those customer whose amount is greater than 500:-
	--------------------------------------------

	cust500 = FILTER spendbycust BY $1>500;

	DESCRIBE cust500;
	cust500: {customer_id: bytearray,totalsales: double}

	DUMP cust500;
	(4009984,522.66)
	(4009987,516.98)
	(4009990,754.42)
	(4009996,836.12)
	---------------------------------------------------------------------------------------------------------------------------------------------

	E. Load customer records:-
	------------------------
	cust = LOAD '/home/hduser/custs' USING PigStorage(',') AS (custid, firstname, lastname, age:long, profession);

	DESCRIBE cust;
	cust: {custid: bytearray,firstname: bytearray,lastname: bytearray,age: long,profession: bytearray}

	DUMP cust;
	(4009992,Erin,Blackwell,33,Electrician)
	(4009993,Becky,Wolfe,67,Musician)
	(4009994,Clyde,Welch,40,Photographer)
	(4009995,Rebecca,Dennis,37,Teacher)
	---------------------------------------------------------------------------------------------------------------------------------------------

	F. Join the customer records with transaction records whose amount is > 500 using custid:-
	----------------------------------------------------------------------------------------

	joined = JOIN cust500 BY $0,cust BY $0;

	DESCRIBE joined;
	joined: {cust500::customer_id: bytearray,cust500::totalsales: double,cust::custid: bytearray,cust::firstname: bytearray,
	cust::lastname: bytearray,cust::age: long,cust::profession: bytearray}

	DUMP joined;
	(4009987,516.98,4009987,Todd,Fox,29,Politician)
	(4009990,754.42,4009990,Stacey,Rouse,21,Actor)
	(4009996,836.12,4009996,Tonya,McIntosh,56,Engineering technician)
	(4009998,665.7,4009998,Tracey,Bullock,60,Computer hardware engineer)
	(4009999,682.02,4009999,Ray,Hewitt,64,Carpenter)
	----------------------------------------------------------------------------------------------------------------------------------------------

	G. Create a new bag removing cust id from previous bag because two time custid in that bag:-
	------------------------------------------------------------------------------------------

	final_join = FOREACH joined GENERATE $0,$3,$4,$5,$6,$1;

	DESCRIBE final_join;
	final_join: {cust500::customer_id: bytearray,cust::firstname: bytearray,cust::lastname: bytearray,cust::age: long,
	cust::profession: bytearray,cust500::totalsales: double}

	DUMP final_join;
	(4009987,Todd,Fox,29,Politician,516.98)
	(4009990,Stacey,Rouse,21,Actor,754.42)
	(4009996,Tonya,McIntosh,56,Engineering technician,836.12)
	(4009998,Tracey,Bullock,60,Computer hardware engineer,665.7)
	(4009999,Ray,Hewitt,64,Carpenter,682.02)
	----------------------------------------------------------------------------------------------------------------------------------------------

	H. Find the customer whose age is less than 50:-
	----------------------------------------------

	final = FILTER final_join BY $3<50;

	DESCRIBE final;
	final: {cust500::customer_id: bytearray,cust::firstname: bytearray,cust::lastname: bytearray,cust::age: long,
	cust::profession: bytearray,cust500::totalsales: double}

	DUMP final;
	(4009979,Tim,Wade,49,Designer,785.28)
	(4009980,Erica,Moore,47,Artist,567.12)
	(4009984,Justin,Melvin,43,Loan officer,522.66)
	(4009987,Todd,Fox,29,Politician,516.98)
	(4009990,Stacey,Rouse,21,Actor,754.42)
	---------------------------------------------------------------------------------------------------------------------------------------------

	I.Store output in the local file system:-
	---------------------------------------
	
	STORE final INTO '/home/hduser/niit/custage50amt500' USING PigStorage();
	---------------------------------------------------------------------------------------------------------------------------------------------

	I.Group the all fields to find how many customer whose age is less than 50 and amount and amount is more than 500:-
	------------------------------------------------------------------------------------------------------------------

	groupall = GROUP final all;

	DESCRIBE groupall;
	groupall: {group: chararray,final: {(cust500::customer_id: bytearray,cust::firstname: bytearray,cust::lastname: bytearray,
	cust::age: long,cust::profession: bytearray,cust500::totalsales: double)}}

	DUMP groupall;
	(all,{(4009990,Stacey,Rouse,21,Actor,754.42),(4009987,Todd,Fox,29,Politician,516.98),
	(4009984,Justin,Melvin,43,Loan officer,522.66),
	(4009980,Erica,Moore,47,Artist,567.12),
	(4009979,Tim,Wade,49,Designer,785.28),..,})
	--------------------------------------------------------------------------------------------------------------------------

	totalcount = FOREACH groupall GENERATE COUNT(final);

	DESCRIBE totalcount;
	totalcount: {long}

	DUMP totalcount;
	(2422)
	----------------------------------------------------------------------------------------------------------------------------------------------	
	
	J.Find totalsales of all customer whose age <50 and totalsales >500:-
	-------------------------------------------------------------------

	totalsalesforcust = FOREACH groupall GENERATE ROUND_TO(SUM(final.totalsales),2);

	DESCRIBE totalsalesforcust;
	totalsalesforcust: {double}

	DUMP totalsalesforcust;
	(1766401.83)
------------------------------------------------------------------------------------------------------------------------------------------------------

	5. Retail Case Study:-	
		1. Find the catid whose yearly avgerage growth is greater than 10%.
		2. Find the catid whose yearly avergae growth is less than -5%.
		3. Find the top 5 sales and bottom 5 sales in the all three years.


	A.Load data for each year in the bag in form of catid,name,sales of each month:-
	------------------------------------------------------------------------------

	year1  =  LOAD  '/home/hduser/2000.txt'  USING PigStorage(',')  
	AS (catid, name, jan:double,feb:double,march:double,
	april:double,may:double,jun:double,jul:double,aug:double,sept:double,oct:double,nov:double,dec:double);

	year2  =  LOAD  '/home/hduser/2001.txt'  USING PigStorage(',')  
	AS (catid, name, jan:double,feb:double,march:double,
	april:double,may:double,jun:double,jul:double,aug:double,sept:double,oct:double,nov:double,dec:double);

	year3  =  LOAD  '/home/hduser/2002.txt'  USING PigStorage(',')  
	AS (catid, name, jan:double,feb:double,march:double,
	april:double,may:double,jun:double,jul:double,aug:double,sept:double,oct:double,nov:double,dec:double);


	DESCRIBE year1;
	year1: {catid: bytearray,name: bytearray,jan: double,feb: double,march: double,april: double,may: double,jun: double,
	jul: double,aug: double,sept: double,oct: double,nov: double,dec: double}

	DUMP year1;
	(4411,Automobile and other motor vehicle 						
	dealers,62306.0,63801.0,63027.0,60592.0,60492.0,61345.0,59995.0,60075.0,61360.0,61017.0,59479.0,58207.0)
	(4413,Automotive parts acc. and tire stores,5373.0,5284.0,5406.0,5220.0,5289.0,5293.0,5210.0,5236.0,5490.0,5191.0,5166.0,5317.0)
	(442,Furniture and home furnishings stores,7484.0,7548.0,7599.0,7729.0,7673.0,7593.0,7748.0,7682.0,7665.0,7737.0,7580.0,7160.0)
	(443,Electronics and appliance stores,6912.0,6959.0,6926.0,7002.0,6898.0,6751.0,6717.0,6781.0,6894.0,6764.0,6688.0,6679.0)
	(4441,Building mat. and supplies dealers,16789.0,16429.0,17268.0,16500.0,16510.0,16414.0,16502.0,16305.0,16253.0,16392.0,16018.0,16447.0)

	DESCRIBE year2;
	year2: {catid: bytearray,name: bytearray,jan: double,feb: double,march: double,april: double,may: double,jun: double,
	jul: double,aug: double,sept: double,oct: double,nov: double,dec: double}

	DUMP year2;
	(4451,Grocery stores,34229.0,34602.0,34477.0,34727.0,34781.0,34866.0,34792.0,35043.0,35152.0,35270.0,35414.0,35208.0)
	(4453,Beer wine and liquor stores,2496.0,2457.0,2444.0,2444.0,2455.0,2474.0,2458.0,2454.0,2451.0,2468.0,2512.0,2510.0)
	(44611,Pharmacies and drug stores,11391.0,11498.0,11571.0,11569.0,11713.0,11822.0,11883.0,11955.0,11906.0,12261.0,12149.0,12167.0)
	(447,Gasoline stations,21931.0,21615.0,20652.0,21618.0,22628.0,21928.0,20686.0,20878.0,21336.0,20033.0,19245.0,18950.0)
	(4481,Clothing stores,10014.0,10084.0,9760.0,10103.0,9928.0,9864.0,9925.0,10090.0,9488.0,10020.0,9915.0,10132.0)

	DESCRIBE year3;
	year3: {catid: bytearray,name: bytearray,jan: double,feb: double,march: double,april: double,may: double,jun: double,
	jul: double,aug: double,sept: double,oct: double,nov: double,dec: double}

	DUMP year3;
	(45299,All other gen. merchandise stores,2917.0,2853.0,2829.0,2850.0,2830.0,2885.0,2832.0,2872.0,2885.0,2922.0,2926.0,2936.0)
	(453,Miscellaneous stores retailers,8447.0,8616.0,8380.0,8579.0,8539.0,8639.0,8575.0,8740.0,8724.0,8579.0,8362.0,8569.0)
	(4541,Electronic shopping and mail order houses,9902.0,9994.0,9898.0,10025.0,10086.0,10066.0,10224.0,10266.0,10241.0,10305.0,10528.0,10527.0)
	(45431,Fuel dealers,1751.0,1732.0,1820.0,1960.0,2048.0,1997.0,2057.0,2024.0,2029.0,2136.0,2271.0,2318.0)
	(722,Food services and drinking places,27201.0,27384.0,27203.0,27500.0,27378.0,27586.0,27616.0,27607.0,27784.0,27623.0,27916.0,28017.0)
	----------------------------------------------------------------------------------------------------------------------------------------------


	B. Create a new bag with column is catid,name,year:-
	--------------------------------------------------

	year2000 = FOREACH year1 GENERATE catid,name,($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13) AS totalsales;

	year2001 = FOREACH year2 GENERATE catid,name,($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13) AS totalsales;

	year2002 = FOREACH year3 GENERATE catid,name,($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13) AS totalsales;
	
	DESCRIBE year2000;
	year2000: {catid: bytearray,name: bytearray,totalsales: double}
	
	DUMP year2000;
	(4411,Automobile and other motor vehicle dealers,731696.0)
	(4413,Automotive parts acc. and tire stores,63475.0)
	(442,Furniture and home furnishings stores,91198.0)
	(443,Electronics and appliance stores,81971.0)

	DESCRIBE year2001;                                                                                   
	year2001: {catid: bytearray,name: bytearray,totalsales: double}

	DUMP year2001;
	(4453,Beer wine and liquor stores,29623.0)
	(44611,Pharmacies and drug stores,141885.0)
	(447,Gasoline stations,251500.0)
	(4481,Clothing stores,119323.0)

	DESCRIBE year2002;
	year2002: {catid: bytearray,name: bytearray,totalsales: double}
		
	DUMP year2002;
	(45299,All other gen. merchandise stores,34537.0)
	(453,Miscellaneous stores retailers,102749.0)
	(4541,Electronic shopping and mail order houses,122062.0)
	(45431,Fuel dealers,24143.0)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	C. Join each year by using catid:-
	--------------------------------

	year = JOIN year2000 BY $0,year2001 BY $0, year2002 BY $0;

	DESCRIBE year;                                            
	year: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,year2001::catid: bytearray,
	year2001::name: bytearray,year2001::totalsales: double,year2002::catid: bytearray,year2002::name: bytearray,year2002::totalsales: double}

	DUMP year;
	(442,Furniture and home furnishings stores,91198.0,
	 442,Furniture and home furnishings stores,91480.0,
  	 442,Furniture and home furnishings stores,94468.0)
	(443,Electronics and appliance stores,81971.0,
	 443,Electronics and appliance stores,79839.0,
 	 443,Electronics and appliance stores,83732.0)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	
	D. Removing common catid,name from the joined bag year:-
	------------------------------------------------------

	finalyear = FOREACH year GENERATE $0,$1,$2,$5,$8;

	DESCRIBE finalyear;
	finalyear: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,year2001::totalsales: double,
	year2002::totalsales: double}

	DUMP finalyear;
	(442,Furniture and home furnishings stores,91198.0,91480.0,94468.0)
	(443,Electronics and appliance stores,81971.0,79839.0,83732.0)
	(447,Gasoline stations,249673.0,251500.0,250554.0)
	---------------------------------------------------------------------------------------------------------------------------------------------

	E. Find the growth of sales:-
	------------------------

	growth = FOREACH finalyear GENERATE $0,$1,$2,$3,$4,ROUND_TO((($3-$2)/$2)*100,2) AS growth1, ROUND_TO((($4-$3)/$3)*100,2) AS gowth2;

	DESCRIBE growth;
	growth: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,year2001::totalsales: double,
	year2002::totalsales: double,growth1: double,gowth2: double}
	
	DUMP growth;
	442,Furniture and home furnishings stores,91198.0,91480.0,94468.0,0.31,3.27)
	(443,Electronics and appliance stores,81971.0,79839.0,83732.0,-2.6,4.88)
	(447,Gasoline stations,249673.0,251500.0,250554.0,0.73,-0.38)
	(451,Sporting goods hobby book and music stores,75863.0,76891.0,76754.0,1.36,-0.18)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	F. Find average growth:-
	----------------------

	avggrowth = FOREACH growth GENERATE $0,$1,$2,$3,$4,$5,$6,ROUND_TO((($5+$6)/2),2) AS avggrowth;

	DESCRIBE avggrowth;
	avggrowth: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,
	year2001::totalsales: double,year2002::totalsales: double,growth1: double,gowth2: double,avggrowth: double}
	
	DUMP avggrowth;
	(442,Furniture and home furnishings stores,91198.0,91480.0,94468.0,0.31,3.27,1.79)
	(443,Electronics and appliance stores,81971.0,79839.0,83732.0,-2.6,4.88,1.14)
	(447,Gasoline stations,249673.0,251500.0,250554.0,0.73,-0.38,0.18)
	(451,Sporting goods hobby book and music stores,75863.0,76891.0,76754.0,1.36,-0.18,0.59)
	----------------------------------------------------------------------------------------------------------------------------------------------

	G. Find the catid whose avggrowth >10:-
	-----------------------------------

	avggrowthabove10 = FILTER avggrowth BY $7>10;

	DESCRIBE avggrowthabove10;
	avggrowthabove10: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,
	year2001::totalsales: double,year2002::totalsales: double,growth1: double,gowth2: double,avggrowth: double}

	DUMP avggrowthabove10;
	(45291,Warehouse clubs and supercenters,138784.0,164278.0,191167.0,18.37,16.37,17.37)
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	H. Store the output in the local file system:-
	--------------------------------------------
	
	STORE avggrowthabove10 INTO '/home/hduser/niit/avggrowthabove10' USING PigStorage();
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	I. Find the catid whose avgerage growth <-5:-
	-------------------------------------------

	avggrowthbelow5 = FILTER avggrowth BY $7<-5;

	DESCRIBE avggrowthbelow5;
	avggrowthbelow5: {year2000::catid: bytearray,year2000::name: bytearray,year2000::totalsales: double,
	year2001::totalsales: 	double,year2002::totalsales: double,growth1: double,gowth2: double,avggrowth: double}
	
	DUMP avggrowthbelow5;	
	(44811,Men's clothing stores,9499.0,8680.0,8143.0,-8.62,-6.19,-7.4)
	(45431,Fuel dealers,26871.0,25870.0,24143.0,-3.73,-6.68,-5.2)
	---------------------------------------------------------------------------------------------------------------------------------------------

	J. Store the output in the local file system:-
	--------------------------------------------
	
	STORE avggrowthbelow5 INTO '/home/hduser/niit/avggrowthbelow5' USING PigStorage();
	----------------------------------------------------------------------------------------------------------------------------------------------

	K. Find the total sales in all three years:-
	------------------------------------------

	totalsales = FOREACH finalyear GENERATE catid,name,($2+$3+$4) as sales;

	DESCRIBE totalsales;
	totalsales: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}
	
	DUMP totalsales;
	(442,Furniture and home furnishings stores,277146.0)
	(443,Electronics and appliance stores,245542.0)
	(447,Gasoline stations,751727.0)
	(451,Sporting goods hobby book and music stores,229508.0)
	----------------------------------------------------------------------------------------------------------------------------------------------

	L. Find the top 5 sales catid:-
	-----------------------------

	toptotalsales = ORDER totalsales BY $2 DESC;

	DESCRIBE toptotalsales;
	toptotalsales: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}

	DUMP toptotalsales;
	(4411,Automobile and other motor vehicle dealers,2242463.0)
	(4451,Grocery stores,1240440.0)
	(722,Food services and drinking places,951357.0)
	(447,Gasoline stations,751727.0)
	-----------------------------------------------------------------------------------------

	topfivetotalsales = LIMIT toptotalsales 5;
	
	DESCRIBE topfivetotalsales;
	topfivetotalsales: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}
	
	DUMP topfivetotalsales;
	(4411,Automobile and other motor vehicle dealers,2242463.0)
	(4451,Grocery stores,1240440.0)
	(722,Food services and drinking places,951357.0)
	(447,Gasoline stations,751727.0)
	(4521,Department stores (excl. L.D.),682278.0)
	---------------------------------------------------------------------------------------------------------------------------------------------

			OR

	we also use limit and order by in one row command:-

	topfivetotalsales2 = LIMIT (ORDER totalsales BY $2 DESC) 5;
	
	DESCRIBE topfivetotalsales2;
	topfivetotalsales2: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}

	DUMP topfivetotalsales2;
	(4411,Automobile and other motor vehicle dealers,2242463.0)
	(4451,Grocery stores,1240440.0)
	(722,Food services and drinking places,951357.0)
	(447,Gasoline stations,751727.0)
	(4521,Department stores (excl. L.D.),682278.0)
	--------------------------------------------------------------------------------------------------------------------------------------------
	
	M. Store the output in the local file system:-
	--------------------------------------------
	
	STORE topfivetotalsales INTO '/home/hduser/niit/topfivetotalsales' USING PigStorage();
	----------------------------------------------------------------------------------------------------------------------------------------------

	N. Find the bottom 5 sales catid:-
	-----------------------------

	bottomtotalsales = ORDER totalsales BY $2;

	DESCRIBE bottomtotalsales;    
	bottomtotalsales: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}
	
	DUMP bottomtotalsales;
	(44811,Men's clothing stores,26322.0)
	(4482,Shoe stores,68943.0)
	(44831,Jewelery stores,73148.0)
	(45431,Fuel dealers,76884.0)
	--------------------------------------------------------------------------------------------
	
	bottomfivetotalsales = LIMIT bottomtotalsales 5;
	
	DESCRIBE bottomfivetotalsales;                  
	bottomfivetotalsales: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}

	DUMP bottomfivetotalsales;
	(44811,Men's clothing stores,26322.0)
	(4482,Shoe stores,68943.0)
	(44831,Jewelery stores,73148.0)
	(45431,Fuel dealers,76884.0)
	(4453,Beer wine and liquor stores,87976.0)
	---------------------------------------------------------------------------------------------------------------------------------------------
			OR

	we also use limit and order by in one row command:-

	bottomfivetotalsales2= LIMIT (ORDER totalsales BY $2) 5;

	DESCRIBE bottomfivetotalsales2;
	bottomfivetotalsales2: {year2000::catid: bytearray,year2000::name: bytearray,sales: double}

	DUMP bottomfivetotalsales2;
	(44811,Men's clothing stores,26322.0)
	(4482,Shoe stores,68943.0)
	(44831,Jewelery stores,73148.0)
	(45431,Fuel dealers,76884.0)
	(4453,Beer wine and liquor stores,87976.0)
	----------------------------------------------------------------------------------------------------------------------------------------------
	
	O. Store the output in the local file system:-
	--------------------------------------------
	
	STORE bottomfivetotalsales INTO '/home/hduser/niit/bottomfivetotalsales' USING PigStorage();
	
--------------------------------------------------------------------------------------------------------------------------------------------------------

