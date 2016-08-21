library(RMySQL)

user <- "root"
password <- "kakarala"
dbname <- "attacks"
host <- "localhost"

mydb = dbConnect(MySQL(), user= user, password=password, dbname=dbname, host=host)

dbListTables(mydb)

tomap$at_summary<- iconv(tomap$at_summary, from = "", to = "UTF-8")
tomap$popup<- iconv(tomap$popup, from = "", to = "UTF-8")
tomap$attack_type<- iconv(tomap$attack_type, from = "", to = "UTF-8")
tomap$country<- iconv(tomap$country, from = "", to = "UTF-8")
tomap$city<- iconv(tomap$city, from = "", to = "UTF-8")





dbWriteTable(mydb,name="countries",value = countries_1)

library(shiny)
library(leaflet)
library(plyr)
library(ggmap)
library(maptools)
library(maps)

library(SparkR)
Sys.setenv(SPARK_HOME="C:/spark-1.6.2-bin-hadoop2.6")

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))

library("SparkR", lib.loc="C:/spark-1.6.2-bin-hadoop2.6/lib") 

sc <- sparkR.init(master="local")
sc <- sparkR.init(sparkPackages="com.databricks:spark-csv_2.11:1.0.3")
sqlContext <- sparkRSQL.init(sc)

tomapDF <- createDataFrame(sqlContext,tomap)
countries <- as.character(unique(select(tomapDF,countries)))
countries <-sort(countries, decreasing = FALSE)

attack_type <- as.character(levels(tomap$attack_type))



ui <- fluidPage(navbarPage("Menu",
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

server <- function(input, output, session) 
{
  
  
  output$Output <- renderLeaflet({
    
    leaflet(na.omit(tomap[tomap$year==input$yearinput[1] & tomap$country == input$countryInput[1]& tomap$attack_type == input$attacktype[1] ,]))%>%
      
      addCircles(lng = ~longitude, lat = ~latitude, weight = 1,
                 radius = ~nkill, popup = ~popup
      ) %>% 
      addTiles()})
  
}
shinyApp(ui = ui, server = server)