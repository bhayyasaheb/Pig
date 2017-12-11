Q.1 Find lsit of authors whose name starts with 'J' and the price of their books is greater than or equal to $200.

	A. Load the book data in the bag:-
	--------------------------------
	book_info  =  LOAD  '/home/hduser/Book_info.txt'  USING PigStorage('|')  AS  (book_id:int,price:int,author_id:int);

	DESCRIBE book_info;
	book_info: {book_id: int,price: int,author_id: int}

	DUMP book_info;
	(100,200,10)
	(200,150,20)
	(300,200,30)
	(400,300,40)
	(500,150,50)
	(600,300,60)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B. Find the book whose price>=200:-
	-------------------------------
	book_info_filtered = FILTER book_info BY price>=200;

	DESCRIBE book_info_filtered;
	book_info_filtered: {book_id: int,price: int,author_id: int}

	DUMP book_info_filtered;
	(100,200,10)
	(300,200,30)
	(400,300,40)
	(600,300,60)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C. Load the authors data in bag:-
	------------------------------- 
	author_info  =  LOAD  '/home/hduser/Author_info.txt'  USING PigStorage('|')  AS  (author_id:int,author_name:chararray);

	DESCRIBE author_info;
	author_info: {author_id: int,author_name: chararray}

	DUMP author_info;
	(10,Johan)
	(20,Jerry)
	(30,Alan)
	(40,Cathy)
	(50,Mark)
	(60,Justin)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	D. Find the author whose name starts with 'J':-
	----------------------------------------------
	author_info_filtered = FILTER author_info BY INDEXOF(author_name,'J',0) == 0;

	DESCRIBE author_info_filtered;
	author_info_filtered: {author_id: int,author_name: chararray}

	DUMP author_info_filtered;
	(10,Johan)
	(20,Jerry)
	(60,Justin)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	E. Join the book and author data using author_id:-
	------------------------------------------------
	book_author_info = JOIN book_info_filtered by author_id, author_info_filtered by author_id;

	DESCRIBE book_author_info;
	book_author_info: {book_info_filtered::book_id: int,book_info_filtered::price: int,
	book_info_filtered::author_id: int,author_info_filtered::author_id: int,author_info_filtered::author_name: chararray}

	DUMP book_author_info;
	(100,200,10,10,Johan)
	(600,300,60,60,Justin)
	----------------------------------------------------------------------------------------------------------------------------------------------

	F. Removing duplicates author_id column:-
	---------------------------------------
	final_book_author_info = FOREACH book_author_info GENERATE $0,$1,$2,$4;

	DESCRIBE final_book_author_info;
	final_book_author_info: {book_info_filtered::book_id: int,book_info_filtered::price: int,
	book_info_filtered::author_id: int,author_info_filtered::author_name: chararray}

	DUMP final_book_author_info;
	(100,200,10,Johan)
	(600,300,60,Justin)

	-----------------------------------------------------------------------------------------------------------------------------------------------

	G. Store output in local file system:-
	------------------------------------
	STORE final_book_author_info INTO '/home/hduser/niit/store_info_book' USING PigStorage('|');


-------------------------------------------------------------------------------------------------------------------------------------------------------

