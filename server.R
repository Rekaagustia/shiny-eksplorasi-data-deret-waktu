library(shiny)
library(ggplot2)
library(dplyr)
library(dygraphs)
library(xts)
library(forecast)
library(lubridate)
library(readxl)
library(TSA)
library(plotly)


shinyServer(function(input, output) {
  
  #first tab
  output$text <- renderText({
    "Penjelasan Analisis Deret Waktu
    Deret waktu (Time Series) adalah sekumpulan data pengamatan yang diukur selama kurun waktu tertentu. Jenis data ini sering kita jumpai dalam kehidupan sehari-hari, karena data dikumpulkan pada interval waktu tertentu, seperti harian, mingguan, atau bulanan. Dari data yang terkumpul terlihat adanya pola. Dalam time series, pola dibagi menjadi empat yaitu. tren, pola siklus,musiman dan random (fluktuasi tidak beraturan)."
  })  
  
  # second tab
  # Live Chart
  output$myPlot <- renderPlot({
    
    # reading in the data from the API
    data_kurs <- read_xlsx("C:/Users/Sofia/Downloads/kurs.xlsx")
    data_penduduk <- read_xlsx("C:/Users/Sofia/OneDrive/Documents/Semester 3/Eksplorasi dan Visualisasi Data/Dashboard EVD/penduduk.xlsx")
    
    # need to convert the dates to Date class in order to use scale_x_data
    Date_kurs_class <- as.Date(data_kurs$Tanggal)
    Date_penduduk_class <- as.Date(data_penduduk$Tanggal)
    
    if(input$tipe == "Data Trend"){
      
      ggplot(data_penduduk, aes(x = Date_penduduk_class, y = Jumlah, group = 1)) +
        geom_line(color = "DarkBlue") + 
        xlab("Tahun") +
        ylab("Jumlah Penduduk") +
        # spreads out the x values and lanels them by their respective months and dates
        scale_x_date(date_breaks = "5 year", date_labels =  "%b %Y") +
        # makes the labels slanted by 45 degrees
        theme_classic() +
        theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
        ggtitle("Jumlah Penduduk Dunia")
      
    } else if(input$tipe == "Data Fluktuatif"){
      ggplot(data_kurs, aes(x = Date_kurs_class, y = Terakhir, group = 1)) + geom_line(color = "Red")+
     # plot_ly(data_kurs, x= data_kurs$Tanggal, y = data_kurs$Terakhir, type = 'scatter', mode = 'lines')
        xlab("Periode") + ylab("Kurs Dollar") + 
          scale_x_date(date_breaks = "3 months", date_labels =  "%b %Y") +
        # makes the labels slanted by 45 degrees
        theme_classic() +
        theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
        ggtitle("Kurs Rupiah Terhadap Dollar")
      
    } else if(input$tipe == "Data Musiman"){
      
      ggplot(tempdub, xlab="Tahun",ylab="Temperatur",) +
        geom_line(color = "DarkBlue") + 
        xlab("Periode") +
        ylab("Kurs Dollar") +
        # spreads out the x values and lanels them by their respective months and dates
        scale_x_date(date_breaks = "3 months", date_labels =  "%b %Y") +
        # makes the labels slanted by 45 degrees
        theme_classic() +
        theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
        ggtitle("Kurs Rupiah Terhadap Dollar")
    } else if(input$tipe == "Data Siklus"){
      
      ggplot(data_kurs, aes(x = Date_kurs_class, y = Terakhir, group = 1)) +
        geom_line(color = "DarkBlue") + 
        xlab("Periode") +
        ylab("Kurs Dollar") +
        # spreads out the x values and lanels them by their respective months and dates
        scale_x_date(date_breaks = "3 months", date_labels =  "%b %Y") +
        # makes the labels slanted by 45 degrees
        theme_classic() +
        theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
        ggtitle("Kurs Rupiah Terhadap Dollar")
    }
  })
  
  # second plot
  # must use renderDygraph instead of renderPlot
  output$dygraph <- renderDygraph({
    
    data <- data_kurs <- read_xlsx("C:/Users/Sofia/Downloads/kurs.xlsx")
    
    new_dat <- data %>%
      arrange(Dates)
    
    start_date <- as.Date(new_dat[1,1])
    end_date <- as.Date(new_dat[length(new_dat$Dates), 1])
    
    inds <- seq(start_date, end_date, by = "day")
    
    uni_data <- new_dat %>%
      select(data)
    
    zoo.obj <- zoo(uni_data, inds)
    
    model = auto.arima(zoo.obj)
    
    predict = forecast(model, h = input$predict) # number of days predicted
    
    predict %>%
      {cbind(actuals=.$x, forecast_mean=.$mean)} %>%
      dygraph()
    
    predict %>%
      {cbind(actuals=.$x, forecast_mean=.$mean,
             lower_95=.$lower[,"95%"], upper_95=.$upper[,"95%"],
             lower_80=.$lower[,"80%"], upper_80=.$upper[,"80%"])} %>%
      dygraph() %>%
      dySeries("actuals", color = "black") %>%
      dySeries(c("lower_80", "forecast_mean", "upper_80"),
               label = "80%", color = "blue") %>%
      dySeries(c("lower_95", "forecast_mean", "upper_95"),
               label = "95%", color = "blue") %>%
      dyOptions(drawGrid = input$showgrid)
  })
  
})
