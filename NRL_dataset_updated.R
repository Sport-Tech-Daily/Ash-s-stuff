library(tidyverse)
library(RPostgreSQL)
library(lubridate)
library(fitdistrplus)
library(LearnBayes)
library(fpp2)
library(ModelMetrics)
library(caret)
library(stepPlr)
library(dplyr)
library(plyr)
install.packages("writexl")
library(writexl)
setwd("C:/Users/aashu/Downloads/Wicky R files/Nrl Csvs/")
source("C:/Users/aashu/Downloads/Wicky R files/Nrl Csvs/Sport_Tech_Daily_Functions.R")

options(scipen = 999, stringsAsFactors = FALSE)



##########----------Loading Data From Database----------##########

print("Loading Data From Database")

df      <- NRL_create_player_stats_df(startseason = 2008) %>% arrange(match_date)
team    <- NRL_create_team_stats_df(startseason = 2008)$data
texps   <- team %>% dplyr::select(match_id, team_id, contains("ExpSmooth"), DeadRubber, TeamHalfwayRank, TeamPremier, TeamWoodenSpoon, TeamMinorPremier)
df      <- left_join(df, texps, by = c("match_id", "team_id"))
teams   <- unique(df$PlayerTeamName) %>% sort
high    <- c("Centre", "Five-Eighth", "Fullback", "Halfback", "Winger")
players <- NRL_7players_table()
tms     <- NRL_teams_table() %>% dplyr::select(team_id, TeamName = team_name)
# game    <- NRL_game_table(startseason = 2008) %>% arrange(match_date)
# odds    <- NRL_odds_table(startseason = 2013)
pl      <- unique(df[which(df$Season >= 2018),]$player_id)
# df_pbp  <- NRL_create_pbp_df(startseason = 2013)

NrlDataset <- df %>% dplyr::select(match_id, round_number, round_name, match_date, all_run_metres, all_runs, minutes_played, field_goals, player, HomeTeam, AwayTeam, PositionsGrouped, points, tackles_made, tries, try_assists, line_breaks, PlayerTeamName, venue, goals, field_goals)
NrlDataset <- NrlDataset %>% mutate(PPScoringSystem = (NrlDataset$points*4 + NrlDataset$tackles_made*1 + NrlDataset$all_run_metres*0.1 + NrlDataset$try_assists*10 + NrlDataset$line_breaks*5))
NrlDataset1 <- NrlDataset %>% dplyr:: filter(match_date > as.Date("2017-01-01"))
colnames(NrlDataset1)[2] <- "Round"
colnames(NrlDataset1)[4] <- "Match Date"
colnames(NrlDataset1)[5] <- "Run Metres"
colnames(NrlDataset1)[6] <- "Runs"
colnames(NrlDataset1)[7] <- "Minutes"
colnames(NrlDataset1)[9] <- "Player Name"
colnames(NrlDataset1)[12]<- "Position Type"
colnames(NrlDataset1)[13]<- "Points"
colnames(NrlDataset1)[14]<- "Tackles"
colnames(NrlDataset1)[15]<- "Tries"
colnames(NrlDataset1)[16]<- "Try Assists"
colnames(NrlDataset1)[17]<- "Line Breaks"
colnames(NrlDataset1)[20]<- "Goals"
colnames(NrlDataset1)[21]<- "Player PP"
colnames(NrlDataset1)[1] <- "Match Id"

NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Brisbane Broncos", "BRI", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "North Queensland Cowboys", "NQL", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Warriors", "WAR", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Parramatta Eels", "PAR", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Cronulla-Sutherland Sharks", "CRO", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "South Sydney Rabbitohs", "SOU", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Canterbury-Bankstown Bulldogs", "BUL", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Melbourne Storm", "MEL", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Wests Tigers", "WST", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Penrith Panthers", "PEN", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "St. George Illawarra Dragons", "STG", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Manly-Warringah Sea Eagles", "MAN", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Newcastle Knights", "NEW", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Sydney Roosters", "SYD", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Gold Coast Titans", "GLD", NrlDataset1$PlayerTeamName)
NrlDataset1$PlayerTeamName <- ifelse(NrlDataset1$PlayerTeamName == "Canberra Raiders", "CAN", NrlDataset1$PlayerTeamName)








Sys.Date()
Sys.time()





write_xlsx(NrlDataset1, "Nrl_PlayerPerformance.xlsx")
