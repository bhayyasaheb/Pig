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

Q.2 Count the frequency of each distinct word in a text file.

	A.Load data file in the bag:-
	--------------------------- 
	file_ip = LOAD '/home/hduser/word_count.txt' USING TextLoader() AS (word:chararray);

	DESCRIBE file_ip;
	file_ip: {word: chararray}

	DUMP file_ip;
	(Hadoop is the Elephant King!)
	(A yellow and elegant thing.)
	(He never forgets)
	(Useful data, or lets)
	(An extraneous element cling!)
	(A wonderful king is Hadoop.)
	(The elephant plays well with Sqoop.)
	(But what helps him to thrive)
	(Are Impala, and Hive,)
	(And HDFS in the group.)
	(Hadoop is an elegant fellow.)
	(An elephant gentle and mellow.)
	(He never gets mad,)
	(Or does anything bad,)
	(Because, at his core, he is yellow.)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B. Using FLATTEN and TOKENIZE spliting each word in each row:-
	-------------------------------------------------------------
	words = FOREACH file_ip GENERATE FLATTEN(TOKENIZE(word));

	DESCRIBE word;
	words: {bag_of_tokenTuples_from_word::token: chararray}

	DUMP word;
	(Hadoop)
	(is)
	(the)
	(Elephant)
	(King!)
	(A)
	(yellow)
	(and)
	(elegant)
	(thing.)
	(He)
	(never)
	(forgets)
	(Useful)
	(data)
	(or)
	(lets)
	(An)
	(extraneous)
	(element)
	(cling!)
	(A)
	(wonderful)
	(king)
	(is)
	(Hadoop.)
	(The)
	(elephant)
	(plays)
	(well)
	(with)
	(Sqoop.)
	(But)
	(what)
	(helps)
	(him)
	(to)
	(thrive)
	(Are)
	(Impala)
	(and)
	(Hive)
	(And)
	(HDFS)
	(in)
	(the)
	(group.)
	(Hadoop)
	(is)
	(an)
	(elegant)
	(fellow.)
	(An)
	(elephant)
	(gentle)
	(and)
	(mellow.)
	(He)
	(never)
	(gets)
	(mad)
	(Or)
	(does)
	(anything)
	(bad)
	(Because)
	(at)
	(his)
	(core)
	(he)
	(is)
	(yellow.)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C. Group data on word:-
	----------------------
	grouped = GROUP words BY $0;

	DESCRIBE grouped;
	grouped: {group: chararray,words: {(bag_of_tokenTuples_from_word::token: chararray)}}


	DUMP grouped;
	(A,{(A),(A)})
	(An,{(An),(An)})
	(He,{(He),(He)})
	(Or,{(Or)})
	(an,{(an)})
	(at,{(at)})
	(he,{(he)})
	(in,{(in)})
	(is,{(is),(is),(is),(is)})
	(or,{(or)})
	(to,{(to)})
	(And,{(And)})
	(Are,{(Are)})
	(But,{(But)})
	(The,{(The)})
	(and,{(and),(and),(and)})
	(bad,{(bad)})
	(him,{(him)})
	(his,{(his)})
	(mad,{(mad)})
	(the,{(the),(the)})
	(HDFS,{(HDFS)})
	(Hive,{(Hive)})
	(core,{(core)})
	(data,{(data)})
	(does,{(does)})
	(gets,{(gets)})
	(king,{(king)})
	(lets,{(lets)})
	(well,{(well)})
	(what,{(what)})
	(with,{(with)})
	(King!,{(King!)})
	(helps,{(helps)})
	(never,{(never),(never)})
	(plays,{(plays)})
	(Hadoop,{(Hadoop),(Hadoop)})
	(Impala,{(Impala)})
	(Sqoop.,{(Sqoop.)})
	(Useful,{(Useful)})
	(cling!,{(cling!)})
	(gentle,{(gentle)})
	(group.,{(group.)})
	(thing.,{(thing.)})
	(thrive,{(thrive)})
	(yellow,{(yellow)})
	(Because,{(Because)})
	(Hadoop.,{(Hadoop.)})
	(elegant,{(elegant),(elegant)})
	(element,{(element)})
	(fellow.,{(fellow.)})
	(forgets,{(forgets)})
	(mellow.,{(mellow.)})
	(yellow.,{(yellow.)})
	(Elephant,{(Elephant)})
	(anything,{(anything)})
	(elephant,{(elephant),(elephant)})
	(wonderful,{(wonderful)})
	(extraneous,{(extraneous)})
	-----------------------------------------------------------------------------------------------------------------------------------------------

	D. Count the word:-
	-----------------
	word_counts = FOREACH grouped GENERATE group, COUNT(words);

	DESCRIBE word_counts;
	word_counts: {group: chararray,long}

	DUMP word_counts;
	(A,2)
	(An,2)
	(He,2)
	(Or,1)
	(an,1)
	(at,1)
	(he,1)
	(in,1)
	(is,4)
	(or,1)
	(to,1)
	(And,1)
	(Are,1)
	(But,1)
	(The,1)
	(and,3)
	(bad,1)
	(him,1)
	(his,1)
	(mad,1)
	(the,2)
	(HDFS,1)
	(Hive,1)
	(core,1)
	(data,1)
	(does,1)
	(gets,1)
	(king,1)
	(lets,1)
	(well,1)
	(what,1)
	(with,1)
	(King!,1)
	(helps,1)
	(never,2)
	(plays,1)
	(Hadoop,2)
	(Impala,1)
	(Sqoop.,1)
	(Useful,1)
	(cling!,1)
	(gentle,1)
	(group.,1)
	(thing.,1)
	(thrive,1)
	(yellow,1)
	(Because,1)
	(Hadoop.,1)
	(elegant,2)
	(element,1)
	(fellow.,1)
	(forgets,1)
	(mellow.,1)
	(yellow.,1)
	(Elephant,1)
	(anything,1)
	(elephant,2)
	(wonderful,1)
	(extraneous,1)
	----------------------------------------------------------------------------------------------------------------------------------------------

	E. Store ouput in local file system:-
	-----------------------------------
	STORE word_counts INTO '/home/hduser/niit/word_counts' USING PigStorage();

