********************************************************************************

* Preparing the patterns dataset for descriptives paper

* Author: Flo Martin 

* Date: 06/08/2024

********************************************************************************

* Datasets created by this do-file 

*	- $Datadir\patterns_in_pregnancy_clean_withclasses.dta

********************************************************************************

* Start logging

	log using "$Logdir\1_cleaning\2_adding class info to patterns", name(adding_class_info) replace

********************************************************************************

* Load in the antidepressant codelist with all the class information in it and keep one instance of each drug substance for correct merging

	use "$Codesdir\antidepressants_codelist.dta", clear
	sort drugsubstance
	bysort drugsubstance: egen seq=seq()
	tab seq
	
	keep if seq==1
	keep drugsubstance class
	drop if drugsubstance==""
	
	* Save the new slimmed codelist as a temporary dataset
	
	save "$Tempdatadir\ad_codelist_for_patterns.dta", replace
	
* Load in new codelist, rename variables to match each drug substance variable in the patterns dataset for every prescription within pregnancy
	
		foreach y in l m n o a b c w x y z {
			
			forvalues x=1/8 {

		use "$Tempdatadir\ad_codelist_for_patterns.dta", clear
		rename class class`x'`y'
		keep drugsubstance class`x'`y' 
	
			foreach drug in agomelatine amitriptyline amoxapine butriptyline citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iprindole iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
		
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' hydrochloride"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' hydrobromide"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' sulfate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' maleate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' mesilate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' oxalate"
		
			}
	
		gen drugsubstance_str = "1" if drugsubstance=="agomelatine"
		replace drugsubstance_str = "2" if drugsubstance=="amitriptyline"
		replace drugsubstance_str = "3" if drugsubstance=="amoxapine"
		replace drugsubstance_str = "4" if drugsubstance=="butriptyline"
		replace drugsubstance_str = "5" if drugsubstance=="citalopram"
		replace drugsubstance_str = "6" if drugsubstance=="clomipramine"
		replace drugsubstance_str = "7" if drugsubstance=="desipramine"
		replace drugsubstance_str = "8" if drugsubstance=="dosulepin"
		replace drugsubstance_str = "9" if drugsubstance=="doxepin"
		replace drugsubstance_str = "10" if drugsubstance=="duloxetine"
		replace drugsubstance_str = "11" if drugsubstance=="escitalopram"
		replace drugsubstance_str = "12" if drugsubstance=="fluoxetine"
		replace drugsubstance_str = "13" if drugsubstance=="fluvoxamine"
		replace drugsubstance_str = "14" if drugsubstance=="imipramine"
		replace drugsubstance_str = "15" if drugsubstance=="iproniazide"
		replace drugsubstance_str = "16" if drugsubstance=="iprindole"
		replace drugsubstance_str = "17" if drugsubstance=="isocarboxazid"
		replace drugsubstance_str = "18" if drugsubstance=="lofepramine"
		replace drugsubstance_str = "19" if drugsubstance=="maprotiline"
		replace drugsubstance_str = "20" if drugsubstance=="mianserin"
		replace drugsubstance_str = "21" if drugsubstance=="mirtazapine"
		replace drugsubstance_str = "22" if drugsubstance=="moclobemide"
		replace drugsubstance_str = "23" if drugsubstance=="nefazodone"
		replace drugsubstance_str = "24" if drugsubstance=="nortriptyline"
		replace drugsubstance_str = "25" if drugsubstance=="paroxetine"
		replace drugsubstance_str = "26" if drugsubstance=="phenelzine"
		replace drugsubstance_str = "27" if drugsubstance=="protriptyline"
		replace drugsubstance_str = "28" if drugsubstance=="reboxetine"
		replace drugsubstance_str = "29" if drugsubstance=="sertraline"
		replace drugsubstance_str = "30" if drugsubstance=="tranylcypromine"
		replace drugsubstance_str = "31" if drugsubstance=="trazodone"
		replace drugsubstance_str = "32" if drugsubstance=="trimipramine"
		replace drugsubstance_str = "33" if drugsubstance=="tryptophan"
		replace drugsubstance_str = "34" if drugsubstance=="venlafaxine"
		replace drugsubstance_str = "35" if drugsubstance=="vortioxetine"
	
		gen drugsubstance`x'`y' = real(drugsubstance_str)

		label define drugsubstance_lb 1"agomelatine" 2"amitriptyline" 3"amoxapine" 4"butriptyline" 5"citalopram" 6"clomipramine" 7"desipramine" 8"dosulepin" 9"doxepin" 10"duloxetine" 11"escitalopram" 12"fluoxetine" 13"fluvoxamine" 14"imipramine" 15"iprindole" 16"iproniazide" 17"isocarboxazid" 18"lofepramine" 19"maprotiline" 20"mianserin" 21"mirtazapine" 22"moclobemide" 23"nefazodone" 24"nortriptyline" 25"paroxetine" 26"phenelzine" 27"protriptyline" 28"reboxetine" 29"sertraline" 30"tranylcypromine" 31"trazodone" 32"trimipramine" 33"tryptophan" 34"venlafaxine" 35"vortioxetine"
	
		label value drugsubstance`x'`y'  drugsubstance_lb
		
		replace class`x'`y' =. if drugsubstance`x'`y' ==.
		
		bysort drugsubstance`x'`y' : egen seq=seq()
		tab seq
		keep if seq==1
		
		keep class`x'`y' drugsubstance`x'`y' 

		save "$Tempdatadir\ad_codelist_for_patterns`x'`y'.dta", replace
		
		}
	}
	
