********************************************************************************************

* Distribution of outcomes in the eligible sample

* Author: Flo Martin

* Date: 06/06/2024

********************************************************************************************

* Table S3 - Proportion of pregnancy outcomes in eligible sample.

********************************************************************************************

* Start logging

	log using "$Logdir\4_supplement\2_distribution of outcomes", name(distribution_of_outcomes) replace

******************************************************************************************** 

use "$Datadir\table_2_dataset.dta", clear
	
	* Set up the table elements
	tempname myhandle	
	file open `myhandle' using "$Tabledir\supp_outcome distrib.txt", write replace
	file write `myhandle' "N (%)" _n
	
	forvalues x=1/12 {
		
		count if updated_outcome==`x'
		local n = `r(N)'
		
		count
		local total = `r(N)'
		
		local pct = ((`n')/(`total'))*100 
		
		file write `myhandle' %7.0fc (`n') (" (") %4.2fc (`pct') (")") _n
		
	}

********************************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close distribution_of_outcomes
	
	translate "$Logdir\4_supplement\2_distribution of outcomes.smcl" "$Logdir\4_supplement\2_distribution of outcomes.pdf", replace
	
	erase "$Logdir\4_supplement\2_distribution of outcomes.smcl" 

********************************************************************************************
