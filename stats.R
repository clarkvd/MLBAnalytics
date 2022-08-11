(.packages())
pacman::p_load(pacman,rvest,dplyr,rio)

test <- readline()
table <- import("~/Desktop/baseballtable.csv")
playername = as.data.frame(table[,2])
for (i in 1:nrow(playername)){
  if (playername[i,]==test){
    newrow <- i
  }
}


playerid = as.data.frame(table[,11])
id <- playerid[newrow,]


hitorpitch = table[newrow,8]
if (hitorpitch == "P"){
  link <- paste0("https://baseballsavant.mlb.com/savant-player/",test,"-",id,"?stats=statcast-r-pitching-mlb")
  page <- read_html(link)
  pitching1 <- page %>% html_nodes("#statcast_stats_pitching .table-static-column span") %>% html_text()
  pitching2 <- page %>% html_nodes("#statcast_stats_pitching .align-right:nth-child(20) span") %>% html_text()
  len <- length(pitching2)-2
  year <- pitching1[1:len]
  ERA <- pitching2[1:len]
  tlb <- cbind.data.frame(year,ERA)
  print(tlb)
} 

if (hitorpitch != "P"){
  link <- paste0("https://baseballsavant.mlb.com/savant-player/",test,"-",id,"?stats=career-r-hitting-mlb")
  page <- read_html(link)
  hitting1 <- page %>% html_nodes(".table-static-column span") %>% html_text()
  hitting2 <- page %>% html_nodes(".tr-data:nth-child(19) .underline") %>% html_text()
  hitting3 <- page %>% html_nodes(".tr-data:nth-child(20) .underline") %>% html_text()
  hitting4 <- page %>% html_nodes(".tr-data:nth-child(21) .underline") %>% html_text()
  hitting5 <- page %>% html_nodes(".tr-data:nth-child(22) .underline") %>% html_text()
  hitting6 <- page %>% html_nodes(".tr-data:nth-child(12) .underline") %>% html_text()
  hitting7 <- page %>% html_nodes(".tr-data:nth-child(13) .underline") %>% html_text()
  
  len <- length(hitting2)
  
  year <- hitting1[1:len]
  AVG <- hitting2[1:len]
  OBP <- hitting3[1:len]
  SLG <- hitting4[1:len]
  OPS <- hitting5[1:len]
  HR <- hitting6[1:len]
  RBI <- hitting7[1:len]
  
  tlb <- cbind.data.frame(year,AVG,OBP,SLG,OPS,HR,RBI)
  print(tlb)
  
}
  


#p_unload(all)

