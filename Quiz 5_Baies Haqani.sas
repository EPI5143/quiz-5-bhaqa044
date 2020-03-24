*Baies Haqani;
*EPI 5143 -- Quiz 5;

libname raw '/folders/myfolders/class_data';
libname Quiz5 '/folders/myfolders/Epi5143 work folder/programs';


*Creating spine dataset from NhrAbstract dataset;
*unique admissions (hraEncWID) with admit dates (hraAdmDtm) between January 1st, 2003 and December 31st, 2004;
data Quiz5.nhrabstracts; 
set raw.nhrabstracts; 
run; 

data spine;
set quiz5.nhrabstracts;  
by hraEncWID;
if year(datepart(hraAdmDtm)) not in (2003,2004) then delete;
run;

*Removing duplicates - total 2230 observations;
proc sort data=spine nodupkey;
by hraEncWID;
run;

*Q2, Q3;
proc sort data=quiz5.nhrdiagnosis out=diagnosis;
by hdghraencwid;
run; 

*flat filing data set; 
data Diabetes;
	set diagnosis;
	by hdghraencwid;
		if first.hdghraencwid=1 then do;
	DM=0;
	count=0; 
end;
	if hdgcd in:('250' 'E10' 'E11') then do; 
	dm=1;
	count=count+1;
end;
	if last.hdghraencwid=1 then output;
	retain DM count; 

run;

*same spine - merging dataset; 
data merged;
		merge spine (in=a rename=(hraEncWID=ID)) 
		diabetes (rename=hdghraencwid=ID);
		if hdgcd ne '';
		by ID;
		if a;
run;

*Final Frequency table;
proc freq data=merged; 
table DM; 
run; 


*diabetes	Frequency	Percent		Cumulative		Cumulative
									Frequency		Percent	
	0		1898		95.81		1898			95.81
	1		83			4.19		1981			100.00


83 (4.19%) admissions of diabetes were recorded between 2003-2004;


