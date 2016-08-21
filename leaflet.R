library(leaflet)
library(plyr)
library(ggmap)
library(maptools)
library(maps)
mysql_1 <- read.csv("C:/Users/Vishesh Kakarala/Desktop/MySQL_1.csv", stringsAsFactors=FALSE)
mysql_1$dt_country<- as.character(mysql_1$dt_country)
mysql_1$lat<-as.numeric(mysql_1$lat)
mysql_1$lon<-as.numeric(mysql_1$lon)
mysql_1$killed<-as.numeric(mysql_1$killed)
mysql_1$deaths_event <- as.numeric(mysql_1$deaths_event)


m <- leaflet(mysql_1[mysql_1$dt_year==2015&mysql_1$tomap.attack_type=="Unknown",])%>%

  addCircles(lng = ~lon, lat = ~lat, weight = ~total_events/10,
             radius = ~deaths_event, popup = ~dt_country
  ) %>% 
  addTiles()
m

tomap1 <- data.frame(latitude = gtd_12to15_0616dist$latitude, longitude = gtd_12to15_0616dist$longitude, city = gtd_12to15_0616dist$city, nkill = gtd_12to15_0616dist$nkill
           ,year = gtd_12to15_0616dist$iyear, month = gtd_12to15_0616dist$imonth, day = gtd_12to15_0616dist$iday,country = gtd_12to15_0616dist$country_txt,attack_type = gtd_12to15_0616dist$attacktype1_txt,at_summary = gtd_12to15_0616dist$summary)

tomap2 <- data.frame(latitude = gtd_70to91_0616dist$latitude, longitude = gtd_70to91_0616dist$longitude, city = gtd_70to91_0616dist$city, nkill = gtd_70to91_0616dist$nkill
,year = gtd_70to91_0616dist$iyear, month = gtd_70to91_0616dist$imonth, day = gtd_70to91_0616dist$iday,country = gtd_70to91_0616dist$country_txt,attack_type = gtd_70to91_0616dist$attacktype1_txt,at_summary = gtd_70to91_0616dist$summary)

tomap3 <- data.frame(latitude = gtd_92to11_0616dist$latitude, longitude = gtd_92to11_0616dist$longitude, city = gtd_92to11_0616dist$city, nkill = gtd_92to11_0616dist$nkill
,year = gtd_92to11_0616dist$iyear, month = gtd_92to11_0616dist$imonth, day = gtd_92to11_0616dist$iday,country = gtd_92to11_0616dist$country_txt,attack_type = gtd_92to11_0616dist$attacktype1_txt,at_summary = gtd_92to11_0616dist$summary)

tomap <- rbind(tomap1,tomap2,tomap3)
tomap <-arrange(tomap,year)

tomap$popup <- paste(sep = "<br>",tomap$city,
                     tomap$attack_type,"<b>Total dead :</b>",tomap$nkill,tomap$at_summary)

countries <- as.character(unique(tomap$country))
countries <-sort(countries, decreasing = FALSE)

#countries <- as.character(c("Select All",countries))

attack_type <- as.character(levels(tomap$attack_type))

#tomap$attack_type[is.na(tomap$attack_type)]

#observe({
 # if ("Select All" %in% input$countryInput) {
  #  selected_choices <- setdiff(countries, "Select All")
   # updateSelectInput(session, "countryInput", selected = selected_choices)
  #}
#})

