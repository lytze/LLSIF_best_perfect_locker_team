require(shiny)
require(knitr)

shinyServer(function(input, output, session) {
    
    card_list <- read.csv('./LoveliveSIF_CNServer_pfLocker_card_list.csv',
                     as.is = T)
    source('./main_function.R')
    
    # Add new card info into the table
    observeEvent(input$addNew, {
        card_list <<- rbind(data.frame(
                                CardID = paste('C', input$addNew, sep = ''),
                                Img0 = './img/custom.jpg',
                                Img1 = './img/custom.jpg',
                                Name = input$newName,
                                Rareness = NA,
                                Jump = input$newInterval,
                                Type = ifelse(input$newType == '秒数', 'S', 'N'),
                                Rate = input$newRate,
                                Duration = input$newDur,
                                stringsAsFactors = F),
                       card_list)
    })
    
    # Show the card list table
    output$cardList <- renderText({
        output$warnNineCard <- renderText('')
        
        input$addNew
        
        card_list_o <- card_list
        Img <- paste('<img src = "', card_list_o$Img0, '">
             <img src = "', card_list$Img1, '">', sep = '')
        card_list_o$CardID <- paste(
            '<input type="checkbox" name="selectedCard" id="selectedCard',
            1:nrow(card_list_o),
            '" value="', card_list_o$CardID, '" ',
            ifelse(1:nrow(card_list) < 15, 'checked="checked"', '')
            ,'/>',
            card_list_o$CardID,
            sep = ''
        )
        show_table <- cbind(卡片ID = card_list_o$CardID, 图像 = Img,
                            角色 = card_list_o$Name,
                            判定间隔 = paste(card_list_o$Jump,
                                ifelse(card_list_o$Type == 'S', '秒', 'Notes')),
                            成功概率 = paste(card_list_o$Rate, '%', sep = ''),
                            持续时间 = paste(card_list_o$Duration, '秒'))
        innerHTMLTable <- kable(show_table, format = 'html', escape = F,
                                align = 'c', table.attr = 'class="shtable"')
        paste(
            '<div id="selectedCard" class="form-group shiny-input-checkboxgrou\
            p shiny-input-container" style="width: 100%">',
            '<div class="shiny-options-group">',
            innerHTMLTable,
            '</div></div>', sep = ''
        )
    })
    
    observeEvent(input$submit, {
        # These pars waite for user input
        song_len <- 4 * 60 * 2
        note_num <- 350
        # extract selected data
        selected <- input$selectedCard
        if (length(selected) > 9) {
            withProgress(message = '...少女祈祷中...', value = 0, {
                outcome <- run_gibbs_sampler(selected, card_list, song_len, note_num)
                outcome_list <- card_list[card_list$CardID %in% outcome$team, ]
                output$outcomeTable <- renderText(outcome$team)
                incProgress(1)
            })
            output$outputResult <- renderUI({
                fluidRow(
                    column(width = 12, 
                          h4('您的最佳判定卡组为:'),
                          htmlOutput('outcomeTable'),
                          uiOutput('showProbabilityChart'),
                          uiOutput('showGibbsSamplerRecord')
                    )
                )
            })
        }
        else output$warnNineCard <- renderText(
            '<span style="color:#900">请选择 9 张以上卡片</span>')
        
    })
    
})