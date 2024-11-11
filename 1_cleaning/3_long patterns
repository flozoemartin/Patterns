***************************************************************************************************

* Creating a long dataset where each row represents a week of pregnancy with prescriptions that are onging in that period are represented in the neighbouring columns

Author: Flo Martin

Date: 04/06/2024

***************************************************************************************************

* Start logging

  log using "$Logdir\1_cleaning\3_long patterns", name(long_patterns) replace

***************************************************************************************************

	use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear // from population derivation scripts
	count
	
	gen gestwks=round(gestdays/7)
	tab gestwks
	
	keep patid pregid pregstart_num pregend_num gestwks
	
	bysort patid: egen seq=seq()
	summ seq // max number of pregnancies within the study period is 16
	local pregmax = r(max) 
	
	summ gestwks // max number of gestational weeks in a pregnancy 53
	local wksmax = r(max) 
	
	* Creating the long dataset for prescriptions
	
	forvalues y=1/`pregmax' {
	    
		use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear
		keep patid pregid pregstart_num pregend_num
		
		bysort patid: egen seq=seq()
		summ seq
	
		keep if seq==`y'
		drop seq
		count

		forvalues x=0/`wksmax' {
		
			gen date_week_start`x' =.
			gen date_week_end`x' =.
		
			replace date_week_start`x'=pregstart_num+(7*`x') if pregstart_num+(7*`x')<=pregend_num
			format date_week_start`x' %td
			
			replace date_week_end`x'=pregstart_num+(7*(`x'+1)) if pregstart_num+(7*(`x'+1))<=pregend_num
			format date_week_end`x' %td
		
		} 
		
		reshape long date_week_start date_week_end, i(patid pregid pregstart_num pregend_num) j(gestwks)
		
		save "$Tempdatadir\week_dates_preg_`y'.dta", replace
		
	}
		
	forvalues y=1/`pregmax' {
		forvalues x=0/`wksmax' {
			
			use "$Tempdatadir\week_dates_preg_`y'.dta", clear
			
			drop if date_week_start==. & date_week_end==. // empty weeks from the reshape
			replace date_week_end=pregend_num if date_week_end==.
			drop if date_week_start==date_week_end
			
			keep if gestwks==`x'
		
			merge 1:m patid using "$Deriveddir\derived_data\AD_pxn_events_from_All_Therapy_clean_doses.dta", keep(3) nogen keepusing(presc_startdate_num presc_enddate_num prescr_length drugsubstance dd_mg dosage)
			
			drop if dd_mg==.
		
			keep if (date_week_start<=presc_startdate_num & date_week_end>presc_startdate_num) | (date_week_start<=presc_enddate_num & date_week_end>presc_enddate_num) | (date_week_start>=presc_startdate_num & date_week_end<=presc_enddate_num)
			
			if _N>0 {
			
				duplicates drop
				
			}
			
			else if _N==0 {
			    
				disp "no obs"
				
			}
			
			if _N>0 {
			
				duplicates report patid drugsubstance dd_mg
				duplicates drop patid drugsubstance dd_mg, force
				
				duplicates report patid
				
				bysort patid: egen seq=seq()
				summ seq 
				
				reshape wide presc_startdate_num presc_enddate_num drugsubstance prescr_length dd_mg dosage, i(patid pregid pregstart_num pregend_num gestwks date_week_start date_week_end) j(seq)
			
			}
			
			else if _N==0 {
			    
				disp "no obs"
				
			}
		
			save "$Tempdatadir\week_`x'_preg_`y'_pxns.dta", replace
			
		}
	}
	
	forvalues y=1/`pregmax' {
		
		use "$Tempdatadir\week_0_preg_`y'_pxns.dta", clear
	
		forvalues x=1/`wksmax' {
			
			append using "$Tempdatadir\week_`x'_preg_`y'_pxns.dta"
			
		}
		
		save "$Tempdatadir\preg_`y'_weeks_pxns.dta", replace
		
	}
	
	use "$Tempdatadir\preg_1_weeks_pxns.dta", clear
	
	forvalues y=2/`pregmax' {
			
		append using "$Tempdatadir\preg_`y'_weeks_pxns.dta"
			
	}
	
	sort patid pregid gestwks
	
	duplicates drop
	
	forvalues y=1/`pregmax' {
	
		merge 1:1 patid pregid gestwks using "$Tempdatadir\week_dates_preg_`y'.dta", nogen
		
	}
	
	merge m:1 patid pregid using "$Deriveddir\derived_data\pregnancy_cohort_final.dta", keepusing(updated_outcome) nogen
	*merge m:1 patid pregid using "$Datadir\patterns_in_pregnancy_clean_withclasses.dta", keep(3) nogen
	
	sort patid pregid gestwks
	
	drop drugsubstance prescr_length dd_mg dosage
	drop if date_week_start==. 
	drop if updated_outcome==13
	
	replace date_week_end=pregend_num if date_week_end==.
	drop if date_week_start==date_week_end

	gen any_week = 1 if presc_enddate_num1!=.
	codebook pregid if any_week==1
	
	preserve
	
		keep patid pregid gestwks any_week 
		reshape wide any_week, i(patid pregid) j(gestwks)
		gen any_preg=.
		forvalues x=0/52 {
			
			replace any_preg=1 if any_week`x'==1
			
		}
		
		keep patid pregid any_preg
		
		save "$Tempdatadir\exposed.dta", replace
		
	restore
	
	save "$Tempdatadir\long_by_week.dta", replace
	
* Prescription counts by trimester

	* Trimester 1
	
	use "$Tempdatadir\long_by_week.dta", clear
	
	keep if gestwks<14
	
	forvalues z=1/7 {
		
		preserve
	
			keep patid pregid gestwks presc_startdate_num`z'
			
			reshape wide presc_startdate_num`z', i(patid pregid) j(gestwks)
			
			gen presc_startdate_num`z'14=.
			
			forvalues x=0/13 {
				
				local y=`x'+1
				
				gen count_pxns_`x'_t1=.
				replace count_pxns_`x'_t1 = 1 if presc_startdate_num`z'`x'!=. & presc_startdate_num`z'`x'!=presc_startdate_num`z'`y'
				
			}
			
			egen counts_`z'_t1 = rowtotal(count_pxns_0_t1-count_pxns_13_t1)
			
			keep patid pregid counts_`z'_t1
			
			save "$Tempdatadir\pxn_count_t1_`z'.dta", replace
		
		restore
	
	}
	
	use "$Tempdatadir\pxn_count_t1_1.dta", clear
	
	forvalues z=2/7 {
		
		merge 1:1 patid pregid using "$Tempdatadir\pxn_count_t1_`z'.dta", nogen
		
	}
	
	egen counts_t1 = rowtotal(counts_1_t1-counts_7_t1)
	
	keep patid pregid counts_t1
	
	save "$Tempdatadir\pxn_count_t1.dta", replace
	
	* Trimester 2
	
	use "$Tempdatadir\long_by_week.dta", clear
	
	keep if gestwks>13 & gestwks<27
	
	forvalues z=1/7 {
		
		preserve
	
			keep patid pregid gestwks presc_startdate_num`z'
			
			reshape wide presc_startdate_num`z', i(patid pregid) j(gestwks)
			
			gen presc_startdate_num`z'27=.
			
			forvalues x=14/26 {
				
				local y=`x'+1
				
				gen count_pxns_`x'_t2=.
				replace count_pxns_`x'_t2 = 1 if presc_startdate_num`z'`x'!=. & presc_startdate_num`z'`x'!=presc_startdate_num`z'`y'
				
			}
			
			egen counts_`z'_t2 = rowtotal(count_pxns_14_t2-count_pxns_26_t2)
			
			keep patid pregid counts_`z'_t2
			
			save "$Tempdatadir\pxn_count_t2_`z'.dta", replace
		
		restore
	
	}
	
	use "$Tempdatadir\pxn_count_t2_1.dta", clear
	
	forvalues z=2/7 {
		
		merge 1:1 patid pregid using "$Tempdatadir\pxn_count_t2_`z'.dta", nogen
		
	}
	
	egen counts_t2 = rowtotal(counts_1_t2-counts_7_t2)
	
	keep patid pregid counts_t2
	
	save "$Tempdatadir\pxn_count_t2.dta", replace
	
	* Trimester 3
	
	use "$Tempdatadir\long_by_week.dta", clear
	
	keep if gestwks>26
	
	forvalues z=1/7 {
		
		preserve
	
			keep patid pregid gestwks presc_startdate_num`z'
			
			reshape wide presc_startdate_num`z', i(patid pregid) j(gestwks)
			
			gen presc_startdate_num`z'53=.
			
			forvalues x=27/52 {
				
				local y=`x'+1
				
				gen count_pxns_`x'_t3=.
				replace count_pxns_`x'_t3 = 1 if presc_startdate_num`z'`x'!=. & presc_startdate_num`z'`x'!=presc_startdate_num`z'`y'
				
			}
			
			egen counts_`z'_t3 = rowtotal(count_pxns_27_t3-count_pxns_52_t3)
			
			keep patid pregid counts_`z'_t3
			
			save "$Tempdatadir\pxn_count_t3_`z'.dta", replace
		
		restore
	
	}
	
	use "$Tempdatadir\pxn_count_t3_1.dta", clear
	
	forvalues z=2/7 {
		
		merge 1:1 patid pregid using "$Tempdatadir\pxn_count_t3_`z'.dta", nogen
		
	}
	
	egen counts_t3 = rowtotal(counts_1_t3-counts_7_t3)
	
	keep patid pregid counts_t3
	
	save "$Tempdatadir\pxn_count_t3.dta", replace
	
	use "$Tempdatadir\long_by_week.dta", clear
	merge m:1 patid pregid using "$Tempdatadir\pxn_count_t1.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\pxn_count_t2.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\pxn_count_t3.dta", nogen
	
	keep patid pregid count*
	duplicates drop
	
	save "$Tempdatadir\pxn_count.dta", replace
	
	* Discontinuers and continuers during pregnancy - who were exposed during pregnancy but whose prescription ended >2 weeks from the end of pregnancy and those who's prescriptions either overlapped with the end of pregnancy or ended within 2 weeks of the end of pregnacy
	
	use "$Tempdatadir\long_by_week.dta", clear
	
	preserve 
	
		gen discontinuer_preg =.
		replace discontinuer_preg = 1 if (presc_enddate_num1<pregend_num-14 & presc_enddate_num1!=.) | (presc_enddate_num2<pregend_num-14 & presc_enddate_num2!=.) | (presc_enddate_num3<pregend_num-14 & presc_enddate_num3!=.) | (presc_enddate_num4<pregend_num-14 & presc_enddate_num4!=.) | (presc_enddate_num5<pregend_num-14 & presc_enddate_num5!=.) | (presc_enddate_num6<pregend_num-14 & presc_enddate_num6!=.) | (presc_enddate_num7<pregend_num-14 & presc_enddate_num7!=.)
		replace discontinuer_preg = 0 if (presc_enddate_num1>=pregend_num-14 & presc_enddate_num1!=.) | (presc_enddate_num2>=pregend_num-14 & presc_enddate_num2!=.) | (presc_enddate_num3>=pregend_num-14 & presc_enddate_num3!=.) | (presc_enddate_num4>=pregend_num-14 & presc_enddate_num4!=.) | (presc_enddate_num5>=pregend_num-14 & presc_enddate_num5!=.) | (presc_enddate_num6>=pregend_num-14 & presc_enddate_num6!=.) | (presc_enddate_num7>=pregend_num-14 & presc_enddate_num7!=.)
	
		keep patid pregid gestwks discontinuer_preg
		reshape wide discontinuer_preg, i(patid pregid) j(gestwks)
		
		gen discontinuer =.
		
		forvalues x=0/52 {
			
			replace discontinuer = 0 if discontinuer_preg`x'==0
			replace discontinuer = 1 if discontinuer_preg`x'==1 & discontinuer!=0
			
		}
		
		keep patid pregid discontinuer
		
		label define discont_lb 0"Continued throughout pregnancy" 1"Discontinued prior to the end of pregnancy"
		label values discontinuer discont_lb
		tab discontinuer
		
		save "$Tempdatadir\continuers.dta", replace
		
	restore
	
	merge m:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\continuers.dta", nogen
	
	sort patid pregid gestwks
	
	save "$Tempdatadir\long_by_week_continuers.dta", replace
	
	* Discontinuation by trimester
	
	use "$Tempdatadir\long_by_week_continuers.dta", clear
	merge m:1 patid pregid using "$Datadir\patterns_in_pregnancy_clean.dta", keepusing(any_w) keep(3) nogen
	
	keep patid pregid gestwks any_preg discontinuer any_w presc_startdate_num1
	
	rename presc_startdate_num1 presc_startdate_num
	
	gen exposed = 1 if presc_startdate_num!=.
	
	drop presc_startdate_num
	
	reshape wide exposed, i(patid pregid any_w discontinuer) j(gestwks)
	
	gen discont_trimester =.
	
	forvalues x=0/13 {
		
		replace discont_trimester = 1 if exposed`x'==1
		
	}
	
	forvalues x=14/26 {
		
		replace discont_trimester = 2 if exposed`x'==1
		
	}
	
	forvalues x=27/52 {
		
		replace discont_trimester = 3 if exposed`x'==1
		
	}
	
	tab discontinuer, m
	tab discont_trimester, m
	
	replace discontinuer = 0 if discont_trimester==3 & any_w==1
	replace discont_trimester =. if discontinuer==0
	
	tab discont_trimester if discont_trimester!=.
	
	keep patid pregid discontinuer discont_trimester
	
	save "$Tempdatadir\continuers.dta", replace
		
	* Differentiate single drug from multi drug regimens
	
	use "$Tempdatadir\long_by_week_continuers.dta", clear
	
	gen single_drug =.
	replace single_drug = 1 if drugsubstance1!=. & drugsubstance2==.
	replace single_drug = 0 if drugsubstance1!=drugsubstance2 & drugsubstance1!=. & drugsubstance2!=.
	
	keep patid pregid gestwks single_drug
	reshape wide single_drug, i(patid pregid) j(gestwks)
	
	gen potential_multi_drug =. 
	
	forvalues x=1/52 {
		
		replace potential_multi_drug=1 if single_drug`x'==0
		
	}
	
	keep patid pregid potential_multi_drug
	keep if potential_multi_drug==1
	
	merge 1:m patid pregid using "$Tempdatadir\continuers.dta", keep(3) nogen
	
	tab discontinuer // 65% of potential multi-drug people continued throughout pregnancy
	
	merge 1:m patid pregid using "$Tempdatadir\long_by_week_continuers.dta", keep(3) nogen
	
	codebook pregid
	sort patid pregid gestwks
	
		* Differentiating probable switchers from multi-drug regimens
		gen active_pxns = 1 if drugsubstance1!=. & drugsubstance2==. & drugsubstance3==. & drugsubstance4==. & drugsubstance5==. 
		replace active_pxns = 2 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3==. & drugsubstance4==. & drugsubstance5==. 
		replace active_pxns = 3 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4==. & drugsubstance5==.
		replace active_pxns = 4 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5==.
		replace active_pxns = 5 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=.
		replace active_pxns = 6 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=. & drugsubstance6!=. 
		replace active_pxns = 7 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=. & drugsubstance6!=. & drugsubstance7!=.
		
		replace active_pxns = 1 if active_pxns==2 & drugsubstance1==drugsubstance2 
		replace active_pxns = 2 if active_pxns==3 & drugsubstance2==drugsubstance3 & drugsubstance1!=drugsubstance2 
		replace active_pxns = 3 if active_pxns==4 & drugsubstance3==drugsubstance4 & drugsubstance2!=drugsubstance3 & presc_startdate_num3==presc_startdate_num4
		replace active_pxns = 4 if active_pxns==5 & drugsubstance4==drugsubstance5 & drugsubstance3!=drugsubstance4 & presc_startdate_num4==presc_startdate_num5
		replace active_pxns = 5 if active_pxns==6 & drugsubstance5==drugsubstance6 & drugsubstance4!=drugsubstance5 & presc_startdate_num4==presc_startdate_num5
	
		keep patid pregid gestwks drugsubstance* active_pxns
		* Number of weeks that someone has more than two prescriptions happening (those with only a short number of weeks with more than one prescription likely to be switchers as opposed to multi-drug regimen people)
		bysort patid pregid active_pxns: egen multi=seq() if active_pxns>1 & active_pxns!=.
		sort patid pregid gestwks
		bysort patid pregid: egen total_multi=max(multi)
		
		keep patid pregid total_multi
		duplicates drop
		
		preserve
		
			drop if total_multi<=4
			drop total_multi
			gen multi_drug=1
			duplicates drop
			
			count // 2,120 patients who had at least two prescriptions for different drug substances that overlapped by more than 4 weeks
			
			save "$Tempdatadir\multi_drug_regimen.dta", replace
			
		restore
		
		keep if total_multi<=4
		drop total_multi
		gen switching=1
		
		count // 3,519 patients who had overlapping prescriptions for different drug substance that overlapped by less than 2 weeks, thus defined as a switch as opposed to a multi-drug regimen
			
		save "$Tempdatadir\switching_single_drug.dta", replace
	
	* Now we have identified the multi-drug people we can investigate their patterns separately to the single drug people by excluding them from the continuers or only looking at them without the single drug regimen people
	
		use "$Tempdatadir\long_by_week_continuers.dta", clear
		merge m:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
		merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta",nogen
		merge m:1 patid pregid using "$Tempdatadir\continuers.dta", nogen
		merge m:1 patid pregid using "$Tempdatadir\switching_single_drug.dta", nogen // add in the switching already coded up from above
	
		codebook pregid if any_preg==1 & multi_drug!=1 // 77,024 single drug regimen users
		keep if any_preg==1 & multi_drug!=1
		
		codebook pregid if switching==1 // 3,519 switchers identified from step above - this utilises all the data held in drugsubstance2-5 so can identify the remainder of the switchers from drugsubstance1
		
		keep patid pregid gestwks drugsubstance1
		rename drugsubstance1 drugsubstance
		reshape wide drugsubstance, i(patid pregid) j(gestwks)
		
		gen switching=.
		
		local wksmax0 = 48-1
		
		forvalues x=0/`wksmax0' {
			forvalues y=1/48 {
			
				replace switching=1 if drugsubstance`x'!=drugsubstance`y' & drugsubstance`x'!=. & drugsubstance`y'!=.
		
			}
		}
		
		keep patid pregid switching
		keep if switching==1
		
		append using "$Tempdatadir\switching_single_drug.dta"
		duplicates drop
		
		count // 6,746 pregnancies with evidence of switching product during pregnancy and a single drug regimen (both continuers and discontinuers)
		
		save "$Tempdatadir\switching_single_drug.dta", replace
		
	* Dose changes 
	
		use "$Tempdatadir\long_by_week_continuers.dta", clear
		merge m:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
		merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", nogen
		
		keep if any_preg==1 & multi_drug!=1 // look at the single drug regimen continuers first
		
		sort patid pregid gestwks
		
		* First, I need to deal with the issue of the double prescriptions for the same product to make composite doses
		
	gen flag=.
		
	forvalues x=1/6 {
		
		local y=`x'+1
		
		replace flag=1 if presc_startdate_num`x'==presc_startdate_num`y' & drugsubstance`x'==drugsubstance`y' & drugsubstance`x'!=.
		
	} 
		
	codebook pregid if flag==1 & discontinuer==0
	br if flag==1
	
	keep if flag==1
	keep *id gestwks dd_mg* drugsubstance*
	
	gen drugsubstance8=.
	gen dd_mg8=.
	
	forvalues x=1/6 {
		
		local y=`x'+1
		local z=`x'+2
		
		replace dd_mg`x'=dd_mg`x'+dd_mg`y' if drugsubstance`x'==drugsubstance`y' & drugsubstance`x'!=.
		replace dd_mg`x'=dd_mg`x'+dd_mg`y'+dd_mg`z' if drugsubstance`x'==drugsubstance`y' & drugsubstance`y'==drugsubstance`z' & drugsubstance`x'!=. & drugsubstance`y'!=.
		
		replace dd_mg`y'=. if drugsubstance`y'==drugsubstance`x' & dd_mg`y'!=dd_mg`x'
		
	}
	
	replace drugsubstance2=. if dd_mg2==.
	replace drugsubstance3=. if dd_mg3==.
	replace drugsubstance4=. if dd_mg4==.
	replace drugsubstance5=. if dd_mg5==.
	replace drugsubstance6=. if dd_mg6==.
	replace drugsubstance7=. if dd_mg7==.
	
	save "$Tempdatadir\double_pxns.dta", replace
	
	use "$Tempdatadir\long_by_week_continuers.dta", clear
	*merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", keep(1) nogen
	merge 1:1 patid pregid gestwks using "$Tempdatadir\double_pxns.dta", update replace
	
	forvalues x=1/6 {
		
		local y=`x'+1
		
		replace dd_mg`y'=. if drugsubstance`y'==drugsubstance`x' & dd_mg`y'!=dd_mg`x'
		
	}
	
	foreach y in presc_startdate_num presc_enddate_num prescr_length dosage {
		
		replace `y'2=. if dd_mg2==. & drugsubstance2==drugsubstance1
		replace `y'3=. if dd_mg3==. & drugsubstance3==drugsubstance2
		replace `y'4=. if dd_mg4==. & drugsubstance4==drugsubstance3
		replace `y'5=. if dd_mg5==. & drugsubstance5==drugsubstance4
		replace `y'6=. if dd_mg6==. & drugsubstance6==drugsubstance5
		replace `y'7=. if dd_mg7==. & drugsubstance7==drugsubstance6
			
	}

	replace drugsubstance2=. if dd_mg2==.
	replace drugsubstance3=. if dd_mg3==.
	replace drugsubstance4=. if dd_mg4==.
	replace drugsubstance5=. if dd_mg5==.
	replace drugsubstance6=. if dd_mg6==.
	replace drugsubstance7=. if dd_mg7==.
	
	tab dd_mg1
	tab dosage1
	
	preserve
	
		keep drugsubstance1 dd_mg1 dosage1 _m
		drop if _m==5
		drop _m
		duplicates drop
		
		sort drugsubstance1 dd_mg1
		br
		
		save "$Tempdatadir\dd_dosage.dta", replace
		
	restore
	
	rename _m doubles
	
	save "$Tempdatadir\long_by_week_continuers_doubleds_sorted.dta", replace
	
	do "$Dodir\1_cleaning\4a_long doses.do"
	
	use "$Tempdatadir\long patterns doubleds cat sorted.dta", clear
	
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", keep(1) nogen
	
	sort patid pregid gestwks
	
	codebook pregid
	
	keep if any_preg==1 // only those exposed to a single drug regimen
	
	bysort patid pregid: egen dealt=max(doubles)
	
	forvalues w=1/35 {
		
		preserve
		
			keep if drugsubstance1==`w'
			
			if _N>0 {
				
				keep patid pregid gestwks dosage1 dealt // I have categorised these as single drug regimen people - any overlapping prescriptions are only by two weeks max so I can ascertain any dose changes from dosage1
			
				rename dosage1 dosage
				drop gestwks
				
				bysort patid pregid: egen gestwks=seq()
				
				sum gestwks
				local wks=`r(max)'-2
			
				reshape wide dosage, i(patid pregid dealt) j(gestwks)
				
				gen dose_increase=.
				forvalues x=1/`wks' {
						
					local y=`x'+1
					local z=`x'+2
					replace dose_increase=1 if dosage`x'<dosage`y' & dosage`x'<dosage`z' & dosage`x'!=. & dosage`y'!=. & dosage`z'!=.
					
				}

				gen dose_decrease=.
				forvalues x=1/`wks' {
						
					local y=`x'+1
					local z=`x'+2
					replace dose_decrease=1 if dosage`x'>dosage`y' & dosage`x'>dosage`z' & dosage`x'!=. & dosage`y'!=. & dosage`z'!=.
					
				}
				
				gen dose_fluctuation = 1 if dose_increase==1 & dose_decrease==1
				
				tab dose_increase
				tab dose_decrease
				tab dose_fluctuation
				
				keep patid pregid dose_*
			
			}
			
			else if _N==0 {
				
				keep patid pregid
				
			}
			
			save "$Tempdatadir\dose_changes_single_`w'.dta", replace
		
		restore
	
	}
	
	use "$Tempdatadir\dose_changes_single_1.dta", clear
	
	forvalues w=2/35 {
		
		merge 1:1 patid pregid using "$Tempdatadir\dose_changes_single_`w'.dta", update replace nogen
		
	}
	
	save "$Tempdatadir\dose_changes_single.dta", replace
	
