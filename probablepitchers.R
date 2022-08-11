pacman::p_load(pacman,rvest,dplyr,rio)

#import spreadsheet to find ID
table <- import("~/Desktop/baseballtable.csv")
playerdf = as.data.frame(table[,2])

#find probable pitchers for today
link <- "https://www.mlb.com/probable-pitchers"
page <- read_html(link)
pitchers <- page %>% html_nodes(".probable-pitchers__pitcher-name-link") %>% html_text()
pitchers
test <- 0


for (i in 1:length(pitchers)){
  #get each players ID and link
  
  split <- strsplit(pitchers[i], "")[[1]]
  split <- tolower(split)
  for (k in 1: length(split)){
    if (split[k] == ' '){
      split[k] <- '-'
    }
  }
  split <- paste(split,collapse="") 
  
  for (j in 1: nrow(playerdf)){
    if (playerdf[j,]==pitchers[i] && table[j,8] == "P"){
      newrow <- j
      test <- 1
    }
  }
  
  #some new callups are not yet availible on the spreadsheet, so have to test for that
  if (test == 0){
    print(paste0("PITCHER ", pitchers[i], " NOT AVAILIBLE"))
  }
  else{
    print(pitchers[i])
    
    playerid = as.data.frame(table[,11])
    id <- playerid[newrow,]
    playerlink <- paste0("https://baseballsavant.mlb.com/savant-player/",split,"-",id,"?stats=statcast-r-pitching-mlb")
    bspage <- read_html(playerlink)
    playerlink
    #get pitch percentages
    pitchnames<-NULL
    pitchpercent<-NULL
    top <- bspage %>% html_nodes(".spin-pitches div") %>% html_text()
    for (a in 1:length(top)){
      if (a%%2==1){
        pitchnames<-append(top[a],pitchnames)
      }
      else{
        split <- strsplit(top[a], "")[[1]]
        for (b in 1: length(split)){
          if (split[b] == ' ' || split[b] == '%' || split[b] == '(' || split[b] == ')' || split[b] == ','){
            split[b] <- ''
          }
        }
        newper <- as.double(paste(split,collapse=""))
        pitchpercent<-append(newper,pitchpercent)
      }
    }
    
    top<-data.frame(pitchnames,pitchpercent)
    print(top)
    
  }
  
}




