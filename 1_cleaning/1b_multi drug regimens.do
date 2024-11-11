********************************************************************************************

* Dealing with the multi-drug regimen people

* Author: Flo Martin

* Date: 14/10/2022

********************************************************************************************

	use "$Tempdatadir\patterns_in_pregnancy_formultiscript.dta", clear

	tab multi_drug
	tab multi_drug any_discont
	* n = 399 discontinue at some point during pregnancy
	* n = 211 continue throughout pregnancy
	
	keep if multi_drug==1 
	count
	
* All I need from the discontinuers is evidence of regimen changes for the main table but then for the continuers I want to know about dose changes, product switching (?) and product adding/dropping from regimens

* Dose changes

	* Dose decrease
	gen dose_reduc_multi =.
	foreach x in a b c {
	
		replace dose_reduc_multi = 1 if (drugsubstance1`x'==drugsubstance2`x') & (presc_startdate_num1`x'!=presc_startdate_num2`x') & (dd_mg1`x'>dd_mg2`x')
		replace dose_reduc_multi = 1 if (drugsubstance1`x'==drugsubstance3`x') & (presc_startdate_num1`x'!=presc_startdate_num3`x') & (dd_mg1`x'>dd_mg3`x')
		replace dose_reduc_multi = 1 if (drugsubstance1`x'==drugsubstance4`x') & (presc_startdate_num1`x'!=presc_startdate_num4`x') & (dd_mg1`x'>dd_mg4`x')
		replace dose_reduc_multi = 1 if (drugsubstance1`x'==drugsubstance5`x') & (presc_startdate_num1`x'!=presc_startdate_num5`x') & (dd_mg1`x'>dd_mg5`x')
		
		replace dose_reduc_multi = 1 if (drugsubstance2`x'==drugsubstance3`x') & (presc_startdate_num2`x'!=presc_startdate_num3`x') & (dd_mg2`x'>dd_mg3`x')
		replace dose_reduc_multi = 1 if (drugsubstance2`x'==drugsubstance4`x') & (presc_startdate_num2`x'!=presc_startdate_num4`x') & (dd_mg2`x'>dd_mg4`x')
		replace dose_reduc_multi = 1 if (drugsubstance2`x'==drugsubstance5`x') & (presc_startdate_num2`x'!=presc_startdate_num5`x') & (dd_mg2`x'>dd_mg5`x')
		replace dose_reduc_multi = 1 if (drugsubstance2`x'==drugsubstance6`x') & (presc_startdate_num2`x'!=presc_startdate_num6`x') & (dd_mg2`x'>dd_mg6`x')
		
		replace dose_reduc_multi = 1 if (drugsubstance3`x'==drugsubstance4`x') & (presc_startdate_num3`x'!=presc_startdate_num4`x') & (dd_mg3`x'>dd_mg4`x')
		replace dose_reduc_multi = 1 if (drugsubstance3`x'==drugsubstance5`x') & (presc_startdate_num3`x'!=presc_startdate_num5`x') & (dd_mg3`x'>dd_mg5`x')
		replace dose_reduc_multi = 1 if (drugsubstance3`x'==drugsubstance6`x') & (presc_startdate_num3`x'!=presc_startdate_num6`x') & (dd_mg3`x'>dd_mg6`x')
		
		replace dose_reduc_multi = 1 if (drugsubstance4`x'==drugsubstance5`x') & (presc_startdate_num4`x'!=presc_startdate_num5`x') & (dd_mg4`x'>dd_mg5`x')
		replace dose_reduc_multi = 1 if (drugsubstance4`x'==drugsubstance6`x') & (presc_startdate_num4`x'!=presc_startdate_num6`x') & (dd_mg4`x'>dd_mg6`x')
		replace dose_reduc_multi = 1 if (drugsubstance4`x'==drugsubstance7`x') & (presc_startdate_num4`x'!=presc_startdate_num7`x') & (dd_mg4`x'>dd_mg7`x')
		
		replace dose_reduc_multi = 1 if (drugsubstance5`x'==drugsubstance6`x') & (presc_startdate_num5`x'!=presc_startdate_num6`x') & (dd_mg5`x'>dd_mg6`x')
		replace dose_reduc_multi = 1 if (drugsubstance5`x'==drugsubstance7`x') & (presc_startdate_num5`x'!=presc_startdate_num7`x') & (dd_mg5`x'>dd_mg7`x')
		
		replace dose_reduc_multi = 1 if (drugsubstance6`x'==drugsubstance7`x') & (presc_startdate_num6`x'!=presc_startdate_num7`x') & (dd_mg6`x'>dd_mg7`x')
	
	}
	
	tab dose_reduc_multi
	br if dose_reduc_multi==1
	
	* Dose increase
	gen dose_increase_multi =.
	foreach x in a b c {
	
		replace dose_increase_multi = 1 if (drugsubstance1`x'==drugsubstance2`x') & (presc_startdate_num1`x'!=presc_startdate_num2`x') & (dd_mg1`x'<dd_mg2`x')
		replace dose_increase_multi = 1 if (drugsubstance1`x'==drugsubstance3`x') & (presc_startdate_num1`x'!=presc_startdate_num3`x') & (dd_mg1`x'<dd_mg3`x')
		replace dose_increase_multi = 1 if (drugsubstance1`x'==drugsubstance4`x') & (presc_startdate_num1`x'!=presc_startdate_num4`x') & (dd_mg1`x'<dd_mg4`x')
		replace dose_increase_multi = 1 if (drugsubstance1`x'==drugsubstance5`x') & (presc_startdate_num1`x'!=presc_startdate_num5`x') & (dd_mg1`x'<dd_mg5`x')
		
		replace dose_increase_multi = 1 if (drugsubstance2`x'==drugsubstance3`x') & (presc_startdate_num2`x'!=presc_startdate_num3`x') & (dd_mg2`x'<dd_mg3`x')
		replace dose_increase_multi = 1 if (drugsubstance2`x'==drugsubstance4`x') & (presc_startdate_num2`x'!=presc_startdate_num4`x') & (dd_mg2`x'<dd_mg4`x')
		replace dose_increase_multi = 1 if (drugsubstance2`x'==drugsubstance5`x') & (presc_startdate_num2`x'!=presc_startdate_num5`x') & (dd_mg2`x'<dd_mg5`x')
		replace dose_increase_multi = 1 if (drugsubstance2`x'==drugsubstance6`x') & (presc_startdate_num2`x'!=presc_startdate_num6`x') & (dd_mg2`x'<dd_mg6`x')
		
		replace dose_increase_multi = 1 if (drugsubstance3`x'==drugsubstance4`x') & (presc_startdate_num3`x'!=presc_startdate_num4`x') & (dd_mg3`x'<dd_mg4`x')
		replace dose_increase_multi = 1 if (drugsubstance3`x'==drugsubstance5`x') & (presc_startdate_num3`x'!=presc_startdate_num5`x') & (dd_mg3`x'<dd_mg5`x')
		replace dose_increase_multi = 1 if (drugsubstance3`x'==drugsubstance6`x') & (presc_startdate_num3`x'!=presc_startdate_num6`x') & (dd_mg3`x'<dd_mg6`x')
		
		replace dose_increase_multi = 1 if (drugsubstance4`x'==drugsubstance5`x') & (presc_startdate_num4`x'!=presc_startdate_num5`x') & (dd_mg4`x'<dd_mg5`x')
		replace dose_increase_multi = 1 if (drugsubstance4`x'==drugsubstance6`x') & (presc_startdate_num4`x'!=presc_startdate_num6`x') & (dd_mg4`x'<dd_mg6`x')
		replace dose_increase_multi = 1 if (drugsubstance4`x'==drugsubstance7`x') & (presc_startdate_num4`x'!=presc_startdate_num7`x') & (dd_mg4`x'<dd_mg7`x')
		
		replace dose_increase_multi = 1 if (drugsubstance5`x'==drugsubstance6`x') & (presc_startdate_num5`x'!=presc_startdate_num6`x') & (dd_mg5`x'<dd_mg6`x')
		replace dose_increase_multi = 1 if (drugsubstance5`x'==drugsubstance7`x') & (presc_startdate_num5`x'!=presc_startdate_num7`x') & (dd_mg5`x'<dd_mg7`x')
		
		replace dose_increase_multi = 1 if (drugsubstance6`x'==drugsubstance7`x') & (presc_startdate_num6`x'!=presc_startdate_num7`x') & (dd_mg6`x'<dd_mg7`x')
	
	}
	
	tab dose_increase_multi
	br if dose_increase_multi==1
	
	gen dose_fluc_multi = 1 if dose_increase_multi==1 & dose_reduc_multi==1
	br if dose_reduc_multi==. & dose_increase_multi==.
	