* Check all the single drug regimen stuff together

	use "$Tempdatadir\exposed.dta", clear
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", nogen
	
	keep if any_preg==1
	drop if multi_drug==1
	
	count // 76,770 single drug regimen users 
	
	merge m:1 patid pregid using "$Tempdatadir\continuers.dta", keep(3) nogen
	
	tab discontinuer
	
	merge m:1 patid pregid using "$Tempdatadir\switching_single_drug.dta", nogen
	
	tab switching
	
	merge m:1 patid pregid using "$Tempdatadir\dose_changes_single.dta", nogen
	
	gen dose_changes =.
	replace dose_changes = 1 if dose_decrease==1
	replace dose_changes = 2 if dose_increase==1
	replace dose_changes = 3 if dose_fluctuation==1
	
	label define dose_lb 1"Dose reduction" 2"Dose increase" 3"Dose fluctuation"
	label values dose_changes dose_lb
	
	tab dose_changes
	
	gen multiple_changes =.
	replace multiple_changes = 1 if switching==1 & dose_changes!=.
	
	tab multiple_changes
	
	gen no_changes =.
	replace no_changes = 1 if switching==. & dose_changes==.
	
	tab no_changes
	
	tab no_changes if discontinuer==0
	tab no_changes if discontinuer==1
	
	gen regimen_changes =.
	replace regimen_changes = 1 if switching==1
	replace regimen_changes = 2 if dose_changes==1
	replace regimen_changes = 3 if dose_changes==2
	replace regimen_changes = 4 if dose_changes==3
	replace regimen_changes = 5 if multiple_changes==1
	replace regimen_changes = 6 if no_changes==1
	
	label define regimens_lb 1"Switching" 2"Dose reduction" 3"Dose increase" 4"Dose fluctuation" 5"Multiple regimen changes" 6"No regimen changes"
	label values regimen_changes regimens_lb
	
	tab regimen_changes if discontinuer==0
	tab regimen_changes if discontinuer==1
	
	keep patid pregid regimen_changes
	
	gen single_drug=1
	
	save "$Tempdatadir\single_drug_patterns_doublesorted.dta", replace
	
