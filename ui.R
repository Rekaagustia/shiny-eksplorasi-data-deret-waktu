library(shiny)
library(shinydashboard)
library(dygraphs)
library(plotly)

#-----------------UI--------------------------#

shinyUI(navbarPage(
  
  # Application title
  "Dashboard Eksplorasi Data Deret Waktu",
  
  # first tab panel
    tabPanel("Definisi",
           fluidPage(
             textOutput("text")
           )),
  
  
  # second tab panel
    tabPanel("Time Series Plot",
           # Sidebar inputs
           sidebarLayout(
             sidebarPanel(
               dateInput("start", 
                         label = "Tanggal Awal Analisis:",
                         value = "2019-01-01"),
               dateInput("end", 
                         label = "Tanggal Akhir Analisis:",
                         value = "2023-10-30"),
               selectInput("tipe", label = "Pilih Pola data", 
                           choices = c("Data Trend", "Data Musiman ", "Data Siklus","Data Fluktuatif" ))
             ),
             conditionalPanel(
               condition = "input.data == 'Data Trend'",
               sliderInput(inputId = "slider.n", label = "Pilih ukuran data", min = 10, max = 300, value = 100)
             )),
             
             # Shows first plot from server file
             mainPanel(
               plotOutput("myPlot"))
           ),
  
  # third tab panel
  tabPanel("Forecast Plot",
           sidebarLayout(
             sidebarPanel(
               dateInput("start2", 
                         label = "Tanggal awal analisis:",
                         value = "2019-01-01"),
               dateInput("end2", 
                         label = "Tanggal akhir analisis:",
                         value = "2023-01-01"),
               selectInput("type2",
                            label = "Pilih pola data:",
                           choices = c("Data Trend", "Data Musiman ", "Data Siklus","Data Fluktuatif" )),
               checkboxInput("showgrid", label = "Show Grid", value = TRUE),
               numericInput("predict",
                            label = "Masukkan banyaknya prediksi:",
                            value = 30),
             ),
             
             # Shows second plot from server file
             mainPanel(
               dygraphOutput("dygraph"))
           )
  )
)
)
