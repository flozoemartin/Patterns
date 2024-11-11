********************************************************************************

* Creating table 1 for patterns of prescribing paper - characteristics of patients in the study

* Author: Flo Martin 

* Date: 30/03/2024

********************************************************************************

* Table 1 in patterns of prescribing paper is created by this script

********************************************************************************

* Start logging 

	log using "$Logdir\2_analysis\2_characteristics table", name(characteristics_table) replace
	
********************************************************************************

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
		file write tablecontent %11.0fc (`rowdenom') (" (") %4.1f (`colpct') (")") _tab

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

********************************************************************************

* Generic code to output one section (varible) within table (calls above)

	cap prog drop tabulatevariable
	prog define tabulatevariable
		
		syntax, variable(varname) start(real) end(real) [missing] outcome(string)

		foreach varlevel of numlist `start'/`end'{ 
		
			generaterow, variable(`variable') condition("==`varlevel'") outcome(any_preg)
	
		}
	
		if "`missing'"!="" generaterow, variable(`variable') condition(">=.") outcome(any_preg)

	end

********************************************************************************

* Set up output file

		use "$Datadir\table_2_dataset.dta", clear

*********************************************************************************
* 2 - Prepare formats for data for output
*********************************************************************************

		*ethnicity
		recode eth5 5=.
		*bmi
		recode bmi_cat 4=.
		*smoking
		recode smokstatus 3=.

		cap file close tablecontent
		file open tablecontent using "$Tabledir\characteristic table.txt", write text replace

		file write tablecontent "Variable" _tab "Level" _tab "Total" _tab "Exposed to antidepressants during pregnancy" _tab "Unexposed to antidepressants during pregnancy" _n
		
		gen byte total=1
		tabulatevariable, variable(total) start(1) end(1) outcome(any_preg)
		
		file write tablecontent "Maternal age at start of pregnancy" _n

		tabulatevariable, variable(matage_cat) start(1) end(5) outcome(any_preg) 
		
		file write tablecontent "Practice IMD (in quintiles)" _n

		tabulatevariable, variable(imd_practice) start(1) end(5) outcome(any_preg)
		
		file write tablecontent "Maternal ethnicity" _n

		tabulatevariable, variable(eth5) start(0) end(4) missing outcome(any_preg)
		
		file write tablecontent "Maternal body mass index (BMI)" _n

		tabulatevariable, variable(bmi_cat) start(0) end(3) missing outcome(any_preg)
		
		file write tablecontent "Maternal smoking status during or before pregnancy" _n

		tabulatevariable, variable(smokstatus) start(0) end(2) missing outcome(any_preg) 

		file write tablecontent "Maternal alcohol intake during or before pregnancy" _n

		tabulatevariable, variable(alcstatus) start(0) end(2) missing outcome(any_preg)
		
		file write tablecontent "Illicit drug use during pregnancy" _n
	
		tabulatevariable, variable(illicitdrug_preg) start(0) end(1) outcome(any_preg) 
		
		file write tablecontent "Maternal history of pregnancy loss at the start of pregnancy" _n

		tabulatevariable, variable(grav_hist_sa) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(grav_hist_sb) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(grav_hist_top) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(grav_hist_otherloss) start(1) end(1) outcome(any_preg)

		file write tablecontent "Maternal parity at the start of pregnancy" _n
		
		tabulatevariable, variable(parity_cat) start(0) end(3) outcome(any_preg)
		
		file write tablecontent "Number of consultations in the 12 months before pregnancy" _n

		tabulatevariable, variable(CPRD_consultation_events_cat) start(0) end(3) outcome(any_preg)
 
		file write tablecontent "Number of consultations during pregnancy" _n
		
		tabulatevariable, variable(CPRD_consult_events_preg_cat) start(0) end(3) outcome(any_preg)

		file write tablecontent "Maternal mental health problems ever before or during pregnancy" _n

		tabulatevariable, variable(depression) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(anxiety) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(bipolar) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(schizo) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(ed) start(1) end(1) outcome(any_preg)

		file write tablecontent "Maternal neurodevelopmental disorder ever" _n

		tabulatevariable, variable(autism) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(adhd) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(id) start(1) end(1) outcome(any_preg)

		file write tablecontent "Possible somatic indications for antidepressants ever before or during pregnancy" _n

		tabulatevariable, variable(pain) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(dn) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(incont) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(migraine) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(headache) start(1) end(1) outcome(any_preg)
		
		file write tablecontent "Other mental health-related prescriptions during pregnancy" _n
		
		tabulatevariable, variable(antipsychotics_preg) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(benzos_preg) start(1) end(1) outcome(any_preg) 
		tabulatevariable, variable(zdrugs_preg) start(1) end(1) outcome(any_preg) 
		tabulatevariable, variable(moodstabs_preg) start(1) end(1) outcome(any_preg) 
		
		file write tablecontent "Other prescriptions during pregnancy" _n
		
		tabulatevariable, variable(teratogen_preg) start(1) end(1) outcome(any_preg) 
		tabulatevariable, variable(multivit_preg) start(1) end(1) outcome(any_preg) 
		tabulatevariable, variable(folic_preg0) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(folic_preg1) start(1) end(1) outcome(any_preg)
		tabulatevariable, variable(antiemetic_preg) start(1) end(1) outcome(any_preg)
		
		file close tablecontent
		
********************************************************************************

* Stop logging, translate .smcl into .pdf and erase .smcl

	log close characteristics_table
	
	translate "$Logdir\2_analysis\2_characteristics table.smcl" "$Logdir\2_analysis\2_characteristics table.pdf", replace
	
	erase "$Logdir\2_analysis\2_characteristics table.smcl"

********************************************************************************