****************************************************************************************

* Multi-drug regimens

	use "$Tempdatadir\long_by_week_continuers_doubleds_sorted.dta", clear
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", keep(3) nogen
	
	codebook pregid // 2,120 multi-drug regimen people
	sort patid pregid gestwks
	
	/* Not sure what this is
	gen flag=.

	foreach x in presc_startdate_num presc_enddate_num drugsubstance prescr_length dd_mg dosage {
		
		replace flag=1 if `x'2==. & `x'3!=.
		replace `x'2 = `x'3 if `x'2==. & `x'3!=.
		replace `x'3 =. if flag==1
		
	}
	
	drop flag*/
	
	* Adding a product 
	gen number_in_regimen =.
	replace number_in_regimen = 1 if drugsubstance1!=. & drugsubstance2==.
	replace number_in_regimen = 2 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3==.
	replace number_in_regimen = 3 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4==.
	replace number_in_regimen = 4 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5==.
	replace number_in_regimen = 5 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=.
	replace number_in_regimen = 6 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=. & drugsubstance6!=.
	replace number_in_regimen = 7 if drugsubstance1!=. & drugsubstance2!=. & drugsubstance3!=. & drugsubstance4!=. & drugsubstance5!=. & drugsubstance6!=. & drugsubstance7!=.
		
	keep patid pregid gestwks number_in_regimen
	
	replace number_in_regimen = 0 if number_in_regimen==.
	
	reshape wide number_in_regimen, i(patid pregid) j(gestwks)
	
	forvalues x=0/43 {
		
		local y=`x'+1
		
		replace number_in_regimen`y'=number_in_regimen`x' if number_in_regimen`y'==.
		
			// to fill in the gaps between prescriptions just to identify adding and dropping
		
	}
	
	* In the distinction between multi-drug regimen people and switchers I have said that if they have prescriptions overlapping by more than 4 weeks then they are polypharmacy as opposed to switching - this needs to be incorporated into the product added and dropped - at the moment it's picking up short breaks between second prescriptions as dropping but they potentially pick right back up again after a week
	
	gen product_added =.
	
	forvalues t=1/5 {
		forvalues v=0/40 {
			
			local u=`t'+1
			
			local w=`v'+1
			local x=`v'+2
			local y=`v'+3
			local z=`v'+4
			
			replace product_added = 1 if number_in_regimen`v'==`t' & number_in_regimen`w'==`u' & number_in_regimen`x'==`u' & number_in_regimen`y'==`u' & number_in_regimen`z'==`u'
			
		}
	}
	
	gen product_dropped =.
	
	forvalues t=2/6 {
		forvalues v=0/40 {
			
			local u=`t'-1
			
			local w=`v'+1
			local x=`v'+2
			local y=`v'+3
			local z=`v'+4
			
			replace product_dropped = 1 if number_in_regimen`v'==`t' & number_in_regimen`w'==`u' & number_in_regimen`x'==`u' & number_in_regimen`y'==`u' & number_in_regimen`z'==`u'
			
		}
	}
	
	gen added_and_dropped =.
	replace added_and_dropped = 1 if product_added==1 & product_dropped==1
	
	gen product =.
	replace product = 1 if product_added==1
	replace product = 2 if product_dropped==1
	replace product = 3 if added_and_dropped==1
	
	tab product
	
	keep patid pregid product
	
	save "$Tempdatadir\multi_drug_product.dta", replace
	
	* Dose changes - I think this is actually clinically redundant for multi-drug regimen people, dose changes are likely particularly in drug regimens where cross-tapering is advised 
	
	use "$Tempdatadir\long_by_week_continuers_doubleds_sorted.dta", clear
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", keep(3) nogen
	
	codebook pregid // 2,586 multi-drug regimen people
	sort patid pregid gestwks
	
	keep patid pregid gestwks drugsubstance* dosage*
	gen dosage8=.
	
	reshape wide drugsubstance* dosage*, i(patid pregid) j(gestwks)
	
	gen dose_increase =.
	
	forvalues x=1/8 {
		forvalues y=0/43 {
			
			local z=`y'+1
			
			replace dose_increase = 1 if drugsubstance`x'`y'==drugsubstance`x'`z' & dosage`x'`y'<dosage`x'`z' & dosage`x'`z'!=.
			
		}
	}
	
	gen dose_decrease =.
	
	forvalues x=1/8 {
		forvalues y=0/43 {
			
			local z=`y'+1
			
			replace dose_decrease = 1 if drugsubstance`x'`y'==drugsubstance`x'`z' & dosage`x'`y'>dosage`x'`z' & dosage`x'`y'!=.
			
		}
	}
	
	gen dose_fluc = 1 if dose_increase==1 & dose_decrease==1
	
	tab dose_increase
	tab dose_decrease
	tab dose_fluc
	
	gen dose_changes_multi =.
	replace dose_changes_multi = 1 if dose_increase==1 | dose_decrease==1 | dose_fluc==1
	tab dose_changes_multi
	
	count
	
	keep patid pregid dose_changes_multi
	
	save "$Tempdatadir\multi_drug_dose.dta", replace
	
	* No changes
	
	use "$Tempdatadir\long_by_week_continuers_doubleds_sorted.dta", clear
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_regimen.dta", keep(3) nogen
	
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_product.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\multi_drug_dose.dta", nogen
	
	keep patid pregid multi_drug product dose_changes_multi
	duplicates drop
	
	tab multi_drug
	tab product
	tab dose_changes_multi
	
	gen multiple_changes = 1 if product!=. & dose_changes_multi==1
	tab multiple_changes
	
	gen no_changes = 1 if product==. & dose_changes_multi==.
	
	gen regimen_changes_multi =.
	replace regimen_changes_multi = 1 if product==1
	replace regimen_changes_multi = 2 if product==2
	replace regimen_changes_multi = 3 if product==3
	replace regimen_changes_multi = 4 if dose_changes_multi==1
	replace regimen_changes_multi = 5 if multiple_changes==1
	replace regimen_changes_multi = 6 if no_changes==1
	
	tab regimen_changes_multi // very few people change dose without also making changes to products (adding and/or dropping) - consider removing?
	
	label define multi_lb 1"Product added" 2"Product dropped" 3"Products added & dropped" 4"Dose changes" 5"Multiple changes" 6"No changes"
	label values regimen_changes_multi multi_lb
	tab regimen_changes_multi
	
	keep patid pregid multi_drug regimen_changes_multi
	
	save "$Tempdatadir\multi_drug_patterns.dta", replace
	
****************************************************************************************

use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear
	drop if updated_outcome==13
	merge m:1 patid pregid using "$Datadir\patterns_in_pregnancy.dta", keepusing(any_l any_m any_n any_o any_a any_b any_c any_w any_x any_y any_z) keep(3) nogen
	merge 1:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\continuers.dta", nogen
	*merge m:1 patid pregid using "$Tempdatadir\trimester_discont.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\single_drug_patterns_doublesorted.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\multi_drug_patterns.dta", nogen
	
	* Prevalent and incident users
	gen prevalent = 1 if any_o==1 & any_preg==1
	replace prevalent = 0 if any_o==. & any_preg==1
	tab prevalent
	
	keep if prevalent==0
	keep if updated_outcome ==4
	keep patid pregid
	merge 1:m patid pregid using "$Tempdatadir\long_by_week.dta", keep(3)
	sort patid pregid gestwks
	keep patid pregid gestwks presc_startdate_num1
	rename presc_startdate_num1 prescribed
	
	replace prescribed = gestwks if prescribed !=.
	format prescribed %9.0fc
	
	reshape wide prescribed, i(patid pregid) j(gestwks)
	
	gen incident_wk=.
	
	forvalues x=0/23 {
	
	replace incident_wk = prescribed`x' if prescribed`x'!=. & incident_wk==.
	
	}
	
	tab incident_wk
	
	keep patid pregid incident_wk
	
	save "$Datadir\incident_wk.dta", replace
	
