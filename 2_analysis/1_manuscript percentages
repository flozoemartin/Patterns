*******************************************************************************

* Preparing the patterns dataset for descriptives paper

* Author: Flo Martin 

* Date: 30/03/2024

*******************************************************************************

* Start logging

	log using "$Logdir\2_analysis\1_manuscript percentages", name(manuscript_percentages) replace

*******************************************************************************

* Manuscript text do file
	
	* RESULTS
	* Section 1 - overall results
	
	use "$Deriveddir\formatted_linked_data\pregnancyregister.dta", clear
	count
	
	local pregreg=`r(N)'
	
	// n = 7,526,077 pregnancies in the pregnancy register July 2021 build
	
	use "$Datadir\table_2_dataset.dta", clear
	count
	
	local eligible=`r(N)'
	
	gen all = 1
	tab all
	
	// n = 1,033,783 pregnancies were eligible
	
	display ((`eligible')/(`pregreg'))*100
	
	// 14% of the whole pregnancy register was eligible for inclusion in the study
	
	tab any_prepreg
	codebook patid if any_prepreg==1
	
	tab any_preg
	codebook patid if any_preg==1
	
	tab any_postpreg
	codebook patid if any_postpreg==1
	
	// Out of all eligible pregnancies...
	// n = 142,817 (13.8%) exposed in the 12 months before pregnancy
	// n = 79,144 (7.7%) exposed during pregnancy
	// n = 162,947 (15.8%) exposed in the 12 months after pregnancy
	
	* Section 3 - pre-pregnancy prescribing patterns
	
	tab any_prepreg
	
	replace late_prepreg_discont = 2 if any_prepreg==1 & late_prepreg_discont==.
	
	label define late_prepreg_discont_lb 0"Continued into pregnancy" 1"Discontinued <3 months before preg" 2"Discontinued >3 months before preg"
	label values late_prepreg_discont late_prepreg_discont_lb
	
	tab late_prepreg_discont if late_prepreg_discont>0
	
	// Out of those exposed to antidepressants pre-pregnancy...
	// n = 68,258 (73.7% of the pre-pregnancy discontinuers) discontinued more than 3 months before pregnancy
	// n = 24,412 (26.3%) discontinued less than 3 months before pregnancy
	
	tab any_preg
	tab prevalent
	
	// Out of those exposed to antidepressants during pregnancy...
	// n = 63,390 (80.1%) had been taking antidepressants in the 3 months before pregnancy
	// n = 15,754 (19.9%) had not taken antidepressants in the 3 months before pregnancy
	
	tab any_postpreg
	
	tab any_postpreg discontinuer, row m
	tab any_postpreg prepreg_discont, row m
	tab any_postpreg no_use, col
	
*******************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close manuscript_percentages
	
	translate "$Logdir\2_analysis\1_manuscript percentages.smcl" "$Logdir\2_analysis\1_manuscript percentages.pdf", replace
	
	erase "$Logdir\2_analysis\1_manuscript percentages.smcl"
	
*******************************************************************************