/* ...and then for the first prescriptions from pre- and post-pregnancy

	foreach y in l m n o w x y z {

		use "$Tempdatadir\ad_codelist_for_patterns.dta", clear
		rename class class1`y'
		keep drugsubstance class1`y' 
	
			foreach drug in agomelatine amitriptyline amoxapine butriptyline citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iprindole iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
		
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' hydrochloride"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' hydrobromide"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' sulfate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' maleate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' mesilate"
				replace drugsubstance = "`drug'" if drugsubstance=="`drug' oxalate"
		
			}
	
		gen drugsubstance_str = "1" if drugsubstance=="agomelatine"
		replace drugsubstance_str = "2" if drugsubstance=="amitriptyline"
		replace drugsubstance_str = "3" if drugsubstance=="amoxapine"
		replace drugsubstance_str = "4" if drugsubstance=="butriptyline"
		replace drugsubstance_str = "5" if drugsubstance=="citalopram"
		replace drugsubstance_str = "6" if drugsubstance=="clomipramine"
		replace drugsubstance_str = "7" if drugsubstance=="desipramine"
		replace drugsubstance_str = "8" if drugsubstance=="dosulepin"
		replace drugsubstance_str = "9" if drugsubstance=="doxepin"
		replace drugsubstance_str = "10" if drugsubstance=="duloxetine"
		replace drugsubstance_str = "11" if drugsubstance=="escitalopram"
		replace drugsubstance_str = "12" if drugsubstance=="fluoxetine"
		replace drugsubstance_str = "13" if drugsubstance=="fluvoxamine"
		replace drugsubstance_str = "14" if drugsubstance=="imipramine"
		replace drugsubstance_str = "15" if drugsubstance=="iproniazide"
		replace drugsubstance_str = "16" if drugsubstance=="iprindole"
		replace drugsubstance_str = "17" if drugsubstance=="isocarboxazid"
		replace drugsubstance_str = "18" if drugsubstance=="lofepramine"
		replace drugsubstance_str = "19" if drugsubstance=="maprotiline"
		replace drugsubstance_str = "20" if drugsubstance=="mianserin"
		replace drugsubstance_str = "21" if drugsubstance=="mirtazapine"
		replace drugsubstance_str = "22" if drugsubstance=="moclobemide"
		replace drugsubstance_str = "23" if drugsubstance=="nefazodone"
		replace drugsubstance_str = "24" if drugsubstance=="nortriptyline"
		replace drugsubstance_str = "25" if drugsubstance=="paroxetine"
		replace drugsubstance_str = "26" if drugsubstance=="phenelzine"
		replace drugsubstance_str = "27" if drugsubstance=="protriptyline"
		replace drugsubstance_str = "28" if drugsubstance=="reboxetine"
		replace drugsubstance_str = "29" if drugsubstance=="sertraline"
		replace drugsubstance_str = "30" if drugsubstance=="tranylcypromine"
		replace drugsubstance_str = "31" if drugsubstance=="trazodone"
		replace drugsubstance_str = "32" if drugsubstance=="trimipramine"
		replace drugsubstance_str = "33" if drugsubstance=="tryptophan"
		replace drugsubstance_str = "34" if drugsubstance=="venlafaxine"
		replace drugsubstance_str = "35" if drugsubstance=="vortioxetine"
	
		gen drugsubstance1`y' = real(drugsubstance_str)

		label define drugsubstance_lb 1"agomelatine" 2"amitriptyline" 3"amoxapine" 4"butriptyline" 5"citalopram" 6"clomipramine" 7"desipramine" 8"dosulepin" 9"doxepin" 10"duloxetine" 11"escitalopram" 12"fluoxetine" 13"fluvoxamine" 14"imipramine" 15"iprindole" 16"iproniazide" 17"isocarboxazid" 18"lofepramine" 19"maprotiline" 20"mianserin" 21"mirtazapine" 22"moclobemide" 23"nefazodone" 24"nortriptyline" 25"paroxetine" 26"phenelzine" 27"protriptyline" 28"reboxetine" 29"sertraline" 30"tranylcypromine" 31"trazodone" 32"trimipramine" 33"tryptophan" 34"venlafaxine" 35"vortioxetine"
	
		label value drugsubstance1`y'  drugsubstance_lb
		
		replace class1`y' =. if drugsubstance1`y' ==.
		
		bysort drugsubstance1`y' : egen seq=seq()
		tab seq
		keep if seq==1
		
		keep class1`y' drugsubstance1`y' 

		save "$Tempdatadir\ad_codelist_for_patterns1`y'.dta", replace
		
		
	} */
		