* Dates for incident users
	
	use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear
	drop if updated_outcome==13
	merge m:1 patid pregid using "$Datadir\patterns_in_pregnancy.dta", keepusing(any_l any_m any_n any_o any_a any_b any_c any_w any_x any_y any_z) keep(3) nogen
	merge 1:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\continuers.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\trimester_discont.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\single_drug_patterns_doublesorted.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\multi_drug_patterns.dta", nogen
	
	* Prevalent and incident users
	gen prevalent = 1 if any_o==1 & any_preg==1
	replace prevalent = 0 if any_o==. & any_preg==1
	tab prevalent
	
	keep patid pregid prevalent
	
	merge 1:m patid pregid using "$Tempdatadir\long_by_week.dta", keep(3)
	sort patid pregid gestwks
	
	keep patid pregid gestwks presc_startdate_num1
	
	reshape wide presc_startdate_num1, i(patid pregid) j(gestwks)
	
	gen presc_startdate_num1a =.
	
	forvalues x=0/52 {
		
		replace presc_startdate_num1a = presc_startdate_num1`x' if presc_startdate_num1`x'!=. & presc_startdate_num1a==.
		
	}
	
	format presc_startdate_num1a %td
	
	keep patid pregid presc_startdate_num1a
	
	save "$Tempdatadir\preg_presc_start_date.dta", replace
	
