# Fighter Analysis Dashboard

My analysis is focus on fighters of various weight division in both Mens and Womens categories.
there are twelve weight division we can select weight division and fighters it shows you two graphs and one top five fighter table in that weight division which your selected.
in third tab user are allow to select fighter, oppenent and weight division. in fourth tab you can find the source code of this shiny application.

# To Run the Application run below code in your R-Studio
runGitHub("R_Project_Shiny_Dashboard","vicky61992","master")
.






# Data Describtion 

I have two data csv file in fileA there are 6 variables and 30864 observations. 
 Match Id- specific IDs of every matches 
 Date - Date of Match,fighter- name of fighter,opponent- name of opponent,winner - 1 & 0 , weight class - categories weight division.
 In fileB there are 76 variables and 812538 observation it is a huge file. 
some variables are same as fileA like MatchID,Fightername,Dates. 
this file give us maximum information about fighter and fights like location of fight, age of fighter, physical fitness of fighters.
i am using both data set for my dashboard building.


