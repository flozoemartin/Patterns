
********************************************************************************

* Defining the patterns of prescribing and cleaning ready for analysis

* Author: Flo Martin 

* Date: 09/08/2022

********************************************************************************

* Datasets created by this do-file 

*	- $Tempdatadir\patterns_in_pregnancy_clean.dta

********************************************************************************

* Start logging

  log using "$Logdir\1_cleaning\1_generating patterns", name(generating_patterns) replace

********************************************************************************

* Load in patterns datatset

	use "$Datadir\patterns_in_pregnancy.dta", clear // from the population derivation scripts
	
	* Generate variables that show us how many prescriptions are made in each period: prenatal, antenatal and postnatal - using codebook to identify in how many patients
	
	recode any_o .=0
	
	* Pre-pregnancy exposure
	
	gen any_prepreg = 1 if any_l==1 | any_m==1 | any_n==1 | any_o==1
	replace any_prepreg = 0 if any_l==. & any_m==. & any_n==. & any_o==.
	tab any_prepreg // 173,125 pregnancies exposed pre-pregnancy...
	codebook patid if any_prepreg==1 // ...in 131,300 patients
	
	* All exposed during pregnancy
	
	gen any_preg = 1 if any_a==1 | any_b==1 | any_c==1
	replace any_preg = 0 if any_a==. & any_b==. & any_c==.
	tab any_preg // 92,058 pregnancies exposed during pregnancy
	
	* Post pregnancy exposure
	
	gen any_postpreg = 1 if any_w==1 | any_x==1 | any_y==1 | any_z==1
	replace any_postpreg = 0 if any_w==. & any_x==. & any_y==. & any_z==.
	tab any_postpreg // 191,196 pregnancies exposed post-pregnancy
	codebook patid if any_postpreg==1 // among 142,770 patients
	
* Looking at Figure 1 - define first the "antenatal exposure" women
	
	* Those who had a prescription in the early pre-pregnancy period and the late pre-pregnancy period
	
	gen continuer =.
	replace continuer = 1 if (any_l==1 | any_m==1 | any_n==1) & any_o==1 & (any_a==1 | any_b==1 | any_c==1)
	tab continuer
	
	* Those who initiated antidepressants in the late pre-pregnany period
	
	gen early_initiator =.
	replace early_initiator = 1 if any_l!=1 & any_m!=1 & any_n!=1 & any_o==1 & (any_a==1 | any_b==1 | any_c==1)
	tab early_initiator
	
	* Those who initiated antidepressants in trimester 1
	
	gen t1_initiator =.
	replace t1_initiator = 1 if any_l!=1 & any_m!=1 & any_n!=1 & any_o!=1 & any_a==1
	tab t1_initiator
	
	* Those who initiated antidepressants in trimester 2
	
	gen t2_initiator =.
	replace t2_initiator = 1 if any_l!=1 & any_m!=1 & any_n!=1 & any_o!=1 & any_a!=1 & any_b==1
	tab t2_initiator
	
	* Those who initiated antidepressants in trimester 3
	
	gen t3_initiator =.
	replace t3_initiator = 1 if any_l!=1 & any_m!=1 & any_n!=1 & any_o!=1 & any_a!=1 & any_b!=1 & any_c==1
	tab t3_initiator
	
	* Those who initiated antidepressants in the antenatal period (trimester 1 - 3)
	
	gen initiator =.
	replace initiator = 1 if t1_initiator==1 | t2_initiator==1 | t3_initiator==1
	tab initiator
	
	* Those who discontinued antidepressants in the early pre-pregnancy period but resumed during pregnancy
	
	gen reinitiator =.
	replace reinitiator = 1 if (any_l==1 | any_m==1 | any_n==1) & any_o!=1 & (any_a==1 | any_b==1 | any_c==1)
	tab reinitiator
	
		* Define a variable for continuers (use in the 3 months before pregnancy and during pregnancy) and initiators (no use in the 3 months pre-pregnancy)
		
		gen prepreg_user =.
		replace prepreg_user = 1 if continuer==1 | early_initiator==1
		replace prepreg_user = 0 if initiator==1 | reinitiator==1
		tab prepreg_user
		
		label define prepreg_user_lb 0"Initiator" 1"Continuer"
		label values prepreg_user prepreg_user_lb
		tab prepreg_user
	