------------------------------------------------------------------------------------------------------------------------------------------------------

Q.3 Find the average number of medical claims amount per user.


	A. Load data in the bag:-
	-----------------------
	claims = LOAD '/home/hduser/medical' USING PigStorage() AS (name,dept,amount:double);

	DESCRIBE claims;
	claims: {name: bytearray,dept: bytearray,amount: double}

	DUMP claims;
	(amy,hr,8000)
	(jack,hr,7500)
	(joe,finance,9000)
	(daniel,admin,4750)
	(tim,TS,4750)
	(tim,TS,3500)
	(tim,TS,2750)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B. Group claims bag on name:-
	---------------------------
	employee_claims = GROUP claims by name;

	DESCRIBE employee_claims;
	employee_claims: {group: bytearray,claims: {(name: bytearray,dept: bytearray,amount: double)}}

	DUMP employee_claims;
	(amy,{(amy,hr,8000.0)})
	(joe,{(joe,finance,9000.0)})
	(tim,{(tim,TS,2750.0),(tim,TS,3500.0),(tim,TS,4750.0)})
	(jack,{(jack,hr,7500.0)})
	(daniel,{(daniel,admin,4750.0)})
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C. Find the average amount of claims:-
	------------------------------------
	emp_avg = FOREACH employee_claims GENERATE group,AVG(claims.amount);

	DESCRIBE emp_avg;
	emp_avg: {group: bytearray,double}

	DUMP emp_avg;
	(amy,8000.0)
	(joe,9000.0)
	(tim,3666.6666666666665)
	(jack,7500.0)
	(daniel,4750.0)

	D. Store output in local file system:-
	-------------------------------------
	STORE emp_avg INTO '/home/hduser/niit/emp_avg' USING PigStorage();

