// PHASE ZERO: Directory Macro

* replace this global with your path to the Data3 folder.
* if you don't do this, the file won't run!
 
global directory C:\users\morganto\desktop\Data3

// Now that that's out of the way:

* Data Project 3
* Tommy Morgan

* I did some preliminary cleaning in Excel that mostly involved making
* sure the first rows were the variable names, and so on. 


* PHASE ONE: Basic Cleaning

clear
cd $directory
import excel 2020pop, firstrow
drop badid CountyFull
rename ID FIPS
rename PopTotal pop2020
save 2020pop
clear

import excel nytcounty, firstrow
drop geoid county state date cases cases_avg cases_avg_per_100k deaths_avg deaths_avg_per_100k
rename ID FIPS
save nytcounty
clear

import excel zipcounty, firstrow
drop RES_RATIO BUS_RATIO OTH_RATIO TOT_RATIO
rename ZIP zip5
rename COUNTY FIPS
save zipcounty
clear

import excel ziphouse, firstrow
drop IndexType
rename Quarter quarter
save ziphouse
clear


* PHASE TWO: Data Prepping

* Part 1: ZIP3-based Housing Price Index Cleanup
use ziphouse
rename zip3 prefix
gen str3 zip3 = string(prefix,"%03.0f")
drop prefix
label variable zip3 "3-digit ZIPs"
gen keep = 0
replace keep = 1 if year == 2020
replace keep = 1 if year == 2021
drop if keep == 0
drop keep
drop if quarter != 1
bysort zip3 (year): gen housechange = 100*(index_1995[_n]-index_1995[_n-1])/index_1995[_n-1]
drop if year != 2021
drop index_1995 quarter year
save, replace
clear

* Part 2: ZIP5-based Crosswalk to ZIP3 Housing Merge
use zipcounty
gen zip3 = substr(zip5,1,3)
joinby zip3 using ziphouse
drop zip5 zip3
collapse housechange, by(FIPS)
save houseindex
erase zipcounty.dta
erase ziphouse.dta
clear

* Part 3: NYT 2020 Deaths Collapse
use nytcounty
collapse (sum) deaths, by(FIPS)
joinby FIPS using houseindex
save deathindex
erase houseindex.dta
erase nytcounty.dta
clear

* Part 4: Per-capita Adjustment to Deaths
use 2020pop
joinby FIPS using deathindex
gen mortper100k = (deaths/pop2020)*100000
drop pop2020 deaths
save mortindex
erase deathindex.dta
erase 2020pop.dta
clear


* PHASE THREE: Controls

* Part 1: FIPS-County Wage Set

// I got this lil beauty off of stackexchange. It takes the
// fifty county wage files and puts them together!
global route "$directory\countywages2021"
cd "$route"
tempfile building
save `building', emptyok
local filenames : dir "$route" files "*.csv"
foreach f of local filenames {
	import delimited using `"`f'"' , rowrange(4:1000) varnames(4) stringcols(_all) clear
	gen source = `"`f'"'
	append using `building'
	save `"`building'"', replace
	}
save "$route\allcountywages2021", replace

// Clean it up!
drop year quarter noofestablishments employment industry source oneyearemploymentgainlosspercent
rename fips FIPS
rename averageweeklywage avgwage
rename onyearweeklywagesgainlosspercent wagechange
destring avgwage wagechange, replace
drop if avgwage==.

// Save it in the main directory
cd $directory
save wagecounty
clear

// Clean up the other file
cd "$route"
erase "$route\allcountywages2021.dta"
cd $directory

* Part 2: Connection of the Sets

use mortindex
joinby FIPS using wagecounty
order areaname usps, last
save mortwagehouse
erase mortindex.dta
erase wagecounty.dta
clear


* PHASE FOUR: Regression Analysis

* Part 1: Summary Stats
use mortwagehouse
sort housechange
sort wagechange
sort mortper100k
sum housechange wagechange mortper100k
histogram mortper100k

* Part 2: Regression
gen lmort = log(mortper100k)
gen lwage = log(avgwage)
regress housechange lmort lwage wagechange, robust

* Part 3: Prediction Accuracy
* due to time constraints, this part ain't in the paper
predict housechangehat
predict error, residuals
sum housechangehat housechange
sum error

* Part 4: A Nice Graph
twoway (scatter housechange mortper100k) (lfit housechange mortper100k)

* Part 5: Look at My Data! 
browse


* That's all, folks!
erase mortwagehouse.dta