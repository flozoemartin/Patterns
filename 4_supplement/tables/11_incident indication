*************************************************************************************

* Incident depression and anxiety - ever to 12 months before pregnancy, 12 months before pregnancy, and during pregnancy

* Author: Flo Martin

* Date: 14/11/2023

*************************************************************************************

* Table S12 - Incident depression and anxiety at different times in relation to pregnancy.

*************************************************************************************

* Start logging

  log using "$Logdir\4_supplement\11_incident indication", name(incident_indication) replace

*************************************************************************************

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
		local colpct = 100*(r(N)/`overalldenom')
		file write tablecontent %11.0fc (`rowdenom')  (" (") %4.1f (`colpct') (")") _tab

		cou if any_preg==1 
		local coldenom = r(N)
		cou if any_preg==1 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _tab

		cou if any_preg==0 
		local coldenom = r(N)
		cou if any_preg==0 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _n
	
	end


*******************************************************************************

* Generic code to output one section (varible) within table (calls above)

	cap prog drop tabulatevariable
	prog define tabulatevariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 
		
			generaterow, variable(`variable') condition("==`varlevel'") outcome(any_preg)
	
		}

	end

*******************************************************************************

* Set up output file

		use "$Datadir\table_2_dataset.dta", clear
		
		foreach x in depression anxiety {
		
			gen incident_`x' = 3 if `x'_preg==1
			replace incident_`x' = 2 if `x'_12mo==1
			replace incident_`x' = 1 if `x'_ever==1
			replace incident_`x' = 0 if `x'==0 & `x'_preg==0
			
			tab incident_`x'
			tab incident_`x' if any_preg==1
			tab incident_`x' if any_preg==0
		
		}

********************************************************************************
* 2 - Prepare formats for data for output
********************************************************************************

		cap file close tablecontent
		file open tablecontent using "$Tabledir\supp_incident dep anx.txt", write text replace

		file write tablecontent "Indication" _tab "Level" _tab "Total N" _tab "Exposed during pregnancy n (%)" _tab "Unexposed during pregnancy n (%)" _n
		
		gen byte total=1
		tabulatevariable, variable(total) start(1) end(1) outcome(any_preg)
		
		file write tablecontent "Depression" _n
		
		tabulatevariable, variable(incident_depression) start(1) end(3) outcome(any_preg)
		
		file write tablecontent "Anxiety" _n
		
		tabulatevariable, variable(incident_anxiety) start(1) end(3) outcome(any_preg)
		
		file close tablecontent

*************************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close incident_indication
	
	translate "$Logdir\4_supplement\11_incident indication.smcl" "$Logdir\4_supplement\11_incident indication.pdf", replace
	
	erase "$Logdir\4_supplement\11_incident indication.smcl"

 *************************************************************************************