****************************************************************************************
	
* Knit it all together
	
	use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear
	drop if updated_outcome==13
	merge m:1 patid pregid using "$Datadir\patterns_in_pregnancy.dta", keepusing(any_l any_m any_n any_o any_a any_b any_c any_w any_x any_y any_z) keep(3) nogen
	merge 1:1 patid pregid using "$Tempdatadir\exposed.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\continuers.dta", nogen
	*merge m:1 patid pregid using "$Tempdatadir\trimester_discont.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\single_drug_patterns_doublesorted.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\multi_drug_patterns.dta", nogen
	merge 1:1 patid pregid using "$Tempdatadir\preg_presc_start_date.dta", nogen
	
	* Prevalent and incident users
	gen prevalent = 1 if any_o==1 & any_preg==1
	replace prevalent = 0 if any_o==. & any_preg==1
	tab prevalent
	
	count
	
	merge 1:1 patid pregid using "$Datadir\incident_wk.dta", nogen
	
	count
	
	* Any exposure during pregnancy
	tab any_preg
	recode any_preg .=0
	tab any_preg // 7.7% exposed during pregnancy
	
	* Those on a multi-drug regimen
	tab multi_drug
	recode multi_drug .=0 if any_preg==1
	tab multi_drug // 2.7% using a mutli-drug regimen
	
	* Discontinuers
	tab discontinuer // 44% continued throughout pregnancy
	tab discont_trimester // majority discontinue in T1 (81%)
	
	* Regimen changes among single drug regimens
	tab regimen_changes if discontinuer==0 // much higher no changes than before driven up by losses (which had previously over-inflated the T1 discontinuers)
	
	* Regimen changes among multi-drug regimens
	tab regimen_changes_multi if discontinuer==0 // very few exclusive dose changes consider dropping
	
	tab updated_outcome
	
	* Stratified by exposure pre-pregnancy
	tab discont_trimester if prevalent==1
	tab discont_trimester if prevalent==0
	
	tab regimen_changes if prevalent==1 & discontinuer==0
	tab regimen_changes if prevalent==0 & discontinuer==0
	
	* Stratified by outcome type
	tab discont_trimester if inlist(updated_outcome,4,5,6,7,8,9,10)
	tab discont_trimester if inlist(updated_outcome,1,2,3,11,12)
	
	tab regimen_changes if inlist(updated_outcome,4,5,6,7,8,9,10) & discontinuer==0
	tab regimen_changes if inlist(updated_outcome,1,2,3,11,12) & discontinuer==0
	
	save "$Datadir\patterns_in_pregnancy_long.dta", replace
	