* Now define the "no antenatal exposure" women

	* Those who discontinued their antidepressants in the early pre-pregnancy period

	gen early_prepreg_discont =.
	replace early_prepreg_discont = 1 if (any_l==1 | any_m==1 | any_n==1) & any_o!=1 & any_a!=1 & any_b!=1 & any_c!=1
	tab early_prepreg_discont
	
	* Those who discontinued their antidepressants in the late pre-pregnancy period
	
	gen late_prepreg_discont =.
	replace late_prepreg_discont = 1 if any_o==1 & any_a!=1 & any_b!=1 & any_c!=1
	tab late_prepreg_discont
	
		* Define a variable for any pre-pregnancy discontinuation
		
		gen prepreg_discont =.
		replace prepreg_discont = 1 if early_prepreg_discont==1 | late_prepreg_discont==1
		tab prepreg_discont
	
	* Those who don't have any prescriptions for antidepressants in the pre-pre-pregnancy or pregnancy period
	
	gen no_use =.
	replace no_use = 1 if any_l!=1 & any_m!=1 & any_n!=1 & any_o!=1 & any_a!=1 & any_b!=1 & any_c!=1
	tab no_use
	
* Generate variables for defining prenatal and antenatal patterns
	
	gen prenatal_x =.
	replace prenatal_x = 1 if continuer==1
	replace prenatal_x = 2 if early_initiator==1
	replace prenatal_x = 3 if initiator==1
	replace prenatal_x = 4 if reinitiator==1
	replace prenatal_x = 5 if early_prepreg_discont==1
	replace prenatal_x = 6 if late_prepreg_discont==1
	replace prenatal_x = 7 if no_use==1
	
	label define prenatal_lb 1"Continuer" 2"Early initiator" 3"Initiator" 4"Re-initiator" 5"Early pre-pregnancy discontinuer" 6"Late pre-pregnancy discontinuer" 7"No use"
	label values prenatal_x prenatal_lb
	
	gen antenatal_x =.
	replace antenatal_x = 1 if continuer==1
	replace antenatal_x = 2 if early_initiator==1
	replace antenatal_x = 3 if initiator==1
	replace antenatal_x = 4 if reinitiator==1

	label define antenatal_lb 1"Continuer" 2"Early initiator" 3"Initiator" 4"Re-initiator"
	label values antenatal_x antenatal_lb
	
* Now define the postnatal exposure
	
	gen postnatal_use = 1 if any_w==1| any_x==1 | any_y==1 | any_z==1
	replace postnatal_use = 0 if any_w==. & any_x==. & any_y==. & any_z==.
	
	save "$Tempdatadir\patterns_in_pregnancy_dup_dataset.dta", replace
	
********************************************************************************

* Sort the duplicate doses out
	
	do "$Dodir\1_cleaning\1a_dealing with duplicate doses.do"
	
