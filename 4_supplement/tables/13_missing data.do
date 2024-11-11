*****************************************************************************************

* Regression analyses assessing the association between missingness in covariates and discontinuing antidepressants during pregnancy

* Author: Flo Martin

* Date: 11/07/2023

*****************************************************************************************

* Table S14 - Likelihood of having missing data in ethnicity, BMI, smoking status, alcohol use status having discontinued.

*****************************************************************************************

* Start logging

	log using "$Logdir\4_supplement\13_missing data", name(missing_data) replace

*****************************************************************************************

* Set up the table elements
	tempname myhandle	
	file open `myhandle' using "$Tabledir\supp_missingness regressions.txt", write replace
	file write `myhandle' "Variable" _tab "Discontinuers with missing" _tab "Continuers with missing" _tab "Odds of discontinuing if missing" _n
	

	use "$Datadir\table_2_dataset.dta", clear
	
	keep if any_preg==1
	
	recode eth5 5=.
	recode bmi_cat 4=.
	recode smokstatus 3=.
	recode multi_drug .=0
	
	foreach x in l m n o {
		
		gen class_prepreg_`x' = 0 if class1`x'==.
		replace class_prepreg_`x' = 1 if class1`x'==1
		replace class_prepreg_`x' = 2 if class1`x'==2
		replace class_prepreg_`x' = 3 if class1`x'==3
		replace class_prepreg_`x' = 4 if inlist(class1`x', 4,5,6,7)
		
	}
	
	gen class_prepreg =.
	
	forvalues x=1/4 {
		
		replace class_prepreg = `x' if (class_prepreg_l==`x' | class_prepreg_l==0) & (class_prepreg_m==`x' | class_prepreg_m==0) & (class_prepreg_n==`x' | class_prepreg_n==0) & (class_prepreg_o==`x' | class_prepreg_o==0)
		
	}
	
	replace class_prepreg = 0 if class_prepreg_l==0 & class_prepreg_m==0 & class_prepreg_n==0 & class_prepreg_o==0
	
	tab class_prepreg, m
	drop class_prepreg_*
	
	replace class_prepreg = 5 if class_prepreg==.
	
	label define class_pre_lb 0"Unexposed" 1"SSRI" 2"SNRI" 3"TCA" 4"Other" 5"Multiple"
	label values class_prepreg class_pre_lb
	tab class_prepreg
	
	gen highest_dose_prepreg = max(dosage1l, dosage1m, dosage1n, dosage1o)
	
	foreach var in matage_cat imd_practice eth5 bmi_cat smokstatus alcstatus illicitdrug_12mo grav_hist_sa grav_hist_sb grav_hist_top grav_hist_otherloss parity_cat CPRD_consultation_events_cat depression anxiety bipolar schizo ed autism adhd id pain dn incont migraine headache antipsychotics_prepreg moodstabs_prepreg benzos_prepreg zdrugs_prepreg teratogen_prepreg multivit_prepreg folic_prepreg0 folic_prepreg1 antiemetic_prepreg  {
	
		gen `var'_m = 1 if `var'==.
		replace `var'_m = 0 if `var'!=.
		tab `var'_m, m
		
	}
	
	foreach var in eth5 bmi_cat smokstatus alcstatus {
		
		count if `var'_m==1 & discontinuer==1
		local n_discont = `r(N)'
		
		count if discontinuer==1
		local total_discont = `r(N)'
		
		local pct_discont = (`n_discont'/`total_discont')*100
		
		count if `var'_m==1 & discontinuer==0
		local n_cont = `r(N)'
		
		count if discontinuer==0
		local total_cont = `r(N)'
		
		local pct_cont = (`n_cont'/`total_cont')*100
		
		logistic `var'_m discontinuer, or vce(cluster patid)
		
		file write `myhandle' ("`var'") _tab %7.0fc (`n_discont') ("/") %7.0fc (`total_discont') (" (") %5.2fc (`pct_discont') (")") _tab %7.0fc (`n_cont') ("/") %7.0fc (`total_cont') (" (") %5.2fc (`pct_cont') (")") 
		
		logistic `var'_m i.discontinuer pregstart_year, or vce(cluster patid)
		lincom 1.discontinuer, or 
		local minadjor=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		
		file write `myhandle' _tab %4.2fc (`minadjor') (" (") %4.2fc (`minadjlci') ("-") %4.2fc (`minadjuci') (")") _n
		
	}

*****************************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close missing_data
	
	translate "$Logdir\4_supplement\13_missing data.smcl" "$Logdir\4_supplement\13_missing data.pdf", replace
	
	erase "$Logdir\4_supplement\13_missing data.smcl"

*****************************************************************************************
