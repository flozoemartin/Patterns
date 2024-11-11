*****************************************************************************

* Prescribing during pregnancy over time restricted to live birth only

* Author: Flo Martin

* Date: 01/11/2024

*****************************************************************************

* Figure S4 - Antidepressant prescribing during pregnancy restricted to live births.

*****************************************************************************

* Start logging

  log using "$Logdir\4_supplement\figures\3_pxn over time live birth", name(pxn_over_time_live_birth) replace

*****************************************************************************

use "$Datadir\table_2_dataset.dta", clear
	
	tab updated_outcome
	keep if updated_outcome==1
	
	gen preg_year = year(pregstart_num)
	
	tab class_preg
	
	bysort preg_year class_preg: egen count_class=seq()
	bysort preg_year class_preg: egen class_count=max(count_class)
	
	bysort preg_year: egen denom_seq=seq()
	bysort preg_year: egen n=max(denom_seq)
	
	replace class_preg=0 if class_preg==.
	
	keep preg_year class_preg class_count n
	duplicates drop
	
	gen pct = (class_count/n)*100
	
	replace pct = 100-pct if class_preg==0
	
	* Confidence intervals
	
		gen p = pct/100
		
		gen se = sqrt((p*(1-p))/n) 
		
		gen lci = (p - (1.96*se))*100
		gen uci = (p + (1.96*se))*100
		
	keep preg_year class_preg pct lci uci
	
	replace class_preg=0 if class_preg==.
	
	reshape wide pct lci uci, i(preg_year) j(class_preg)
	
	gen x=2018
	gen y=0
	
	tw /// 
	(rarea lci0 uci0 preg_year, color("`.__SCHEME.color.p1'") fintensity(inten30) lcolor("`.__SCHEME.color.p1'%30")) /// 95% CI code
	(rarea lci1 uci1 preg_year, color("`.__SCHEME.color.p2'") fintensity(inten30) lcolor("`.__SCHEME.color.p2'%30")) /// 
	(rarea lci2 uci2 preg_year, color("`.__SCHEME.color.p3'") fintensity(inten30) lcolor("`.__SCHEME.color.p3'%30")) ///
	(rarea lci3 uci3 preg_year, color("`.__SCHEME.color.p4'") fintensity(inten30) lcolor("`.__SCHEME.color.p4'%30")) /// 
	(rarea lci4 uci4 preg_year, color("`.__SCHEME.color.p7'") fintensity(inten30) lcolor("`.__SCHEME.color.p7'%30")) /// 
	(rarea lci5 uci5 preg_year, color("`.__SCHEME.color.p8'") fintensity(inten30) lcolor("`.__SCHEME.color.p8'%30")) /// 
	(line pct0 preg_year, color(darkgray) lpattern(dash) lwidth(medium)) /// 
	(line pct1 preg_year, color("`.__SCHEME.color.p2'")) ///
	(line pct2 preg_year, color("`.__SCHEME.color.p3'")) ///
	(line pct3 preg_year, color("`.__SCHEME.color.p4'")) ///
	(line pct4 preg_year, color("`.__SCHEME.color.p7'")) ///
	(line pct5 preg_year, color("`.__SCHEME.color.p8'")), ///
	legend(order(7 8 "SSRI prescriptions" 9 "TCA prescriptions" 10 "SNRI prescriptions" 11 "Other antidepressant prescriptions" 12 "Multiple class prescriptions")label(7 "{bf:Any antidepressant prescriptions}" "{bf:during pregnancy}") size(tiny) col(1) position(3) symxsize(large)) ///
	xtitle("{bf:Year of pregnancy start}", size(vsmall) color(black)) xscale(range(1996 2018)) xlabel(1997(4)2017, nogrid labsize(vsmall)) /// x axis
	ytitle("{bf:Proportion of pregnancies (%)}", size(vsmall) color(black)) ylabel(, labsize(vsmall)) /// y axis ///
	title("{bf:Antidepressant prescriptions during pregnancy}" "{bf}between 1996 and 2018 in CPRD GOLD", color(black) size(small)) || ///
	scatter y x, msymbol(i) yaxis(2) xaxis(2) ylab(, axis(2) notick nolab) xlab(, axis(2) notick nolab) ytitle("", axis(2)) xtitle("", axis(2)) /// box around graph
	plotregion(margin(0 0 1 1)) /// overall
	name(prescribing_over_time_lbonly, replace)
	
	cd "$Graphdir\"
	graph export prescribing_over_time_lbonly.pdf, replace

*****************************************************************************

 * Stop logging, translate .smcl into .pdf and erase .smcl

	log close pxn_over_time_live_birth
	
	translate "$Logdir\4_supplement\figures\3_pxn over time live birth.smcl" "$Logdir\4_supplement\figures\3_pxn over time live birth.pdf", replace
	
	erase "$Logdir\4_supplement\figures\3_pxn over time live birth.smcl"

*****************************************************************************
