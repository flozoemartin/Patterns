*******************************************************************************

* Prescribing between 1996 and 2018 in CPRD GOLD and across pregnancy from 12 months before to 12 months after

* Author: Flo Martin

* Date: 01/11/2024

*******************************************************************************

* Start logging

  log using "$Logdir\3_figures\1_over time & across preg", name(over_time_across_preg) replace

*******************************************************************************

* Set colour scheme

  net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/stata-schemepack/main/installation/") replace
	ssc install schemepack
	
	set scheme tab3, perm
	gr_setscheme
	classutil des .__SCHEME
	classutil des .__SCHEME.color
	di "`.__SCHEME.color.p1bar'" 

*******************************************************************************
	
* Prescribing over time

	use "$Datadir\table_2_dataset.dta", clear
	
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
	
	local t1=1996
	local t2=2018

	
	tw ///
	(scatteri 1 `t1' 1 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 3 `t1' 3 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 5 `t1' 5 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 7 `t1' 7 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 9 `t1' 9 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 11 `t1' 11 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 13 `t1' 13 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 15 `t1' 15 `t2', recast(line) xaxis(1) lcolor(gs14)) /// 
	(rarea lci0 uci0 preg_year, color("`.__SCHEME.color.p1'") fintensity(inten30) lcolor("`.__SCHEME.color.p1'%30")) /// 95% CI code
	(rarea lci1 uci1 preg_year, color("`.__SCHEME.color.p2'") fintensity(inten30) lcolor("`.__SCHEME.color.p2'%30")) /// 
	(rarea lci2 uci2 preg_year, color("`.__SCHEME.color.p3'") fintensity(inten30) lcolor("`.__SCHEME.color.p3'%30")) ///
	(rarea lci3 uci3 preg_year, color("`.__SCHEME.color.p4'") fintensity(inten30) lcolor("`.__SCHEME.color.p4'%30")) /// 
	(rarea lci4 uci4 preg_year, color("`.__SCHEME.color.p5'") fintensity(inten30) lcolor("`.__SCHEME.color.p7'%30")) /// 
	(rarea lci5 uci5 preg_year, color("`.__SCHEME.color.p6'") fintensity(inten30) lcolor("`.__SCHEME.color.p8'%30")) /// 
	(line pct0 preg_year, color(darkgray) lpattern(dash) lwidth(medium)) /// 
	(line pct1 preg_year, color("`.__SCHEME.color.p2'")) ///
	(line pct2 preg_year, color("`.__SCHEME.color.p3'")) ///
	(line pct3 preg_year, color("`.__SCHEME.color.p4'")) ///
	(line pct4 preg_year, color("`.__SCHEME.color.p7'")) ///
	(line pct5 preg_year, color("`.__SCHEME.color.p8'")), ///
	legend(order(15 16 "SSRI prescriptions" 17 "TCA prescriptions" 18 "SNRI prescriptions" 19 "Other antidepressant" "prescriptions" 20 "Multiple class prescriptions")label(15 "{bf:Any antidepressant}" "{bf:prescriptions}") size(tiny) col(6) position(6) symxsize(large) region(lcolor(black))) ///
	b2title("{bf:Year of pregnancy start}", size(vsmall) color(black)) xscale(range(1996 2018)) xlabel(1997(4)2017, nogrid labsize(vsmall)) xtitle("") /// x axis
	ytitle("{bf:Proportion of pregnancies (%)}", size(vsmall) color(black)) ylabel(1(2)15, labsize(vsmall)) /// y axis 
	title("{bf:(a) Antidepressant prescriptions during pregnancy}" "{bf}between 1996 and 2018 in CPRD GOLD", color(black) size(small)) || ///
	scatter y x, msymbol(i) yaxis(2) xaxis(2) ylab(, axis(2) notick nolab) xlab(, axis(2) notick nolab) ytitle("", axis(2)) xtitle("", axis(2)) /// box around graph
	plotregion(margin(0 0 1 1)) graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15)) /// overall
	name(prescribing_over_time, replace)

* Prescribing across pregnancy