****************************************************************************************

* Adding class info

	use "$Tempdatadir\long_by_week_continuers.dta", clear
	
	keep patid pregid drugsubstance*
	
	decode drugsubstance1, generate(drugsubstance_1)
	decode drugsubstance2, generate(drugsubstance_2) 
	decode drugsubstance3, generate(drugsubstance_3) 
	decode drugsubstance4, generate(drugsubstance_4)
	decode drugsubstance5, generate(drugsubstance_5)
	decode drugsubstance6, generate(drugsubstance_6)
	decode drugsubstance7, generate(drugsubstance_7)
	
	keep patid pregid drugsubstance_*
	
	gen ssri=.
	gen snri=.
	gen tca=.
	gen other=.
	
	forvalues x=1/7 {
	
		replace ssri = 1 if drugsubstance_`x'=="citalopram" | drugsubstance_`x'=="escitalopram" | drugsubstance_`x'=="fluoxetine" | drugsubstance_`x'=="fluvoxamine" | drugsubstance_`x'=="paroxetine" | drugsubstance_`x'=="sertraline"
		
		replace snri = 1 if drugsubstance_`x'=="duloxetine" | drugsubstance_`x'=="reboxetine" | drugsubstance_`x'=="venlafaxine"
		
		replace tca = 1 if drugsubstance_`x'=="amitriptyline" | drugsubstance_`x'=="amoxapine" | drugsubstance_`x'=="butriptyline" | drugsubstance_`x'=="clomipramine" | drugsubstance_`x'=="desipramine" | drugsubstance_`x'=="dosulepin" | drugsubstance_`x'=="doxepin" | drugsubstance_`x'=="imipramine" | drugsubstance_`x'=="lofepramine" | drugsubstance_`x'=="maprotiline" | drugsubstance_`x'=="nortriptyline" | drugsubstance_`x'=="protriptyline" | drugsubstance_`x'=="trimipramine"
 
		replace other = 1 if drugsubstance_`x'=="agomelatine" | drugsubstance_`x'=="isocarboxazid" | drugsubstance_`x'=="mianserin" | drugsubstance_`x'=="mirtazapine" | drugsubstance_`x'=="moclobemide" | drugsubstance_`x'=="nefazodone" | drugsubstance_`x'=="phenelzine" | drugsubstance_`x'=="tranylcypromine" | drugsubstance_`x'=="trazodone" | drugsubstance_`x'=="tryptophan" | drugsubstance_`x'=="vortioxetine" 
		
	}
	
	drop drugsubstance* 
	drop if ssri==. & snri==. & tca==. & other==.
	
	bysort patid pregid: egen seq=seq()
	
	reshape wide ssri snri tca other, i(patid pregid) j(seq)
	
	gen ssri=.
	gen snri=.
	gen tca=.
	gen other=.
	
	forvalues x=1/46 {
		
		replace ssri = 1 if ssri`x'==1
		replace snri = 1 if snri`x'==1
		replace tca = 1 if tca`x'==1
		replace other = 1 if other`x'==1
		
	}
	
	keep patid pregid ssri snri tca other
	
	foreach x in ssri snri tca other {
		
		replace `x' = 0 if `x'==.
		
	}
	
	gen total = ssri + snri + tca + other
	
	gen multi = 1 if total>1
	
	gen class_preg = 1 if ssri==1 & multi==.
	replace class_preg = 2 if snri==1 & multi==.
	replace class_preg = 3 if tca==1 & multi==.
	replace class_preg = 4 if other==1 & multi==.
	replace class_preg = 5 if multi==1
	
	label define class_lb 1"SSRI exposed" 2"SNRI exposed" 3"TCA exposed" 4"Other exposed" 5"Multiple exposed"
	label values class_preg class_lb
	
	tab class_preg, m
	
	keep patid pregid class_preg
	duplicates drop
	
	save "$Tempdatadir\class_preg.dta", replace
	
