********************************************************************************

* Other indications among those with depression, anxiety, depression and anxiety, and neither depression nor anxiety

* Author: Flo Martin

* Date: 15/11/2023

********************************************************************************

* Table S13 - Prevalence of other indications among those prescribed to antidepressants during pregnancy with depression and/or anxiety.

********************************************************************************

* Start logging

  log using "$Logdir\4_supplement\12_other indications", name(other_indications) replace

********************************************************************************  

* Generic code to output one row of table
	cap prog drop generaterow

	program define generaterow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou if any_preg==1
		local overalldenom=r(N)
		
		cou if any_preg==1 & `variable' `condition'
		local rowdenom = r(N)
		local colpct = 100*(r(N)/`overalldenom')
		file write tablecontent %11.0fc (`rowdenom')  (" (") %4.1f (`colpct') (")") _tab

		cou if dep_anx==1 & any_preg==1
		local coldenom = r(N)
		cou if dep_anx==1 & any_preg==1 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _tab

		cou if dep_anx==2 & any_preg==1
		local coldenom = r(N)
		cou if dep_anx==2 & any_preg==1 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _tab
		
		cou if dep_anx==3 & any_preg==1
		local coldenom = r(N)
		cou if dep_anx==3 & any_preg==1 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _tab
		
		cou if dep_anx==4 & any_preg==1
		local coldenom = r(N)
		cou if dep_anx==4 & any_preg==1 & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1f (`pct') (")") _n
	
	end


*******************************************************************************

* Generic code to output one section (varible) within table (calls above)

	cap prog drop tabulatevariable
	prog define tabulatevariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 
		
			generaterow, variable(`variable') condition("==`varlevel'") outcome(dep_anx)
	
		}

	end

*******************************************************************************

* Set up output file

		use "$Datadir\table_2_dataset.dta", clear
		
		gen dep_anx = 1 if depression==1
		replace dep_anx = 2 if anxiety==1
		replace dep_anx = 3 if depression==1 & anxiety==1
		replace dep_anx = 4 if depression==0 & anxiety==0
		
		gen no_indic = 1 if depression==0 & anxiety==0 & mood==0 & ed==0 & pain==0 & dn==0 & incont==0 & migraine==0 & headache==0

********************************************************************************
* 2 - Prepare formats for data for output
********************************************************************************

		cap file close tablecontent
		file open tablecontent using "$Tabledir\supp_other indics.txt", write text replace

		file write tablecontent "Variable" _tab "Level" _tab "Total exposed n (%)" _tab "Depression n (%)" _tab "Anxiety n (%)" _tab "Depression and anxiety n (%)" _tab "Neither depression nor anxiety n (%)" _n
		
		gen byte total=1
		tabulatevariable, variable(total) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(depression) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(anxiety) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(mood) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(ed) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(pain) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(dn) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(incont) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(migraine) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(headache) start(1) end(1) outcome(dep_anx)
		tabulatevariable, variable(no_indic) start(1) end(1) outcome(dep_anx)
		
		file close tablecontent

********************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl
  
  log close other_indications
	
	translate "$Logdir\4_supplement\12_other indications.smcl" "$Logdir\4_supplement\12_other indications.pdf", replace
	
	erase "$Logdir\4_supplement\12_other indications.smcl"

********************************************************************************
