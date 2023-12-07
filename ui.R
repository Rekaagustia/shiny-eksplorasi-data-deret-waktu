library(shiny)
library(shinydashboard)
library(dygraphs)
library(plotly)
library(DT)
library(DBI)
library(bslib)
library(tidyverse)
library(shinythemes)
library(shinydashboardPlus)
library(bs4Dash)
library(dplyr)
library(shinyjs)
library(data.table)
library(rhandsontable)
#-----------------UI--------------------------#
shinyUI(navbarPage(
    title = "Eksplorasi Data Deret Waktu",
    collapsible = TRUE,
    tabPanel(
      title = "Definisi",
      fluidRow(
        tags$br(),
        tags$ h2("Pengertian Data Deret Waktu"),
        tags$p("Deret waktu (Time Series) adalah sekumpulan data pengamatan yang diukur selama kurun waktu tertentu. Jenis data ini sering kita jumpai dalam kehidupan sehari-hari, karena data dikumpulkan pada interval waktu tertentu, seperti harian, mingguan, atau bulanan. Dari data yang terkumpul terlihat adanya pola. Dalam time series, pola dibagi menjadi empat yaitu. tren, pola siklus,musiman dan random (fluktuasi tidak beraturan).")
        ),
      fluidRow(
        tags$br(),
        tags$ h2("Pola Data Deret Waktu"),
        tags$p("Menampilkan pola data deret waktu yang terdiri dari:"),
        tags$ol(
          tags$li("Data Tren"),
          tags$p("Tren merupakan perubahan jangka panjang baik naik maupun turun dalam data. Dalam pembicaraan tentang tren kita harus memperhatikan berapa banyak data yang ada dan juga penilain kita terhadap definisi jangka panjang. Sebagai contoh peubah-peubah keadaan cuaca biasanya memberikan variasi siklus pada periode yang sangat panjang, misalkan 75 tahun. Jika kita hanya punya data untuk 20 tahun saja, maka pola osilasi jangka panjang ini akan terlihat sebagai tren."),
          tags$br(),
          tags$li("Data Siklus"),
          tags$p("Pola siklus muncul apabila data dipengaruhi fluktuasi jangka panjang yang biasanya berbentuk osilasi, misalnya gelombang sinus. Gejala-gejala fisika seperti gelombang tsunami yang terjadi setiap 100 tahun sekali, jumlah titik matahari Wolfer ( ¨ Wolfer sunspot¨) biasanya membentuk suatu siklus. Perbedaan utama pola musiman dan siklus terletak pada panjang dan periodenya. Pada musiman pola cenderung memiliki panjang konstan dan terjadi berulang pada periode teratur; namun, pada siklus pola ini memiliki panjang yang bervariasi dan magnitudo yang juga bervariasi."),
          tags$br(),
          tags$li("Data Seasonal"),
          tags$p("Pola musiman muncul apabila deret dipengaruhi oleh faktor-faktor musiman, misalnya kuartalan, bulanan, harian, dan tahunan."),
          tags$br(),
          tags$li("Data Random(Fluktuatif tak beraturan"),
          tags$p("Fluktuasi acak dalam data yang tidak dapat dijelaskan oleh tren, musiman, atau siklus. Fluktuasi ini bisa disebabkan oleh faktor-faktor acak atau faktor tak terduga lainnya.")
        ),
      )
      ),
  # second tab panel
    tabPanel("Time Series Plot",
           # Sidebar inputs
               fluidRow(
                 column(6, selectInput(inputId = "data", label = "Pilih Data",
                                       choices = c("Unggah Data", 
                                                   "Masukan Mandiri"))
                 ),
                 #Upload File
                 column(6, conditionalPanel(
                   condition = "input.data == 'Unggah Data'",
                   fileInput(inputId = 'chosen_file', 
                             label = 'Choose CSV File',
                             accept = c('text/csv',
                                        'text/comma-separated-values,text/plain',
                                        '.csv'))
                 ))
               ),
               #Upload mandiri
               fluidRow(
                 column(12, conditionalPanel(
                   condition = "input.data == 'Masukan Mandiri'",
                   rHandsontableOutput(outputId = "tabelle"),
                   actionButton("save",label = "Save Data")
                 ))
               ),
               # ------ Display Table ------ #
               fluidRow(
                 DT::dataTableOutput("show_tbl", width = "100%")
               ),
               # ------ Set Used Variables ------ #
               fluidRow(
                 column(6, uiOutput('iv')), # Set X-Variable
                 column(6, uiOutput('dv'))  # Set Y-Variable
               ),
           # ----- Input Mandiri
           conditionalPanel(
             condition = "input.data == 'Masukan Mandiri'",
             textOutput(outputId = "caption"),
             sliderInput(inputId = "slider.x", label = "Atur rentang X", min = -100, max = 100, value = c(-10, 10)),
             sliderInput(inputId = "slider.y", label = "Atur rentang Y", min = -100, max = 100, value = c(-10, 10)),
             actionButton("reset", "Reset")
           ),
           
           # ----- Refresh Button
           conditionalPanel(
             condition = "input.data != 'Input Mandiri'",
             actionButton("refresh", "Refresh")
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
)

#-----------------FOOTER-----------------#
footer = dashboardFooter(
  left = "by Kelompok 2",
  right = "IPB University, 2023"
)
