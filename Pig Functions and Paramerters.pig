UNION & SPLIT:-
-------------

	A.Load data in book1 bag:-
	------------------------
	book1 = LOAD '/home/hduser/book1.txt' USING TextLoader() AS (lines:chararray);

	DESCRIBE book1;
	book1: {lines: chararray}

	DUMP book1;
	(this is a sentence one)
	(this is a sentence two)
	(this is a sentence three)
	(this is a sentence eight)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B.Load data in book2 bag:-
	------------------------
	book2 = LOAD '/home/hduser/book2.txt' USING TextLoader() AS (lines:chararray);

	DESCRIBE book2;
	book2: {lines: chararray}

	DUMP book2;
	(this is a sentence four)
	(this is a sentence five)
	(this is a sentence six)
	(this is a sentence seven)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C.Union book1 and book2 bag:-
	--------------------------- 
	bookcombined = UNION book1,book2;

	DESCRIBE bookcombined;
	bookcombined: {lines: chararray}

	DUMP bookcombined;
	(this is a sentence one)
	(this is a sentence four)
	(this is a sentence two)
	(this is a sentence five)
	(this is a sentence three)
	(this is a sentence six)
	(this is a sentence eight)
	(this is a sentence seven)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	D.Split bookcombied:-
	-------------------
	SPLIT bookcombined INTO book3 IF SUBSTRING(lines,5,7) == 'is', book4 IF SUBSTRING(lines,19,24) =='three', 
	book5 IF SUBSTRING(lines,0,4) == 'this';

	DESCRIBE book3;
	book3: {lines: chararray}

	DESCRIBE book4;
	book4: {lines: chararray}

	DESCRIBE book5;
	book5: {lines: chararray}

	DUMP book3;
	(this is a sentence four)
	(this is a sentence five)
	(this is a sentence six)
	(this is a sentence seven)
	(this is a sentence one)
	(this is a sentence two)
	(this is a sentence three)
	(this is a sentence eight)

	DUMP book4;
	(this is a sentence three)

	DUMP book5;
	(this is a sentence one)
	(this is a sentence two)
	(this is a sentence three)
	(this is a sentence eight)
	(this is a sentence four)
	(this is a sentence five)
	(this is a sentence six)
	(this is a sentence seven)
	
	E.Store bag in local file system:-
	--------------------------------
	STORE book3 INTO '/home/hduser/niit/unionsplit/book3' USING PigStorage();
	
	STORE book4 INTO '/home/hduser/niit/unionsplit/book4' USING PigStorage();

	STORE book5 INTO '/home/hduser/niit/unionsplit/book5' USING PigStorage();
-------------------------------------------------------------------------------------------------------------------------------------------------------


