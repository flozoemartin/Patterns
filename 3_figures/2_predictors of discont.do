*****************************************************************************

* Predictors of antidepressant discontinuation during pregnancy

* Author: Flo Martin

* Date: 06/08/2024

*****************************************************************************

Figure 2 - Maternal factors associated with discontinuation of antidepressants during pregnancy. Rx = prescription Dx = evidence of a diagnosis

*****************************************************************************

* Start logging

  log using "$Logdir\3_figures\2_predictors of discont", name(predictors_of_discont) replace

*****************************************************************************

* Creating the dataset for the figure

use "$Datadir\table_2_dataset.dta", clear
	count
	
	foreach x in l m n o {
		
		gen dosage6`x' =.
		gen dosage7`x' =.
		gen dosage8`x' =.
		
	}
	
	keep if any_preg==1
	
	tab discontinuer
	
	recode eth5 5=.
	recode bmi_cat 4=.
	recode smokstatus 3=.
	recode multi_drug .=0 
	
	gen class_prepreg =.
	
	forvalues x=1/4 {
		
		replace class_prepreg = `x' if (class_l==`x' | class_l==0) & (class_m==`x' | class_m==0) & (class_n==`x' | class_n==0) & (class_o==`x' | class_o==0)
		
	}
	
	replace class_prepreg = 0 if class_l==0 & class_m==0 & class_n==0 & class_o==0
	
	tab class_prepreg, m
	
	replace class_prepreg = 5 if class_prepreg==.
	
	label define class_pre_lb 0"Unexposed" 1"SSRI" 2"TCA" 3"SNRI" 4"Other" 5"Multiple"
	label values class_prepreg class_pre_lb
	tab class_prepreg
	
	foreach y in l m n o {
	
		gen highest_dose_prepreg_`y' = max(dosage1`y', dosage2`y', dosage3`y', dosage4`y', dosage5`y', dosage6`y', dosage7`y', dosage8`y')
	
	}
	
	gen highest_dose_prepreg = max(highest_dose_prepreg_l, highest_dose_prepreg_m, highest_dose_prepreg_n, highest_dose_prepreg_o)
	
	gen illicitdrug = 1 if illicitdrug_preg==1 | illicitdrug_12mo==1
	
	capture postutil close 
	tempname memhold 

	postfile `memhold' str15 subgroup str30 variable float id or lci uci p ///
	using "$Graphdir\data for figures\discont_predictors.dta", replace
	
	foreach level in 1 2 3 4 5 {
	
		logistic discontinuer ib3.matage_cat pregstart_year, or vce(cluster patid)
		
		local tot=`e(N)'
		lincom `level'.matage_cat, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'
				
		post `memhold' ("characteristic") ("maternal age") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
		
	}
	
	foreach level in 1 2 3 4 5 {
	
		logistic discontinuer i.imd_practice pregstart_year, or vce(cluster patid)
		
		local tot=`e(N)'
		lincom `level'.imd_practice, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'
				
		post `memhold' ("characteristic") ("maternal IMD") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
		
	}
	
	foreach level in 0 1 2 3 4 {
	
		logistic discontinuer i.eth5 pregstart_year, or vce(cluster patid)
		
		local tot=`e(N)'
		lincom `level'.eth5, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'
				
		post `memhold' ("characteristic") ("maternal ethnicity") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
		
	}
	
	foreach level in 0 1 2 3 {
	
		logistic discontinuer ib1.bmi_cat pregstart_year, or vce(cluster patid)
		
		local tot=`e(N)'
		lincom `level'.bmi_cat, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'
				
		post `memhold' ("characteristic") ("maternal BMI") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
		
	}
	
	foreach var in smokstatus alcstatus {
		foreach level in 0 1 2 {
	
			logistic discontinuer i.`var' pregstart_year, or vce(cluster patid)
			
			local tot=`e(N)'
			lincom `level'.`var', or
			local minadjhr=`r(estimate)'
			local minadjuci=`r(ub)'
			local minadjlci=`r(lb)'
			local pvalue=`r(p)'
					
			post `memhold' ("exposure") ("`var'") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
		
		}
	}
	
	foreach level in 0 1 {
		
		logistic discontinuer i.illicitdrug_12mo pregstart_year, or vce(cluster patid)
			
		local tot=`e(N)'
		lincom `level'.illicitdrug_12mo, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'
					
		post `memhold' ("exposure") ("illicitdrug_12mo") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
	}
	
	foreach var in grav_hist_sa grav_hist_sb grav_hist_top grav_hist_otherloss {
		foreach level in 0 1 {
		
			logistic discontinuer i.`var' pregstart_year, or vce(cluster patid)
			
			local tot=`e(N)'
			lincom `level'.`var', or
			local minadjhr=`r(estimate)'
			local minadjuci=`r(ub)'
			local minadjlci=`r(lb)'
			local pvalue=`r(p)'
					
			post `memhold' ("characteristic") ("`var'") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue') 
	
		}
	}
	
	foreach var in parity_cat CPRD_consultation_events_cat {
		foreach level in 0 1 2 3 {
		
			logistic discontinuer i.`var' pregstart_year, or vce(cluster patid)
				
			local tot=`e(N)'
			lincom `level'.`var', or
			local minadjhr=`r(estimate)'
			local minadjuci=`r(ub)'
			local minadjlci=`r(lb)'
			local pvalue=`r(p)'
						
			post `memhold' ("characteristic") ("`var'") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
		}
	}
	
	foreach var in depression anxiety bipolar schizo ed autism adhd id pain dn incont migraine headache {
		foreach level in 0 1 {
			
			logistic discontinuer i.`var' pregstart_year, or vce(cluster patid)
				
			local tot=`e(N)'
			lincom `level'.`var', or
			local minadjhr=`r(estimate)'
			local minadjuci=`r(ub)'
			local minadjlci=`r(lb)'
			local pvalue=`r(p)'
						
			post `memhold' ("comorbidities") ("`var'") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
		}
	}
	
	
	foreach var in antipsychotics_prepreg moodstabs_prepreg benzos_prepreg zdrugs_prepreg teratogen_prepreg multivit_prepreg folic_prepreg0 folic_prepreg1 antiemetic_prepreg multi_drug {
		foreach level in 0 1 {
			
			logistic discontinuer i.`var' pregstart_year, or vce(cluster patid)
				
			local tot=`e(N)'
			lincom `level'.`var', or
			local minadjhr=`r(estimate)'
			local minadjuci=`r(ub)'
			local minadjlci=`r(lb)'
			local pvalue=`r(p)'
						
			post `memhold' ("exposure") ("`var'") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
		}
	}
	
	foreach level in 0 1 2 3 4 5 {
		
		logistic discontinuer i.class_prepreg pregstart_year, or vce(cluster patid)
				
		local tot=`e(N)'
		lincom `level'.class_prepreg, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'	
		
		post `memhold' ("exposure") ("class") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
	}
	
	foreach level in 1 2 3 {
		
		logistic discontinuer i.highest_dose_prepreg pregstart_year, or vce(cluster patid)
				
		local tot=`e(N)'
		lincom `level'.highest_dose_prepreg, or
		local minadjhr=`r(estimate)'
		local minadjuci=`r(ub)'
		local minadjlci=`r(lb)'
		local pvalue=`r(p)'	
		
		post `memhold' ("exposure") ("dose") (`level') (`minadjhr') (`minadjlci') (`minadjuci') (`pvalue')
		
	}
	
	postclose `memhold'

* Load in the data

use "$Graphdir\data for figures\discont_predictors.dta", clear
	
	keep if subgroup=="characteristic"
	
	replace subgroup="a_maternal age" if variable=="maternal age"
	replace subgroup="b_maternal IMD" if variable=="maternal IMD"
	replace subgroup="c_maternal ethnicity" if variable=="maternal ethnicity"
	replace subgroup="d_maternal BMI" if variable=="maternal BMI"
	replace subgroup="e_gravidity history" if variable=="grav_hist_sa" | variable=="grav_hist_sb" | variable=="grav_hist_top" | variable=="grav_hist_otherloss" 
	replace subgroup="f_parity" if variable=="parity_cat"
	replace subgroup="g_CPRD_consultation_events_cat" if variable=="CPRD_consultation_events_cat"
	
	gen logor = log(or)
	gen loglci = log(lci)
	gen loguci = log(uci)
	
	admetan logor loglci loguci, eform by(subgroup) nohet nowt forestplot(nobox nosubgroup) saving(forest, replace)
	
* Characteristics
	
	use forest, clear
	
	drop if _USE==5
	count
	set obs 45
	
	egen seq = seq()
	
	replace _USE = 1 if _USE==.
	replace _ES = 0 if _BY==.
	replace _EFFECT = "1.00 (reference)" if _BY==.
	
	replace _STUDY=3 if seq==40
	replace _BY=1 if seq==40
	replace _LABELS="Maternal age" if _LABELS=="a_maternal age"
	replace _LABELS = "<18" if _STUDY==1
	replace _LABELS = "18-24" if _STUDY==2
	replace _LABELS = "25-29" if _STUDY==3
	replace _LABELS = "30-34" if _STUDY==4
	replace _LABELS = ">=35" if _STUDY==5
	
	replace _STUDY=6 if seq==41
	replace _BY=2 if seq==41
	replace _LABELS = "Maternal IMD quintile" if _LABELS=="b_maternal IMD"
	replace _LABELS = "1 (least deprived)" if _STUDY==6
	replace _LABELS = "2" if _STUDY==7
	replace _LABELS = "3" if _STUDY==8
	replace _LABELS = "4" if _STUDY==9
	replace _LABELS = "5 (most deprived)" if _STUDY==10
	
	replace _STUDY=11 if seq==42
	replace _BY=3 if seq==42
	replace _LABELS = "Maternal ethnicity" if _LABELS=="c_maternal ethnicity"
	replace _LABELS = "White" if _STUDY==11
	replace _LABELS = "South Asian" if _STUDY==12
	replace _LABELS = "Black" if _STUDY==13
	replace _LABELS = "Other" if _STUDY==14
	replace _LABELS = "Mixed" if _STUDY==15
	
	replace _STUDY=17 if seq==43
	replace _BY=4 if seq==43
	replace _LABELS = "Maternal BMI" if _LABELS=="d_maternal BMI"
	replace _LABELS = "<18kg/m2" if _STUDY==16
	replace _LABELS = "18-25kg/m2" if _STUDY==17
	replace _LABELS = "25-29kg/m2" if _STUDY==18
	replace _LABELS = ">30kg/m2" if _STUDY==19
	
	replace _LABELS = "Gravidity history" if _LABELS=="e_gravidity history"
	replace _LABELS = "Miscarriage" if _STUDY==21
	replace _LABELS = "Stillbirth" if _STUDY==23
	replace _LABELS = "Termination" if _STUDY==25
	replace _LABELS = "Other loss" if _STUDY==27
	
	replace _STUDY=28 if seq==44
	replace _BY=6 if seq==44
	replace _LABELS = "Maternal parity" if _LABELS=="f_parity"
	replace _LABELS = "Nulliparous" if _STUDY==28
	replace _LABELS = "1" if _STUDY==29
	replace _LABELS = "2" if _STUDY==30
	replace _LABELS = "3 or more" if _STUDY==31
	
	replace _STUDY=32 if seq==45
	replace _BY=7 if seq==45
	replace _LABELS = "Number of GP visits" if _LABELS=="g_CPRD_consultation_events_cat"
	replace _LABELS = "0" if _STUDY==32
	replace _LABELS = "1-3" if _STUDY==33
	replace _LABELS = "4-10" if _STUDY==34
	replace _LABELS = "10 or more" if _STUDY==35
	
	sort _BY _USE _STUDY
	
	replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0
	label var _EFFECT `"`"{bf:Odds ratio (95% CI)}"' `"adjusted for pregnancy year"'"'
	label var _LABELS `"`"{bf:Characteristics associated with discontinuation}"'"'
	
	replace _ES = exp(_ES)
	replace _LCI = exp(_LCI)
	replace _UCI = exp(_UCI)
	
	replace _ES=10 if _ES==.
	replace _LCI=10 if _LCI==.
	replace _UCI=10 if _UCI==.
	
	drop seq
	egen seq=seq()
	
	forvalues x=2/44 {
		foreach y in _ES _LCI _UCI {
		
			sum `y' if seq==`x'
			local `y'_`x' = `r(mean)'
			local `y'_`x'_f : display %4.2fc ``y'_`x'' 
			
		}		
	}
	
	replace _ES=. if _ES==10
	replace _LCI=. if _LCI==10
	replace _UCI=. if _UCI==10
	
	* Macros to create the null line
	local t1=0
	local t2=45
	
	twoway ///
	(scatteri `t1' 1 `t2' 1, recast(line) yaxis(1) lpatter(dash) lcolor(cranberry)) /// null line
	(rcap _LCI _UCI seq, horizontal lcolor(black)) /// code for NO 95% CI
	(scatter seq _ES, mcolor("204 146 194") ms(o) msize(medium) mlcolor(black) mlw(thin)), yscale(reverse) yscale(range(0 44)) ylabel(0.5 "{bf:Maternal ageᵃ}" 2 "<18" 3 "18-24" 4 "25-29" 5 "30-34" 6 ">=35 or over" /// 
	7.5 "{bf:IMD quintile}" 9 "1 (least deprived)" 10 "2" 11 "3" 12 "4" 13 "5 (most deprived)" ///
	14.5 "{bf}Maternal ethnicity" 16 "White" 17 "South Asian" 18 "Black" 19 "Other" 20 "Mixed" ///
	21.5 "{bf}Maternal BMIᵇ" 23 "<18" 24 "18-24.9" 25 "25-29.9" 26 "30 or over" ///
	27.5 "{bf}Gravidity historyᵃ" 29 "Miscarriage" 30 "Stillbirth" 31"Termination" 32"Other loss" ///
	33.5 "{bf}Parityᵃ" 35"Nulliparous" 36"1" 37"2" 38"3 or more" ///
	39.5"{bf}GP visitsᶜ" 41"0" 42"1-3" 43"4-10" 44"10 or more" ///
	, angle(0) labsize(*0.6) notick nogrid nogextend) ///
	text(-0.5 3 "{bf}OR (95%CI)", size(*0.5)) ///
	yline(0.5, lcolor(gray) lpattern(dot)) /// 
	text(2 2.78 "`_ES_2_f' (`_LCI_2_f'-`_UCI_2_f')", size(*0.5)) ///
	text(3 2.78 "`_ES_3_f' (`_LCI_3_f'-`_UCI_3_f')", size(*0.5)) ///
	text(4 2.78 "`_ES_4_f' (reference)", size(*0.5)) ///
	text(5 2.78 "`_ES_5_f' (`_LCI_5_f'-`_UCI_5_f')", size(*0.5)) ///
	text(6 2.78 "`_ES_6_f' (`_LCI_6_f'-`_UCI_6_f')", size(*0.5)) ///
	yline(7.5, lcolor(gray) lpattern(dot)) /// 
	text(9 2.78 "`_ES_9_f' (reference)", size(*0.5)) ///
	text(10 2.78 "`_ES_10_f' (`_LCI_10_f'-`_UCI_10_f')", size(*0.5)) ///
	text(11 2.78 "`_ES_11_f' (`_LCI_11_f'-`_UCI_11_f')", size(*0.5)) ///
	text(12 2.78 "`_ES_12_f' (`_LCI_12_f'-`_UCI_12_f')", size(*0.5)) ///
	text(13 2.78 "`_ES_13_f' (`_LCI_13_f'-`_UCI_13_f')", size(*0.5)) ///
	yline(14.5, lcolor(gray) lpattern(dot)) /// 
	text(16 2.78 "`_ES_16_f' (reference)", size(*0.5)) ///
	text(17 2.78 "`_ES_17_f' (`_LCI_17_f'-`_UCI_17_f')", size(*0.5)) ///
	text(18 2.78 "`_ES_18_f' (`_LCI_18_f'-`_UCI_18_f')", size(*0.5)) ///
	text(19 2.78 "`_ES_19_f' (`_LCI_19_f'-`_UCI_19_f')", size(*0.5)) ///
	text(20 2.78 "`_ES_20_f' (`_LCI_20_f'-`_UCI_20_f')", size(*0.5)) ///
	yline(21.5, lcolor(gray) lpattern(dot)) /// 
	text(23 2.78 "`_ES_23_f' (`_LCI_23_f'-`_UCI_23_f')", size(*0.5)) ///
	text(24 2.78 "`_ES_24_f' (reference)", size(*0.5)) ///
	text(25 2.78 "`_ES_25_f' (`_LCI_25_f'-`_UCI_25_f')", size(*0.5)) ///
	text(26 2.78 "`_ES_26_f' (`_LCI_26_f'-`_UCI_26_f')", size(*0.5)) ///
	yline(27.5, lcolor(gray) lpattern(dot)) /// 
	text(29 2.78 "`_ES_29_f' (`_LCI_29_f'-`_UCI_29_f')", size(*0.5)) ///
	text(30 2.78 "`_ES_30_f' (`_LCI_30_f'-`_UCI_30_f')", size(*0.5)) ///
	text(31 2.78 "`_ES_31_f' (`_LCI_31_f'-`_UCI_31_f')", size(*0.5)) ///
	text(32 2.78 "`_ES_32_f' (`_LCI_32_f'-`_UCI_32_f')", size(*0.5)) ///
	yline(33.5, lcolor(gray) lpattern(dot)) /// 
	text(35 2.78 "`_ES_35_f' (reference)", size(*0.5)) ///
	text(36 2.78 "`_ES_36_f' (`_LCI_36_f'-`_UCI_36_f')", size(*0.5)) ///
	text(37 2.78 "`_ES_37_f' (`_LCI_37_f'-`_UCI_37_f')", size(*0.5)) ///
	text(38 2.78 "`_ES_38_f' (`_LCI_38_f'-`_UCI_38_f')", size(*0.5)) ///
	yline(39.5, lcolor(gray) lpattern(dot)) /// 
	text(41 2.78 "`_ES_41_f' (reference)", size(*0.5)) ///
	text(42 2.78 "`_ES_42_f' (`_LCI_42_f'-`_UCI_42_f')", size(*0.5)) ///
	text(43 2.78 "`_ES_43_f' (`_LCI_43_f'-`_UCI_43_f')", size(*0.5)) ///
	text(44 2.78 "`_ES_44_f' (`_LCI_44_f'-`_UCI_44_f')", size(*0.5)) ///
	xscale(log) xlab(0.6(0.4)1.8, labsize(vsmall) format(%3.1fc)) xtitle("{bf}Odds ratio (95% confidence interval)" "adjusted for pregnancy year", size(*0.6)) xscale(range(0.34 4.2)) plotregion(margin(zero) ilcolor(black))yscale(noline) ///
	graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15))  legend(off) title("{bf}Maternal characteristics", size(vsmall) justification(left) pos(11)) name(charac, replace) 
	