* Load in the patterns dataset, define labels for the new class variable that will be brought in by the new codelist - classes mess up here
	
	use "$Datadir\patterns_in_pregnancy_clean.dta", clear
	
	forvalues x=6/8 {
		foreach y in l m n o w x y z {	
		
			gen drugsubstance`x'`y' =.
		
		}
	}
	
	forvalues x=1/8 {
		foreach y in l m n o a b c w x y z {
	
			merge m:1 drugsubstance`x'`y' using "$Tempdatadir\ad_codelist_for_patterns`x'`y'.dta", keep(1 3)
			drop _merge
			
			label values class`x'`y' class_lb
			
		}
	}
	
	/*foreach y in l m n o w x y z {
		
		merge m:1 drugsubstance1`y' using "$Tempdatadir\ad_codelist_for_patterns1`y'.dta", keep(1 3)
		drop _merge
		label values class1`y' class_lb
		
	}*/

	count
	
	label define class_lb 1"SSRI" 2"SNRI" 3"TCA" 4"MAOI" 5"RIMA" 6"SMS" 7"Atypical"
	
	forvalues x=1/8 {
		foreach y in l m n o a b c w x y z {
			
			label values class`x'`y' class_lb
		
		}
	}
	
	/*foreach y in l m n o w x y z {
			
		label values class1`y' class_lb
		
	}*/
	
	
	order patid pregid seq *l *m *n *o *a *b *c *w *x *y *z
	
	merge 1:1 patid pregid using "$Deriveddir\derived_data\pregnancy_cohort_final.dta", keepusing(patid pregid updated_outcome pregstart_num) keep(3) nogen
	
	tab updated_outcome, nolabel m
	tab multi_drug
	
	* Drug-specific variable for birth outcome study
	
	/*1"agomelatine" 2"amitriptyline" 3"amoxapine" 4"butriptyline" 5"citalopram" 6"clomipramine" 7"desipramine" 8"dosulepin" 9"doxepin" 10"duloxetine" 11"escitalopram" 12"fluoxetine" 13"fluvoxamine" 14"imipramine" 15"iprindole" 16"iproniazide" 17"isocarboxazid" 18"lofepramine" 19"maprotiline" 20"mianserin" 21"mirtazapine" 22"moclobemide" 23"nefazodone" 24"nortriptyline" 25"paroxetine" 26"phenelzine" 27"protriptyline" 28"reboxetine" 29"sertraline" 30"tranylcypromine" 31"trazodone" 32"trimipramine" 33"tryptophan" 34"venlafaxine" 35"vortioxetine"*/
	
	foreach x in agomelatine amitriptyline amoxapine butriptyline citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iprindole iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
	
		gen `x' =.
		
	}
	
	foreach x in a b c {
		forvalues y=1/7 {
		
			replace sertraline = 1 if drugsubstance`y'`x'==29
			replace citalopram = 1 if drugsubstance`y'`x'==5
			replace fluoxetine = 1 if drugsubstance`y'`x'==12
			replace escitalopram = 1 if drugsubstance`y'`x'==11
			replace venlafaxine = 1 if drugsubstance`y'`x'==34
			replace mirtazapine = 1 if drugsubstance`y'`x'==21
			replace amitriptyline = 1 if drugsubstance`y'`x'==2
			replace paroxetine = 1 if drugsubstance`y'`x'==25
			replace duloxetine = 1 if drugsubstance`y'`x'==10
			replace agomelatine = 1 if drugsubstance`y'`x'==1
			replace amoxapine = 1 if drugsubstance`y'`x'==3
			replace butriptyline = 1 if drugsubstance`y'`x'==4
			replace clomipramine = 1 if drugsubstance`y'`x'==6
			replace desipramine = 1 if drugsubstance`y'`x'==7
			replace dosulepin = 1 if drugsubstance`y'`x'==8
			replace doxepin = 1 if drugsubstance`y'`x'==9
			replace fluvoxamine = 1 if drugsubstance`y'`x'==13
			replace imipramine = 1 if drugsubstance`y'`x'==14
			replace iprindole = 1 if drugsubstance`y'`x'==15
			replace iproniazide = 1 if drugsubstance`y'`x'==16
			replace isocarboxazid = 1 if drugsubstance`y'`x'==17
			replace lofepramine = 1 if drugsubstance`y'`x'==18
			replace maprotiline = 1 if drugsubstance`y'`x'==19
			replace mianserin = 1 if drugsubstance`y'`x'==20
			replace moclobemide = 1 if drugsubstance`y'`x'==22
			replace nefazodone = 1 if drugsubstance`y'`x'==23
			replace nortriptyline = 1 if drugsubstance`y'`x'==24
			replace phenelzine = 1 if drugsubstance`y'`x'==26
			replace protriptyline = 1 if drugsubstance`y'`x'==27
			replace reboxetine = 1 if drugsubstance`y'`x'==28
			replace tranylcypromine = 1 if drugsubstance`y'`x'==30
			replace trazodone = 1 if drugsubstance`y'`x'==31
			replace trimipramine = 1 if drugsubstance`y'`x'==32
			replace tryptophan = 1 if drugsubstance`y'`x'==33
			replace vortioxetine = 1 if drugsubstance`y'`x'==35
 			
		}
	}
	
		gen other = 1 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==1 & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 2 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==1 & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 3 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==1 & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 4 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==1 & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 5 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==1 & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 6 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==1 & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 7 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==1 & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 8 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==1 & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 9 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==1 & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 10 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==1 & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 11 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==1 & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 12 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==1 & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 13 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==1 & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 14 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==1 & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 15 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==1 & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 16 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==1 & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 16 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==1 & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 17 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==1 & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 18 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==1 & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 19 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==1 & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 20 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==1 & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 21 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==1 & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 22 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==1 & trimipramine==. & tryptophan==. & vortioxetine==.
		replace other = 23 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==1 & tryptophan==. & vortioxetine==.
		replace other = 24 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==1 & vortioxetine==.
		replace other = 25 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. &  agomelatine==. & amoxapine==. & butriptyline==. & clomipramine==. & desipramine==. & dosulepin==. & doxepin==. & fluvoxamine==. & imipramine==. & iprindole==. & iproniazide==. & isocarboxazid==. & lofepramine==. & maprotiline==. & mianserin==. & moclobemide==. & nefazodone==. & nortriptyline==. & phenelzine==. & protriptyline==. & reboxetine==. & tranylcypromine==. & trazodone==. & trimipramine==. & tryptophan==. & vortioxetine==1
		
		foreach w in agomelatine amitriptyline amoxapine butriptyline citalopram clomipramine desipramine dosulepin doxepin duloxetine escitalopram fluoxetine fluvoxamine imipramine iprindole iproniazide isocarboxazid lofepramine maprotiline mianserin mirtazapine moclobemide nefazodone nortriptyline paroxetine phenelzine protriptyline reboxetine sertraline tranylcypromine trazodone trimipramine tryptophan venlafaxine vortioxetine {
			
			replace other = 26 if any_preg==1 & other==. & (amoxapine==1 | butriptyline==1 | clomipramine==1 | desipramine==1 | dosulepin==1 | doxepin==1 | fluvoxamine==1 | imipramine==1 | iprindole==1 | iproniazide==1 | isocarboxazid==1 | lofepramine==1 | maprotiline==1 | mianserin==1 | moclobemide==1 | nefazodone==1 | nortriptyline==1 | phenelzine==1 | protriptyline==1 | reboxetine==1 | tranylcypromine==1 | trazodone==1 | trimipramine==1 | tryptophan==1 | vortioxetine==1) & `w'==1
			
		}
	
		gen specific_drug_analysis = 0 if any_preg==0
		replace specific_drug_analysis = 1 if sertraline==1 & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 2 if sertraline==. & citalopram==1 & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 3 if sertraline==. & citalopram==. & fluoxetine==1 & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 4 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==1 & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 5 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==1 & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 6 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==1 & amitriptyline==. & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 7 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==1 & paroxetine==. & duloxetine==. & other==.
		replace specific_drug_analysis = 8 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==1 & duloxetine==. & other==.
		replace specific_drug_analysis = 9 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==1 & other==.
		replace specific_drug_analysis = 10 if sertraline==. & citalopram==. & fluoxetine==. & escitalopram==. & venlafaxine==. & mirtazapine==. & amitriptyline==. & paroxetine==. & duloxetine==. & other<26
		replace specific_drug_analysis = 11 if any_preg==1 & specific_drug_analysis==.
		
		tab specific_drug_analysis, m
	
	* Dosage
	
	gen highest_dose_t1 = max(dosage1a, dosage2a, dosage3a, dosage4a, dosage5a, dosage6a, dosage7a)
	tab highest_dose_t1
	
	gen highest_dose_t2 = max(dosage1b, dosage2b, dosage3b, dosage4b, dosage5b, dosage6b, dosage7b)
	tab highest_dose_t2
	
	gen highest_dose_t3 = max(dosage1c, dosage2c, dosage3c, dosage4c, dosage5c, dosage6c, dosage7c)
	tab highest_dose_t3
	
	* Class
	
	* Pre- and post-preg
	
	tab class1l
	tab class1l, nol
	
	foreach x in l m n o w x y z {
	
		gen class_`x' = 0 if any_`x'!=1
		
		replace class_`x' = 1 if class1`x'==1 & (class2`x'==1 | class2`x'==.) & (class3`x'==1 | class3`x'==.) & (class4`x'==1 | class4`x'==.) & (class5`x'==1 | class5`x'==.) & (class6`x'==1 | class6`x'==.) & (class7`x'==1 | class7`x'==.) & (class8`x'==1 | class8`x'==.)
		
		replace class_`x' = 2 if class1`x'==3 & (class2`x'==3 | class2`x'==.) & (class3`x'==3 | class3`x'==.) & (class4`x'==3 | class4`x'==.) & (class5`x'==3 | class5`x'==.) & (class6`x'==3 | class6`x'==.) & (class7`x'==3 | class7`x'==.) & (class8`x'==3 | class8`x'==.)
		
		replace class_`x' = 3 if class1`x'==2 & (class2`x'==2 | class2`x'==.) & (class3`x'==2 | class3`x'==.) & (class4`x'==2 | class4`x'==.) & (class5`x'==2 | class5`x'==.) & (class6`x'==2 | class6`x'==.) & (class7`x'==2 | class7`x'==.) & (class8`x'==2 | class8`x'==.)
		
		replace class_`x' = 4 if inlist(class1a, 4,5,6,7) & (inlist(class2a, 4,5,6,7) | class2`x'==.) & (inlist(class3a, 4,5,6,7) | class3`x'==.) & (inlist(class4a, 4,5,6,7) | class4`x'==.) & (inlist(class5a, 4,5,6,7) | class5`x'==.) & (inlist(class6a, 4,5,6,7) | class6`x'==.) & (inlist(class7a, 4,5,6,7) | class7`x'==.) & (inlist(class8a, 4,5,6,7) | class8`x'==.)
		
		replace class_`x' = 5 if class_`x'==.
		
		label define class_`x'_lb 0"Unexposed in T1" 1"SSRI exposed in T1" 2"TCA exposed in T1" 3"SNRI exposed in T1" 4"Other exposed in T1" 5"Multiple classes in T1"
		label values class_`x' class_`x'_lb
		tab class_`x'
	
	}
	
	* Trimester 1
	
	tab class1a
	tab class1a, nol
	
	gen class_t1 = 0 if any_a!=1
	
	replace class_t1 = 1 if class1a==1 & (class2a==1 | class2a==.) & (class3a==1 | class3a==.) & (class4a==1 | class4a==.) & (class5a==1 | class5a==.) & (class6a==1 | class6a==.) & (class7a==1 | class7a==.) & (class8a==1 | class8a==.)
	
	replace class_t1 = 2 if class1a==3 & (class2a==3 | class2a==.) & (class3a==3 | class3a==.) & (class4a==3 | class4a==.) & (class5a==3 | class5a==.) & (class6a==3 | class6a==.) & (class7a==3 | class7a==.) & (class8a==3 | class8a==.)
	
	replace class_t1 = 3 if class1a==2 & (class2a==2 | class2a==.) & (class3a==2 | class3a==.) & (class4a==2 | class4a==.) & (class5a==2 | class5a==.) & (class6a==2 | class6a==.) & (class7a==2 | class7a==.) & (class8a==2 | class8a==.)
	
	replace class_t1 = 4 if inlist(class1a, 4,5,6,7) & (inlist(class2a, 4,5,6,7) | class2a==.) & (inlist(class3a, 4,5,6,7) | class3a==.) & (inlist(class4a, 4,5,6,7) | class4a==.) & (inlist(class5a, 4,5,6,7) | class5a==.) & (inlist(class6a, 4,5,6,7) | class6a==.) & (inlist(class7a, 4,5,6,7) | class7a==.) & (inlist(class8a, 4,5,6,7) | class8a==.)
	
	replace class_t1 = 5 if class_t1==.
	
	label define class_t1_lb 0"Unexposed in T1" 1"SSRI exposed in T1" 2"TCA exposed in T1" 3"SNRI exposed in T1" 4"Other exposed in T1" 5"Multiple classes in T1"
	label values class_t1 class_t1_lb
	tab class_t1
	
	* Trimester 2
	
	gen class_t2 = 0 if any_b!=1
	
	replace class_t2 = 1 if class1b==1 & (class2b==1 | class2b==.) & (class3b==1 | class3b==.) & (class4b==1 | class4b==.) & (class5b==1 | class5b==.) & (class6b==1 | class6b==.) & (class7b==1 | class7b==.) & (class8b==1 | class8b==.)
	
	replace class_t2 = 2 if class1b==3 & (class2b==3 | class2b==.) & (class3b==3 | class3b==.) & (class4b==3 | class4b==.) & (class5b==3 | class5b==.) & (class6b==3 | class6b==.) & (class7b==3 | class7b==.) & (class8b==3 | class8b==.)
	
	replace class_t2 = 3 if class1b==2 & (class2b==2 | class2b==.) & (class3b==2 | class3b==.) & (class4b==2 | class4b==.) & (class5b==2 | class5b==.) & (class6b==2 | class6b==.) & (class7b==2 | class7b==.) & (class8b==2 | class8b==.)
	
	replace class_t2 = 4 if inlist(class1b, 4,5,6,7) & (inlist(class2b, 4,5,6,7) | class2b==.) & (inlist(class3b, 4,5,6,7) | class3b==.) & (inlist(class4b, 4,5,6,7) | class4b==.) & (inlist(class5b, 4,5,6,7) | class5b==.) & (inlist(class6b, 4,5,6,7) | class6b==.) & (inlist(class7b, 4,5,6,7) | class7b==.) & (inlist(class8b, 4,5,6,7) | class8b==.)
	
	replace class_t2 = 5 if class_t2==.
	
	label define class_t2_lb 0"Unexposed in T2" 1"SSRI exposed in T2" 2"TCA exposed in T2" 3"SNRI exposed in T2" 4"Other exposed in T2" 5"Multiple classes in T2"
	label values class_t2 class_t2_lb
	tab class_t2
	
	* Trimester 3
	
	gen class_t3 = 0 if any_b!=1
	
	replace class_t3 = 1 if class1c==1 & (class2c==1 | class2c==.) & (class3c==1 | class3c==.) & (class4c==1 | class4c==.) & (class5c==1 | class5c==.) & (class6c==1 | class6c==.) & (class7c==1 | class7c==.)
	
	replace class_t3 = 2 if class1c==3 & (class2c==3 | class2c==.) & (class3c==3 | class3c==.) & (class4c==3 | class4c==.) & (class5c==3 | class5c==.) & (class6c==3 | class6c==.) & (class7c==3 | class7c==.)
	
	replace class_t3 = 3 if class1c==2 & (class2c==2 | class2c==.) & (class3c==2 | class3c==.) & (class4c==2 | class4c==.) & (class5c==2 | class5c==.) & (class6c==2 | class6c==.) & (class7c==2 | class7c==.)
	
	replace class_t3 = 4 if inlist(class1c, 4,5,6,7) & (inlist(class2c, 4,5,6,7) | class2c==.) & (inlist(class3c, 4,5,6,7) | class3c==.) & (inlist(class4c, 4,5,6,7) | class4c==.) & (inlist(class5c, 4,5,6,7) | class5c==.) & (inlist(class6c, 4,5,6,7) | class6c==.) & (inlist(class7c, 4,5,6,7) | class7c==.) & (inlist(class8c, 4,5,6,7) | class8c==.)
	
	replace class_t3 = 5 if class_t3==.
	
	label define class_t3_lb 0"Unexposed in T2" 1"SSRI exposed in T2" 2"TCA exposed in T2" 3"SNRI exposed in T2" 4"Other exposed in T2" 5"Multiple classes in T2"
	label values class_t3 class_t3_lb
	tab class_t3
	
	*  In pregnancy
	
	gen class_preg = 0 if any_preg==0
	replace class_preg = 1 if (class_t1==1 | class_t1==0) & (class_t2==1 | class_t2==0) & (class_t3==1 | class_t3==0) & any_preg==1
	replace class_preg = 2 if (class_t1==2 | class_t1==0) & (class_t2==2 | class_t2==0) & (class_t3==2 | class_t3==0) & any_preg==1
	replace class_preg = 3 if (class_t1==3 | class_t1==0) & (class_t2==3 | class_t2==0) & (class_t3==3 | class_t3==0) & any_preg==1
	replace class_preg = 4 if (class_t1==4 | class_t1==0) & (class_t2==4 | class_t2==0) & (class_t3==4 | class_t3==0) & any_preg==1
	replace class_preg = 5 if class_preg==.
	
	label define class_preg_lb 0"Unexposed" 1"SSRI exposed" 2"TCA exposed" 3"SNRI exposed" 4"Other exposed" 5"Multiple classes"
	label values class_preg class_preg_lb
	tab class_preg, m
	
	save "$Deriveddir\exposure\pregnancy_cohort_exposure_with_unknownoutcome.dta", replace
	
	drop if updated_outcome==13
	*drop if multi_drug==1
	
	count
	
* Clean up the variables 

	recode any_prepreg .=0
	recode any_preg .=0
	recode any_postpreg .=0
	
* Save dataset for patterns analysis
	
	save "$Datadir\patterns_in_pregnancy_clean_withclasses.dta", replace
	
* Save a slimmed down dataset for future analyses (exposure dataset)

	keep patid pregid any_l any_m any_n any_o presc_startdate_num1a any_a presc_startdate_num1b any_b presc_startdate_num1c any_c any_w any_x any_y any_z any_prepreg any_preg any_postpreg continuer initiator prepreg_discont discontinue discontinue_t2 discontinue_t3 postnatal_use prenatal_x any_discont no_change_cont highest_dose_t* class_* specific_drug_analysis count_pxn_ta
	
	save "$Deriveddir\exposure\pregnancy_cohort_exposure.dta", replace
	
********************************************************************************

* Delete unnecessary datasets

	erase "$Tempdatadir\ad_codelist_for_patterns.dta"

	foreach y in a b c {
		forvalues x=1/7 {
			
			erase "$Tempdatadir\ad_codelist_for_patterns`x'`y'.dta"
			
		}
	}
	
	foreach y in l m n o w x y z {
		
		erase "$Tempdatadir\ad_codelist_for_patterns1`y'.dta"
		
	}


********************************************************************************

* Stop logging

	log close adding_class_info
	
	translate "$Logdir\1_cleaning\2_adding class info to patterns.smcl" "$Logdir\1_cleaning\2_adding class info to patterns.pdf", replace
	
	erase "$Logdir\1_cleaning\2_adding class info to patterns.smcl"
	
********************************************************************************