********************************************************************************

	use "$Tempdatadir\patterns_in_pregnancy_duprm_dataset.dta", clear

	* Given the complexity and individuality of these patterns between women, need to describe each trimester individually - maybe start by looking at simpler regimens (single drug regimens)

	gen n_t1 =.
	replace n_t1 = 1 if drugsubstance1a!=.
	replace n_t1 = 2 if ((drugsubstance1a!=drugsubstance2a) & drugsubstance1a!=. & drugsubstance2a!=. & (presc_startdate_num1a==presc_startdate_num2a)) & n_t1==1
	replace n_t1 = 3 if ((drugsubstance2a!=drugsubstance3a) & drugsubstance2a!=. & drugsubstance3a!=. & (presc_startdate_num2a==presc_startdate_num3a) & (presc_startdate_num1a==presc_startdate_num3a)) & n_t1==2
	replace n_t1 = 4 if ((drugsubstance3a!=drugsubstance4a) & drugsubstance3a!=. & drugsubstance4a!=. & (presc_startdate_num3a==presc_startdate_num4a) & (presc_startdate_num1a==presc_startdate_num4a)) & n_t1==3
	replace n_t1 = 5 if ((drugsubstance4a!=drugsubstance5a) & drugsubstance4a!=. & drugsubstance5a!=. & (presc_startdate_num4a==presc_startdate_num5a) & (presc_startdate_num1a==presc_startdate_num5a)) & n_t1==4
	replace n_t1 = 6 if ((drugsubstance5a!=drugsubstance6a) & drugsubstance5a!=. & drugsubstance6a!=. & (presc_startdate_num5a==presc_startdate_num6a) & (presc_startdate_num1a==presc_startdate_num6a)) & n_t1==5
	replace n_t1 = 7 if ((drugsubstance6a!=drugsubstance7a) & drugsubstance6a!=. & drugsubstance7a!=. & (presc_startdate_num6a==presc_startdate_num7a) & (presc_startdate_num1a==presc_startdate_num7a)) & n_t1==6
	
	replace n_t1 = 0 if n_t1==. & any_preg==1
	
	tab n_t1
	tab any_a
	
	gen n_t2 =.
	replace n_t2 = 1 if drugsubstance1b!=.
	replace n_t2 = 2 if ((drugsubstance1b!=drugsubstance2b) & drugsubstance1b!=. & drugsubstance2b!=. & (presc_startdate_num1b==presc_startdate_num2b)) & n_t2==1
	replace n_t2 = 3 if ((drugsubstance2b!=drugsubstance3b) & drugsubstance2b!=. & drugsubstance3b!=. & (presc_startdate_num2b==presc_startdate_num3b) & (presc_startdate_num1b==presc_startdate_num3b)) & n_t2==2
	replace n_t2 = 4 if ((drugsubstance3b!=drugsubstance4b) & drugsubstance3b!=. & drugsubstance4b!=. & (presc_startdate_num3b==presc_startdate_num4b) & (presc_startdate_num1b==presc_startdate_num4b)) & n_t2==3
	replace n_t2 = 5 if ((drugsubstance4b!=drugsubstance5b) & drugsubstance4b!=. & drugsubstance5b!=. & (presc_startdate_num4b==presc_startdate_num5b) & (presc_startdate_num1b==presc_startdate_num5b)) & n_t2==4
	replace n_t2 = 6 if ((drugsubstance5b!=drugsubstance6b) & drugsubstance5b!=. & drugsubstance6b!=. & (presc_startdate_num5b==presc_startdate_num6b) & (presc_startdate_num1b==presc_startdate_num6b)) & n_t2==5
	replace n_t2 = 7 if ((drugsubstance6b!=drugsubstance7b) & drugsubstance6b!=. & drugsubstance7b!=. & (presc_startdate_num6b==presc_startdate_num7b) & (presc_startdate_num1b==presc_startdate_num7b)) & n_t2==6
	
	replace n_t2 = 0 if n_t2==. & any_preg==1
	
	tab n_t2
	tab any_b
	
	gen n_t3 =.
	replace n_t3 = 1 if drugsubstance1c!=.
	replace n_t3 = 2 if ((drugsubstance1c!=drugsubstance2c) & drugsubstance1c!=. & drugsubstance2c!=. & (presc_startdate_num1c==presc_startdate_num2c)) & n_t3==1
	replace n_t3 = 3 if ((drugsubstance2c!=drugsubstance3c) & drugsubstance2c!=. & drugsubstance3c!=. & (presc_startdate_num2c==presc_startdate_num3c) & (presc_startdate_num1c==presc_startdate_num3c)) & n_t3==2
	replace n_t3 = 4 if ((drugsubstance3c!=drugsubstance4c) & drugsubstance3c!=. & drugsubstance4c!=. & (presc_startdate_num3c==presc_startdate_num4c) & (presc_startdate_num1c==presc_startdate_num4c)) & n_t3==3
	replace n_t3 = 5 if ((drugsubstance4c!=drugsubstance5c) & drugsubstance4c!=. & drugsubstance5c!=. & (presc_startdate_num4c==presc_startdate_num5c) & (presc_startdate_num1c==presc_startdate_num5c)) & n_t3==4
	replace n_t3 = 6 if ((drugsubstance5c!=drugsubstance6c) & drugsubstance5c!=. & drugsubstance6c!=. & (presc_startdate_num5c==presc_startdate_num6c) & (presc_startdate_num1c==presc_startdate_num6c)) & n_t3==5
	replace n_t3 = 7 if ((drugsubstance6c!=drugsubstance7c) & drugsubstance6c!=. & drugsubstance7c!=. & (presc_startdate_num6c==presc_startdate_num7c) & (presc_startdate_num1c==presc_startdate_num7c)) & n_t3==6
	
	replace n_t3 = 0 if n_t3==. & any_preg==1

	tab n_t3
	tab any_c
	
	gen single_drug =.
	replace single_drug = 1 if (n_t1<=1 & n_t2<=1 & n_t3<=1) 
	
	gen multi_drug =.
	replace multi_drug = 1 if (n_t1>1 | n_t2>1 | n_t3>1) & (n_t1!=. & n_t2!=. & n_t3!=.)
		
	tab single_drug
	tab multi_drug
	
	* Sensitivity analysis - picking up more potential multi-drug regimens by picking those whose "previous prescription" end date overlaps with the start of the new prescription by more than 5 days - TO CHECK WITH DHEERAJ
	
	gen multi_sens = 1 if ((drugsubstance1a!=drugsubstance2a) & drugsubstance1a!=. & drugsubstance2a!=. & (presc_enddate_num1a-5>presc_startdate_num2a))
	replace multi_sens = 1 if ((drugsubstance2a!=drugsubstance3a) & drugsubstance2a!=. & drugsubstance3a!=. & (presc_enddate_num2a-5>presc_startdate_num3a))
	replace multi_sens = 1 if ((drugsubstance3a!=drugsubstance4a) & drugsubstance3a!=. & drugsubstance4a!=. & (presc_enddate_num3a-5>presc_startdate_num4a))
	replace multi_sens = 1  if ((drugsubstance4a!=drugsubstance5a) & drugsubstance4a!=. & drugsubstance5a!=. & (presc_enddate_num4a-5>presc_startdate_num5a))
	replace multi_sens = 1  if ((drugsubstance5a!=drugsubstance6a) & drugsubstance5a!=. & drugsubstance6a!=. & (presc_enddate_num5a-5>presc_startdate_num6a))
	replace multi_sens = 1 if ((drugsubstance6a!=drugsubstance7a) & drugsubstance6a!=. & drugsubstance7a!=. & (presc_enddate_num6a-5>presc_startdate_num7a)) 
	
	replace multi_sens = 1 if ((drugsubstance1b!=drugsubstance2b) & drugsubstance1b!=. & drugsubstance2b!=. & (presc_enddate_num1b-5>presc_startdate_num2b))
	replace multi_sens = 1 if ((drugsubstance2b!=drugsubstance3b) & drugsubstance2b!=. & drugsubstance3b!=. & (presc_enddate_num2b-5>presc_startdate_num3b))
	replace multi_sens = 1 if ((drugsubstance3b!=drugsubstance4b) & drugsubstance3b!=. & drugsubstance4b!=. & (presc_enddate_num3b-5>presc_startdate_num4b))
	replace multi_sens = 1  if ((drugsubstance4b!=drugsubstance5b) & drugsubstance4b!=. & drugsubstance5b!=. & (presc_enddate_num4b-5>presc_startdate_num5b))
	replace multi_sens = 1  if ((drugsubstance5b!=drugsubstance6b) & drugsubstance5b!=. & drugsubstance6b!=. & (presc_enddate_num5b-5>presc_startdate_num6b))
	replace multi_sens = 1 if ((drugsubstance6b!=drugsubstance7b) & drugsubstance6b!=. & drugsubstance7b!=. & (presc_enddate_num6b-5>presc_startdate_num7b))
	
	replace multi_sens = 1 if ((drugsubstance1c!=drugsubstance2c) & drugsubstance1c!=. & drugsubstance2c!=. & (presc_enddate_num1c-5>presc_startdate_num2c))
	replace multi_sens = 1 if ((drugsubstance2c!=drugsubstance3c) & drugsubstance2c!=. & drugsubstance3c!=. & (presc_enddate_num2c-5>presc_startdate_num3c))
	replace multi_sens = 1 if ((drugsubstance3c!=drugsubstance4c) & drugsubstance3c!=. & drugsubstance4c!=. & (presc_enddate_num3c-5>presc_startdate_num4c))
	replace multi_sens = 1  if ((drugsubstance4c!=drugsubstance5c) & drugsubstance4c!=. & drugsubstance5c!=. & (presc_enddate_num4c-5>presc_startdate_num5c))
	replace multi_sens = 1  if ((drugsubstance5c!=drugsubstance6c) & drugsubstance5c!=. & drugsubstance6c!=. & (presc_enddate_num5c-5>presc_startdate_num6c))
	replace multi_sens = 1 if ((drugsubstance6c!=drugsubstance7c) & drugsubstance6c!=. & drugsubstance7c!=. & (presc_enddate_num6c-5>presc_startdate_num7c))
	
	replace multi_sens=1 if multi_drug==1 // all the originals picked up by new way
	
	tab multi_drug // 1,220 - this should be the sensitivity
	tab multi_sens // 3,993 - this should be the main
	
	tab single_drug multi_sens
	recode single_drug 1=. if multi_sens==1
	
	rename multi_drug multi_same_day_sens
	rename multi_sens multi_drug
		