-------------------------------------------------------------------------------------------------------------------------------------------------------

Q. 4 Find out user who use "Reliable" payment gateways. 
     Hint:-here Reilable payment gateway is avgerage success rate is above 90.

	A. Load the weblog data in the users bag:-
	----------------------------------------
	users = LOAD '/home/hduser/weblog' USING PigStorage() AS (user:chararray,gateway:chararray,time:chararray);

	DESCRIBE users;
	users: {user: chararray,gateway: chararray,time: chararray}

	DUMP users;
	(john,citibank,19.00)
	(john,hsbc bank,19.05)
	(john,sc bank,17.00)
	(john,abc bank,17.05)
	(rita,sc bank,11.05)
	(rita,abc bank,11.00)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	B. Load the gateway data in gateways bag:-
	----------------------------------------
	gateways = LOAD '/home/hduser/gateway' USING PigStorage() AS (gateway:chararray,success_rate:float);

	DESCRIBE gateways;
	gateways: {gateway: chararray,success_rate: float}


	DUMP gateways;
	(citibank,95.0)
	(hsbc bank,95.0)
	(sc bank,92.0)
	(abc bank,85.0)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	C. Join the users and gateways bag on gateway:-
	---------------------------------------------
	users_gateways = JOIN users BY gateway, gateways BY gateway;

	DESCRIBE users_gateways;
	users_gateways: {users::user: chararray,users::gateway: chararray,users::time: chararray,gateways::gateway: chararray,
	gateways::success_rate: float}

	DUMP users_gateways;
	(rita,sc bank,11.05,sc bank,92.0)
	(john,sc bank,17.00,sc bank,92.0)
	(rita,abc bank,11.00,abc bank,85.0)
	(john,abc bank,17.05,abc bank,85.0)
	(john,citibank,19.00,citibank,95.0)
	(john,hsbc bank,19.05,hsbc bank,95.0)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	D. Removing Unwanted column from the bag:-
	----------------------------------------
	final_user_gateways = FOREACH users_gateways GENERATE $0,$1,$4;


	DESCRIBE final_user_gateways;
	final_user_gateways: {users::user: chararray,users::gateway: chararray,gateways::success_rate: float}

	DUMP final_user_gateways;
	(rita,sc bank,92.0)
	(john,sc bank,92.0)
	(rita,abc bank,85.0)
	(john,abc bank,85.0)
	(john,citibank,95.0)
	(john,hsbc bank,95.0)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	E. Group the bag on user:-
	------------------------
	group_users_gateways= GROUP final_user_gateways by user;


	DESCRIBE group_users_gateways;
	group_users_gateways: {group: chararray,final_user_gateways: {(users::user: chararray,users::gateway: chararray,
	gateways::success_rate: float)}}


	DUMP group_users_gateways;
	(john,{(john,hsbc bank,95.0),(john,citibank,95.0),(john,abc bank,85.0),(john,sc bank,92.0)})
	(rita,{(rita,abc bank,85.0),(rita,sc bank,92.0)})
	-----------------------------------------------------------------------------------------------------------------------------------------------

	F. Find the average of success rate for each user:-
	-------------------------------------------------
	user_avg = FOREACH group_users_gateways GENERATE group, AVG(final_user_gateways.success_rate) as avgsuccrate;

	DESCRIBE user_avg;
	user_avg: {group: chararray,avgpr: double}

	DUMP user_avg;
	(john,91.75)
	(rita,88.5)
	-----------------------------------------------------------------------------------------------------------------------------------------------

	G. Find the user whose average success rate > 90:-
	------------------------------------------------
	result = FILTER user_avg BY avgsuccrate > 90;

	DESCRIBE result;
	result: {group: chararray,avgpr: double}

	DUMP result;
	(john,91.75)

	H. Store the output in the local file system:-
	--------------------------------------------
	STORE result INTO '/home/hduser/niit/reliable_gateway' USING PigStorage();
-------------------------------------------------------------------------------------------------------------------------------------------------------

