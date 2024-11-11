*******************************************************************************

* Filling in supplementary table for patterns of prescribing paper - individual drugs in each class in this study

* Author: Flo Martin 

* Date: 14/11/2023

*******************************************************************************

* Table S1 - Drug substances that fall into each class category of antidepressants: SSRIs, SNRIs, TCAs, and ‘other’.

*******************************************************************************

* Start logging 

	log using "$Logdir\4_supplement\1_drugs in each class", name(drugs_in_each_class) replace
	
*******************************************************************************

* Load in the clean prescription data

	use "$Deriveddir\derived_data\AD_pxn_events_from_All_Therapy_clean.dta", clear
	
	keep patid drugsubstance class
	
	tab class, nolabel
	
	gen class_simple = 1 if class==1
	replace class_simple = 2 if class==2
	replace class_simple = 3 if class==3
	replace class_simple = 4 if class==4 | class==5 | class==6 | class==7
	
	label define class_simple_lb 1"SSRI" 2"SNRI" 3"TCA" 4"Other"
	label values class_simple class_simple_lb
	tab class_simple
	
	drop class
	rename class_simple class
	
	tempname myhandle	
	file open `myhandle' using "$Tabledir\supp_drug in each class.txt", write replace
	file write `myhandle' "Selective serotonin reuptake inhibitors (SSRIs)" _tab "Serotonin noradrenaline reuptake inhibitors (SNRI/NRIs)" _tab "Tricyclic antidepressants (TCAs)" _tab "Other antidepressants" _n
	
	tab drugsubstance if class==1
	
	file write `myhandle' "Citalopram" " Escitalopram" " Fluoxetine" " Fluvoxamine" " Paroxetine" " Sertraline"
	
	tab drugsubstance if class==2
	
	file write `myhandle' _tab "Duloxetine" " Reboxetine" " Venlafaxine"
	
	tab drugsubstance if class==3
	
	file write `myhandle' _tab "Amitriptyline" " Amoxapine" " Clomipramine" " Desipramine" " Dosulepin" " Doxepin" " Imipramine" " Iproniazide" " Lofepramine" " Maprotiline" " Nortriptyline" " Proptriptyline" " Trimipramine"
	
	tab drugsubstance if class==4
	
	file write `myhandle' _tab " Agomelatine" " Isocarboxazid" " Mianserin" " Mirtazapine" " Nefazodone" " Phenelzine" " Tranylcypromine" " Trazodone" " Tryptophan" " Vortioxetine"
	
*******************************************************************************

* Stop logging

	log close drugs_in_each_class
	
	translate "$Logdir\4_supplement\1_drugs in each class.smcl" "$Logdir\4_supplement\1_drugs in each class.pdf", replace
	
	erase "$Logdir\4_supplement\1_drugs in each class.smcl"
	
*******************************************************************************