* Exposures

	use "$Graphdir\data for figures\discont_predictors.dta", clear
	
	keep if subgroup=="exposure"
	keep if variable!="folic_prepreg0"
	keep if variable!="multi_drug"
	
	replace subgroup="a_Smoking status around pregnancy" if variable=="smokstatus"
	replace subgroup="b_Alcohol use status around pregnancy" if variable=="alcstatus"
	replace subgroup="c_Illicit drug use in the 12 months before pregnancy" if variable=="illicitdrug_12mo"
	replace subgroup="d_Other MH-related prescriptions in the 12 months before pregnancy" if variable=="antipsychotics_prepreg" | variable=="moodstabs_prepreg" | variable=="benzos_prepreg" | variable=="zdrugs_prepreg"
	replace subgroup="e_Other prescriptions in the 12 months before pregnancy" if variable=="folic_prepreg1" | variable=="antiemetic_prepreg" | variable=="teratogen_prepreg" | variable=="multivit_prepreg"
	replace subgroup="f_Antidepressant class in the 12 months before pregnancy" if variable=="class"
	replace subgroup="g_Antidepressant dose in the 12 months before pregnancy" if variable=="dose"
	
	gen logor = log(or)
	gen loglci = log(lci)
	gen loguci = log(uci)
	
	admetan logor loglci loguci, eform by(subgroup) nohet nowt forestplot(nobox nosubgroup) saving(forest, replace)
	
	use forest, clear
	
	drop if _USE==5
	count

	set obs 39
	egen seq = seq()
	
	replace _USE = 1 if _USE==.
	replace _ES = 0 if _BY==.
	replace _EFFECT = "1.00 (reference)" if _BY==.
	
	replace _STUDY=1 if seq==35
	replace _BY=1 if seq==35
	replace _LABELS="Smoking status" if _LABELS=="a_Smoking status around pregnancy"
	replace _LABELS="Non-smoker" if _STUDY==1
	replace _LABELS="Ex-smoker" if _STUDY==2
	replace _LABELS="Current smoker" if _STUDY==3
	
	replace _STUDY=4 if seq==36
	replace _BY=2 if seq==36
	replace _LABELS="Alcohol use" if _LABELS=="b_Alcohol use status around pregnancy"
	replace _LABELS="Non-drinker" if _STUDY==4
	replace _LABELS="Current drinker" if _STUDY==5
	replace _LABELS="Ex-drinker" if _STUDY==6
	
	replace _STUDY=7 if seq==37
	replace _BY=3 if seq==37
	replace _LABELS="Illicit drug use" if _LABELS=="c_Illicit drug use in the 12 months before pregnancy"
	replace _LABELS="No use" if _STUDY==7
	replace _LABELS="Use" if _STUDY==8
	
	replace _LABELS="Mental health prescriptions" if _LABELS=="d_Other MH-related prescriptions in the 12 months before pregnancy"
	replace _LABELS="Antipychotic use" if _STUDY==10
	replace _LABELS="Mood stabiliser use" if _STUDY==12
	replace _LABELS="Benzodiazepine use" if _STUDY==14
	replace _LABELS="Z-drug use" if _STUDY==16
	
	replace _LABELS="Other prescriptions" if _LABELS=="e_Other prescriptions in the 12 months before pregnancy"
	replace _LABELS="High dose folic acid use" if _STUDY==18
	replace _LABELS="Antiemetic use" if _STUDY==20
	replace _LABELS="Teratogen use" if _STUDY==22
	replace _LABELS="Multivitamin use" if _STUDY==24
	
	replace _LABELS="AD class" if _LABELS=="f_Antidepressant class in the 12 months before pregnancy"
	replace _STUDY=25 if seq==38
	replace _BY=6 if seq==38
	replace _LABELS="No use" if _STUDY==25
	replace _LABELS="SSRI use" if _STUDY==26
	replace _LABELS="TCA use" if _STUDY==27
	replace _LABELS="SNRI use" if _STUDY==28
	replace _LABELS="Other use" if _STUDY==29
	replace _LABELS="Multiple class use" if _STUDY==30
	
	replace _LABELS="AD dose" if _LABELS=="g_Antidepressant dose in the 12 months before pregnancy"
	replace _STUDY=31 if seq==39
	replace _BY=7 if seq==39
	replace _LABELS="Low dose" if _STUDY==31
	replace _LABELS="Medium dose" if _STUDY==32
	replace _LABELS="High dose" if _STUDY==33
	
	sort _BY _USE _STUDY
	
	replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0
	label var _EFFECT `"`"{bf:Odds ratio (95% CI)}"' `"adjusted for pregnancy year"'"'
	label var _LABELS `"`"{bf:Exposures associated with discontinuation}"'"'
	
	replace _ES = exp(_ES)
	replace _LCI = exp(_LCI)
	replace _UCI = exp(_UCI)
	
	replace _ES=10 if _ES==.
	replace _LCI=10 if _LCI==.
	replace _UCI=10 if _UCI==.
	
	drop seq
	egen seq=seq()
	
	forvalues x=2/39 {
		foreach y in _ES _LCI _UCI {
		
			sum `y' if seq==`x'
			local `y'_`x' = `r(mean)'
			local `y'_`x'_f : display %4.2fc ``y'_`x'' 
			
		}		
	}
	
	replace _ES=. if _ES==10
	replace _LCI=. if _LCI==10
	replace _UCI=. if _UCI==10
	
	* Macros to create the null line
	local t1=0
	local t2=39

	twoway ///
	(scatteri `t1' 1 `t2' 1, recast(line) yaxis(1) lpatter(dash) lcolor(cranberry)) /// null line
	(rcap _LCI _UCI seq, horizontal lcolor(black)) /// code for NO 95% CI
	(scatter seq _ES, mcolor("137 49 104") ms(o) msize(medium) mlcolor(black) mlw(thin)), yscale(reverse) yscale(range(0 39)) ylabel(0.5 "{bf:Smoking statusᵇ}" 2 "Non-smoker" 3 "Ex-smoker" 4 "Current smoker" /// 
	5.5 "{bf:Alcohol useᵇ}" 7 "Non-drinker" 8 "Current drinker" 9 "Ex-drinker" ///
	10.5 "{bf}Illicit drug useᶜ" 12 "No" 13 "Yes" ///
	14.5 "{bf}Mental health Rxᶜ" 16 "Antipsychotics" 17 "Mood stabilisers" 18 "Benzodiazepines" 19 "Z-drugs" ///
	20.5 "{bf}Other Rxᶜ" 22 "High dose folic acid" 23 "Antiemetics" 24"Teratogens" 25"Multivitamins" ///
	26.5 "{bf}AD Rxᶜ" 28"None" 29"SSRIs" 30"TCAs" 31"SNRIs" 32"Other" 33"Multiple classes" ///
	34.5"{bf}AD doseᶜ" 36"Low" 37"Medium" 38"High" ///
	, angle(0) labsize(*0.6) notick nogrid nogextend) ///
	text(-0.5 3 "{bf}OR (95%CI)", size(*0.5)) ///
	yline(0.5, lcolor(gray) lpattern(dot)) /// 
	text(2 2.78 "`_ES_2_f' (reference)", size(*0.5)) ///
	text(3 2.78 "`_ES_3_f' (`_LCI_3_f'-`_UCI_3_f')", size(*0.5)) ///
	text(4 2.78 "`_ES_4_f' (`_LCI_4_f'-`_UCI_4_f')", size(*0.5)) ///
	yline(5.5, lcolor(gray) lpattern(dot)) /// 
	text(7 2.78 "`_ES_7_f' (reference)", size(*0.5)) ///
	text(8 2.78 "`_ES_8_f' (`_LCI_8_f'-`_UCI_8_f')", size(*0.5)) ///
	text(9 2.78 "`_ES_9_f' (`_LCI_9_f'-`_UCI_9_f')", size(*0.5)) ///
	yline(10.5, lcolor(gray) lpattern(dot)) /// 
	text(12 2.78 "`_ES_12_f' (reference)", size(*0.5)) ///
	text(13 2.78 "`_ES_13_f' (`_LCI_13_f'-`_UCI_13_f')", size(*0.5)) ///
	yline(14.5, lcolor(gray) lpattern(dot)) /// 
	text(16 2.78 "`_ES_16_f' (`_LCI_16_f'-`_UCI_16_f')", size(*0.5)) ///
	text(17 2.78 "`_ES_17_f' (`_LCI_17_f'-`_UCI_17_f')", size(*0.5)) ///
	text(18 2.78 "`_ES_18_f' (`_LCI_18_f'-`_UCI_18_f')", size(*0.5)) ///
	text(19 2.78 "`_ES_19_f' (`_LCI_19_f'-`_UCI_19_f')", size(*0.5)) ///
	yline(20.5, lcolor(gray) lpattern(dot)) /// 
	text(22 2.78 "`_ES_22_f' (`_LCI_22_f'-`_UCI_22_f')", size(*0.5)) ///
	text(23 2.78 "`_ES_23_f' (`_LCI_23_f'-`_UCI_23_f')", size(*0.5)) ///
	text(24 2.78 "`_ES_24_f' (`_LCI_24_f'-`_UCI_24_f')", size(*0.5)) ///
	text(25 2.78 "`_ES_25_f' (`_LCI_25_f'-`_UCI_25_f')", size(*0.5)) ///
	yline(26.5, lcolor(gray) lpattern(dot)) /// 
	text(28 2.78 "`_ES_28_f' (reference)", size(*0.5)) ///
	text(29 2.78 "`_ES_29_f' (`_LCI_29_f'-`_UCI_29_f')", size(*0.5)) ///
	text(30 2.78 "`_ES_30_f' (`_LCI_30_f'-`_UCI_30_f')", size(*0.5)) ///
	text(31 2.78 "`_ES_31_f' (`_LCI_31_f'-`_UCI_31_f')", size(*0.5)) ///
	text(32 2.78 "`_ES_32_f' (`_LCI_32_f'-`_UCI_32_f')", size(*0.5)) ///
	text(33 2.78 "`_ES_33_f' (`_LCI_33_f'-`_UCI_33_f')", size(*0.5)) ///
	yline(34.5, lcolor(gray) lpattern(dot)) /// 
	text(36 2.78 "`_ES_36_f' (reference)", size(*0.5)) ///
	text(37 2.78 "`_ES_37_f' (`_LCI_37_f'-`_UCI_37_f')", size(*0.5)) ///
	text(38 2.78 "`_ES_38_f' (`_LCI_38_f'-`_UCI_38_f')", size(*0.5)) ///
	xscale(log) xlab(0.6(0.4)1.8, labsize(vsmall) format(%3.1fc)) xtitle("{bf}Odds ratio (95% confidence interval)" "adjusted for pregnancy year", size(*0.6)) xscale(range(0.34 4.2)) plotregion(margin(zero) ilcolor(black))yscale(noline) ///
	graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15))  legend(off) title("{bf}Maternal exposures", size(vsmall) justification(left) pos(11)) name(exp, replace) 
	
