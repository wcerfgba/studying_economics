* read;  
options linesize = 120 nocenter;

libname cps '/var/tmp/';


data cps.extract2012;

infile "/var/tmp/march2012.raw" lrecl=1016;

/* length statement */ 

length  
numfam state  
famkind famtype povstat povll numperf
age race sex  higrad ethnic
hrswkly hourslw marstat  classly
ftptr esr weeksu mover ernsrc
alloc_e alloc_v 3;



* start of loop;

retain hhnum;



input type 7-8 @;

nexthh3:;
                                                                                
 if type ne 0 then do;
  if 41<=type<=79 then go to nextper3;
  else if 1<=type<=39 then go to nextfam3;
  else do;
   put 'attempt to read hh rec failed at _n_ =' _n_ ' type=' type;
   abort;
  end;
 end;
                                                                                
 else do;
    *read household record;
                                                                                
  input
      hhseq 2-6
      numperhh 21-22
      numfam 23-24 
      hhtype 25   /*0=nonint 1=HWprimary 2=HW AF  3=Mprim 4=Fprim */
      livqrt 31-32   /*01=house/apt, 5-6=mobile home */
      htenure 35  /*1=own  2=rent 3=no cash rent */
      state 40-41
      cbsa 44-48
      county 49-51
      cbsa_size 55  /* 0=nonmet 2-7 = city size */
      numperlt15 60-61  /*number persons under 15 */
      foodstamps 76    /*=1 if anyone got FS*/
      numkidsfs  77   /*number of kids covered by FS*/
      nummonthsfs 79-80   /*number months FS last year 0-12*/
      valuefs    387-391 ;  /*value FS  -- moved in 2010 */

  hhnum+1;
 
  do ifam=1 to numfam;
   input type 7-8 @;

   nextfam3:;
    if type<1 or type>39 then do;
     if type=0 then go to nexthh3;
     else if (41<=type<=79) then go to nextper3;
     else do;
      put 'attempt to read fam rec at _n_=' _n_ ' type= ' type;
      abort;
     end;
    end;


                                                                                
    *Read family record;
    else input
             hh_fam_id $ 2-8  
             famkind 9   /*1=hw 2=male hd 3=fem hd*/
             famtype 10  /*1=prim 2=nonfam 3=rel subfam 4=unrelsub 5=ind */ 
             numperf 11-12 
             ownkidsu6 25
             ownkidsu18 27  /*own never married kids under 18*/
             povcut 32-36
             povstat 37  /*1=poor 2=100-124 3=125-150 4=150+ */
             povll   38-39 /* detailed ratio faminc-povline 01..14 */
             famwagesal 48-54   /*family wage-salary*/  
             faminc  205-212 
             famfs   243-246 /*imputed family value FS*/
             famlunch 247-250 /*imputed family school lunch*/
             fammcare 251-255 /*imputed value medicare*/
             fammcaid 256-260 /*imputed value medicaid*/
             famhip   272-278 /*total family health insurance payments*/
             fampocket 279-285 /*total family out of pocket*/
             famotc    286-291 ; /*total family over the counter*/

	   famnum=type;

                      
    do ip=1 to numperf;     /* loop over persons in family */
     input type 7-8 @;
       
     nextper3:;
      if type<41 then do;
       if type=0 then go to nexthh3;
       else if type <41 then do;
        ifam=ifam+1;
        go to nextfam3;
       end;
      end;
                                                                                
      else do;                  /*valid p-record, so continue input*/

              /***********positions changed in 2012 ?? ***************/
       input      relhead 15-16 /*1=ref 2=lone ref 3=H 4=W 5=child...*/
                  age 19-20
                  marstat 21 /*1,2=married, sp pres; 7=never*/
                  sex 24
                  higrad 25-26  
                  race 27-28  /*expanded race code*/
                  ethnic  32  /*1=mex ..5=oth span 0=not */
                  famrel  36 /*fam rel 1=ref 2=spouse 3-5 =kids ...*/
                  hhdfxm 41-42  /*detailed household/family status -- NEW */
                  cob  84-86 
                  momcob 87-89
                  dadcob 90-92
                  immyr  93-94
                  citizen 95

                  weight 139-146   /* basic cps weight, 2 decimal implied*/
                  psupwgt 155-162 /*weight for march cps*/
                  hourslw 163-164

                  ogrflag 183
                  uhrswk 184-185 /*ogr usual hours on main job*/
                  paidhr  186    /*ogr paid hr */
                  hrpay  187-190 /*ogr hrly pay*/
                  wkpay  191-194 /*usual earns wk*/                  

                  enroll 197   /*enrolled last week 16-24 ONLY*/
                  esr  200     /*1,2=work  3-4=u   7=nilf  */
                  weeksu  255-256  /*weeks unemployed*/
                  weeksly 258-259
                  numjobs 267   /*number employers LY 1-3, 3=3+ */
                  hrswkly 268-269
                  ftptr   277  /*1=ftfy,2=ptfy,3=ftpy,4=ptpy,5=nonwk*/

                  occ2ly  283-284  /*2 digit occ longest job*/
                  occ1ly  285-286
                  ind2ly  287-288
                  ind1ly  289-290
                  classly 291  /*1=priv 2=fed 3=st 4=loc 5-6=self 7=nopay*/

                  mover   323   /*0=nonmover 1=cbsa 2=other 3=abroad 4=ni*/
                  ernsrc  353     /*earns source 1=ws 2-self 3-farm 4=nopay*/
                  ernval  355-361  /* earns from longest job*/

                  wagesal 364-370
                  selfinc 380-386
                  farminc 395-401
                  uiamount 411-415
                  wcamount 418-422
                  ssamount 424-428
                  sdiamount 433-437
                  welfare 445-449
                  disability 500-505
                  income  580-587
                  totearn 588-595
                  mcare 629
                  mcaid 636
                  hins_priv 642     /*any private ins*/ 
                  hins_emp  644     /*current past employer or union*/
                  health  691   /*health status 1=exc 5=poor*/
                  eitc         736-739
                  tax_income   765-771
                  fedtax    772-777
                  statetax  784-789

                  alloc_v 941  /*alloc for earnings longest job*/
                  alloc_e 944 ;  /*alloc for total wagesal */  


       length imm hispanic dropout hs somecoll ba collplus white black asian 3;
       imm=(citizen in (4,5));
       hispanic=(ethnic>0);
       white=(race=1);
       black=(race=2);
       asian=(race=4);
       dropout=(higrad<=38);
       hs=(higrad=39);
       somecoll=(40<=higrad<=42);
       ba=(higrad=43);
       collplus=(higrad>=43);
       maplus=(higrad>=44); 
       phd=(higrad>=45);
       educ=0*(higrad<=31)+3*(higrad=32)+6*(higrad=33)+8*(higrad=34)
		+ 9*(higrad=35)+10*(higrad=36)+11*(higrad in (37,38))
	        + 12*(higrad=39)+13*(higrad=40)+14*(higrad in (41,42))
		+ 16*(higrad=43)+18*(higrad=44)+20*(higrad>=45);

       annhrs=hrswkly*weeksly;
       if annhrs>0 then do;
	earnwk=wagesal/weeksly; 
  	earnhr=wagesal/annhrs;
	end;
       else do; 
	earnwk=.;
	earnhr=.;
	end;

       *OGR items;
       *set to missing if not in OGR or if weekly pay/weekly hours missing;

       if ogrflag=1 and wkpay>0 and uhrswk>0 then do;
         if paidhr=1 and hrpay>0 then wage_ogr=hrpay/100;
          else wage_ogr=wkpay/uhrswk;
       end;

       else do;
        paidhr=.;
        wage_ogr=.;
        hrpay=.;
        wkpay=.;
        uhrswk=.;
        end;


     

       if age>=16 then output;


      end; /* end of p-record input */
    end;  /* end of person loop*/
  end;  /* end of family loop*/
 end;  /* end of household loop */



run;

proc freq;
tables age higrad race ethnic 
       citizen immyr  
        hhdfxm*famrel higrad*educ
        hrswkly weeksly;
       

proc means;

proc corr;
var wage_ogr wkpay wagesal totearn income tax_income educ annhrs;


proc corr;
where (wagesal>0);
var wage_ogr wkpay earnwk ernval wagesal totearn income tax_income educ annhrs;

proc corr;
where (wagesal>0 and wkpay>0);
var wage_ogr wkpay earnwk ernval wagesal totearn income tax_income educ annhrs;



