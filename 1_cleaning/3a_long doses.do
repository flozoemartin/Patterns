********************************************************************************************

* Deriving doses in the long patterns dataset

* Author: Flo Martin

* Date: 03/01/2024

********************************************************************************************

	use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear

	bysort patid: egen seq=seq()
	summ seq // max number of pregnancies for a mother is 16
	local pregmax = r(max) 

	forvalues x=1/`pregmax' {
		
		use "$Deriveddir\derived_data\pregnancy_cohort_final.dta", clear
		count
		
		keep patid pregid pregstart_num pregend_num pregend_num secondtrim_num thirdtrim_num pregnum_new
		
		sort patid pregid
		
		bysort patid: egen seq=seq()
		bysort pregid (patid): keep if seq==`x'
		
		merge 1:m patid using "$Deriveddir\derived_data\AD_pxn_events_from_All_Therapy_clean.dta", keep(match) nogen
		
		* Define periods of interest
		
		gen prepreg_3month_num  = round(pregstart_num-3*30.5)
		gen prepreg_6month_num  = round(pregstart_num-6*30.5)
		gen prepreg_9month_num  = round(pregstart_num-9*30.5)
		gen prepreg_12month_num = round(pregstart_num-12*30.5)

		gen postpreg_3month_num  = round(pregend_num+3*30.5)
		gen postpreg_6month_num  = round(pregend_num+6*30.5)
		gen postpreg_9month_num  = round(pregend_num+9*30.5)
		gen postpreg_12month_num = round(pregend_num+12*30.5)
		
		format %td prepreg_* postpreg_*
		
		drop if missing(presc_startdate_num)==1
		
		* Pre-pregnancy period
	
		/*gen flag1_prepreg_12_9 		= 1 if (prepreg_12month_num <= presc_startdate_num & presc_startdate_num < prepreg_9month_num) | (prepreg_12month_num <= presc_enddate_num & presc_enddate_num < prepreg_9month_num) 	
		gen flag2_prepreg_9_6  		= 1 if (prepreg_9month_num <= presc_startdate_num & presc_startdate_num < prepreg_6month_num) | (prepreg_9month_num <= presc_enddate_num & presc_enddate_num < prepreg_6month_num)
		gen flag3_prepreg_6_3  		= 1 if (prepreg_6month_num <= presc_startdate_num & presc_startdate_num < prepreg_3month_num) | (prepreg_6month_num <= presc_enddate_num & presc_enddate_num < prepreg_3month_num)
		gen flag4_prepreg_3_0  		= 1 if (prepreg_3month_num <= presc_startdate_num & presc_startdate_num < pregstart_num) | (prepreg_3month_num <= presc_enddate_num & presc_enddate_num < pregstart_num) 
		
		* Pregnancy period
	
		gen flag5_preg_firsttrim  	= 1 if ((secondtrim_num!=. & pregstart_num <= presc_startdate_num & presc_startdate_num < secondtrim_num) | (secondtrim_num!=. & pregstart_num <= presc_enddate_num & presc_enddate_num < secondtrim_num)) | ((secondtrim_num==. & pregstart_num <= presc_startdate_num & presc_startdate_num < pregend_num) | (secondtrim_num==. & pregstart_num <= presc_enddate_num & presc_enddate_num < pregend_num))
		gen flag6_preg_secondtrim 	= 1 if ((secondtrim_num!=. & thirdtrim_num!=. & secondtrim_num <= presc_startdate_num & presc_startdate_num < thirdtrim_num) | (secondtrim_num!=. & thirdtrim_num!=. & secondtrim_num <= presc_enddate_num & presc_enddate_num < thirdtrim_num)) | ((secondtrim_num!=. & thirdtrim_num==. & secondtrim_num <= presc_startdate_num & presc_startdate_num < pregend_num) | (secondtrim_num!=. & thirdtrim_num==. & secondtrim_num <= presc_enddate_num & presc_enddate_num < pregend_num))
		gen flag7_preg_thirdtrim  	= 1 if (thirdtrim_num!=. & thirdtrim_num <= presc_startdate_num & presc_startdate_num < pregend_num) | (thirdtrim_num!=. & thirdtrim_num <= presc_enddate_num & presc_enddate_num < pregend_num)
	
		* Post-pregnancy period
		
		gen flag8_postpreg_0_3   	= 1 if (pregend_num <= presc_startdate_num & presc_startdate_num < postpreg_3month_num) | (pregend_num <= presc_enddate_num & presc_enddate_num < postpreg_3month_num)
		gen flag9_postpreg_3_6   	= 1 if (postpreg_3month_num <= presc_startdate_num & presc_startdate_num < postpreg_6month_num) | (postpreg_3month_num <= presc_enddate_num & presc_enddate_num < postpreg_6month_num)
		gen flag10_postpreg_6_9  	= 1 if (postpreg_6month_num <= presc_startdate_num & presc_startdate_num < postpreg_9month_num) | (postpreg_6month_num <= presc_enddate_num & presc_enddate_num < postpreg_9month_num)
		gen flag11_postpreg_9_12 	= 1 if (postpreg_9month_num <= presc_startdate_num & presc_startdate_num < postpreg_12month_num) | (postpreg_9month_num <= presc_enddate_num & presc_enddate_num < postpreg_12month_num)
		
		egen anytime = rowmax(flag*)
		count if anytime == 1
		drop if anytime != 1 // removing all prescriptions not relevant to the pre-pregnancy period*/
		
		save "$Tempdatadir\stage1_pregpresc_`x'.dta", replace
		
	}


	use "$Tempdatadir\stage1_pregpresc_1.dta", clear
	
	forvalues x= 2/`pregmax' {
    
		append using "$Tempdatadir\stage1_pregpresc_`x'"

	}
	
	sort patid pregid
	tab drugsubstance		// correct format but labelled numerical variable
	
	decode drugsubstance, generate(drugsubstance_str)
	tab drugsubstance_str
	
	drop drugsubstance
	rename drugsubstance_str drugsubstance
	
	* Define cut-offs using all prescriptions from the year prior to pregnancy start 
	
	*gen diff=presc_startdate_num-pregstart_num
	*keep if diff<0
	keep patid pregid dd_mg drugsubstance class
	tab drugsubstance

	tempname myhandle	
	file open `myhandle' using "$Datadir\dosage.txt", write replace
	file write `myhandle' "Drug" _tab "Total Rx" _tab "Level" _tab "Value (mg)" _tab "N" _tab
	file write `myhandle' "Minimum" _tab "25% QI" _tab "50% Median" _tab "75% Q3" _tab "Maximium" _n
	
	foreach drug in agomelatine amitriptyline amoxapine citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
	
		preserve
		file write `myhandle' "`drug'" _tab 
		keep if drugsubstance=="`drug'"
		count
		file write `myhandle' (`r(N)') _tab 

		if `r(N)'!=0 {
	
			noi di "************"
			noi di "`drug'"

			* Keep highest dose, if a single preg has different doses in first trimesters
			* Keep single Rx per pregnancy
			*gsort patid pregid -dd_mg
			*by patid pregid: keep if _n==1

			* Generate dosage
			noi sum dd_mg, det
			
			if `r(p25)'!=`r(p75)' {
				
				noi di "quartiles ok"
				local low`drug'=`r(p25)'
				local mid`drug'=`r(p50)'
				local high`drug'=`r(p75)'
				
			}
			
			else if `r(p25)'==`r(p75)' {
				
				noi di "quantiles needed"
				local low`drug'=`r(p25)'
				local mid`drug'=`r(p50)'
				local high`drug'=`r(p90)'
				
			}

			gen dosage=1 if dd_mg<=`low`drug''
			replace dosage=2 if dd_mg>`low`drug'' & dd_mg<=`high`drug''
			replace dosage=3 if dd_mg>`high`drug''
			noi bysort dosage: sum dd_mg
			noi tab dosage

			count if dosage==1
			local lowN=`r(N)'
			count if dosage==2
			local medN=`r(N)'
			count if dosage==3
			local highN=`r(N)'

			noi sum dd_mg if dosage==1, det
	
			if `r(N)'!=0 {

				local lowMIN=`r(min)'
				local low25=`r(p25)'
				local low50=`r(p50)'
				local low75=`r(p75)'
				local lowMAX=`r(max)'
		
			}

		sum dd_mg if dosage==2, det

		if `r(N)'!=0 {

			local medMIN=`r(min)'
			local med25=`r(p25)'
			local med50=`r(p50)'
			local med75=`r(p75)'
			local medMAX=`r(max)'

		}

		sum dd_mg if dosage==3, det
		
		if `r(N)'!=0 {
			
			local highMIN=`r(min)'
			local high25=`r(p25)'
			local high50=`r(p50)'
			local high75=`r(p75)'
			local highMAX=`r(max)'

		}


file write `myhandle' "Low" _tab "<=" (`low`drug'') _tab (`lowN') _tab
file write `myhandle' (`lowMIN') _tab (`low25') _tab (`low50') _tab (`low75') _tab (`lowMAX') _n

