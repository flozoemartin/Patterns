********************************************************************************************

* Area of residence by exposure status during pregnancy

* Author: Flo Martin

* Date: 14/11/2023

********************************************************************************************

* Table S4 - Proportion of pregnancies from each CPRD region prescribed antidepressants during pregnancy.

********************************************************************************************

* Start logging

	log using "$Logdir\4_supplement\3_area of residence", name(area_of_residence) replace

********************************************************************************************

use "$Datadir\table_2_dataset.dta", clear
	
	tab AreaOfResidence any_preg, row 
	
	tempname myhandle	
	file open `myhandle' using "$Tabledir\supp_areaofresid.txt", write replace
	file write `myhandle' "Practice region" _tab "Exposed/Total" _tab "%" _n
	
	forvalues x=1/13 {
		
		count if AreaOfResidence==`x' & any_preg==1
		local exp_n=`r(N)'
		
		count if AreaOfResidence==`x'
		local n=`r(N)'
		
		local pct= (`exp_n'/`n')*100
		
		file write `myhandle'  (`x') _tab %6.0fc (`exp_n') ("/") %7.0fc (`n') _tab %4.2fc (`pct') _n 
		
	}

********************************************************************************************

 * Stop logging, translate .smcl into .pdf and erase .smcl

	log close area_of_residence
	
	translate "$Logdir\4_supplement\3_area of residence.smcl" "$Logdir\4_supplement\3_area of residence.pdf", replace
	
	erase "$Logdir\4_supplement\3_area of residence.smcl"

********************************************************************************************
