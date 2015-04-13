require(shiny)
require(knitr)

shinyServer(function(input, output) {
    
    data <- read.csv('./LoveliveSIF_CNServer_pfLocker_card_list.csv',
                     as.is = T)
    
    # Add new card info into the table
    observeEvent(input$addNew, {
        data <<- rbind(c(paste('C', input$addNew, sep = ''),
                         './img/custom.jpg', './img/custom.jpg',
                         input$newName, NA, input$newInterval,
                         ifelse(input$newType == '秒数', 'S', 'N'),
                         input$newRate, input$newDur),
                       data)
    })
    
    # Show the card list table
    output$cardList <- renderText({
        input$addNew
        
        data_o <- data
        Img <- paste('<img src = "', data_o$Img0, '">
             <img src = "', data$Img1, '">', sep = '')
        data_o$CardID <- paste(
            '<input type="checkbox" name="selectedCard" id="selectedCard',
            1:nrow(data_o),
            '" value="', data_o$CardID, '"/>',
            data_o$CardID,
            sep = ''
        )
        show_table <- cbind(卡片ID = data_o$CardID, 图像 = Img,
                            角色 = data_o$Name,
                            判定间隔 = paste(data_o$Jump,
                                ifelse(data_o$Type == 'S', '秒', 'Notes')),
                            成功概率 = paste(data_o$Rate, '%', sep = ''),
                            持续时间 = paste(data_o$Duration, '秒'))
        innerHTMLTable <- kable(show_table, format = 'html', escape = F,
                                align = 'c', table.attr = 'class="shtable"')
        paste(
            '<div id="selectedCard" class="form-group shiny-input-checkboxgrou\
            p shiny-input-container" style="width: 100%">',
            innerHTMLTable,
            '</div>', sep = ''
        )
    })
    
    output$outputResult <- renderUI({
        
    })
    
})