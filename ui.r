library(shiny)
library(leaflet)
library(plyr)
library(ggmap)
library(maptools)
library(maps)


gtd_70to91_0616dist <- read.csv("~/Final/gtd_70to91_0616dist.csv")
gtd_12to15_0616dist <- read.csv("~/Final/gtd_12to15_0616dist.csv")
gtd_92to11_0616dist <- read.csv("~/Final/gtd_92to11_0616dist.csv")



gtd_12to15_0616dist$fulldate <- as.Date(paste(as.character(gtd_12to15_0616dist$iyear),as.character(gtd_12to15_0616dist$imonth),as.character(gtd_12to15_0616dist$iday),sep=""),"%Y%m%d")

gtd_92to11_0616dist$fulldate <- as.Date(paste(as.character(gtd_92to11_0616dist$iyear),as.character(gtd_92to11_0616dist$imonth),as.character(gtd_92to11_0616dist$iday),sep=""),"%Y%m%d")

gtd_70to91_0616dist$fulldate <- as.Date(paste(as.character(gtd_70to91_0616dist$iyear),as.character(gtd_70to91_0616dist$imonth),as.character(gtd_70to91_0616dist$iday),sep=""),"%Y%m%d")




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

attack_type <- as.character(levels(tomap$attack_type))










fluidPage(navbarPage("Menu",
                           tabPanel("Interactive Visualization",
                                    h1("Interactive Visualization of Terrorist Attacks", align = "center"),
                                    sidebarLayout
                                    (
                                    sidebarPanel 
                                    (
                                    "Select country",
                                    selectInput("countryInput", "Country",countries, selected = "Iraq"),
                                    "Select year",
                                    selectInput("yearinput","Year",sort(unique(tomap$year)),selected = 2015),
                                    "Select Attack type",
                                    radioButtons("attacktype","Attack Type",attack_type)
                                    ),
                                    mainPanel 
                                    ( 
                                    leafletOutput("Output")
                                    
                                    )
                                    )
                           ),
                           tabPanel("Timeline visualization - Year [1970-2015]",
                                    imageOutput("myImage")
                           ),
                           tabPanel("Timeline visualization - Monthly [1970-2015]")
                           
)
) 
