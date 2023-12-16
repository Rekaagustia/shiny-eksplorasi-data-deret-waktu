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
        tags$p("Contoh data tren adalah jumlah penduduk, pertumbuhan tinggi pohon,jumlah pengguna internet, dan ketersediaan sumber daya alam ."),
        tags$br(),
        tags$li("Data Siklus"),
        tags$p("Pola siklus muncul apabila data dipengaruhi fluktuasi jangka panjang yang biasanya berbentuk osilasi, misalnya gelombang sinus. Gejala-gejala fisika seperti gelombang tsunami yang terjadi setiap 100 tahun sekali, jumlah titik matahari Wolfer ( ¨ Wolfer sunspot¨) biasanya membentuk suatu siklus. Perbedaan utama pola musiman dan siklus terletak pada panjang dan periodenya. Pada musiman pola cenderung memiliki panjang konstan dan terjadi berulang pada periode teratur; namun, pada siklus pola ini memiliki panjang yang bervariasi dan magnitudo yang juga bervariasi."),
        tags$br(),
        tags$li("Data Seasonal"),
        tags$p("Pola musiman muncul apabila deret dipengaruhi oleh faktor-faktor musiman, misalnya kuartalan, bulanan, harian, dan tahunan."),
        tags$p("Contoh data seasonal adalah penjualan peralatan sekolah, produksipadi, penjualan tiket wisata."),
        tags$br(),
        tags$li("Data Random (fluktuatif tak beraturan)"),
        tags$p("Fluktuasi acak dalam data yang tidak dapat dijelaskan oleh tren, musiman, atau siklus. Fluktuasi ini bisa disebabkan oleh faktor-faktor acak atau faktor tak terduga lainnya."),
        tags$p("Contoh data random adalah inflasi, harga jual saham dan harga emas.")
        )
    ),
    fluidRow(
      tags$br(),
      tags$h2("ARIMA (Autoregresiive Integrated Moving Average"),
      tags$p("ARIMA sering juga disebut metode Box-Jenkins. ARIMA sangat baik ketepatannya untuk peramalan jangka pendek, sedangkan untuk peramalan jangka panjang ketepatan peramalannya kurang baik. Biasanya akan cenderung  flat (mendatar /konstan) untuk periode yang cukup panjang. Model Autoregresiive Integrated Moving Average (ARIMA) adalah model yang secara penuh mengabaikan peubah bebas dalam membuat peramalan. ARIMA menggunakan nilai masa lalu dan sekarang dari variabel dependen untuk menghasilkan peramalan jangka pendek yang akurat. ARIMA cocok jika observasi dari deret waktu (timeseries) secara statistik berhubungan satu sama lain (dependent). Tujuan model ARIMA adalah untuk menentukan hubungan statistik yang baik antar variabel yang diramal dengan nilai historis variabel tersebut sehingga peramalan dapat dilakukan dengan model tersebut.   Model ARIMA sendiri hanya menggunakan suatu variabel (univariate) deret waktu. Hal yang perlu diperhatikan adalah bahwa kebanyakan deret berkala bersifat non-stasioner dan bahwa aspek-aspek AR dan MA dari model ARIMA hanya berkenaan dengan deret berkala yang stasioner.vStasioneritas berarti tidak terdapat pertumbuhan atau penurunan pada data. Data secara kasarnya harus horizontal sepanjang sumbu waktu. Dengan kata lain, fluktuasi data berada di sekitar suatu nilai rata-rata yang konstan, tidak tergantung pada waktu dan varians dari fluktuasi tersebut pada pokoknya tetap konstan setiap waktu. Suatu deret waktu yang tidak stasioner harus diubah menjadi data stasioner dengan melakukan differencing. Yang dimaksud dengan differencing adalah menghitung perubahan atau selisih nilai observasi. Nilai selisih yang diperoleh dicek lagi apakah stasioner atau tidak. Jika belum stasioner maka dilakukan differencing lagi. Jika varians tidak stasioner, maka dilakukan transformasi logaritma."),
      tags$p("Tujuan model ARIMA adalah untuk menentukan hubungan statistik yang baik antar variabel yang diramal dengan nilai historis variabel tersebut sehingga peramalan dapat dilakukan dengan model tersebut.   Model ARIMA sendiri hanya menggunakan suatu variabel (univariate) deret waktu. Hal yang perlu diperhatikan adalah bahwa kebanyakan deret berkala bersifat non-stasioner dan bahwa aspek-aspek AR dan MA dari model ARIMA hanya berkenaan dengan deret berkala yang stasioner.vStasioneritas berarti tidak terdapat pertumbuhan atau penurunan pada data. Data secara kasarnya harus horizontal sepanjang sumbu waktu. Dengan kata lain, fluktuasi data berada di sekitar suatu nilai rata-rata yang konstan, tidak tergantung pada waktu dan varians dari fluktuasi tersebut pada pokoknya tetap konstan setiap waktu. Suatu deret waktu yang tidak stasioner harus diubah menjadi data stasioner dengan melakukan differencing. Yang dimaksud dengan differencing adalah menghitung perubahan atau selisih nilai observasi. Nilai selisih yang diperoleh dicek lagi apakah stasioner atau tidak. Jika belum stasioner maka dilakukan differencing lagi. Jika varians tidak stasioner, maka dilakukan transformasi logaritma.")
    ),
    ),
  # second tab panel
  tabPanel("Time Series Plot",
           # Sidebar inputs
           sidebarLayout(
             sidebarPanel(
               fluidRow(
                 column(6, selectInput(inputId = "data", label = "Pilih Data",
                                       choices = c("Masukan Mandiri", 
                                                   "Contoh Dataset")),
                 ),
                 #Upload File
                 column(6, conditionalPanel(
                   condition = "input.data == 'Masukkan Mandiri'",
                   fileInput(inputId = 'chosen_file', 
                             label = 'Unggah File CSV',
                             accept = c('text/csv',
                                        'text/comma-separated-values,text/plain',
                                        '.csv'),
                             multiple = FALSE)
                 ))), 
               actionButton("loadBtn", "Tampilkan Plot"),
               #  tableOutput("uploadData"),
               
               # ------ Display Table ------ #                      
               
               
               # ------ Set Used Variables ------ #
               fluidRow(
                 column(6, uiOutput('iv')), # Set X-Variable
                 column(6, uiOutput('dv'))  # Set Y-Variable
               ),
               
               
               # ----- Pilih Pola Data
               selectInput("tipe", label = "Jenis Pola data", 
                           choices = c("Data Trend", "Data Musiman", "Data Siklus","Data Fluktuatif" )),
               sliderInput("slider.n", label = "Smooth Trend", min = 1, max = 50, value = 30)
             ),
             
             mainPanel(
               plotlyOutput("myPlot"),
               plotlyOutput("uploadData")
             )
           )
  ),
  
  # third tab panel
  tabPanel("Forecast Plot",
           sidebarLayout(
             sidebarPanel(
               sliderInput("n",
                           "Rentang Waktu",
                           value = c(30, 80),
                           min = 1,
                           max = 257
               ),
               # days for prediction ahead
               numericInput("arm", "Banyaknya Peramalan", value = 10),
               
               # add options for prediction method
               radioButtons("model", "Pilih Model",
                            choices = c("ARIMA"),
                            choiceValues = "ARIMA")
               
             ),
             
             # Show a plot of the generated distribution
             mainPanel(
               plotOutput("trendPlot")
               
             )
           )
  )
)
)