file write `myhandle' _tab _tab  "Medium" _tab ">" (`low`drug'') " to <=" (`high`drug'') _tab (`medN') _tab
file write `myhandle' (`medMIN') _tab (`med25') _tab (`med50') _tab (`med75') _tab (`medMAX') _n

file write `myhandle' _tab _tab   "High" _tab ">" (`high`drug'') _tab (`highN') _tab
file write `myhandle' (`highMIN') _tab (`high25') _tab (`high50') _tab (`high75') _tab (`highMAX') _n

			keep patid pregid drugsubstance class dosage
			noi tab dosage
			noi di "************"
			restore
			
		}

		file write `myhandle' _n
	
	}
	
	use "$Tempdatadir\long_by_week_continuers_doubleds_sorted.dta", clear
	
	decode drugsubstance1, generate(drugsubstance_1)
	decode drugsubstance2, generate(drugsubstance_2) 
	decode drugsubstance3, generate(drugsubstance_3) 
	decode drugsubstance4, generate(drugsubstance_4)
	decode drugsubstance5, generate(drugsubstance_5) // create string variable to identify antidepressant classes

	forvalues x=1/5 {
		foreach drug in agomelatine amitriptyline amoxapine citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
	
			count if drugsubstance_`x'=="`drug'"
	
			if r(N)!=0 {	
		
				replace dosage`x'=1 if dd_mg`x'<=`low`drug'' & drugsubstance_`x'=="`drug'"
				replace dosage`x'=2 if dd_mg`x'>`low`drug'' & dd_mg`x'<=`high`drug'' & drugsubstance_`x'=="`drug'"
				replace dosage`x'=3 if dd_mg`x'>`high`drug'' & drugsubstance_`x'=="`drug'"
	
			}
		}
	}
	
	/*lab define dosage 1 Low 2 Medium 3 High
	lab val dosage dosage*/
	
	forvalues x=1/5 {
		foreach drug in agomelatine amitriptyline amoxapine citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
	
			disp "`drug'"
			tab dosage`x' if drugsubstance_`x'=="`drug'"
		
		}
	}
	
	save "$Tempdatadir\long patterns doubleds cat sorted.dta", replace

********************************************************************************************
