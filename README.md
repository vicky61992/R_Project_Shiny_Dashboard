# Fighter Analysis Dashboard

My analysis is mostly focus on comparision of fighters on various weight division in both Mens and Womens categories.
In the dashboard there are twelve weight division, user can select weight class according to thier choice.  
It shows you two graphs and one table of top five fighter in selected weight class. 
In third tab user are allow to select fighter, oppenent and weight division. 
In fourth tab you can find the Github Repository URL of this shiny application.

# To Run the Application run below code in your R-Studio
 # first install the R package "devtools","elo","shinydashboard" , if not installed
 Run Below commonds first
 
 install.packages("elo")
 
 install.packages("shinydashboard")
 
 library("elo")
 
 library("shinydashboard")
 
 runGitHub("R_Project_Shiny_Dashboard","vicky61992","master")

# Table Contents
1. About
2. Weight Categories
3. Fighter to Fighter comparision
4. Source

# Snippets from the App

![shiny1](https://user-images.githubusercontent.com/55536334/114886738-1558cc00-9e08-11eb-97ec-69b843b6fedf.png)




# What is covered by the Application
The Following have been cover 
1. About - information about the sport
2. Top Fighter in different weight category - select weight class it shows you two graphs and one top 5 fighters table in selected weight category 
3. Fighter and opponent comparision - Head to Head comparision of fighter and their opponent according weight class & shows the ability of both fighter and opponent in percentage.
4. Source - In this tab you can find github repository where every data and codes are avialable.




# Data Describtion 

I have two dataset in csv file format. In fileA there are 6 variables and 30864 observations. 
Match Id- specific IDs of every matches , Date - Date of Match,fighter- name of fighter,opponent- name of opponent,winner - 1 & 0 , weight class - categories weight division.
In fileB there are 76 variables and 812538 observation it is a huge file. some variables are same as fileA like MatchID,Fightername,Dates.This file give us maximum information about fighter and fights like location of fight, age of fighter, physical fitness of fighters.


# Technology Used

R language (R-Studio)



# Author
Vickysingh Baghel