* Product dropping or adding
	tab n_t1
	tab n_t2
	tab n_t3
	
	gen prod_dropped = 1 if n_t1>n_t2 | n_t2>n_t3 | n_t1>n_t3
	gen prod_added = 1 if n_t1<n_t2 | n_t2<n_t3 | n_t1<n_t3
	
	br n_t1 n_t2 n_t3 prod_added prod_dropped
	gen regimen_change = 1 if prod_dropped==1
	replace regimen_change = 2 if prod_added==1
	replace regimen_change = 3 if prod_added==1 & prod_dropped==1
	
	label define regimen_change_lb 1"Product added" 2"Product dropped" 3"Products dropped & added"
	label values regimen_change regimen_change_lb
	tab regimen_change
	
	tab regimen_change dose_reduc_multi
	
	gen only_regimen_change = regimen_change if regimen_change!=. & any_discont==0
	
	gen no_change_cont_multi = 1 if any_discont==0 & dose_reduc_multi==. & dose_increase_multi==. & regimen_change==.
	tab no_change_cont_multi
	br if no_change_cont_multi==1 // n = 3 have a prescription for another AD in amongst their regular multi-drug regimen - not really adding a product to the regimen unless
	
	gen dose_changes_multi = 1 if dose_reduc_multi==1 
	replace dose_changes_multi = 2 if dose_increase_multi==1  
	replace dose_changes_multi = 3 if dose_fluc_multi==1 
	
	tab dose_changes_multi
	tab dose_changes_multi if any_discont==1
	tab dose_changes_multi if any_discont==0
	
	gen only_dose_changes_multi = dose_changes_multi if regimen_change==.

 ********************************************************************************************
	gen any_only_dose_changes_multi = 1 if only_dose_changes_multi!=.
	
	gen multi_change_multi = 1 if dose_changes_multi!=. & regimen_change!=.
	
	save "$Tempdatadir\patterns_in_pregnancy_multi.dta", replace