use "$Datadir\table_2_dataset.dta", clear
	
	count
	local tot=`r(N)'
	
	count if secondtrim_num!=.
	local t2 = `r(N)'
	
	count if thirdtrim_num!=.
	local t3 = `r(N)'
	
	use "$Tempdatadir\count_class_l0.dta", replace
	
	forvalues x=1/5 {
		
		append using "$Tempdatadir\count_class_l`x'.dta"
		
	}
	
	foreach y in m n o a b c w x y z {
		forvalues x=0/5 {
			
			append using "$Tempdatadir\count_class_`y'`x'.dta"
			
		}
	}
	
	local i=0
	
	gen period =.
	
	foreach x in l m n o a b c w x y z {
		
		local j = `i'+1
		
		replace period = `j' if regexm(period_class, "`x'")
		
		local i = `j'
		
	}
	
	gen class = substr(period_class, 3, 3)
	gen class_num = real(class)
	drop class
	rename class_num class
	drop period_class
	
	
	gen tot = `tot' if period!=6 | period!=7
	replace tot = `t2' if period==6
	replace tot = `t3' if period==7
	
	replace count = tot - count if class==0
	
	gen pct = (count/tot)*100
	
	*gen total = n0 + n1
		
	*gen pct = (n1/total)*100
		
	* Confidence intervals
	
		gen p = pct/100
		
		gen se = sqrt((p*(1-p))/tot) 
		
		gen lci = (p - (1.96*se))*100
		gen uci = (p + (1.96*se))*100
		
	keep period class pct lci uci
	
	reshape wide pct lci uci, i(class) j(period)
	reshape long pct lci uci, i(class) j(period)
	
	set scheme tab3, perm
	
	gen x=11
	gen y=0

	* Macros to create grids lines that render over the bar
	local t1=1
	local t2=11
	local t3=0
	local y=15
	
	tw ///
	(scatteri 1 `t1' 1 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 3 `t1' 3 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 5 `t1' 5 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 7 `t1' 7 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 9 `t1' 9 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 11 `t1' 11 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 13 `t1' 13 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri 15 `t1' 15 `t2', recast(line) xaxis(1) lcolor(gs14)) ///
	(scatteri `t3' 4.5 `y' 4.5, recast(line) xaxis(1) lcolor(gs9) lpattern(dash)) ///
	(scatteri `t3' 7.5 `y' 7.5, recast(line) xaxis(1) lcolor(gs9) lpattern(dash)) ///
	(rarea lci uci period if class==0, color("`.__SCHEME.color.p1'") fintensity(inten30) lcolor("`.__SCHEME.color.p1'%30")) /// 95% CI code
	(rarea lci uci period if class==1, color("`.__SCHEME.color.p2'") fintensity(inten30) lcolor("`.__SCHEME.color.p2'%30")) /// 95% CI code
	(rarea lci uci period if class==2, color("`.__SCHEME.color.p3'") fintensity(inten30) lcolor("`.__SCHEME.color.p3'%30")) /// 95% CI code
	(rarea lci uci period if class==3, color("`.__SCHEME.color.p4'") fintensity(inten30) lcolor("`.__SCHEME.color.p4'%30")) /// 95% CI code
	(rarea lci uci period if class==4, color("`.__SCHEME.color.p7'") fintensity(inten30) lcolor("`.__SCHEME.color.p7'%30")) /// 95% CI code
	(rarea lci uci period if class==5, color("`.__SCHEME.color.p8'") fintensity(inten30) lcolor("`.__SCHEME.color.p8'%30")) /// 95% CI code
	(line pct period if class==0, color(darkgray) lpattern(dash) lwidth(medium)) ///
	(line pct period if class==1, color("`.__SCHEME.color.p2'")) ///
	(line pct period if class==2, color("`.__SCHEME.color.p3'")) ///
	(line pct period if class==3, color("`.__SCHEME.color.p4'")) ///
	(line pct period if class==4, color("`.__SCHEME.color.p7'")) ///
	(line pct period if class==5, color("`.__SCHEME.color.p8'")) ///
	, ///
	xline(6, lwidth(24) lc(gs14*0.5)) /// grey banding
	xscale(range(1 11)) xlabel(2.75 "12 months pre-pregnancy" 6 "During pregnancy"  9.25 "12 months post-pregnancy", nogrid labsize(vsmall) tlcolor(gs15)) xtick(1 4.5 7.5 11) b2title("{bf}Pregnancy period", size(vsmall) color(black)) /// x axis
	legend(order(15 16 "SSRI prescriptions" 17 "Other antidepressant" 18 "TCA prescriptions" 19 "SNRI prescriptions" "prescriptions" 20 "Multiple class prescriptions")label(15 "{bf:Any antidepressant}" "{bf:prescriptions}") size(tiny) col(6) position(6) symxsize(large) region(lcolor(black))) ///
	ytitle("{bf:Proportion of pregnancies (%)}", size(vsmall) color(black)) ylabel(1(2)15, labsize(vsmall) nogrid) yscale(range(1 15)) /// y axis 
	title("{bf:(b) Antidepressant prescribing before, during,}" "{bf}and after pregnancy", color(black) size(small)) || ///
	scatter y x, msymbol(i) yaxis(2) xaxis(2) ylab(, axis(2) notick nolab) xlab(, axis(2) notick nolab) ytitle("", axis(2)) xtitle("", axis(2)) ///
	plotregion(margin(0 0 1 1)) xsize(50) ysize(100) graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15)) /// overall
	name(prescribing_around_preg, replace)

* Combine the two chunks into a figure with an (a) and (b) panel

	grc1leg prescribing_over_time prescribing_around_preg, graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15)) name(time_preg_combi, replace)
	
	cd "$Graphdir\"
	graph export time_preg_combi.pdf, replace

*******************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close over_time_across_preg
	
	translate "$Logdir\3_figures\1_over time & across preg.smcl" "$Logdir\3_figures\1_over time & across preg.pdf", replace
	
	erase "$Logdir\3_figures\1_over time & across preg.smcl"

*******************************************************************************
