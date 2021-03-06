output$contents6 <- renderPlot({
  
  req(input$file1)
  
  dt <- read.csv(input$file1$datapath,
                 header = input$header,
                 sep = input$sep)
  
  JetNo <- dt[,1]
  FullName <- dt[,2]
  Date <- dt[,5]
  Calendar <- dt[,7]
  
  Date <- as.Date(dt[,5], "%Y/%m/%d")
  strDate <- as.character(Date)
  
  for (i in 1:length(strDate)) {
    strDate[i] <- str_replace_all(strDate[i], "-", "/")
  }
  
  jikan <- as.POSIXlt(dt[,18], format="%H:%M")
  hours <- jikan$hour + jikan$min / 60
  hours[is.na(hours)] <- 0.00
  
  for (i in 1:length(hours)) {
    hours[i] <- round(hours[i], digits = 3)
  }
  
  
  night <- as.POSIXlt(dt[,21], format="%H:%M")
  nighthours <- night$hour + night$min / 60
  nighthours[is.na(nighthours)] <- 0.00
  
  for (i in 1:length(nighthours)) {
    nighthours[i] <- round(nighthours[i], digits = 3)
  }
  
  
  OverTime <- hours
  NightWork <- nighthours
  i <- 1
  j <- 1
  k <- 1
  MonthLabel <- NA
  MonthOverTime <- NA
  
  while(length(OverTime) >= i) {
    # print(strDate[i])   
    # [1] "2017/08/16"
    # [1] "2017/09/17"
    # [1] "2017/10/17"
    # [1] "2017/11/17"
    # [1] "2017/12/17"
    # [1] "2018/01/17"

    # if(str_detect(strDate[i], pattern = "01$")){
      m <- regexpr("/[0123456789]+/", strDate[i])
      
      back_ref <- substr(strDate[i], m+1, m + attr(m, "match.length")-2)
      back_ref_num <- as.integer(back_ref)
      
      if(back_ref_num != 12){
        back_ref_num <- back_ref_num+1
        if(str_detect(back_ref_num, "[1-9]$")){
          back_ref_num=paste("0",back_ref_num, sep = "")
        }
        year <- substr(strDate[i], 1, 5)
        
        str_month <- paste(year, back_ref_num, sep="")
        MonthLabel[k] <- str_month
        # dmonth <- as.Date(str_month, format = "%Y/%m")
        # MonthLabel[k] <- dmonth
      }else{
        back_ref_num <- 1
        year <- paste(as.integer(substr(strDate[i], 1, 4))+1, "/")
        if(str_detect(back_ref_num, "[1-9]$")){
          back_ref_num=paste("0",back_ref_num, sep = "")
        }
        str_month <- paste(year,back_ref_num, sep="")
        MonthLabel[k] <- str_month
        # dmonth <- as.Date(str_month, format = "%Y/%m")
        # MonthLabel[k] <- dmonth
      }
      
    # }
    
    if(str_detect(strDate[i], "16$")) {
      tmp <- OverTime[i]
      i <- i + 1
    } else {
      tmp <- 0.00
    }
    
    while(!str_detect(strDate[i], "16$") & length(OverTime) >= i) {
      tmp <- OverTime[i] + tmp
      i <- i + 1
    }

    i <- i + 1
    MonthOverTime[k] <-tmp
    k <- k + 1
    
    
    
  }
  
  print(MonthOverTime)
  
  newdt <- data.frame(
    JetNo,
    FullName,
    strDate,
    Calendar,
    OverTime,
    NightWork
  )
  
  # print(newdt)
  
  x <- MonthLabel
  y <- MonthOverTime
  
  print(x)
  print(y)

  plot(x, y, cex=0.5, pch=4, xlab="date(x)", ylab="hours(y)", col="blue")
  

})