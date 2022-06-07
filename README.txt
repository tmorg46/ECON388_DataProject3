Data Project 3
Tommy Morgan
ECON 388

PURPOSE: Determine what effect (if any) 2020 county-level per-capita COVID-19
mortality rates had on 2021 housing prices.

----------------------------------------------------------------------------

FOLDER CONTENTS:

This folder should contain the following files and folders.
If any of these are missing, the do file may fail.

EXCEL
- 2020pop.xlsx
- zipcounty.xlsx
- ziphouse.xlsx

STATA
- nytcounty.dta

TEXT
- README.txt

DO
- TommyData3.do

FOLDER
- countywages2021
	- 50 more Excel files should be in this folder; described below.

----------------------------------------------------------------------------

DO-FILE INSTRUCTIONS:

To run the do-file, the only thing you need to do is edit the path in line (6) to
point to Data3, the folder in which you found this README. If, for example, I had
extracted the Data3 folder to my desktop, I would change the path in line (6) to
C:\users\morganto\desktop\Data3

The file will then run without issue.

----------------------------------------------------------------------------

EXCEL FILE DESCRIPTIONS:

These are brief descriptions of where I got my data files (all the Excel files),
what is in each of them, and what I did in Excel to prep them for Stata.

- 2020pop.xlsx
This is a dataset of redistricting data from the 2020 Census. After following the
source link, I adjusted the table to county level data and downloaded the file. After
doing so, I cleaned out unnecessary columns and created a 5-digit FIPS code column.
The columns on this file are ID, badid, County Full, and PopTotal. I used this file
because it provided data on county level populations in 2020.
LINK: https://data.census.gov/cedsci/table?q=United%20States&tid=DECENNIALPL2020.P1

- nytcounty.dta
This is a dataset of county level day-to-day COVID death counts from the New York
Times. The source link leads to a page with a download button. In order to upload this file
to GitHub, I had to upload the cleaned file. The do-file has the section I used to clean the below-
linked .csv file commented out. I used this file because it provided data on county level
COVID-19 deaths in 2020.
LINK: https://github.com/nytimes/covid-19-data/blob/master/rolling-averages/us-counties-2020.csv

- zipcounty.xlsx
This is a 5-digit ZIP to 5-digit FIPS code crosswalk provided by the Department of
Housing and Urban Development. The source link leads to a page with data download
options at the bottom. After following the source link, select Crosswalk Type:
ZIP-COUNTY and select Data Year and Quarter: 1st Quarter 2021. Then download the
file. After doing so, I cleaned out the columns with county names and two-digit
state abbreviations. The columns on this file are ZIP, COUNTY, RES_RATIO,
BUS_RATIO, OTH_RATIO, and TOT_RATIO. I used this file because it allowed me to
connect other data files that were organized by ZIP code and by FIPS code.
LINK: https://www.huduser.gov/portal/datasets/usps_crosswalk.html

- ziphouse.xlsx
This is a time series dataset of the Housing Price Index organized by 3-digit ZIP
code from the Federal Housing Finance Authority. The source link leads to a page
with a line for Three-Digit ZIP Codes (Developmental Index; Not Seasonally Adjusted)
with an [XLSX] file download link just to the right. After downloading the file, I
removed the four-row header and renamed the variable columns. The columns on this
file are zip3, year, Quarter, index_1995, and Index Type. I used this file because
it provided data on housing price increases from 2020 to 2021.
LINK: https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index-Datasets.aspx

- The fifty files in the countywages2021 folder
These are individual state sets of county level wage data for each of the fifty
states from the U.S. Bureau of Labor Statistics. The source link leads to a map
with adjustable parameters. Use the drop-down menu to set Time Period to Q1 2021,
then press the Update button. Then, click any state. Scroll to the bottom of that
new page and click the underlined download link "CSV for Excel". Then repeat for
each of the remaining 49 states. I did no outside cleaning of these datasets. I used
these files because they provided data on county-level wage statistics like year-on
change in wages and average weekly wage.
LINK: https://data.bls.gov/maps/cew/us

----------------------------------------------------------------------------

Enjoy! :) By the way, the do-file will clean up after itself, so if you need to go
through any of the intermediate data files, be sure to only run part of the do!


