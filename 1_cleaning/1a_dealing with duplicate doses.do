*********************************************************************************

* Dealing with the "duplicate doses"

* Author: Flo Martin

* Date: 04/07/2023

*********************************************************************************

	use "$Tempdatadir\patterns_in_pregnancy_dup_dataset.dta", clear

* Some people have two prescriptions written on the same day for the same drug but different prescriptions - this may be because drugs are dosed at specific doses - i.e. moclobemide can only be given in 150mg and 300mg tablets but may be dosed up to 600mg. Thus, this person would be prescribed 2 x 300mg on the same day. Check with Dheeraj
	
	* What I can do is create a variable that combines these dose milligrams depending on how many there in the sequence
	
	gen presc_startdate_num8b =.
	gen presc_enddate_num8b =.
	
	gen drugsubstance8b =.
	gen dd_mg8b =.
	gen dosage8b =.
	
	gen presc_startdate_num8c =.
	gen presc_enddate_num8c =.
	
	gen drugsubstance8c =.
	gen dd_mg8c =.
	gen dosage8c =.
	
	foreach x in a b c {
	
		gen dd_mg_comb_1`x'2 = (dd_mg1`x' + dd_mg2`x') if (drugsubstance1`x'==drugsubstance2`x')  & (presc_startdate_num1`x'==presc_startdate_num2`x')
		gen dd_mg_comb_1`x'3 = (dd_mg1`x' + dd_mg2`x' + dd_mg3`x') if (drugsubstance1`x'==drugsubstance2`x') & (drugsubstance2`x'==drugsubstance3`x') & (presc_startdate_num1`x'==presc_startdate_num2`x') & (presc_startdate_num2`x'==presc_startdate_num3`x') 
		gen dd_mg_comb_1`x'4 = (dd_mg1`x' + dd_mg2`x' + dd_mg3`x' + dd_mg4`x') if (drugsubstance1`x'==drugsubstance2`x') & (drugsubstance2`x'==drugsubstance3`x') & (drugsubstance3`x' == drugsubstance4`x') & (presc_startdate_num1`x'==presc_startdate_num2`x') & (presc_startdate_num2`x'==presc_startdate_num3`x') & (presc_startdate_num3`x' == presc_startdate_num4`x')   

		gen dd_mg_comb_2`x'2 = (dd_mg2`x' + dd_mg3`x') if (drugsubstance2`x'==drugsubstance3`x')  & (presc_startdate_num2`x'==presc_startdate_num3`x') & dd_mg_comb_1`x'2==. & dd_mg_comb_1`x'3==. & dd_mg_comb_1`x'4==.
		gen dd_mg_comb_2`x'3 = (dd_mg2`x' + dd_mg3`x' + dd_mg4`x') if (drugsubstance2`x'==drugsubstance3`x') & (drugsubstance3`x' == drugsubstance4`x')  & (presc_startdate_num2`x'==presc_startdate_num3`x') & (presc_startdate_num3`x' == presc_startdate_num4`x') & dd_mg_comb_1`x'2==. & dd_mg_comb_1`x'3==. & dd_mg_comb_1`x'4==.
		gen dd_mg_comb_2`x'4 = (dd_mg2`x' + dd_mg3`x' + dd_mg4`x' + dd_mg5`x') if (drugsubstance2`x'==drugsubstance3`x') & (drugsubstance3`x' == drugsubstance4`x') & (drugsubstance4`x' == drugsubstance5`x')  & (presc_startdate_num2`x'==presc_startdate_num3`x') & (presc_startdate_num3`x' ==presc_startdate_num4`x') & (presc_startdate_num4`x' == presc_startdate_num5`x') & dd_mg_comb_1`x'2==. & dd_mg_comb_1`x'3==. & dd_mg_comb_1`x'4==.

		gen dd_mg_comb_3`x'2 = (dd_mg3`x' + dd_mg4`x') if (drugsubstance3`x'==drugsubstance4`x')  & (presc_startdate_num3`x'==presc_startdate_num4`x') & dd_mg_comb_2`x'2==. & dd_mg_comb_2`x'3==. & dd_mg_comb_2`x'4==.
		gen dd_mg_comb_3`x'3 = (dd_mg3`x' + dd_mg4`x' + dd_mg5`x') if (drugsubstance3`x'==drugsubstance4`x') & (drugsubstance4`x' == drugsubstance5`x')  & (presc_startdate_num3`x'==presc_startdate_num4`x') & (presc_startdate_num4`x' == presc_startdate_num5`x') & dd_mg_comb_2`x'2==. & dd_mg_comb_2`x'3==. & dd_mg_comb_2`x'4==.
		gen dd_mg_comb_3`x'4 = (dd_mg3`x' + dd_mg4`x' + dd_mg5`x' + dd_mg6`x') if (drugsubstance3`x'==drugsubstance4`x') & (drugsubstance4`x' == drugsubstance5`x') & (drugsubstance5`x'==drugsubstance6`x')  & (presc_startdate_num3`x'==presc_startdate_num4`x') & (presc_startdate_num4`x' == presc_startdate_num5`x') & (presc_startdate_num5`x'==presc_startdate_num6`x') & dd_mg_comb_2`x'2==. & dd_mg_comb_2`x'3==.  & dd_mg_comb_2`x'4==.
		
		gen dd_mg_comb_4`x'2 = (dd_mg4`x' + dd_mg5`x') if (drugsubstance4`x'==drugsubstance5`x')  & (presc_startdate_num4`x'==presc_startdate_num5`x')  & dd_mg_comb_3`x'2==. & dd_mg_comb_3`x'3==. & dd_mg_comb_3`x'4==.
		gen dd_mg_comb_4`x'3 = (dd_mg4`x' + dd_mg5`x' + dd_mg6`x') if (drugsubstance4`x'==drugsubstance5`x') & (drugsubstance5`x'==drugsubstance6`x')  & (presc_startdate_num4`x'==presc_startdate_num5`x') & (presc_startdate_num5`x'==presc_startdate_num6`x') & dd_mg_comb_3`x'2==. & dd_mg_comb_3`x'3==. & dd_mg_comb_3`x'4==.
		gen dd_mg_comb_4`x'4 = (dd_mg4`x' + dd_mg5`x' + dd_mg6`x' + dd_mg7`x') if (drugsubstance4`x'==drugsubstance5`x') & (drugsubstance5`x'==drugsubstance6`x') & (drugsubstance6`x'==drugsubstance7`x')  & (presc_startdate_num4`x'==presc_startdate_num5`x') & (presc_startdate_num5`x'==presc_startdate_num6`x') & (presc_startdate_num6`x'==presc_startdate_num7`x') & dd_mg_comb_3`x'2==. & dd_mg_comb_3`x'3==. & dd_mg_comb_3`x'4==.
		
		gen dd_mg_comb_5`x'2 = (dd_mg5`x' + dd_mg6`x') if (drugsubstance5`x'==drugsubstance6`x')  & (presc_startdate_num5`x'==presc_startdate_num6`x') & dd_mg_comb_4`x'2==. & dd_mg_comb_4`x'3==. & dd_mg_comb_4`x'4==.
		gen dd_mg_comb_5`x'3 = (dd_mg5`x' + dd_mg6`x' + dd_mg7`x') if (drugsubstance5`x'==drugsubstance6`x') & (drugsubstance6`x'==drugsubstance7`x')  & (presc_startdate_num5`x'==presc_startdate_num6`x') & (presc_startdate_num6`x' & presc_startdate_num7`x') & dd_mg_comb_4`x'2==. & dd_mg_comb_4`x'3==. & dd_mg_comb_4`x'4==.
		
		gen dd_mg_comb_6`x'2 = (dd_mg6`x' + dd_mg7`x') if (drugsubstance6`x'==drugsubstance7`x')  & (presc_startdate_num6`x'==presc_startdate_num7`x') & dd_mg_comb_5`x'2==. & dd_mg_comb_5`x'3==.
		gen dd_mg_comb_6`x'3 = (dd_mg6`x' + dd_mg7`x' + dd_mg8`x') if (drugsubstance6`x'==drugsubstance7`x') & (drugsubstance7`x'==drugsubstance8`x') & (presc_startdate_num6`x'==presc_startdate_num7`x') & (presc_startdate_num7`x'==presc_startdate_num8`x') & dd_mg_comb_5`x'2==. & dd_mg_comb_5`x'3==. 
	
		}
		
	gen dup=.
	
	foreach x in a b c {
		
		replace dup = 1 if dd_mg_comb_1`x'2!=.
		replace dup = 1 if dd_mg_comb_1`x'3!=.
		replace dup = 1 if dd_mg_comb_1`x'4!=.
		replace dup = 1 if dd_mg_comb_2`x'2!=.
		replace dup = 1 if dd_mg_comb_2`x'3!=.
		replace dup = 1 if dd_mg_comb_2`x'4!=.
		replace dup = 1 if dd_mg_comb_3`x'2!=.
		replace dup = 1 if dd_mg_comb_3`x'3!=.
		replace dup = 1 if dd_mg_comb_3`x'4!=.
		replace dup = 1 if dd_mg_comb_4`x'2!=.
		replace dup = 1 if dd_mg_comb_4`x'3!=.
		replace dup = 1 if dd_mg_comb_4`x'4!=.
		replace dup = 1 if dd_mg_comb_5`x'2!=.
		replace dup = 1 if dd_mg_comb_5`x'3!=.
		replace dup = 1 if dd_mg_comb_6`x'2!=.
		replace dup = 1 if dd_mg_comb_6`x'3!=.
		
	}
	
	
	* And then get rid of the "duplicate" pxns leaving only the first 
	
	foreach x in a b c {
	
		* Where the multiple drugs start on 1`x'
	
		replace drugsubstance2`x' =. if dd_mg_comb_1`x'2!=.
		replace dd_mg2`x' =. if dd_mg_comb_1`x'2!=.
		replace presc_startdate_num2`x' =. if dd_mg_comb_1`x'2!=.
		replace presc_enddate_num2`x' =. if dd_mg_comb_1`x'2!=.
		replace dosage2`x' =. if dd_mg_comb_1`x'2!=.
		
			replace dd_mg1`x' = dd_mg_comb_1`x'2 if dd_mg_comb_1`x'2!=.
		
		replace drugsubstance3`x' =. if dd_mg_comb_1`x'3!=. 
		replace dd_mg3`x' =. if dd_mg_comb_1`x'3!=.
		replace presc_startdate_num3`x' =. if dd_mg_comb_1`x'3!=.
		replace presc_enddate_num3`x' =. if dd_mg_comb_1`x'3!=.
		replace dosage3`x' =. if dd_mg_comb_1`x'3!=.
			
			replace dd_mg1`x' = dd_mg_comb_1`x'3 if dd_mg_comb_1`x'3!=.
	
		replace drugsubstance4`x' =. if dd_mg_comb_1`x'4!=. 
		replace dd_mg4`x' =. if dd_mg_comb_1`x'4!=.
		replace presc_startdate_num4`x' =. if dd_mg_comb_1`x'4!=.
		replace presc_enddate_num4`x' =. if dd_mg_comb_1`x'4!=.
		replace dosage4`x' =. if dd_mg_comb_1`x'4!=.
		
			replace dd_mg1`x' = dd_mg_comb_1`x'4 if dd_mg_comb_1`x'4!=.
	
		* Where the multiple drugs start on 2`x'
		
		replace drugsubstance3`x' =. if dd_mg_comb_2`x'2!=.
		replace dd_mg3`x' =. if dd_mg_comb_2`x'2!=.
		replace presc_startdate_num3`x' =. if dd_mg_comb_2`x'2!=.
		replace presc_enddate_num3`x' =. if dd_mg_comb_2`x'2!=.
		replace dosage3`x' =. if dd_mg_comb_2`x'2!=.
		
			replace dd_mg2`x' = dd_mg_comb_2`x'2 if dd_mg_comb_2`x'2!=.
		
		replace drugsubstance4`x' =. if dd_mg_comb_2`x'3!=. 
		replace dd_mg4`x' =. if dd_mg_comb_2`x'3!=.
		replace presc_startdate_num4`x' =. if dd_mg_comb_2`x'3!=.
		replace presc_enddate_num4`x' =. if dd_mg_comb_2`x'3!=.
		replace dosage4`x' =. if dd_mg_comb_2`x'3!=.
		
			replace dd_mg2`x' = dd_mg_comb_2`x'3 if dd_mg_comb_2`x'3!=.
	
		replace drugsubstance5`x' =. if dd_mg_comb_2`x'4!=. 
		replace dd_mg5`x' =. if dd_mg_comb_2`x'4!=.
		replace presc_startdate_num5`x' =. if dd_mg_comb_2`x'4!=.
		replace presc_enddate_num5`x' =. if dd_mg_comb_2`x'4!=.
		replace dosage5`x' =. if dd_mg_comb_2`x'4!=.
		
			replace dd_mg2`x' = dd_mg_comb_2`x'4 if dd_mg_comb_2`x'4!=.
		
		* Where the multiple drugs start on 3`x'
		
		replace drugsubstance4`x' =. if dd_mg_comb_3`x'2!=.
		replace dd_mg4`x' =. if dd_mg_comb_3`x'2!=.
		replace presc_startdate_num4`x' =. if dd_mg_comb_3`x'2!=.
		replace presc_enddate_num4`x' =. if dd_mg_comb_3`x'2!=.
		replace dosage4`x' =. if dd_mg_comb_3`x'2!=.
		
			replace dd_mg3`x' = dd_mg_comb_3`x'2 if dd_mg_comb_3`x'2!=.
		
		replace drugsubstance5`x' =. if dd_mg_comb_3`x'3!=. 
		replace dd_mg5`x' =. if dd_mg_comb_3`x'3!=.
		replace presc_startdate_num5`x' =. if dd_mg_comb_3`x'3!=.
		replace presc_enddate_num5`x' =. if dd_mg_comb_3`x'3!=.
		replace dosage5`x' =. if dd_mg_comb_3`x'3!=.
		
			replace dd_mg3`x' = dd_mg_comb_3`x'3 if dd_mg_comb_3`x'3!=.
	
		replace drugsubstance6`x' =. if dd_mg_comb_3`x'4!=. 
		replace dd_mg6`x' =. if dd_mg_comb_3`x'4!=.
		replace presc_startdate_num6`x' =. if dd_mg_comb_3`x'4!=.
		replace presc_enddate_num6`x' =. if dd_mg_comb_3`x'4!=.
		replace dosage6`x' =. if dd_mg_comb_3`x'4!=.
		
			replace dd_mg3`x' = dd_mg_comb_3`x'4 if dd_mg_comb_3`x'4!=.
		
		* Where the multiple drugs start on 4`x'
		
		replace drugsubstance5`x' =. if dd_mg_comb_4`x'2!=. 
		replace dd_mg5`x' =. if dd_mg_comb_4`x'2!=.
		replace presc_startdate_num5`x' =. if dd_mg_comb_4`x'2!=.
		replace presc_enddate_num5`x' =. if dd_mg_comb_4`x'2!=.
		replace dosage5`x' =. if dd_mg_comb_4`x'2!=.
		
			replace dd_mg4`x' = dd_mg_comb_4`x'2 if dd_mg_comb_4`x'2!=.
	
		replace drugsubstance6`x' =. if dd_mg_comb_4`x'3!=. 
		replace dd_mg6`x' =. if dd_mg_comb_4`x'3!=.
		replace presc_startdate_num6`x' =. if dd_mg_comb_4`x'3!=.
		replace presc_enddate_num6`x' =. if dd_mg_comb_4`x'3!=.
		replace dosage6`x' =. if dd_mg_comb_4`x'3!=.
		
			replace dd_mg4`x' = dd_mg_comb_4`x'3 if dd_mg_comb_4`x'3!=.
		
		replace drugsubstance7`x' =. if dd_mg_comb_4`x'4!=.
		replace dd_mg7`x' =. if dd_mg_comb_4`x'4!=.
		replace presc_startdate_num7`x' =. if dd_mg_comb_4`x'4!=.
		replace presc_enddate_num7`x' =. if dd_mg_comb_4`x'4!=.
		replace dosage7`x' =. if dd_mg_comb_4`x'4!=.
		
			replace dd_mg4`x' = dd_mg_comb_4`x'4 if dd_mg_comb_4`x'4!=.
		
		* Where the multiple drugs start on 5`x'
		
		replace drugsubstance6`x' =. if dd_mg_comb_5`x'2!=.
		replace dd_mg6`x' =. if dd_mg_comb_5`x'2!=.
		replace presc_startdate_num6`x' =. if dd_mg_comb_5`x'2!=.
		replace presc_enddate_num6`x' =. if dd_mg_comb_5`x'2!=.
		replace dosage6`x' =. if dd_mg_comb_5`x'2!=.
		
			replace dd_mg5`x' = dd_mg_comb_5`x'2 if dd_mg_comb_5`x'2!=.
		
		replace drugsubstance7`x' =. if dd_mg_comb_5`x'3!=. 
		replace dd_mg7`x' =. if dd_mg_comb_5`x'3!=.
		replace presc_startdate_num7`x' =. if dd_mg_comb_5`x'3!=.
		replace presc_enddate_num7`x' =. if dd_mg_comb_5`x'3!=.
		replace dosage7`x' =. if dd_mg_comb_5`x'3!=.
		
			replace dd_mg5`x' = dd_mg_comb_5`x'3 if dd_mg_comb_5`x'3!=.

		* Where the multiple drugs start on 6`x'
		
		replace drugsubstance7`x' =. if dd_mg_comb_6`x'2!=.
		replace dd_mg7`x' =. if dd_mg_comb_6`x'2!=.
		replace presc_startdate_num7`x' =. if dd_mg_comb_6`x'2!=.
		replace presc_enddate_num7`x' =. if dd_mg_comb_6`x'2!=.
		replace dosage7`x' =. if dd_mg_comb_6`x'2!=.
		
			replace dd_mg6`x' = dd_mg_comb_6`x'2 if dd_mg_comb_6`x'2!=.
			
		replace drugsubstance8`x' =. if dd_mg_comb_6`x'3!=.
		replace dd_mg8`x' =. if dd_mg_comb_6`x'3!=.
		replace presc_startdate_num8`x' =. if dd_mg_comb_6`x'3!=.
		replace presc_enddate_num8`x' =. if dd_mg_comb_6`x'3!=.
		replace dosage8`x' =. if dd_mg_comb_6`x'3!=.
		
			replace dd_mg6`x' = dd_mg_comb_6`x'3 if dd_mg_comb_6`x'3!=.

		}
		
	* Where there are now gaps in my dataset where "duplicates" have been changed to missing, I need to shift the prescriptions back into chronological order with no gaps so the rest of the code will run
	
	foreach x in a b c { 
	
  	* Where there is a gap created by the "duplicate" move what's in the next column along to the gap - this creates duplicate prescriptions if you don't rid of the data in the moving column
  	* First create a marker of the rows that have moving data
  	gen marker = 1 if drugsubstance2`x'==. & drugsubstance3`x'!=.
  	* Then move the data
  	replace drugsubstance2`x' = drugsubstance3`x' if drugsubstance2`x'==. & drugsubstance3`x'!=.
  	replace presc_startdate_num2`x' = presc_startdate_num3`x' if presc_startdate_num2`x'==. & presc_startdate_num3`x'!=.
  	replace presc_enddate_num2`x' = presc_enddate_num3`x' if presc_enddate_num2`x'==. & presc_enddate_num3`x'!=.
  	replace dd_mg2`x' = dd_mg3`x' if dd_mg2`x'==. & dd_mg3`x'!=.
  	replace dosage2`x' = dosage3`x' if dosage2`x'==. & dosage3`x'!=.
  	* Then use the marker to drop the data that has "moved"
  	replace drugsubstance3`x' =. if marker==1
  	replace presc_startdate_num3`x' =. if marker==1
  	replace presc_enddate_num3`x' =. if marker==1
  	replace dd_mg3`x' =. if marker==1
  	replace dosage3`x' =. if marker==1
  	* Drop the marker to use again
  	drop marker
  	
  	gen marker = 1 if drugsubstance2`x'==. & drugsubstance3`x'==. & drugsubstance4`x'!=.
  	replace drugsubstance2`x' = drugsubstance4`x' if drugsubstance2`x'==. & drugsubstance3`x'==. & drugsubstance4`x'!=.
  	replace presc_startdate_num2`x' = presc_startdate_num4`x' if presc_startdate_num2`x'==. & presc_startdate_num3`x'==. & presc_startdate_num4`x'!=.
  	replace presc_enddate_num2`x' = presc_enddate_num4`x' if presc_enddate_num2`x'==. & presc_enddate_num3`x'==. & presc_enddate_num4`x'!=.
  	replace dd_mg2`x' = dd_mg4`x' if dd_mg2`x'==. & dd_mg3`x'==. & dd_mg4`x'!=.
  	replace dosage2`x' = dosage4`x' if dosage2`x'==. & dosage3`x'==. & dosage4`x'!=.
  	
  	replace drugsubstance4`x' =. if marker==1
  	replace presc_startdate_num4`x' =. if marker==1
  	replace presc_enddate_num4`x' =. if marker==1
  	replace dd_mg4`x' =. if marker==1
  	replace dosage4`x' =. if marker==1
  	drop marker
  		
  	gen marker = 1 if drugsubstance2`x'==. & drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace drugsubstance2`x' = drugsubstance5`x' if drugsubstance2`x'==. & drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace presc_startdate_num2`x' = presc_startdate_num5`x' if presc_startdate_num2`x'==. & presc_startdate_num3`x'==. & presc_startdate_num4`x'==. & presc_startdate_num5`x'!=.
  	replace presc_enddate_num2`x' = presc_enddate_num5`x' if presc_enddate_num2`x'==. & presc_enddate_num3`x'==. & presc_enddate_num4`x'==. & presc_enddate_num5`x'!=.
  	replace dd_mg2`x' = dd_mg5`x' if dd_mg2`x'==. & dd_mg3`x'==. & dd_mg4`x'==. & dd_mg5`x'!=.
  	replace dosage2`x' = dosage5`x' if dosage2`x'==. & dosage3`x'==. & dosage4`x'==. & dosage5`x'!=.
  	
  	replace drugsubstance5`x' =. if marker==1
  	replace presc_startdate_num5`x' =. if marker==1
  	replace presc_enddate_num5`x' =. if marker==1
  	replace dd_mg5`x' =. if marker==1
  	replace dosage5`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance3`x'==. & drugsubstance4`x'!=.
  	replace drugsubstance3`x' = drugsubstance4`x' if drugsubstance3`x'==. & drugsubstance4`x'!=.
  	replace presc_startdate_num3`x' = presc_startdate_num4`x' if presc_startdate_num3`x'==. & presc_startdate_num4`x'!=.
  	replace presc_enddate_num3`x' = presc_enddate_num4`x' if presc_enddate_num3`x'==. & presc_enddate_num4`x'!=.
  	replace dd_mg3`x' = dd_mg4`x' if dd_mg3`x'==. & dd_mg4`x'!=.
  	replace dosage3`x' = dosage4`x' if dosage3`x'==. & dosage4`x'!=.
  	
  	replace drugsubstance4`x' =. if marker==1
  	replace presc_startdate_num4`x' =. if marker==1
  	replace presc_enddate_num4`x' =. if marker==1
  	replace dd_mg4`x' =. if marker==1
  	replace dosage4`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace drugsubstance3`x' = drugsubstance5`x' if drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace presc_startdate_num3`x' = presc_startdate_num5`x' if presc_startdate_num3`x'==. & presc_startdate_num4`x'==. & presc_startdate_num5`x'!=.
  	replace presc_enddate_num3`x' = presc_enddate_num5`x' if presc_enddate_num3`x'==. & presc_enddate_num4`x'==. & presc_enddate_num5`x'!=.
  	replace dd_mg3`x' = dd_mg5`x' if dd_mg3`x'==. & dd_mg4`x'==. & dd_mg5`x'!=.
  	replace dosage3`x' = dosage5`x' if dosage3`x'==. & dosage4`x'==. & dosage5`x'!=.
  	
  	replace drugsubstance5`x' =. if marker==1
  	replace presc_startdate_num5`x' =. if marker==1
  	replace presc_enddate_num5`x' =. if marker==1
  	replace dd_mg5`x' =. if marker==1
  	replace dosage5`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace drugsubstance3`x' = drugsubstance6`x' if drugsubstance3`x'==. & drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace presc_startdate_num3`x' = presc_startdate_num6`x' if presc_startdate_num3`x'==. & presc_startdate_num4`x'==. & presc_startdate_num5`x'==. & presc_startdate_num6`x'!=.
  	replace presc_enddate_num3`x' = presc_enddate_num6`x' if presc_enddate_num3`x'==. & presc_enddate_num4`x'==. & presc_enddate_num5`x'==. & presc_enddate_num6`x'!=.
  	replace dd_mg3`x' = dd_mg6`x' if dd_mg3`x'==. & dd_mg4`x'==. & dd_mg5`x'==. & dd_mg6`x'!=.
  	replace dosage3`x' = dosage6`x' if dosage3`x'==. & dosage4`x'==. & dosage5`x'==. & dosage6`x'!=.
  	
  	replace drugsubstance6`x' =. if marker==1
  	replace presc_startdate_num6`x' =. if marker==1
  	replace presc_enddate_num6`x' =. if marker==1
  	replace dd_mg6`x' =. if marker==1
  	replace dosage6`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace drugsubstance4`x' = drugsubstance5`x' if drugsubstance4`x'==. & drugsubstance5`x'!=.
  	replace presc_startdate_num4`x' = presc_startdate_num5`x' if presc_startdate_num4`x'==. & presc_startdate_num5`x'!=.
  	replace presc_enddate_num4`x' = presc_enddate_num5`x' if presc_enddate_num4`x'==. & presc_enddate_num5`x'!=.
  	replace dd_mg4`x' = dd_mg5`x' if dd_mg4`x'==. & dd_mg5`x'!=.
  	replace dosage4`x' = dosage5`x' if dosage4`x'==. & dosage5`x'!=.
  	
  	replace drugsubstance5`x' =. if marker==1
  	replace presc_startdate_num5`x' =. if marker==1
  	replace presc_enddate_num5`x' =. if marker==1
  	replace dd_mg5`x' =. if marker==1
  	replace dosage5`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace drugsubstance4`x' = drugsubstance6`x' if drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace presc_startdate_num4`x' = presc_startdate_num6`x' if presc_startdate_num4`x'==. & presc_startdate_num5`x'==. & presc_startdate_num6`x'!=.
  	replace presc_enddate_num4`x' = presc_enddate_num6`x' if presc_enddate_num4`x'==. & presc_enddate_num5`x'==. & presc_enddate_num6`x'!=.
  	replace dd_mg4`x' = dd_mg5`x' if dd_mg4`x'==. & dd_mg5`x'==. & dd_mg6`x'!=.
  	replace dosage4`x' = dosage5`x' if dosage4`x'==. & dosage5`x'==. & dosage6`x'!=.
  	
  	replace drugsubstance6`x' =. if marker==1
  	replace presc_startdate_num6`x' =. if marker==1
  	replace presc_enddate_num6`x' =. if marker==1
  	replace dd_mg6`x' =. if marker==1
  	replace dosage6`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace drugsubstance4`x' = drugsubstance7`x' if drugsubstance4`x'==. & drugsubstance5`x'==. & drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace presc_startdate_num4`x' = presc_startdate_num7`x' if presc_startdate_num4`x'==. & presc_startdate_num5`x'==. & presc_startdate_num6`x'==. & presc_startdate_num7`x'!=.
  	replace presc_enddate_num4`x' = presc_enddate_num7`x' if presc_enddate_num4`x'==. & presc_enddate_num5`x'==. & presc_enddate_num6`x'==. & presc_enddate_num7`x'!=.
  	replace dd_mg4`x' = dd_mg7`x' if dd_mg4`x'==. & dd_mg5`x'==. & dd_mg6`x'==. & dd_mg7`x'!=.
  	replace dosage4`x' = dosage7`x' if dosage4`x'==. & dosage5`x'==. & dosage6`x'==. & dosage7`x'!=.
  	
  	replace drugsubstance7`x' =. if marker==1
  	replace presc_startdate_num7`x' =. if marker==1
  	replace presc_enddate_num7`x' =. if marker==1
  	replace dd_mg7`x' =. if marker==1
  	replace dosage7`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace drugsubstance5`x' = drugsubstance6`x' if drugsubstance5`x'==. & drugsubstance6`x'!=.
  	replace presc_startdate_num5`x' = presc_startdate_num6`x' if presc_startdate_num5`x'==. & presc_startdate_num6`x'!=.
  	replace presc_enddate_num5`x' = presc_enddate_num6`x' if presc_enddate_num5`x'==. & presc_enddate_num6`x'!=.
  	replace dd_mg5`x' = dd_mg6`x' if dd_mg5`x'==. & dd_mg6`x'!=.
  	replace dosage5`x' = dosage6`x' if dosage5`x'==. & dosage6`x'!=.
  	
  	replace drugsubstance6`x' =. if marker==1
  	replace presc_startdate_num6`x' =. if marker==1
  	replace presc_enddate_num6`x' =. if marker==1
  	replace dd_mg6`x' =. if marker==1
  	replace dosage6`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance5`x'==. & drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace drugsubstance5`x' = drugsubstance7`x' if drugsubstance5`x'==. & drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace presc_startdate_num5`x' = presc_startdate_num7`x' if presc_startdate_num5`x'==. & presc_startdate_num6`x'==. & presc_startdate_num7`x'!=.
  	replace presc_enddate_num5`x' = presc_enddate_num7`x' if presc_enddate_num5`x'==. & presc_enddate_num6`x'==. & presc_enddate_num7`x'!=.
  	replace dd_mg5`x' = dd_mg7`x' if dd_mg5`x'==. & dd_mg6`x'==. & dd_mg7`x'!=.
  	replace dosage5`x' = dosage7`x' if dosage5`x'==. & dosage6`x'==. & dosage7`x'!=.
  	
  	replace drugsubstance7`x' =. if marker==1
  	replace presc_startdate_num7`x' =. if marker==1
  	replace presc_enddate_num7`x' =. if marker==1
  	replace dd_mg7`x' =. if marker==1
  	replace dosage7`x' =. if marker==1
  	drop marker
  	
  	gen marker = 1 if drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace drugsubstance6`x' = drugsubstance7`x' if drugsubstance6`x'==. & drugsubstance7`x'!=.
  	replace presc_startdate_num6`x' = presc_startdate_num7`x' if presc_startdate_num6`x'==. & presc_startdate_num7`x'!=.
  	replace presc_enddate_num6`x' = presc_enddate_num7`x' if presc_enddate_num6`x'==. & presc_enddate_num7`x'!=.
  	replace dd_mg6`x' = dd_mg7`x' if dd_mg6`x'==. & dd_mg7`x'!=.
  	replace dosage6`x' = dosage7`x' if dosage6`x'==. & dosage7`x'!=.
  	
  	replace drugsubstance7`x' =. if marker==1
  	replace presc_startdate_num7`x' =. if marker==1
  	replace presc_enddate_num7`x' =. if marker==1
  	replace dd_mg7`x' =. if marker==1
  	replace dosage7`x' =. if marker==1
  	drop marker
	
	}
	
	* A few prescriptions are retained that are now the same (i.e. would've been dropped in the data generating script) so I want to get rid of the now duplicates
	
	replace drugsubstance2a =. if (drugsubstance1a==drugsubstance2a) & (dd_mg1a==dd_mg2a) & drugsubstance3a==. & drugsubstance1a!=. & drugsubstance2a!=.
	replace dd_mg2a =. if (dd_mg1a==dd_mg2a) & drugsubstance2a==.
	replace presc_startdate_num2a =. if dd_mg2a==. & drugsubstance2a==.
	replace presc_enddate_num2a =. if dd_mg2a==. & drugsubstance2a==.
	replace dosage2a =. if dd_mg2a==. & drugsubstance2a==.
	
	replace drugsubstance2b =. if (drugsubstance1b==drugsubstance2b) & (dd_mg1b==dd_mg2b) & drugsubstance3b==. & drugsubstance1b!=. & drugsubstance2b!=.
	replace dd_mg2b =. if (dd_mg1b==dd_mg2b) & drugsubstance2b==.
	replace presc_startdate_num2b =. if dd_mg2b==. & drugsubstance2b==.
	replace presc_enddate_num2b =. if dd_mg2b==. & drugsubstance2b==.
	replace dosage2b =. if dd_mg2b==. & drugsubstance2b==.
	
* New problem - some dosage categories will be wrong for ones moved across (attributed to only part of the dose)

	tab dup // n = 4,751 might have the wrong dosage category attached to them
	
	save "$Tempdatadir\patterns_in_pregnancy_duprm_dataset.dta", replace

*********************************************************************************