* Moving onto the patterns of prescribing within pregnancy - try by column of the table to lessen numbers in each box which will be easier for checking?
	
	* Discontinuers in T1
	
	gen discontinue =.
	replace discontinue = 1 if drugsubstance1a!=. & drugsubstance1b==. & drugsubstance1c==.
	tab discontinue
	
	* Discontinuers in T2
	
	gen discontinue_t2 =.
	replace discontinue_t2 = 1 if drugsubstance1a!=. & drugsubstance1b!=. & drugsubstance1c==.
	replace discontinue_t2 = 1 if drugsubstance1a==. & drugsubstance1b!=. & drugsubstance1c==.
	tab discontinue_t2
	
	* Discontinuers in T3
	
	gen discontinue_t3 =.
	replace discontinue_t3 = 1 if drugsubstance1c!=. & any_w!=1
	
	tab discontinue_t3
	
	* Antidepressant switching in single drug regimen
	
	gen switching =.
	replace switching = 1 if (drugsubstance1a!=drugsubstance1b) & drugsubstance1a!=. & drugsubstance1b!=. & single_drug==1
	replace switching = 1 if (drugsubstance1b!=drugsubstance1c) & drugsubstance1b!=. & drugsubstance1c!=. & single_drug==1
	replace switching = 1 if (drugsubstance1a!=drugsubstance1c) & drugsubstance1a!=. & drugsubstance1c!=. & single_drug==1
	
	replace switching = 1 if (drugsubstance1a!=drugsubstance2a) & drugsubstance1a!=. & drugsubstance2a!=. & single_drug==1
	replace switching = 1 if (drugsubstance1b!=drugsubstance2b) & drugsubstance1b!=. & drugsubstance2b!=. & single_drug==1
	replace switching = 1 if (drugsubstance1c!=drugsubstance2c) & drugsubstance1c!=. & drugsubstance2c!=. & single_drug==1
	
	gen switching_t1 =.
	replace switching_t1 = 1 if (drugsubstance2a!=drugsubstance3a) & drugsubstance2a!=. & drugsubstance3a!=. & single_drug==1
	replace switching_t1 = 1 if (drugsubstance3a!=drugsubstance4a) & drugsubstance3a!=. & drugsubstance4a!=. & single_drug==1
	replace switching_t1 = 1 if (drugsubstance4a!=drugsubstance5a) & drugsubstance4a!=. & drugsubstance5a!=. & single_drug==1
	replace switching_t1 = 1 if (drugsubstance5a!=drugsubstance6a) & drugsubstance5a!=. & drugsubstance6a!=. & single_drug==1
	replace switching_t1 = 1 if (drugsubstance6a!=drugsubstance7a) & drugsubstance6a!=. & drugsubstance7a!=. & single_drug==1
	
	gen switching_t2 =.
	replace switching_t2 = 1 if (drugsubstance2b!=drugsubstance3b) & drugsubstance2b!=. & drugsubstance3b!=. & single_drug==1
	replace switching_t2 = 1 if (drugsubstance3b!=drugsubstance4b) & drugsubstance3b!=. & drugsubstance4b!=. & single_drug==1
	replace switching_t2 = 1 if (drugsubstance4b!=drugsubstance5b) & drugsubstance4b!=. & drugsubstance5b!=. & single_drug==1
	replace switching_t2 = 1 if (drugsubstance5b!=drugsubstance6b) & drugsubstance5b!=. & drugsubstance6b!=. & single_drug==1
	replace switching_t2 = 1 if (drugsubstance6b!=drugsubstance7b) & drugsubstance6b!=. & drugsubstance7b!=. & single_drug==1
	
	gen switching_t3 =.
	replace switching_t3 = 1 if (drugsubstance2c!=drugsubstance3c) & drugsubstance2c!=. & drugsubstance3c!=. & single_drug==1
	replace switching_t3 = 1 if (drugsubstance3c!=drugsubstance4c) & drugsubstance3c!=. & drugsubstance4c!=. & single_drug==1
	replace switching_t3 = 1 if (drugsubstance4c!=drugsubstance5c) & drugsubstance4c!=. & drugsubstance5c!=. & single_drug==1
	replace switching_t3 = 1 if (drugsubstance5c!=drugsubstance6c) & drugsubstance5c!=. & drugsubstance6c!=. & single_drug==1
	replace switching_t3 = 1 if (drugsubstance6c!=drugsubstance7c) & drugsubstance6c!=. & drugsubstance7c!=. & single_drug==1

	replace switching = 1 if switching_t1==1 | switching_t2==1 | switching_t3==1
	
	tab switching
	
	* No change continuer
	
	gen no_change_cont =.
	replace no_change_cont = 1 if ((drugsubstance1a==drugsubstance1b) & (drugsubstance1b==drugsubstance1c)) & drugsubstance1a!=. & drugsubstance1b!=. & drugsubstance1c!=. & ((dd_mg1a==dd_mg1b) & (dd_mg1b==dd_mg1c)) & dd_mg1a!=. & dd_mg1b!=. & dd_mg1c!=. & drugsubstance2a==. & drugsubstance2b==. & drugsubstance2c==. & single_drug==1
	replace no_change_cont = 1 if ((drugsubstance1a==drugsubstance1b) & drugsubstance1a!=. & drugsubstance1b!=. & drugsubstance1c==.) & ((dd_mg1a==dd_mg1b) & dd_mg1a!=. & dd_mg1b!=. & dd_mg1c==.) &drugsubstance2a==. & drugsubstance2b==. & drugsubstance2c==. & single_drug==1
	replace no_change_cont = 1 if drugsubstance1a==. & ((drugsubstance1b==drugsubstance1c) & drugsubstance1b!=. & drugsubstance1c!=.) & (dd_mg1a==. & (dd_mg1b==dd_mg1c) & dd_mg1b!=. & dd_mg1c!=.) &drugsubstance2a==. & drugsubstance2b==. & drugsubstance2c==. & single_drug==1
	replace no_change_cont = 1 if ((drugsubstance1a==drugsubstance1c) & drugsubstance1b==. & drugsubstance1a!=. & drugsubstance1c!=.) & ((dd_mg1a==dd_mg1c) & dd_mg1b==. & dd_mg1a!=. & dd_mg1c!=.) &drugsubstance2a==. & drugsubstance2b==. & drugsubstance2c==. & single_drug==1
	
	replace no_change_cont = 1 if drugsubstance1a==. & drugsubstance1b==. & drugsubstance1c!=. & drugsubstance2c==. & single_drug==1
	
	replace no_change_cont = 1 if (drugsubstance1b==drugsubstance1c) & drugsubstance1b!=. & drugsubstance1c!=. & (dd_mg1b==. | dd_mg1c==.) & (drugsubstance2b==drugsubstance2c) & single_drug==1
	
	tab no_change_cont
	
	gen no_change_cont_cont = 1 if no_change_cont==1 & discontinue==. & discontinue_t2==. & discontinue_t3==.
	drop no_change_cont
	rename no_change_cont_cont no_change_cont
	
	tab no_change_cont
	
	* Dose reduction/increase/fluctuation
	
	* Dose reduction
	gen dose_reduc =.
	
	replace dose_reduc = 1 if (dd_mg1a > dd_mg1b) & dd_mg1a!=. & dd_mg1b!=. & (drugsubstance1a==drugsubstance1b) & drugsubstance1a!=. & drugsubstance1b!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg1b > dd_mg1c) & dd_mg1b!=. & dd_mg1c!=. & (drugsubstance1b==drugsubstance1c) & drugsubstance1b!=. & drugsubstance1c!=. & single_drug==1
	replace dose_reduc = 1 if ((dd_mg1a > dd_mg1c) & dd_mg1a!=. & dd_mg1c!=.) & ((drugsubstance1a==drugsubstance1c) & drugsubstance1a!=. & drugsubstance1c!=.) & drugsubstance1b==. & single_drug==1
	
	replace dose_reduc = 1 if (dd_mg1a > dd_mg2a) & dd_mg1a!=. & dd_mg2a!=. & (drugsubstance1a==drugsubstance2a) & drugsubstance1a!=. & drugsubstance2a!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg2a > dd_mg3a) & dd_mg2a!=. & dd_mg3a!=. & (drugsubstance2a==drugsubstance3a) & drugsubstance2a!=. & drugsubstance3a!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg3a > dd_mg4a) & dd_mg3a!=. & dd_mg4a!=. & (drugsubstance3a==drugsubstance4a) & drugsubstance3a!=. & drugsubstance4a!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg4a > dd_mg5a) & dd_mg4a!=. & dd_mg5a!=. & (drugsubstance4a==drugsubstance5a) & drugsubstance4a!=. & drugsubstance5a!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg5a > dd_mg6a) & dd_mg5a!=. & dd_mg6a!=. & (drugsubstance5a==drugsubstance6a) & drugsubstance5a!=. & drugsubstance6a!=. & single_drug==1

	replace dose_reduc = 1 if (dd_mg1b > dd_mg2b) & dd_mg1b!=. & dd_mg2b!=. & (drugsubstance1b==drugsubstance2b) & drugsubstance1b!=. & drugsubstance2b!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg2b > dd_mg3b) & dd_mg2b!=. & dd_mg3b!=. & (drugsubstance2b==drugsubstance3b) & drugsubstance2b!=. & drugsubstance3b!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg3b > dd_mg4b) & dd_mg3b!=. & dd_mg4b!=. & (drugsubstance3b==drugsubstance4b) & drugsubstance3b!=. & drugsubstance4b!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg4b > dd_mg5b) & dd_mg4b!=. & dd_mg5b!=. & (drugsubstance4b==drugsubstance5b) & drugsubstance4b!=. & drugsubstance5b!=. & single_drug==1
	
	replace dose_reduc = 1 if (dd_mg1c > dd_mg2c) & dd_mg1c!=. & dd_mg2c!=. & (drugsubstance1c==drugsubstance2c) & drugsubstance1c!=. & drugsubstance2c!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg2c > dd_mg3c) & dd_mg2c!=. & dd_mg3c!=. & (drugsubstance2c==drugsubstance3c) & drugsubstance2c!=. & drugsubstance3c!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg3c > dd_mg4c) & dd_mg3c!=. & dd_mg4c!=. & (drugsubstance3c==drugsubstance4c) & drugsubstance3c!=. & drugsubstance4c!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg4c > dd_mg5c) & dd_mg4c!=. & dd_mg5c!=. & (drugsubstance4c==drugsubstance5c) & drugsubstance4c!=. & drugsubstance5c!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg5c > dd_mg6c) & dd_mg5c!=. & dd_mg6c!=. & (drugsubstance5c==drugsubstance6c) & drugsubstance5c!=. & drugsubstance6c!=. & single_drug==1
	replace dose_reduc = 1 if (dd_mg6c > dd_mg7c) & dd_mg6c!=. & dd_mg7c!=. & (drugsubstance6c==drugsubstance7c) & drugsubstance6c!=. & drugsubstance7c!=. & single_drug==1
	
	tab dose_reduc
	
	* Dose increase
	gen dose_increase =.
	
	replace dose_increase = 1 if ((dd_mg1a <  dd_mg1b) & dd_mg1a!=. & dd_mg1b!=.) & ((drugsubstance1a==drugsubstance1b) & drugsubstance1a!=. & drugsubstance1b!=.) & single_drug==1
	replace dose_increase = 1 if ((dd_mg1b < dd_mg1c) & dd_mg1b!=. & dd_mg1c!=.) & ((drugsubstance1b==drugsubstance1c) & drugsubstance1b!=. & drugsubstance1c!=.) & single_drug==1
	
	replace dose_increase = 1 if ((dd_mg1a <  dd_mg1c) & dd_mg1a!=. & dd_mg1c!=.) & ((drugsubstance1a==drugsubstance1c) & drugsubstance1a!=. & drugsubstance1c!=.) & drugsubstance1b==. & single_drug==1
	
	replace dose_increase = 1 if (dd_mg1a < dd_mg2a) & dd_mg1a!=. & dd_mg2a!=. & (drugsubstance1a==drugsubstance2a) & drugsubstance1a!=. & drugsubstance2a!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg2a < dd_mg3a) & dd_mg2a!=. & dd_mg3a!=. & (drugsubstance2a==drugsubstance3a) & drugsubstance2a!=. & drugsubstance3a!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg3a < dd_mg4a) & dd_mg3a!=. & dd_mg4a!=. & (drugsubstance3a==drugsubstance4a) & drugsubstance3a!=. & drugsubstance4a!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg4a < dd_mg5a) & dd_mg4a!=. & dd_mg5a!=. & (drugsubstance4a==drugsubstance5a) & drugsubstance4a!=. & drugsubstance5a!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg5a < dd_mg6a) & dd_mg5a!=. & dd_mg6a!=. & (drugsubstance5a==drugsubstance6a) & drugsubstance5a!=. & drugsubstance6a!=. & single_drug==1

	replace dose_increase = 1 if (dd_mg1b < dd_mg2b) & dd_mg1b!=. & dd_mg2b!=. & (drugsubstance1b==drugsubstance2b) & drugsubstance1b!=. & drugsubstance2b!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg2b < dd_mg3b) & dd_mg2b!=. & dd_mg3b!=. & (drugsubstance2b==drugsubstance3b) & drugsubstance2b!=. & drugsubstance3b!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg3b < dd_mg4b) & dd_mg3b!=. & dd_mg4b!=. & (drugsubstance3b==drugsubstance4b) & drugsubstance3b!=. & drugsubstance4b!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg4b < dd_mg5b) & dd_mg4b!=. & dd_mg5b!=. & (drugsubstance4b==drugsubstance5b) & drugsubstance4b!=. & drugsubstance5b!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg5b < dd_mg6b) & dd_mg5b!=. & dd_mg6b!=. & (drugsubstance5b==drugsubstance6b) & drugsubstance5b!=. & drugsubstance6b!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg6b < dd_mg7b) & dd_mg6b!=. & dd_mg7b!=. & (drugsubstance6b==drugsubstance7b) & drugsubstance6b!=. & drugsubstance7b!=. & single_drug==1
	
	replace dose_increase = 1 if (dd_mg1c < dd_mg2c) & dd_mg1c!=. & dd_mg2c!=. & (drugsubstance1c==drugsubstance2c) & drugsubstance1c!=. & drugsubstance2c!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg2c < dd_mg3c) & dd_mg2c!=. & dd_mg3c!=. & (drugsubstance2c==drugsubstance3c) & drugsubstance2c!=. & drugsubstance3c!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg3c < dd_mg4c) & dd_mg3c!=. & dd_mg4c!=. & (drugsubstance3c==drugsubstance4c) & drugsubstance3c!=. & drugsubstance4c!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg4c < dd_mg5c) & dd_mg4c!=. & dd_mg5c!=. & (drugsubstance4c==drugsubstance5c) & drugsubstance4c!=. & drugsubstance5c!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg5c < dd_mg6c) & dd_mg5c!=. & dd_mg6c!=. & (drugsubstance5c==drugsubstance6c) & drugsubstance5c!=. & drugsubstance6c!=. & single_drug==1
	replace dose_increase = 1 if (dd_mg6c < dd_mg7c) & dd_mg6c!=. & dd_mg7c!=. & (drugsubstance6c==drugsubstance7c) & drugsubstance6c!=. & drugsubstance7c!=. & single_drug==1
	
	tab dose_increase
	
	* Dose fluctuation
	
	gen dose_fluc =.
	replace dose_fluc = 1 if dose_reduc==1 & dose_increase==1
	tab dose_fluc
	
	replace dose_reduc =. if dose_fluc==1
	replace dose_increase =. if dose_fluc==1
	
	gen dose_changes =.
	replace dose_changes = 1 if dose_reduc==1
	replace dose_changes = 2 if dose_increase==1
	replace dose_changes = 3 if dose_fluc==1
	
	tab dose_changes
	
	gen only_dose_changes = 1 if switching==. & discontinue==. & discontinue_t2==. & discontinue_t3==. & dose_changes==1
	replace only_dose_changes = 2 if switching==. & discontinue==. & discontinue_t2==. & discontinue_t3==. & dose_changes==2
	replace only_dose_changes = 3 if switching==. & discontinue==. & discontinue_t2==. & discontinue_t3==. & dose_changes==3
	
	tab only_dose_changes
	
	* Dose switching in continuers
	
	gen only_switching = 1 if switching==1 & discontinue==. & discontinue_t2==. & discontinue_t3==. & dose_changes==.
	
	* Dose changes and switching
	
	gen multi_change = 1 if switching!=. & dose_changes!=. & discontinue==. & discontinue_t2==. & discontinue_t3==.
	
	tab multi_change
	
	* Any discontinuation
	
	gen any_discont = 1 if discontinue==1 | discontinue_t2==1 | discontinue_t3==1
	replace any_discont = 0 if any_preg==1 & discontinue==. & discontinue_t2==. & discontinue_t3==.
	
	tab any_discont
	