* During trimester one

	use "$Tempdatadir\long_by_week_continuers.dta", clear
	
	keep if gestwks<14
	
	keep patid pregid drugsubstance*
	
	decode drugsubstance1, generate(drugsubstance_1)
	decode drugsubstance2, generate(drugsubstance_2) 
	decode drugsubstance3, generate(drugsubstance_3) 
	decode drugsubstance4, generate(drugsubstance_4)
	decode drugsubstance5, generate(drugsubstance_5)
	decode drugsubstance6, generate(drugsubstance_6)
	decode drugsubstance7, generate(drugsubstance_7)
	
	keep patid pregid drugsubstance_*
	
	gen ssri=.
	gen snri=.
	gen tca=.
	gen other=.
	
	forvalues x=1/7 {
	
		replace ssri = 1 if drugsubstance_`x'=="citalopram" | drugsubstance_`x'=="escitalopram" | drugsubstance_`x'=="fluoxetine" | drugsubstance_`x'=="fluvoxamine" | drugsubstance_`x'=="paroxetine" | drugsubstance_`x'=="sertraline"
		
		replace snri = 1 if drugsubstance_`x'=="duloxetine" | drugsubstance_`x'=="reboxetine" | drugsubstance_`x'=="venlafaxine"
		
		replace tca = 1 if drugsubstance_`x'=="amitriptyline" | drugsubstance_`x'=="amoxapine" | drugsubstance_`x'=="butriptyline" | drugsubstance_`x'=="clomipramine" | drugsubstance_`x'=="desipramine" | drugsubstance_`x'=="dosulepin" | drugsubstance_`x'=="doxepin" | drugsubstance_`x'=="imipramine" | drugsubstance_`x'=="lofepramine" | drugsubstance_`x'=="maprotiline" | drugsubstance_`x'=="nortriptyline" | drugsubstance_`x'=="protriptyline" | drugsubstance_`x'=="trimipramine"
 
		replace other = 1 if drugsubstance_`x'=="agomelatine" | drugsubstance_`x'=="isocarboxazid" | drugsubstance_`x'=="mianserin" | drugsubstance_`x'=="mirtazapine" | drugsubstance_`x'=="moclobemide" | drugsubstance_`x'=="nefazodone" | drugsubstance_`x'=="phenelzine" | drugsubstance_`x'=="tranylcypromine" | drugsubstance_`x'=="trazodone" | drugsubstance_`x'=="tryptophan" | drugsubstance_`x'=="vortioxetine" 
		
	}
	
	drop drugsubstance* 
	drop if ssri==. & snri==. & tca==. & other==.
	
	bysort patid pregid: egen seq=seq()
	
	reshape wide ssri snri tca other, i(patid pregid) j(seq)
	
	gen ssri=.
	gen snri=.
	gen tca=.
	gen other=.
	
	forvalues x=0/14 {
		
		replace ssri = 1 if ssri`x'==1
		replace snri = 1 if snri`x'==1
		replace tca = 1 if tca`x'==1
		replace other = 1 if other`x'==1
		
	}
	
	keep patid pregid ssri snri tca other
	
	foreach x in ssri snri tca other {
		
		replace `x' = 0 if `x'==.
		
	}
	
	gen total = ssri + snri + tca + other
	
	gen multi = 1 if total>1
	
	gen class_t1 = 1 if ssri==1 & multi==.
	replace class_t1 = 2 if snri==1 & multi==.
	replace class_t1 = 3 if tca==1 & multi==.
	replace class_t1 = 4 if other==1 & multi==.
	replace class_t1 = 5 if multi==1
	
	label define class_lb 1"SSRI exposed" 2"SNRI exposed" 3"TCA exposed" 4"Other exposed" 5"Multiple exposed"
	label values class_t1 class_lb
	
	tab class_t1, m
	
	keep patid pregid class_t1
	duplicates drop
	
	save "$Tempdatadir\class_t1.dta", replace
	
