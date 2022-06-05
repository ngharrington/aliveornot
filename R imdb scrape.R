#install packages and load libraries
install.packages("data.table")
install.packages("dplyr")
install.packages("stringr")
library(data.table)
library(dplyr)
library(stringr)

#read the database into a dataframe
df = fread("https://datasets.imdbws.com/name.basics.tsv.gz")

#if you want a smaller set to play with, this selects a random 1000 entries from the table
hot_1000 <- df[sample(nrow(df), 1000), ]

#filter into actors/actresses/known birth year
df_bornactORs <- df %>% filter(birthYear > 0) %>% filter(str_detect(primaryProfession, "actor") | str_detect(primaryProfession, "actress"))

#writes to a csv
write.csv(df_bornactORs, "C:\\Users\\alexr\\Desktop\\bornactors_imdb.csv")