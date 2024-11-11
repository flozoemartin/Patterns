********************************************************************************

* Creating supplementary table for patterns of prescribing paper - discontinuation by trimester among those with at least 27 completed weeks' gestation

* Author: Harriet Forbes (amended by Flo Martin for antidepressant project)

* Date: 08/08/2024

********************************************************************************

* Table S5 - Patterns of discontinuation among those with at least 27 completed weeks’ gestation.

********************************************************************************

* Start logging 

	log using "$Logdir\4_supplement\4_discont by trimester", name(discont_by_trimester) replace
	
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
		file write tablecontent %11.0fc (`rowdenom') (" (") %4.1fc (100) (")")  _tab

		cou if prevalent==1 
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (100) (")")  _tab

		cou if prevalent==0 
		local rowdenom = r(N)
		cou if prevalent==0 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (100) (")")  _n
	
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
		
		cou if prevalent!=. & discontinuer==1
		local rowdenom = r(N)
		cou if prevalent!=. & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==1 & discontinuer==1
		local rowdenom = r(N)
		cou if prevalent==1 & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom')
		file write tablecontent %11.0fc (r(N)) (" (") %4.1fc (`pct') (")") _tab

		cou if prevalent==0 & discontinuer==1
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
		
		keep if gestdays>=203
		
		gen footnote_evidence_changes = 0 if any_preg==1 & (regimen_changes==6 | regimen_changes_multi==6)
		replace footnote_evidence_changes = 1 if any_preg==1 & regimen_changes<6
		replace footnote_evidence_changes = 1 if any_preg==1 & regimen_changes_multi<6
		tab footnote_evidence_changes
		
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
		file open tablecontent using "$Tabledir\supp_discont by trimester.txt", write text replace

		file write tablecontent "Variable" _tab "Level" _tab "Total (exposed during pregnancy)" _tab "Prevalent user (antidepressant use in the 3 months prior to pregnancy)" _tab "Incident user (no antidepressant use in the 3 months prior to pregnancy)" _n
		
		gen total=1
		tabulatetitlevariable, variable(discontinuer) start(1) end(1) outcome(prevalent)
		file write tablecontent _n

		tabulatediscontvariable, variable(discont_trimester) start(1) end(3) outcome(prevalent)
		file write tablecontent _n
		
		file close tablecontent
		
********************************************************************************

* Stop logging
		
	log close discont_by_trimester
	
	translate "$Logdir\4_supplement\4_discont by trimester.smcl" "$Logdir\4_supplement\4_discont by trimester.pdf", replace
	
	erase "$Logdir\4_supplement\4_discont by trimester.smcl"

********************************************************************************
