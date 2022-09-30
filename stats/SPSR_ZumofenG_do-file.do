*** Swiss Political Science Review ***
* Title: What Drives the Selection of Political Information in Google? Tension Between Ideal Democracy and the Influence of Ranking
clear all
cd "/Users/ZumofenG/OneDrive/011_PhD/8_Projects/P5_Selection Political Information Google/Daten"
capture log close
log using analysis1_google.log, replace
set more off

* Figure 1: Google trends and newspaper
use figure1_data, replace
twoway (line newsp semaine, lcolor(black) lpattern(solid)) (line staf semaine) (line rffa semaine), ytitle(Salience) ytitle(, color(black)) xtitle(Weeks) xtitle(, color(black)) xlabel(#52, labels labsize(vsmall) angle(vertical)) subtitle(Referendum vote on fiscal policy '19 May 2019') legend(order(1 "Newspaper articles on fiscal policy" 2 "Google trends with keyword 'STAF' (German)" 3 "Google trends with keyword 'RFFA' (French)") rows(3)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Empirical analysis
use welle1bis_staf, replace

* Step 1: Data preparation
* 1.1 : Operating system - Respondents used a computer or a smartphone (0 = computer, 1=smartphone)
generate operation = 1 if meta_operatingsystem == "iPhone"
replace operation = 1 if meta_operatingsystem == "iPad"
replace operation = 1 if meta_operatingsystem == "Android 4.4.2"
replace operation = 1 if meta_operatingsystem == "Android 5.0.2"
replace operation = 1 if meta_operatingsystem == "Android 5.1"
replace operation = 1 if meta_operatingsystem == "Android 6.0"
replace operation = 1 if meta_operatingsystem == "Android 6.0.1"
replace operation = 1 if meta_operatingsystem == "Android 7.0"
replace operation = 1 if meta_operatingsystem == "Android 7.1.1"
replace operation = 1 if meta_operatingsystem == "Android 8.0.0"
replace operation = 1 if meta_operatingsystem == "Android 8.1.0"
replace operation = 1 if meta_operatingsystem == "Android 9"
replace operation = 0 if operation ==.
label variable operation "Operating system"

*1.2 : Demographic variables
* 1.2.1 : Sex (0=men, 1=women)
recode sex (2=0) (3=.)
label variable sex "Sex"
*1.2.2 : Age + Age_cat (1=18-34, 2=35-54, 3=55+)
generate age_number = 2019-age
drop age
rename age_number age
label variable age "Age"
generate age_cat = 1 if age<=34
replace age_cat = 2 if age>=35 & age <=54
replace age_cat = 3 if age>=55
label variable age_cat "Age categories"
*1.2.3: Kanton
label variable canton "Canton"
*1.2.4: Education (1 to 12)
label variable educ "Education"
*1.2.5: Revenue (1 to 8) (9 = kein Antwort)
label  variable revenu "Revenue"
recode revenu (9=.)

*1.3: Political related variables
*1.3.1: Political interest (1 = low, 4= high)
recode polint (1=4) (2=3) (3=2) (4=1) (5=.)
label variable polint "Political interest"
*1.3.2: Right to vote (0=no, 1=yes)
rename stimmber rightvote
replace rightvote = "0" if rightvote=="2"
replace rightvote = "." if rightvote=="9"
label variable rightvote "Right to vote"
*1.3.3: Trust in federal council (1 to 10)
rename trust_br trust_fc
label variable trust_fc "Trust in Federal Council"
*1.3.4: Party attachment (1 to 3)
rename party_prox party_attach
destring party_attach, replace
recode party_attach (1=3) (3=1) (9=.)
label variable party_attach "Party attachment"
*1.3.5: Party name 
tostring party_name, replace
replace party_name = "." if party_name=="99"
replace party_name = "8" if party_name=="9"| party_name=="10"| party_name=="11"| party_name=="12"| party_name=="20"
label variable party_name "Political party name"
*1.3.6: Political knowledge (0 to 4)
destring knowl1, replace
destring knowl2, replace
destring knowl3, replace
destring knowl4, replace
generate pol_knowl1 = 1 if knowl1==3
replace pol_knowl1 = 0 if pol_knowl1==.
generate pol_knowl2 = 1 if knowl2==1
replace pol_knowl2 = 0 if pol_knowl2==.
generate pol_knowl3 = 1 if knowl3==1
replace pol_knowl3 = 0 if pol_knowl3==.
generate pol_knowl4 = 1 if knowl4==2
replace pol_knowl4 = 0 if pol_knowl4==.
generate polknowl= pol_knowl1+pol_knowl2+pol_knowl3+pol_knowl4
label variable polknowl "Political knowledge"

*1.4: Media variables
*1.4.1: sources of information
generate source_discussion=1 if so_discu_alltag=="1"
replace source_discussion=0 if source_discussion==.
generate source_forum=1 if so_discu_internet=="1"
replace source_forum=0 if source_forum==.
generate source_party=1 if so_party=="1"
replace source_party=0 if source_party==.
generate source_committee=1 if so_committee=="1"
replace source_committee=0 if source_committee==.
generate source_flyer_fc=1 if so_flyer_cf=="1"
replace source_flyer_fc=0 if source_flyer_fc==.
generate source_newspaper=1 if so_newspaper=="1"
replace source_newspaper=0 if source_newspaper==.
generate source_tv=1 if so_tv=="1"
replace source_tv=0 if source_tv==.
generate source_google=1 if so_google=="1"
replace source_google=0 if source_google==.
generate source_radio=1 if so_radio=="1"
replace source_radio=0 if source_radio==.
generate source_socialmedia=1 if so_socialmedia=="1"
replace source_socialmedia=0 if source_socialmedia==.
generate source_IN=1 if so_IN=="1"
replace source_IN=0 if source_IN==.
generate source_survey=1 if so_survey=="1"
replace source_survey=0 if source_survey==.
*1.4.2: Internet as a source of information (1 to 5)
label variable internet "Internet as a source of information"

*1.5: Vote decision (1=no, 4=yes)
drop vote_choice
generate vote_choice = entsch1w1
replace vote_choice = entsch2w1 if vote_choice==.
recode vote_choice (9=.)
label variable vote_choice "Vote decision"

* 2. Treatment and control groups
*2.1: Define the 6 groups
generate group = 1 if group1_random==1
replace group = 2 if group2_top51==1
replace group = 3 if group3_top52==1
replace group = 4 if group4_top2gov==1
replace group = 5 if group5_top2ads==1
replace group = 6 if group6_une==1
label define group 1 "random" 2 "top51" 3 "top52" 4 "top2gov" 5 "top2ads" 6 "news"

generate database = 1 if group==1 | group==2 | group==3 | group==4 | group==5
replace database = 0 if database!=1

* 3. Analysis
generate result1 = googlerandom_1+ googletop51_1+ googletop52_1+ googletop2gov_1+ googletop2ads_1+ googleune_1
label variable result1 "Choice of result 1"

generate result2 = googlerandom_2+ googletop51_2+ googletop52_2+ googletop2gov_2+ googletop2ads_2+ googleune_2
label variable result2 "Choice of result 2"

generate result3 = googlerandom_3+ googletop51_3+ googletop52_3+ googletop2gov_3+ googletop2ads_3+ googleune_3
label variable result3 "Choice of result 3"

generate result4 = googlerandom_4+ googletop51_4+ googletop52_4+ googletop2gov_4+ googletop2ads_4+ googleune_4
label variable result4 "Choice of result 4"

generate result5 = googlerandom_5+ googletop51_5+ googletop52_5+ googletop2gov_5+ googletop2ads_5+ googleune_5
label variable result5 "Choice of result 5"

generate result6 = googlerandom_6+ googletop51_6+ googletop52_6+ googletop2gov_6+ googletop2ads_6+ googleune_6
label variable result6 "Choice of result 6"

generate result7 = googlerandom_7+ googletop51_7+ googletop52_7+ googletop2gov_7+ googletop2ads_7+ googleune_7
label variable result7 "Choice of result 7"

generate result8 = googlerandom_8+ googletop51_8+ googletop52_8+ googletop2gov_8+ googletop2ads_8+ googleune_8
label variable result8 "Choice of result 8"

generate result9 = googlerandom_9+ googletop51_9+ googletop52_9+ googletop2gov_9+ googletop2ads_9+ googleune_9
label variable result9 "Choice of result 9"

generate result10 = googlerandom_10+ googletop51_10+ googletop52_10+ googletop2gov_10+ googletop2ads_10+ googleune_10
label variable result10 "Choice of result 10"

generate total_choice = googlerandom_1+ googletop51_1+ googletop52_1+ googletop2gov_1+ googletop2ads_1+ googleune_1 + googlerandom_2+ googletop51_2+ googletop52_2+ googletop2gov_2+ googletop2ads_2+ googleune_2+ googlerandom_1+ googletop51_3+ googletop52_3+ googletop2gov_3+ googletop2ads_3+ googleune_3+googlerandom_4+ googletop51_4+ googletop52_4+ googletop2gov_4+ googletop2ads_4+ googleune_4+googlerandom_5+ googletop51_5+ googletop52_5+ googletop2gov_5+ googletop2ads_5+ googleune_5+googlerandom_6+ googletop51_6+ googletop52_6+ googletop2gov_6+ googletop2ads_6+ googleune_6+googlerandom_7+ googletop51_7+ googletop52_7+ googletop2gov_7+ googletop2ads_7+ googleune_7+googlerandom_8+ googletop51_8+ googletop52_8+ googletop2gov_8+ googletop2ads_8+ googleune_8+googlerandom_9+ googletop51_9+ googletop52_9+ googletop2gov_9+ googletop2ads_9+ googleune_9+googlerandom_10+ googletop51_10+ googletop52_10+ googletop2gov_10+ googletop2ads_10+ googleune_10

generate rel_choice1 = result1/total_choice
generate rel_choice2 = result2/total_choice
generate rel_choice3 = result3/total_choice
generate rel_choice4 = result4/total_choice
generate rel_choice5 = result5/total_choice
generate rel_choice6 = result6/total_choice
generate rel_choice7 = result7/total_choice
generate rel_choice8 = result8/total_choice
generate rel_choice9 = result9/total_choice
generate rel_choice10 = result10/total_choice

*3.1 Demographic
sort group
tab sex if database==1
sum sex if database==1
by group: tab sex if database==1

tab age_cat if database==1
sum age_cat if database==1
by group: tab age_cat if database==1

tab revenu if database==1
sum revenu if database==1
by group: sum revenu if database==1
by group: tab revenu if database==1

tab educ if database==1
sum educ if database==1
by group: sum educ if database==1
by group: tab educ if database==1

tab polint if database==1
sum polint if database==1
by group: sum polint if database==1
by group: tab polint if database==1

tab polknowl if database==1
sum polknowl if database==1
by group: sum polknowl if database==1
by group: tab polknowl if database==1

tab trust_fc if database==1
sum trust_fc if database==1
by group: sum trust_fc if database==1
by group: tab trust_fc if database==1

tab party_attach if database==1
sum party_attach if database==1
by group: tab party_attach if database==1

tab vote_choice if database==1
sum vote_choice if database==1
by group: sum vote_choice if database==1
by group: tab vote_choice if database==1

tab internet if database==1
sum internet if database==1
by group: sum internet if database==1
by group: tab internet if database==1

tab source_google if database==1
sum source_google if database==1
by group: tab source_google if database==1

tab operation if database==1
sum operation if database==1
by group: tab operation if database==1

* 3.2: Structural consistency tests = analyse wether different experimental groups of a data set are homogeneous regarding a specific variable

* 3.2.1:  Demographic related variables
tabulate sex group if database==1, chi2

tabulate operation group if database==1, chi2

* I assume independence of observations (no observations in two groups) + I check for homogeneity of variance (Levene test)
robvar educ if database==1, by(group) 
oneway educ group if database==1

robvar age if database==1, by(group)
oneway age group if database==1

robvar age_cat if database==1, by(group)
oneway age_cat group if database==1

robvar revenu if database==1, by(group)
oneway revenu group if database==1

tabulate operation group if database==1, chi2


*3.2.2: Political related variables

robvar polint if database==1, by(group)
oneway polint group if database==1

tabulate rightvote group if database==1, chi2

robvar trust_fc if database==1, by(group)
oneway trust_fc group if database==1

robvar party_attach if database==1, by(group)
oneway party_attach group if database==1

robvar polknowl if database==1, by(group)
oneway polknowl group if database==1

robvar vote_choice if database==1, by(group)
* homogeneity of variance is not given - Levene test (p=0.010)
oneway vote_choice group if database==1, scheffe

* 3.2.3: Media related variables

tabulate source_google group if database==1, chi2

robvar internet if database==1, by(group)
oneway internet group if database==1

* 3.3 Cross-table analysis and chi-square test for independence
*--> Test if there is a significant relationship between Google's ranking and selection of a source of information
tabulate result1 group if database==1, chi2
* Yes: p-value = 0.000
tabulate result2 group if database==1, chi2
* Yes: p-value = 0.000
tabulate result3 group if database==1, chi2
* No: p-value = 0.207
tabulate result4 group if database==1, chi2
* Yes: p-value = 0.001
tabulate result5 group if database==1, chi2
* Yes: p-value= 0.048
tabulate result6 group if database==1, chi2
* Yes: p-value = 0.000
tabulate result7 group if database==1, chi2
* ~Yes: p-value = 0.090 (at 0.1)
tabulate result8 group if database==1, chi2
* Yes: p-value = 0.001
tabulate result9 group if database==1, chi2
* Yes: p-value = 0.019
tabulate result10 group if database==1, chi2
* Yes: p-value = 0.014

* 3.4 ANOVA
*--> Test if there is a significant relationship between Google's ranking and selection of a source of information
*--> Relative choice - Consider how many sources of information were selected (as respondents can choose as many as they want)
robvar rel_choice1 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice1 group if database==1, bonferroni
* p-value = 0.000 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice2 if database==1, by(group)
* Homogeneity of variance is slightly given (0.052) - still I choose a stricter interpretation
oneway rel_choice2 group if database==1, bonferroni
* p-value = 0.000 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice3 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice3 group if database==1, bonferroni
* p-value= 0.1067
* No difference in means

robvar rel_choice4 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice4 group if database==1, bonferroni
* p-value = 0.002 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice5 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice5 group if database==1, bonferroni
* p-value = 0.0015 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice6 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice6 group if database==1, bonferroni
* p-value = 0.000 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice7 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice7 group if database==1, bonferroni
* p-value = 0.099 --> Statistically different (but if we are stricter, then no)
* no differnces in mean value

robvar rel_choice8 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice8 group if database==1, bonferroni
* p-value = 0.0036 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice9 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice9 group if database==1, bonferroni
* p-value = 0.0068 --> Statistically different
* At least a pair of mean values are different

robvar rel_choice10 if database==1, by(group)
* Homogeneity of variance is not given --> Be stricter with interpretation
oneway rel_choice10 group if database==1, bonferroni
* p-value = 0.06 --> Statistically different
* At least a pair of mean values are different
* If we are stricter, then it is not significant at 1%. No difference in mean value.

* Conclusion: Ranking has a significant impact (not for 3, 7 and 10)

* 3.5 Graphs

* Search result 1: Absolute
graph bar (mean) result1 if database==1, over(group, relabel(1 "Random" 2 "Top 5" 3 "#6" 4 "#1" 5 "#3") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 1) subtitle(Type: Governmental, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 1: Relative
graph bar (mean) rel_choice1 if database==1, over(group, relabel(1 "Random" 2 "Top 5 ***" 3 "#6" 4 "#1 ***" 5 "#3") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 2: Absolute
graph bar (mean) result2 if database==1, over(group, relabel(1 "Random" 2 "#8" 3 "Top 5" 4 "#2" 5 "#4") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 2) subtitle(Type: Governmental, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 2: Relative
graph bar (mean) rel_choice2 if database==1, over(group, relabel(1 "Random" 2 "#8 *" 3 "Top 5" 4 "#2" 5 "#4") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 3: Absolute
graph bar (mean) result3 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#7" 4 "Least 8" 5 "#5") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 3) subtitle(Type: Newspaper, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 3: Relative
graph bar (mean) rel_choice3 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#7" 4 "Least 8" 5 "#5") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 4: Absolute
graph bar (mean) result4 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#9" 4 "Least 8" 5 "#1 (ads)") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 4) subtitle(Type: Oganization, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 4: Relative
graph bar (mean) rel_choice4 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#9" 4 "Least 8" 5 "#1 (ads)") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 5: Absolute
graph bar (mean) result5 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#8" 4 "Least 8" 5 "#6") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 5) subtitle(Type: Media, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 5: Relative
graph bar (mean) rel_choice5 if database==1, over(group, relabel(1 "Random" 2 "Top5" 3 "#8" 4 "Least 8" 5 "#6") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 6: Absolute
graph bar (mean) result6 if database==1, over(group, relabel(1 "Random" 2 "#6" 3 "Top5" 4 "Least 8" 5 "#7") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 6) subtitle(Type: Newspaper, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 6: Relative
graph bar (mean) rel_choice6 if database==1, over(group, relabel(1 "Random" 2 "#6" 3 "Top5" 4 "Least 8" 5 "#7") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 7: Absolute
graph bar (mean) result7 if database==1, over(group, relabel(1 "Random" 2 "#7" 3 "Top5" 4 "Least 8" 5 "#8") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 7) subtitle(Type: Blog, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 7: Relative
graph bar (mean) rel_choice7 if database==1, over(group, relabel(1 "Random" 2 "#7" 3 "Top5" 4 "Least 8" 5 "#8") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 8: Absolute
graph bar (mean) result8 if database==1, over(group, relabel(1 "Random" 2 "Top 5" 3 "#10" 4 "Least 8" 5 "#9") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 8) subtitle(Type: Newspaper, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 8: Relative
graph bar (mean) rel_choice8 if database==1, over(group, relabel(1 "Random" 2 "Top 5" 3 "#10" 4 "Least 8" 5 "#9") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 9: Absolute
graph bar (mean) result9 if database==1, over(group, relabel(1 "Random" 2 "#9" 3 "Top 5" 4 "Least 8" 5 "#2 (ads)") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 9) subtitle(Type: Media, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 9: Relative
graph bar (mean) rel_choice9 if database==1, over(group, relabel(1 "Random" 2 "#9" 3 "Top 5" 4 "Least 8" 5 "#2 (ads)") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Search result 10: Absolute
graph bar (mean) result10 if database==1, over(group, relabel(1 "Random" 2 "#10" 3 "Top 5" 4 "Least 8" 5 "#10") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Selection of sources (%)) title(Search result 10) subtitle(Type: Governmental, size(medium) position(11)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* Search result 10: Relative
graph bar (mean) rel_choice10 if database==1, over(group, relabel(1 "Random" 2 "#10" 3 "Top 5" 4 "Least 8" 5 "#10") gap(2) label(labcolor("black") angle(forty_five))) bar(1, fcolor(black) lcolor(black)) ytitle(Relative selection of search result) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 3.6 Descriptive analysis
sum total_choice if database==1
* --> 2.4 sources on average
tab source_google if database==1
* --> 18.50 %
tab internet if database==1

* 4. Run a multilevel mixed-effects logistic regression
* 4.1 Generate an ID for each observation (for panel data)
gen id=_n

* 4.2 Reshape the data from wide to long: panelvar = id, timevar = source
reshape long result, i(id) j(source)

* 4.3 Create a variable "ranking"
gen ranking = 0 if group==1
replace ranking = 1 if group==4 & source==1
replace ranking = 2 if group==4 & source==2
replace ranking = 2 if group==6 & source==6
replace ranking = 3 if group==5 & source==1
replace ranking = 3 if group==6 & source==1
replace ranking = 4 if group==5 & source==2
replace ranking = 4 if group==6 & source==2
replace ranking = 5 if group==5 & source==3
replace ranking = 5 if group==6 & source==3
replace ranking = 6 if group==2 & source==1
replace ranking = 6 if group==3 & source==2
replace ranking = 6 if group==2 & source==2
replace ranking = 6 if group==2 & source==4
replace ranking = 6 if group==2 & source==5
replace ranking = 6 if group==3 & source==6
replace ranking = 6 if group==3 & source==7
replace ranking = 6 if group==2 & source==8
replace ranking = 6 if group==3 & source==9
replace ranking = 6 if group==3 & source==10
replace ranking = 7 if group==3 & source==1
replace ranking = 7 if group==6 & source==4
replace ranking = 7 if group==5 & source==5
replace ranking = 7 if group==2 & source==6
replace ranking = 8 if group==3 & source==3
replace ranking = 8 if group==6 & source==5
replace ranking = 8 if group==5 & source==6
replace ranking = 8 if group==2 & source==7
replace ranking = 9 if group==2 & source==2
replace ranking = 9 if group==3 & source==5
replace ranking = 9 if group==5 & source==7
replace ranking = 9 if group==6 & source==7
replace ranking = 10 if group==3 & source==4
replace ranking = 10 if group==5 & source==8
replace ranking = 10 if group==2 & source==9
replace ranking = 10 if group==6 & source==9
replace ranking = 11 if group==3 & source==8
replace ranking = 11 if group==2 & source==10
replace ranking = 11 if group==5 & source==10
replace ranking = 11 if group==6 & source==10
replace ranking = 12 if group==4 & source==3
replace ranking = 12 if group==4 & source==4
replace ranking = 12 if group==4 & source==5
replace ranking = 12 if group==4 & source==6
replace ranking = 12 if group==4 & source==7
replace ranking = 12 if group==4 & source==8
replace ranking = 12 if group==4 & source==9
replace ranking = 12 if group==4 & source==10
replace ranking = 13 if group==5 & source==9
replace ranking = 13 if group==5 & source==4

label define ranking 0"random" 1"1st" 2"2nd" 3"3rd" 4"4th" 5"5th" 6"Top 5" 7"6th" 8"7th" 9"8th" 10"9th" 11"10th" 12"Least 8" 13"Google ads"

generate ranking_cat=0 if ranking==0
replace ranking_cat=1 if ranking==1 |ranking==2| ranking==3 | ranking==4 | ranking==5 | ranking==6
replace ranking_cat=2 if ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12

generate ranking_cat2=0 if ranking==0
replace ranking_cat2=1 if ranking==1 |ranking==2
replace ranking_cat2=2 if ranking==3 | ranking==4 | ranking==5 | ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12


label define ranking_cat 0"random" 1"Top 5" 2"Least 5" 
label define ranking_cat2 0"random" 1"Top 2" 2"Least 8" 


* 4.4 Adapt variable "source" to fit with type of sources
replace source=0 if source==10
label define source 0"Easyvote" 1"Governmental information (1)" 2"Governmental information (2)" 3"National newspaper" 4"Economic association" 5"National television" 6"Regional newspaper" 7"Expert blog" 8"Free newspaper" 9"Preferred political party"

generate info_cues=1 if source==1 | source==2
replace info_cues=2 if source==9
replace info_cues=3 if source==3 | source==5 | source==6
replace info_cues=4 if source==8
replace info_cues=5 if source==4
replace info_cues=6 if source==7
replace info_cues=0 if source==0
label define info_cues 0"Easyvote-Basis" 1"Government" 2"Political party" 3"Quality media" 4"Tabloid media" 5"Economic association" 6"Expert blog" 

generate info_cues2=1 if info_cues==2 | info_cues==5
replace info_cues2=2 if info_cues==3 |info_cues==4
replace info_cues2=3 if info_cues==6 
replace info_cues2=4 if info_cues==1 | info_cues==0
label define info_cues2 1"Advocacy" 2"News" 3"Personal" 4"Informational"

generate gov_cues = 1 if info_cues==1
replace gov_cues=0 if info_cues!=1

generate party_cues = 1 if info_cues==2
replace party_cues=0 if info_cues!=2

generate mediaq_cues = 1 if info_cues==3
replace mediaq_cues=0 if info_cues!=3

generate mediat_cues = 1 if info_cues==4
replace mediat_cues=0 if info_cues!=4

generate ecoass_cues = 1 if info_cues==5
replace ecoass_cues=0 if info_cues!=5

generate expert_cues=1 if info_cues==6
replace expert_cues=0 if info_cues!=6


* 4.5 Variable choice of sources is "result". Binary variable. 

* 5. Run a binary logistic regression
* Figure 1 - Political information selection on a Google results page - Only ranking
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking if database==1
margins, dydx(ranking)
marginsplot, xdimension(_deriv) recast(scatter) level(95) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet source_google i.ranking if database==1, or

* Figure 2 - Political information selection on a Google results page - Ranking and cues
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1
margins, dydx(ranking)
marginsplot, xdimension(_deriv) allxlabels recast(scatter) level(95) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
margins, dydx(source)
marginsplot, xdimension(_deriv) allxlabels recast(scatter) level(95) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Information cues on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* Goodness-of-fit
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1
estat classification
lsens
lroc
estat gof

* Figure 3 - Political information selection on a Google results page - Interaction effect
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking_cat#i.info_cues if database==1
margins, dydx(ranking_cat) at(info_cues=(1(1)6))
marginsplot, allxlabels recast(scatter) level(95) plot1opts(mcolor(black) msymbol(O)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Information cues on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking_cat#i.info_cues if database==1, or


logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking_cat#i.info_cues2#i.polknowl if database==1
margins, dydx(ranking_cat) at(info_cues2=(1(1)4))

* 6. Robustness check
* 6.1 Run a multilevel logistic regression

xtmelogit result i.ranking i.source|| id: || group: if database==1, intpoints(10) 
estat icc
xtmelogit result i.ranking i.source|| id: || group: if database==1, intpoints(10) or
* --> Detect only within-variation, but no between-variation (close to 0). It means we can also run a logistic regression

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet source_google i.ranking i.source || id: || group: if database==1, intpoints(10) 
estat icc
xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet source_google i.ranking i.source  || id:|| group: if database==1, intpoints(10) 
estat icc

* 6.2 Operating system
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1 & operation==0
margins, dydx(ranking)
marginsplot, title(Computer user) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source  if database==1 & operation==1
margins, dydx(ranking)
marginsplot, title(Smartphone user) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 6.3 Google as a source of information
logit result i.sex age educ polint polknowl trust_fc party_attach i.ranking i.source if database==1 & source_google==0
margins, dydx(ranking)
marginsplot, title(Do not use Google as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.sex age educ polint polknowl trust_fc party_attach i.ranking i.source if database==1 & source_google==1
margins, dydx(ranking)
marginsplot, level(90) title(Use Google as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (90% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 6.4 French - German speaking respondents
logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1 & userlanguage=="DE"

logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1 & userlanguage=="FR"

* 6.5 Vote choice
generate vote_decision = 0 if vote_choice==1 | vote_choice==2
replace vote_decision = 1 if vote_choice==3 | vote_choice==4

logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1 & vote_decision==0

logit result i.sex age educ polint polknowl trust_fc party_attach internet source_google i.ranking i.source if database==1 & vote_decision==1

* 6.6 Margins
xtmelogit result i.ranking|| id: || group: if database==1, intpoints(10) 
margins, dydx(ranking)
marginsplot, xdimension(_deriv) allxlabels recast(scatter) level(95) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 6.7 Robustness check
xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet source_google i.ranking || group: if database==1 & operation==0, intpoints(10)
margins, dydx(ranking)
marginsplot, title(Computer user) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet source_google i.ranking || group: if database==1 & operation==1, intpoints(10)
margins, dydx(ranking)
marginsplot, title(Smartphone user) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet i.ranking || group: if database==1 & source_google==0, intpoints(10)
margins, dydx(ranking)
marginsplot, title(Do not use Google as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet i.ranking || group: if database==1 & source_google==1, intpoints(10)
margins, dydx(ranking)
marginsplot, level(90) title(Use Google as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (90% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

generate source_web = 0 if  internet==1 | internet==2
replace source_web=1 if internet==3 | internet==4 | internet==5

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet i.ranking || group: if database==1 & source_web==0, intpoints(10)
margins, dydx(ranking)
marginsplot, level(95) title(Do not use the Internet as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

xtmelogit result i.sex age educ polint polknowl trust_fc party_attach vote_choice internet i.ranking || group: if database==1 & source_web==1, intpoints(10)
margins, dydx(ranking)
marginsplot, level(95) title(Use the Internet as a source of political information) title(, size(medium) color(black)) xdimension(_deriv) allxlabels recast(scatter) plotopts(mcolor(black) msymbol(diamond)) ciopts(lcolor(black) lpattern(solid)) ytitle(Conditional marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) yline(0, lpattern(dash) lcolor(black)) xtitle(Ranking on Google's result page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* END
