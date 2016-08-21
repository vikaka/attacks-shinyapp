library(shiny)
library(leaflet)
library(plyr)
library(ggmap)
library(maptools)
library(maps)



server <- function(input, output, session) 
{
  
  
  output$Output <- renderLeaflet({
    
    leaflet(na.omit(tomap[tomap$year==input$yearinput[1] & tomap$country == input$countryInput[1]& tomap$attack_type == input$attacktype[1] ,]))%>%
      
      addCircles(lng = ~longitude, lat = ~latitude, weight = 1,
                 radius = ~nkill, popup = ~popup
      ) %>% 
      addTiles()})
  
}