* Get rid of unnecessary variables

	drop dd_mg_comb* 
	
* Save 

	save "$Tempdatadir\patterns_in_pregnancy_formultiscript.dta", replace

	keep if multi_drug==.
	save "$Tempdatadir\patterns_in_pregnancy_single.dta", replace
	
********************************************************************************

* Run the multi_drug regimen do-file

	do "$Dodir\1_cleaning\1b_multi drug regimens.do"
	
********************************************************************************

* Append the datasets together

	use "$Tempdatadir\patterns_in_pregnancy_single.dta", clear
	append using "$Tempdatadir\patterns_in_pregnancy_multi.dta"
	count
	sort patid pregid
	
	merge 1:1 patid pregid using "$Datadir\patterns_in_pregnancy.dta"
	count
	sort patid pregid
	drop _m
	
	gen any_discont_single = any_discont if single_drug==1
	gen any_discont_multi = any_discont if multi_drug==1
	
* Save the data for merging with codelists as temporary dataset
	
	save "$Datadir\patterns_in_pregnancy_clean.dta", replace
	
********************************************************************************
	
* Delete unnecessary datasets

	erase "$Tempdatadir\patterns_in_pregnancy_dup_dataset.dta"
	erase "$Tempdatadir\patterns_in_pregnancy_duprm_dataset.dta"
	erase "$Tempdatadir\patterns_in_pregnancy_formultiscript.dta"
	erase "$Tempdatadir\patterns_in_pregnancy_single.dta"
	erase "$Tempdatadir\patterns_in_pregnancy_multi.dta"
	
* Stop logging

	log close generating_patterns
	
	translate "$Logdir\1_cleaning\1_generating patterns.smcl" "$Logdir\1_cleaning\1_generating patterns.pdf", replace
	
	erase "$Logdir\1_cleaning\1_generating patterns.smcl"
	
********************************************************************************