* Highest dose during trimester one

	use "$Tempdatadir\long_by_week_continuers.dta", clear
	
	keep if gestwks<14
	
	keep patid pregid gestwks dosage*
	
	egen dosage = rowmax(dosage1-dosage7)
	
	keep patid pregid gestwks dosage
	
	reshape wide dosage, i(patid pregid) j(gestwks)
	
	egen highest_dose_t1 = rowmax(dosage0-dosage13)
	
	keep patid pregid highest_dose_t1
	duplicates drop
	
	save "$Tempdatadir\dose_t1.dta", replace
	
* Knit together

	use "$Datadir\patterns_in_pregnancy_long.dta", clear
	
	merge m:1 patid pregid using "$Tempdatadir\class_t1.dta", nogen
	merge m:1 patid pregid using "$Tempdatadir\dose_t1.dta", nogen
	
	merge m:1 patid pregid using "$Tempdatadir\class_preg.dta", nogen
	
	merge 1:1 patid pregid using "$Tempdatadir\pxn_count.dta", nogen
	
	save "$Datadir\patterns_in_pregnancy_long.dta", replace

********************************************************************************

 * Stop logging, translate .smcl into .pdf and erase .smcl

	log close long_patterns
	
	translate "$Logdir\1_cleaning\3_long patterns.smcl" "$Logdir\1_cleaning\3_long patterns.pdf", replace
	
	erase "$Logdir\1_cleaning\3_long patterns.smcl"

********************************************************************************
