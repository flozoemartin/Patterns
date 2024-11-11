*******************************************************************************

* Proportions who were and were not exposed to antidepressants in the 12 months after pregnancy in each discontinuation/no use group in losses

* Author: Flo Martin 

* Date: 06/06/2024

*******************************************************************************

* Table S10 - Proportion of individuals who were prescribed antidepressants in the 12 months after pregnancy stratified by previous use, among losses (post-pregnancy use)

*******************************************************************************

* Start logging 

	log using "$Logdir\4_supplement\9b_post patterns in losses", name(post_patterns_in_losses) replace
	
*******************************************************************************

	* Generic code to output one row of table
	cap prog drop generaterow

	program define generaterow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		local overalldenom=r(N)
		
		cou if `variable' `condition'
		local rowdenom = r(N)
		local colpct = 100
		file write tablecontent %11.0fc (`rowdenom')  (" (") %4.1f (`colpct') (")") _tab

		cou if any_postpreg==1 
		local coldenom = r(N)
		cou if any_postpreg==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f  (`pct') (")") _tab

		cou if any_postpreg==0 
		local coldenom = r(N)
		cou if any_postpreg==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f  (`pct') (")") _n
	
	end


*******************************************************************************

* Generic code to output one section (varible) within table (calls above)

	cap prog drop tabulatevariable
	prog define tabulatevariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 
		
			generaterow, variable(`variable') condition("==`varlevel'") outcome(any_postpreg)
	
		}

	end

*******************************************************************************

* Set up output file

		use "$Datadir\table_2_dataset.dta", clear
		
		keep if inlist(updated_outcome, 4,5,6,7,8,9,10)

********************************************************************************
* 2 - Prepare formats for data for output
********************************************************************************

		cap file close tablecontent
		file open tablecontent using "$Tabledir\supp_post preg row pct losses.txt", write text replace

		file write tablecontent "Variable" _tab "Level" _tab "Total N" _tab "Prescribed after pregnancy n (%)" _tab "Not prescribed after pregnancy n (%)" _n
		
		gen byte total=1
		tabulatevariable, variable(total) start(1) end(1) outcome(any_postpreg)
		tabulatevariable, variable(discontinuer) start(0) end(1) outcome(any_postpreg)
		tabulatevariable, variable(prepreg_discont) start(1) end(1) outcome(any_postpreg)
		tabulatevariable, variable(no_use) start(1) end(1) outcome(any_postpreg)
		
		file close tablecontent
		
********************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close post_patterns_in_losses
	
	translate "$Logdir\4_supplement\9b_post patterns in losses.smcl" "$Logdir\4_supplement\9b_post patterns in losses.pdf", replace
	
	erase "$Logdir\4_supplement\9b_post patterns in losses.smcl"
	
********************************************************************************
