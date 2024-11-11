********************************************************************************

* Creating table 3 for patterns of prescribing paper - patterns of prescribing during pregnancy by pre-pregnancy prescribing

* Author: Harriet Forbes (amended by Flo Martin for antidepressant project)

* Date started: 11/10/2022

* Date finished: 11/10/2022

********************************************************************************

* Table S8 - Patterns of prescribing stratified by pre-pregnancy use among those with linked secondary care (HES) data.

********************************************************************************

* Start logging 

	log using "$Logdir\4_supplement", name(patterns_in_hes) replace
	
********************************************************************************

	clear all

	* Generic code to output top row of table (denominator is total exposed pregnancies then proportion of those that are continuers, early initiators etc.)
	cap prog drop generatetoprow

	program define generatetoprow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		local overalldenom=r(N)
		
		cou if `variable' `condition'
		local rowdenom = r(N)
		local colpct = 100*(r(N)/`overalldenom')
		file write tablecontent %11.0fc (`rowdenom') _tab

		cou if prevalent==1 
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) _tab

		cou if prevalent==0 
		local rowdenom = r(N)
		cou if prevalent==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) _n
	
	end
	
	* Generic code to output one of two rows of table within continuation or discontinuation (defining the denominator for within discont/cont patterns analysis so should be 100%)
	cap prog drop generatetitlerow

	program define generatetitlerow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		
		cou if `variable' `condition'
		local coldenom = r(N)
		local colpct = 100
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`colpct') (")") _tab

		cou if prevalent==1 
		local coldenom = r(N) 
		cou if prevalent==1 & `variable' `condition'
		local colpct = 100
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`colpct') (")") _tab

		cou if prevalent==0 
		local coldenom = r(N) 
		cou if prevalent==0 & `variable' `condition'
		local colpct = 100
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`colpct') (")") _n
	
	end

* Generic code to output one row of table within discontinuation (denominator is the number who discontinue)
	cap prog drop generatediscontrow

	program define generatediscontrow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		
		cou if prevalent!=. 
		local rowdenom = r(N)
		cou if prevalent!=. & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==1 
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==0 
		local rowdenom = r(N)
		cou if prevalent==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _n
	
	end	
	
* Generic code to output one row of table within continuation of single drug regimen (denominator is the number who continue)
	cap prog drop generatesinglecontrow

	program define generatesinglecontrow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		
		cou if prevalent!=. & discontinuer_single==0
		local rowdenom = r(N)
		cou if prevalent!=. & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==1 & discontinuer_single==0
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==0 & discontinuer_single==0
		local rowdenom = r(N)
		cou if prevalent==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _n
	
	end	
	
* Generic code to output one row of table within continuation of multi drug regimen (denominator is the number who continue)
	cap prog drop generatemulticontrow

	program define generatemulticontrow
		
		syntax, variable(varname) condition(string) outcome(string)
	
		* Put the varname and condition to left so that alignment can be checked vs shell
		file write tablecontent ("`variable'") _tab ("`condition'") _tab
		
		cou
		
		cou if prevalent!=. & discontinuer==0 & multi_drug==1
		local rowdenom = r(N)
		cou if prevalent!=. & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==1 & discontinuer==0 & multi_drug==1
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==0 & discontinuer==0 & multi_drug==1
		local rowdenom = r(N)
		cou if prevalent==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _n
	
	end	


********************************************************************************

* Generic code to output one section (varible) within table (calls above)

	cap prog drop tabulatetopvariable
	prog define tabulatetopvariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 
		
			generatetoprow, variable(`variable') condition("==`varlevel'") outcome(prevalent)
	
		}

	end
	
	cap prog drop tabulatetitlevariable
	prog define tabulatetitlevariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 

				generatetitlerow, variable(`variable') condition("==`varlevel'") outcome(discontinuer)
				
		}
		
	end
	
	cap prog drop tabulatediscontvariable
	prog define tabulatediscontvariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 

				generatediscontrow, variable(`variable') condition("==`varlevel'") outcome(discontinuer)
				
		}
		
	end
	
	cap prog drop tabulatesinglecontvariable
	prog define tabulatesinglecontvariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 

				generatesinglecontrow, variable(`variable') condition("==`varlevel'") outcome(discontinuer)
				
		}
		
	end
	
	cap prog drop tabulatemulticontvariable
	prog define tabulatemulticontvariable
		
		syntax, variable(varname) start(real) end(real) outcome(string)

		foreach varlevel of numlist `start'/`end'{ 

				generatemulticontrow, variable(`variable') condition("==`varlevel'") outcome(discontinuer)
				
		}
		
	end
	
********************************************************************************

* Set up output file

		use "$Datadir\patterns_in_pregnancy_long.dta", clear
		
		keep if hes_apc_e==1
		
		gen footnote_evidence_changes = 0 if any_preg==1 & (regimen_changes==6 | regimen_changes_multi==6)
		replace footnote_evidence_changes = 1 if any_preg==1 & regimen_changes<6
		replace footnote_evidence_changes = 1 if any_preg==1 & regimen_changes_multi<6
		tab footnote_evidence_changes if discontinuer==1
		
		tab discont_trimester footnote_evidence_changes, row
		
		tab discont_trimester footnote_evidence_changes if prevalent==1, row
		
		tab discont_trimester footnote_evidence_changes if prevalent==0, row
		
		gen discontinuer_single = 0 if single_drug==1 & discontinuer==0
		gen discontinuer_multi = 0 if multi_drug==1 & discontinuer==0
		
		gen regimen_changes_cont = regimen_changes if discontinuer==0
		gen regimen_changes_multi_cont = regimen_changes_multi if discontinuer==0

*********************************************************************************
* 2 - Prepare formats for data for output
*********************************************************************************

		keep if prevalent!=.

		cap file close tablecontent
		file open tablecontent using "$Tabledir\supp_patterns hes only.txt", write text replace

		file write tablecontent "Variable" _tab "Level" _tab "Total (exposed during pregnancy)" _tab "Prevalent user (antidepressant use in the 3 months prior to pregnancy)" _tab "Incident user (no antidepressant use in the 3 months prior to pregnancy)" _n
		
		gen total=1
		tabulatetopvariable, variable(total) start(1) end(1) outcome(prevalent)
		file write tablecontent _n

		tabulatediscontvariable, variable(discontinuer) start(1) end(1) outcome(prevalent)
		tabulatediscontvariable, variable(discontinuer_single) start(0) end(0) outcome(prevalent)
		tabulatediscontvariable, variable(discontinuer_multi) start(0) end(0) outcome(prevalent)
		file write tablecontent _n
		
		tabulatetitlevariable, variable(discontinuer_single) start(0) end(0) outcome(prevalent)
		tabulatesinglecontvariable, variable(regimen_changes_cont) start(1) end(6) outcome(prevalent)
		file write tablecontent _n
		
		tabulatetitlevariable, variable(discontinuer_multi) start(0) end(0) outcome(prevalent)
		tabulatemulticontvariable, variable(regimen_changes_multi_cont) start(1) end(6) outcome(prevalent)
		file close tablecontent
		
********************************************************************************

* Stop logging
		
	log close patterns_in_hes
	
	translate "$Logdir\4_supplement\7_patterns in hes.smcl" "$Logdir\4_supplement\7_patterns in hes.pdf", replace
	
	erase "$Logdir\4_supplement\7_patterns in hes.smcl"

********************************************************************************