* Comorbidities */
	
	use "$Graphdir\data for figures\discont_predictors.dta", clear
	
	keep if subgroup=="comorbidities"
	
	replace subgroup="Mental health problems" if variable=="depression" | variable=="anxiety" | variable=="bipolar" | variable=="schizo" | variable=="ed"
	
	replace subgroup="Neurodevelopmental disorders" if variable=="autism" | variable=="adhd" | variable=="id"
	
	replace subgroup="Somatic antidepressant indications" if variable=="pain" | variable=="incont" | variable=="dn" | variable=="migraine" | variable=="headache"
	
	gen logor = log(or)
	gen loglci = log(lci)
	gen loguci = log(uci)
	
	admetan logor loglci loguci, eform by(subgroup) nohet nowt forestplot(nobox nosubgroup) saving(forest, replace)
	
	use forest, clear
	
	drop if _USE==5
	count
	
	replace _LABELS = "Depression" if _LABELS=="2"
	replace _LABELS = "Anxiety" if _LABELS=="4"
	replace _LABELS = "Bipolar" if _LABELS=="6"
	replace _LABELS = "Schizoaffective disorder" if _LABELS=="8"
	replace _LABELS = "Eating disorder" if _LABELS=="10"
	
	replace _LABELS = "Autism" if _LABELS=="12"
	replace _LABELS = "ADHD" if _LABELS=="14"
	replace _LABELS = "Intellectual disability" if _LABELS=="16"
	
	replace _LABELS = "Pain" if _LABELS=="18"
	replace _LABELS = "Diabetic neuropathy" if _LABELS=="20"
	replace _LABELS = "Stress incontinence" if _LABELS=="22"
	replace _LABELS = "Migraine prophylaxis" if _LABELS=="24"
	replace _LABELS = "Tension-type headache" if _LABELS=="26"
	
	replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0
	label var _EFFECT `"`"{bf:Odds ratio (95% CI)}"' `"adjusted for pregnancy year"'"'
	label var _LABELS `"`"{bf:Comorbidities associated with discontinuation}"'"'
	
	replace _ES = exp(_ES)
	replace _LCI = exp(_LCI)
	replace _UCI = exp(_UCI)
	
	replace _ES=10 if _ES==.
	replace _LCI=10 if _LCI==.
	replace _UCI=10 if _UCI==.
	
	egen seq=seq()
	
	forvalues x=2/19 {
		foreach y in _ES _LCI _UCI {
		
			sum `y' if seq==`x'
			local `y'_`x' = `r(mean)'
			local `y'_`x'_f : display %4.2fc ``y'_`x'' 
			
		}		
	}
	
	replace _ES=. if _ES==10
	replace _LCI=. if _LCI==10
	replace _UCI=. if _UCI==10
	
	* Macros to create the null line
	local t1=0
	local t2=19
	
	* Adjust the CIs for DN and TTH so that I can enforce arrows on the wide CIs
	
	replace _LCI=0.4 if seq==15
	replace _UCI=1.9 if seq==18
	
	gen _UCI_dn = _UCI if seq==15
	gen _LCI_dn = _UCI if seq==15
	
	gen _UCI_tt = _LCI if seq==18
	gen _LCI_tt = _LCI if seq==18
	
	gen dn = 15
	gen tt = 18

	twoway ///
	(scatteri `t1' 1 `t2' 1, recast(line) yaxis(1) lpatter(dash) lcolor(cranberry)) /// null line
	(rcap _LCI _UCI seq if _STUDY!=20 & _STUDY!=26, horizontal lcolor(black)) /// code for NO 95% CI
	(rcap _LCI_dn _UCI_dn seq if _STUDY==20, horizontal lcolor(black)) /// code for NO 95% CI
	(rcap _LCI_tt _UCI_tt seq if _STUDY==26, horizontal lcolor(black)) /// code for NO 95% CI
	(pcarrow _UCI dn _LCI seq if _STUDY==20, horizontal mcolor(black) msize(small) lcolor(black)) /// code for NO 95% CI
	(pcarrow _LCI seq _UCI tt if _STUDY==26, horizontal mcolor(black) msize(small) lcolor(black)) /// code for NO 95% CI
	(scatter seq _ES, mcolor("74 25 66") ms(o) msize(medium) mlcolor(black) mlw(thin)), yscale(reverse) yscale(range(0 19)) ylabel(0.5 `" "{bf}Maternal mental" "{bf}health Dxᵈ" "' 2 "Depression" 3 "Anxiety" 4 "Bipolar" 5`" "Schizoaffective" "disorder" "' 6"Eating disorder" /// 
	7.5 "{bf}Maternal NDDᵈ" 9 "Autism" 10 "ADHD" 11 `" "Intellectual" "disability" "' ///
	12.5 `" "{bf:Somatic AD}" "{bf:indication Dxᵈ}" "' 14 "Pain" 15 "Diabetic neuropathy" 16 "Stress incontinence" 17"Migraine prophylaxis" 18`" "Tension-type" "headache" "' ///
	, angle(0) labsize(*0.6) notick nogrid nogextend) ///
	text(21.1 0.5 "← Less likely to discontinue", size(*0.5)) ///
	text(21.1 2.2 "More likely to discontinue →", size(*0.5)) ///
	text(-0.25 3 "{bf}OR (95%CI)", size(*0.5)) ///
	yline(0.5, lcolor(gray) lpattern(dot)) /// 
	text(2 2.78 "`_ES_2_f' (`_LCI_2_f'-`_UCI_2_f')", size(*0.5)) ///
	text(3 2.78 "`_ES_3_f' (`_LCI_3_f'-`_UCI_3_f')", size(*0.5)) ///
	text(4 2.78 "`_ES_4_f' (`_LCI_4_f'-`_UCI_4_f')", size(*0.5)) ///
	text(5 2.78 "`_ES_5_f' (`_LCI_5_f'-`_UCI_5_f')", size(*0.5)) ///
	text(6 2.78 "`_ES_6_f' (`_LCI_6_f'-`_UCI_6_f')", size(*0.5)) ///
	yline(7.5, lcolor(gray) lpattern(dot)) /// 
	text(9 2.78 "`_ES_9_f' (`_LCI_9_f'-`_UCI_9_f')", size(*0.5)) ///
	text(10 2.78 "`_ES_10_f' (`_LCI_10_f'-`_UCI_10_f')", size(*0.5)) ///
	text(11 2.78 "`_ES_11_f' (`_LCI_11_f'-`_UCI_11_f')", size(*0.5)) ///
	yline(12.5, lcolor(gray) lpattern(dot)) /// 
	text(14 2.78 "`_ES_14_f' (`_LCI_14_f'-`_UCI_14_f')", size(*0.5)) ///
	text(15 2.78 "`_ES_15_f' (`_LCI_15_f'-`_UCI_15_f')", size(*0.5)) ///
	text(16 2.78 "`_ES_16_f' (`_LCI_16_f'-`_UCI_16_f')", size(*0.5)) ///
	text(17 2.78 "`_ES_17_f' (`_LCI_17_f'-`_UCI_17_f')", size(*0.5)) ///
	text(18 2.78 "`_ES_18_f' (`_LCI_18_f'-`_UCI_18_f')", size(*0.5)) ///
	xscale(log) xlab(0.6(0.4)1.8, labsize(vsmall) format(%3.1fc)) xtitle("{bf}Odds ratio (95% confidence interval)" "adjusted for pregnancy year", size(*0.6)) xscale(range(0.34 4.2)) plotregion(margin(zero) ilcolor(black)) yscale(noline) ///
	graphregion(color(gs15) fcolor(gs15) ifcolor(gs15) lcolor(gs15)) legend(off) title("{bf}Maternal comorbidities", size(vsmall) justification(left) pos(11)) name(comorbid, replace) 
	
	graph combine charac exp comorbid, col(3) imargin(0.5 0.5 0.5 0.5) graphregion(color(gs15))  title("{bf}Maternal factors associated with discontinuation of antidepressants during pregnancy", size(small)) caption("ᵃ = at the start of pregnancy	ᵇ = around the start of pregnancy	ᶜ = in the 12 months before pregnancy	 ᵈ = ever before the start of pregnancy", size(tiny)) name(panel, replace)
	
	cd "$Graphdir"
	graph export panel.pdf, replace

*****************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close predictors_of_discont
	
	translate "$Logdir\3_figures\2_predictors of discont.smcl" "$Logdir\3_figures\2_predictors of discont.pdf", replace
	
	erase "$Logdir\3_figures\2_predictors of discont.smcl"

*****************************************************************************
