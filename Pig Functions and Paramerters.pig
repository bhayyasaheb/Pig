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

Union & Split:-
--------------

	Q. Find the count of INFO,WARN,ERROR and count by datewise,count by codewise in the log file.

	A.Load data in the bag:-
	----------------------
	log1 = LOAD '/home/hduser/mapred-hduser-historyserver-ubuntu.log' USING PigStorage() AS (lines:chararray);

	DESCRIBE log1;
	log1: {lines: chararray}

	DUMP log1;
	(2017-09-16 03:27:23,504 ERROR org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)
	(2017-09-16 03:30:23,099 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)
	(2017-09-16 03:33:23,099 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)
	(2017-09-16 03:36:23,099 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)
	------------------------------------------------------------------------------------------------------------------------------------

	B.Split the log1 bag:-
	--------------------
	SPLIT log1 INTO log2 IF SUBSTRING (lines, 24, 28) == 'INFO', log3 IF SUBSTRING (lines, 24, 29) == 'ERROR', 
	log4 IF SUBSTRING (lines, 24, 28) == 'WARN';

	DESCRIBE log2;
	log2: {lines: chararray}

	DUMP log2;
	(2017-09-16 03:30:23,099 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)
	(2017-09-16 03:33:23,099 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistory: Starting scan to move intermediate done files)


	DESCRIBE log3;
	log3: {lines: chararray}

	DUMP log3;
	(2017-09-15 07:54:21,578 ERROR org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: RECEIVED SIGNAL 15: SIGTERM)
	(2017-09-15 07:54:21,651 ERROR org.apache.hadoop.security.token.delegation.AbstractDelegationTokenSecretManager)


	DESCRIBE log4;
	log4: {lines: chararray}

	DUMP log4;
	(2017-09-15 05:45:14,187 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library for your)
	(2017-09-16 01:09:05,469 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library for your)
	----------------------------------------------------------------------------------------------------------------------------------------------

	C. Group the bag:-
	----------------
	groupoflog2 = GROUP log2 ALL;

	DESCRIBE groupoflog2;
	groupoflog2: {group: chararray,log2: {(lines: chararray)}}

	DUMP groupoflog2;
	(all,{(2016-02-07 08:31:56,176 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: registered UNIX signal handlers for [TERM, HUP, INT]),
	(2016-02-07 08:31:56,167 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: STARTUP_MSG: )})
	------------------------------------------------------------------------------------------------------------------------------

	groupoflog3 = GROUP log3 ALL;

	DESCRIBE groupoflog3;
	groupoflog3: {group: chararray,log3: {(lines: chararray)}}

	DUMP groupoflog3;
	(all,{(2017-09-15 07:54:21,651 ERROR org.apache.hadoop.security.token.delegation.AbstractDelegationTokenSecretManager),
	     (2016-02-07 12:22:27,323 ERROR org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: RECEIVED SIGNAL 15: SIGTERM)})
	------------------------------------------------------------------------------------------------------------------------------

	groupoflog4 = GROUP log4 ALL;

	DESCRIBE groupoflog4;
	groupoflog4: {group: chararray,log4: {(lines: chararray)}}

	DUMP groupoflog4;
	(all,{(2017-09-16 01:09:05,469 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library for your ),
	(2017-09-15 05:45:14,187 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library for your)})
	------------------------------------------------------------------------------------------------------------------------------

	D.Count the no of the INFO,ERROR,WARN messages:-
	-----------------------------------------------
	countoflog2 = FOREACH groupoflog2 GENERATE COUNT(log2);

	DESCRIBE countoflog2;
	countoflog2: {long}

	DUMP countoflog2;
	INFO:- (6157)
	-----------------------------------------------------------------

	countoflog3 = FOREACH groupoflog3 GENERATE COUNT(log3);

	DESCRIBE countoflog3;
	countoflog3: {long}

	DUMP countoflog3;
	ERROR:-(59)
	----------------------------------------------------------------

	countoflog4 = FOREACH groupoflog4 GENERATE COUNT(log4);

	DESCRIBE countoflog4;                                  
	countoflog4: {long}

	DUMP countoflog4;
	WARN:-(54)
	-----------------------------------------------------------------------------------------------------------------------------------------

	E.Store bag in local file system:-
	--------------------------------
	STORE countoflog2 INTO '/home/hduser/niit/unionsplit/countofinfo' USING PigStorage();

	STORE countoflog3 INTO '/home/hduser/niit/unionsplit/countoferror' USING PigStorage();

	STORE countoflog4 INTO '/home/hduser/niit/unionsplit/countofwarn' USING PigStorage();
	------------------------------------------------------------------------------------------------------------------------------------------

	F.Group the INFO messages on INFO code wise:-
	-------------------------------------------
	infocodegroup = group log2 by SUBSTRING(lines,20,23);

	DESCRIBE infocodegroup;
	infocodegroup: {group: chararray,log2: {(lines: chararray)}}

	DUMP infocodegroup;
	(994,{(2017-04-05 04:53:47,994 INFO org.apache.hadoop.mapreduce.v2.hs.HistoryFileManager: Deleting JobSummary file)})
	(995,{(2017-02-11 00:03:11,995 INFO org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: STARTUP_MSG: ),
	     (2017-04-05 04:53:47,995 INFO org.apache.hadoop.mapreduce.v2.hs.HistoryFileManager: Deleting JobSummary file)})
	---------------------------------------------------------------------------------------------------------------------------------------------

	G.Count the INFO messages INFO code wise:-
	----------------------------------------
	infocodecount = FOREACH infocodegroup GENERATE group,COUNT(log2);

	DESCRIBE infocodecount;
	infocodecount: {group: chararray,long}

	DUMP infocodecount;
	(901,6)
	(902,4)
	(903,4)
	(904,6)
	----------------------------------------------------------------------------------------------------------------

	H.Order the infocodecount by count:-
	----------------------------------

	infocountorder = ORDER infocodecount BY $1 DESC;

	DESCRIBE infocountorder;
	infocountorder: {group: chararray,long}

	DUMP infocountorder;
	(999,95)
	(379,89)
	(535,84)
	(234,67)
	---------------------------------------------------------------------------------------------------------------

	I.Store bag in local file system:-
	--------------------------------
	STORE infocountorder INTO '/home/hduser/niit/unionsplit/infocountorder' USING PigStorage();

	-------------------------------------------------------------------------------------------------------------------------

	J.Group the INFO message on date:-
	--------------------------------
	infodtgroup = GROUP log2 BY SUBSTRING(lines,0,10);

	DESCRIBE infodtgroup;
	infodtgroup: {group: chararray,log2: {(lines: chararray)}}

	DUMP infodtgroup;
	(2017-09-16,{(2017-09-16 01:09:23,179 INFO org.mortbay.log: Logging to org.slf4j.impl.Log4jLoggerAdapter(org.mortbay.log)),
	(2017-09-16 01:09:23,183 INFO org.apache.hadoop.http.HttpRequestLog: Http request log for http.requests.jobhistory is not defined),
	(2017-09-16 01:09:23,195 INFO org.apache.hadoop.http.HttpServer2: Added global filter 'safety'),
	(2017-09-16 01:09:23,197 INFO org.apache.hadoop.http.HttpServer2: Added filter static_user_filter)})
	---------------------------------------------------------------------------------------------------------------------------------------------

	K.Count the INFO message date wise:-
	----------------------------------
	infodtcount = FOREACH infodtgroup GENERATE group, COUNT(log2);

	DESCRIBE infodtcount;
	infodtcount: {group: chararray,long}

	DUMP infodtcount;
	(2017-07-10,245)
	(2017-07-11,205)
	(2017-08-01,261)
	(2017-08-27,210)
	(2017-09-15,331)
	-------------------------------------------------------------------------------------------------------------------------------------------

	L.Store bag in local file system:-
	--------------------------------
	STORE infodtcount INTO '/home/hduser/niit/unionsplit/infodtcount' USING PigStorage();

	------------------------------------------------------------------------------------------------------------------------------------------

	M. Group the ERROR messages on ERROR code wise:-
	-----------------------------------------------
	errorcodegroup = GROUP log3 BY SUBSTRING(lines,20,23);

	DESCRIBE errorcodegroup;
	errorcodegroup: {group: chararray,log3: {(lines: chararray)}}

	DUMP errorcodegroup;
	(998,{(2016-04-22 10:02:40,998 ERROR org.apache.hadoop.security. java.lang.InterruptedException: sleep interrupted)})
	------------------------------------------------------------------------------------------------------------------------------------------

	N.Count the ERROR messages ERROR code wise:-
	------------------------------------------
	errorcodecount = FOREACH errorcodegroup GENERATE group, COUNT(log3);

	DESCRIBE errorcodecount;
	errorcodecount: {group: chararray,long}

	DUMP errorcodecount;
	(881,1)
	(921,1)
	(990,1)
	(998,1)
	------------------------------------------------------------------------------------------------------------------------------------------

	O.Order the errorcodecount by count:-
	----------------------------------
	errorcountorder = ORDER errorcodecount BY $1 DESC;

	DESCRIBE errorcountorder;
	errorcountorder: {group: chararray,long}

	DUMP errorcountorder;
	(780,2)
	(998,1)
	(990,1)
	(921,1)
	----------------------------------------------------------------------------------------------------------------------------------------

	P.Store bag in local file system:-
	--------------------------------
	STORE errorcountorder INTO '/home/hduser/niit/unionsplit/errorcountorder' USING PigStorage();

	----------------------------------------------------------------------------------------------------------------------------------------

	Q.Group ERROR message on date:-
	-----------------------------
	errordtgroup = GROUP log3 BY SUBSTRING(lines,0,10);

	DESCRIBE errordtgroup;
	errordtgroup: {group: chararray,log3: {(lines: chararray)}}

	DUMP errordtgroup;
	(2017-09-15,{(2017-09-15 07:54:21,578 ERROR org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer: RECEIVED SIGNAL 15: SIGTERM),
		    (2017-09-15 07:54:21,651 ERROR org.apache.hadoop.security.token.delegation.AbstractDelegationTok)})
	----------------------------------------------------------------------------------------------------------------------------------------

	R.Count ERROR message date wise:-
	-------------------------------- 
	errordtcount = FOREACH errordtgroup GENERATE group, COUNT(log3);

	DESCRIBE errordtcount;
	errordtcount: {group: chararray,long}

	DUMP errordtcount;
	(2017-07-11,2)
	(2017-08-01,2)
	(2017-08-27,2)
	(2017-09-15,2)
	----------------------------------------------------------------------------------------------------------------------------------------

	S.Store bag in local file system:-
	--------------------------------
	STORE errordtcount INTO '/home/hduser/niit/unionsplit/errordtcount' USING PigStorage();

	----------------------------------------------------------------------------------------------------------------------------------------

	T. Group WARN message on WARN code wise:-
	---------------------------------------
	warncodegroup = GROUP log4 BY SUBSTRING(lines,20,23);

	DESCRIBE warncodegroup;
	warncodegroup: {group: chararray,log4: {(lines: chararray)}}

	DUMP warncodegroup;
	(987,{(2016-04-23 11:20:39,987 WARN org.apache.hadoop.util.NativeCodeLoader: java classes where applicable)})
	----------------------------------------------------------------------------------------------------------------------------------------

	U. Count the WARN message on WARN code:-
	--------------------------------------
	warncodecount = FOREACH warncodegroup GENERATE group, COUNT(log4);

	DESCRIBE warncodecount;
	warncodecount: {group: chararray,long}

	DUMP warncodecount;
	(917,1)
	(935,2)
	(951,1)
	(956,2)
	(987,1)
	-----------------------------------------------------------------------------------------------------------------------------------------

	V. Order warncodecount by count:-
	-------------------------------
	warncountorder = ORDER warncodecount BY $1 DESC;

	DESCRIBE warncountorder;
	warncountorder: {group: chararray,long}

	DUMP warncountorder;
	(837,2)
	(221,2)
	(472,2)
	(831,2)
	---------------------------------------------------------------------------------------------------------------------------------------

	W.Store bag in local file system:-
	--------------------------------
	STORE warncountorder INTO '/home/hduser/niit/unionsplit/warncountorder' USING PigStorage();

	----------------------------------------------------------------------------------------------------------------------------------------

	X.Group the WARN message on date:-
	--------------------------------
	warndtgroup = GROUP log4 BY SUBSTRING(lines,0,10);

	DESCRIBE warndtgroup;
	warndtgroup: {group: chararray,log4: {(lines: chararray)}}

	DUMP warndtgroup;
	(2017-09-16,{(2017-09-16 01:09:05,469 WARN org.apache.hadoop.util.NativeCodeLoader: Unable to load native-hadoop library)})
	---------------------------------------------------------------------------------------------------------------------------------------

	Y.Count the WARN message on datewise:-
	-------------------------------------
	warndtcount = FOREACH warndtgroup GENERATE group, COUNT(log4);

	DESCRIBE warndtcount;
	warndtcount: {group: chararray,long}

	DUMP warndtcount;
	(2017-08-01,3)
	(2017-08-27,1)
	(2017-09-15,1)
	(2017-09-16,1)
	-------------------------------------------------------------------------------------------------------------------------------------

	Z.Store bag in local file system:-
	--------------------------------
	STORE warndtcount INTO '/home/hduser/niit/unionsplit/warndtcount' USING PigStorage();

------------------------------------------------------------------------------------------------------------------------------------------------------

