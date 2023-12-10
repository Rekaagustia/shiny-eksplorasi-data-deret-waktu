library(shiny)
library(ggplot2)
library(dplyr)
library(dygraphs)
library(xts)
library(forecast)
library(lubridate)
library(readxl)
library(TSA)
library(datasets)
library(plotly)

#------------------server---------------------#

  #first tab
  shinyServer(function(input, output) {
    #First tab 
    # ------------ Definisi
    
    #Second tab
    # ------------- Time Series Plot
    
    # ------------- Menu Upload Mandiri
    data <- reactiveVal(NULL)
    observeEvent(input$chosen_file, {
      req(input$chosen_file)
      
      # Membaca file CSV
      data_read <- read.csv(input$chosen_file$datapath)
      data(data_read)
    })
    
    
    # -------------- Menampilkan Plot Upload Mandiri
    observeEvent(input$loadBtn, {
      req(data())
      output$uploadData <- renderPlotly({
        req(data())
        if (!is.null(data()$XColumn) && !is.null(data()$YColumn)) {
          plot_ly(data(), x = ~Date, y = ~General, type = 'scatter', mode = 'lines')
        } else {
          plot_ly(data()) 
        }
      })
    })
  #------------- Tabel Upload
  data <- reactiveVal(NULL)
  observeEvent(input$loadBtn, {
    req(input$chosen_file)
    
    # Membaca file CSV
    data_read <- read.csv(input$chosen_file$datapath)
    
    # Simpan data di reactiveVal
    data(data_read)
  })
  # output$uploadData <- renderTable({
  #    req(data())
  #    data()
  #    })
  
  uploaded_df <- reactive({
    inFile <- input$chosen_file
    ext <- tools::file_ext(inFile$datapath)
    req(inFile)
    validate(need(ext =="csv", "Silahkan unggah berkas csv"))
    readData <- read.csv(inFile$datapath, header = TRUE)
    readData
  })
  
  myData <- reactive({
    req(input$data)
    # ---------- Example Dataset ---------- #
    if(input$data == "Contoh Dataset"){
      return(as.data.frame(selected_df()))
    }
    # ---------- Upload the Dataset ---------- #
    else if(input$data == "Masukkan Mandiri"){
      return(as.data.frame(uploaded_df()))  
    }
  })
  
  output$show_tbl = renderTable(myData(),
                                options = list(scrollX = TRUE))
  #------------------Menampilkan Plot Upload Mandiri
  
  output$uploadData <- renderPlotly({
    req(data())
    data()
    plot_ly(data())
  })
  
  #------------------Pola Time Series
  
  output$myPlot <- renderPlotly({
    
    # reading in the data from the API
    data_kurs <- read_xlsx("C:/Users/Lenovo/Documents/IPB/fix/Eksplorasi dan Visualisasi Data/kurs.xlsx")
    data_penduduk <- read_xlsx("C:/Users/Lenovo/Documents/IPB/fix/Eksplorasi dan Visualisasi Data/penduduk.xlsx")
    data_seasonal<- read_xlsx("C:/Users/Lenovo/Documents/IPB/fix/Eksplorasi dan Visualisasi Data/data_seasonal.xlsx")
    data_siklus<- read_xlsx("C:/Users/Lenovo/Documents/IPB/fix/Eksplorasi dan Visualisasi Data/data siklus.xlsx")
    
    # need to convert the dates to Date class in order to use scale_x_data
    Date_kurs_class <- as.Date(data_kurs$Tanggal)
    Date_penduduk_class <- as.Date(data_penduduk$Tanggal)
    
    #--slider coba
    #    autoplot(ts(data_kurs[input$n[1]:input$n[2], "Close"])) +
    #      ggtitle("Data Kurs Rupiah Terhadap Dollar")
    #    end = dim(stock)[1]
    #    start = end - 100
    
    if(input$tipe == "Data Trend"){
      p1 <- plot_ly(data_penduduk, x= data_penduduk$Tanggal, y = data_penduduk$Jumlah, type = 'scatter', mode = 'lines', marker = list(color = 'red'))
      p1 <- p1 %>% layout(title = "Jumlah Penduduk Dunia",
                          xaxis = list(title = "Tahun"),
                          yaxis = list (title = "Jumlah Penduduk"))
      bins <- seq(min(data_penduduk$Tanggal), max(data_penduduk$Tanggal), length.out <- input$slider.n+1)
      ggplotly(p1, x = ~Tanggal, y = ~Jumlah, breaks = bins)
    }  
    else if(input$tipe == "Data Musiman"){
      p2 <- plot_ly(data_seasonal, x= data_seasonal$Time, y = data_seasonal$Temperature_change, type = 'scatter', mode = 'lines', marker = list(color = 'blue'))
      p2 <- p2 %>% layout(title = "Temperature Change at Nottingham, 1920-1939",
                          xaxis = list(title = "Year"),
                          yaxis = list (title = "Temperature Change (°F)"))
      #bins <- seq(min(data_seasonal$Time), max(data_seasonal$Time), length.out <- input$slider.n+1)
      ggplotly(p2, x = ~Time, y = ~Temperature_change, breaks = bins)
      
    }
    else if(input$tipe == "Data Siklus"){
      p3 <- plot_ly(data_siklus, x= data_siklus$Time, y = data_siklus$Temperature, type = 'scatter', mode = 'lines', marker = list(color = 'green'))
      p3 <- p3 %>% layout(title = "Temperatures at Nottingham, 1920-1939",
                          xaxis = list(title = "Year"),
                          yaxis = list (title = "Temperature (°F)"))
      bins <- seq(min(data_siklus$Time), max(data_siklus$Time), length.out <- input$slider.n+1)
      ggplotly(p3, x = ~Time, y = ~Temperature, breaks = bins)
      
    }
    else if(input$tipe == "Data Fluktuatif"){
      p4 <- plot_ly(data_kurs, x= data_kurs$Tanggal, y = data_kurs$Terakhir, type = 'scatter', mode = 'lines', marker = list(color = 'blue'))
      p4 <- p4 %>% layout(title = "Kurs Rupiah Terhadap Dolar",
                          xaxis = list(title = "Tahun"),
                          yaxis = list (title = "Kurs Dollar"))
      ggplotly(p4, smoothnes = input$slider.n)
    }
    
  })
  
  #--------------------Smooth Trend
  
  output$PolaSmooth <- renderPlotly({
    data_kurs <- read_xlsx("C:/Users/Sofia/Downloads/kurs.xlsx")
    scatter.smooth(x = data_kurs$Tanggal, y = data_kurs$Terakhir, type = 'o', pch=20, 
                   lpars = list(col = 'red', lwd = 2), 
                   main = 'Kurs Rupiah Terhadap Dollar',
                   xlab = 'Tahun',
                   ylab = 'Kurs')
    
  })
    
    # Third tab
    # -------------- Forecast Plot
    
  # Third tab
  # -------------- Forecast Plot
  
  output$trendPlot <- renderPlot({
    kurs <- read_xlsx("C:/Users/Lenovo/Documents/IPB/fix/Eksplorasi dan Visualisasi Data/kurs.xlsx")
    kurs <- kurs[c("Tanggal", "Terakhir")]
    kurs$Tanggal <- as.Date(kurs$Tanggal)
    
    require(gridExtra)
    t1 <- autoplot(ts(kurs[input$n[1]:input$n[2], "Terakhir"])) +
      ggtitle("Data Kurs Rupiah Terhadap Dollar")
    
    end = dim(kurs)[1]
    start = end - 100
    
    mod <- auto.arima(kurs[start : end, "Terakhir"])
    data <- forecast(mod, arm = input$arm)
    t2 <- autoplot(forecast(mod, arm = input$arm)) + 
      ggtitle("Meramalkan data 10 periode kedepan berdasarkan data 100 periode sebelumnya")
    
    grid.arrange(t1, t2, ncol=1)
  })
  
})
