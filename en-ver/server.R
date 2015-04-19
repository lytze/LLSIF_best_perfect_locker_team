require(shiny)
require(knitr)

shinyServer(function(input, output, session) {
    
    card_list <- read.csv('./LoveliveSIF_CNServer_pfLocker_card_list.csv',
                     as.is = T)
    source('./main_function.R')
    selected <- character(0)
#     selected <- card_list$CardID[1:20]
    
    # Add new card info into the table
    observeEvent(input$addNew, {
        selected <<- c(input$selectedCard, paste('C', input$addNew, sep = ''))
        card_list <<- rbind(data.frame(
                                CardID = paste('C', input$addNew, sep = ''),
                                Img0 = './img/custom.jpg',
                                Img1 = './img/custom.jpg',
                                Name = input$newName,
                                Rareness = NA,
                                Jump = input$newInterval,
                                Type = ifelse(input$newType == 'Second', 'S', 'N'),
                                Rate = input$newRate,
                                Duration = input$newDur,
                                stringsAsFactors = F),
                       card_list)
    })
    
    # Show the card list table
    output$cardList <- renderText({
        output$warnNineCard <- renderText('')
        
        input$addNew
        
        withProgress(message = '...Loading List Nya...', {
            card_list_o <- card_list
            Img <- paste('<img src="', card_list_o$Img0, '" height="50px" width="50px">
             <img src="', card_list_o$Img1, '" height="50px" width="50px">', sep = '')
            card_list_o$CardID <- paste(
                '<input type="checkbox" name="selectedCard" id="selectedCard',
                1:nrow(card_list_o),
                '" value="', card_list_o$CardID, '" ',
                ifelse(card_list_o$CardID %in% selected, 'checked="checked"', '')
                ,'/>',
                card_list_o$CardID,
                sep = ''
            )
            show_table <- cbind(Card_ID = card_list_o$CardID, Image = Img,
                                Character = card_list_o$Name,
                                Yell_Interval = paste(card_list_o$Jump,
                                             ifelse(card_list_o$Type == 'S', 'sec', 'notes')),
                                Success_Rate = paste(card_list_o$Rate, '%', sep = ''),
                                Effect_Duration = paste(card_list_o$Duration, 'sec'))
            innerHTMLTable <- kable(show_table, align = 'c', format = 'html', escape = F,
                                    table.attr = 'class="shtable"')
            innerHTMLTable <- gsub('<tr>\\n(\\s)+<td',
                                   '<tr onclick="cardListRowClick(this)"><td',
                                   innerHTMLTable)
        })
        
        paste(
            '<div id="selectedCard" class="form-group shiny-input-checkboxgroup',
            'shiny-input-container" style="width: 100%">',
            '<div class="shiny-options-group">',
            innerHTMLTable,
            '</div></div>',
            '<script type="text/javascript" src="table_fresh.js">', sep = ''
        )
    })
    
    observeEvent(input$submit, {
        # These pars waite for user input
        song_len <- input$songLen * 60 * 2
        note_num <- input$noteNum
        # extract selected data
        selected <- input$selectedCard
        if (length(selected) > 9) {
            withProgress(message = '...NicoNicoNiiii...', value = 0, {
                outcome <- run_gibbs_sampler(selected, card_list, song_len, note_num)
                outcome_list <- card_list[card_list$CardID %in% outcome$team, ]
                incProgress(0.05)
                # Prepare short form output
                Img0 <- paste('<img src="', outcome_list$Img0,
                              '" height="50px" width="50px">', sep = '')
                Img1 <- paste('<img src="', outcome_list$Img1,
                              '" height="50px" width="50px">', sep = '')
                short_form <- as.data.frame(rbind(Img0, Img1))
                names(short_form) <- outcome_list$Name
                row.names(short_form) <- NULL
                short_form <- paste('<center>',
                                    kable(short_form, 'html', align = 'c', escape = F,
                                    table.attr = 'class="resTable"'),
                                    '</center>', sep = '')
                output$outcomeTable <- renderText(short_form)
#                 output$showProbabilityChart <- renderPlot({
#                     x <- 1:song_len / 2
#                     y <- outcome$effect
#                     xyplot(y ~ x, type = 's', panel = function(x, y, ...) {
#                         x <- x + 0.5
#                         y <- rep(y, each = 2)
#                         y <- c(0, y[-length(y)], 0)
#                         x <- rep(x, each = 2)[-1]
#                         x <- c(min(x), x, max(x))
#                         panel.polygon(x, y, col = '#a8cce5', border = NA)
#                     }, ylim = c(0, 1),
#                     xlab = 'Second', ylab = '% Have Effect')
#                 })
#                 output$showGibbsSamplerRecord <- renderPlot({
#                     y <- outcome$record
#                     x <- 1:length(y)
#                     xyplot(y ~ x, panel = function(x, y, ...) {
#                         panel.xyplot(x, y, type = 'l', col = '#a8cce5')
#                         x <- x[y == outcome$max]
#                         y <- y[y == outcome$max]
#                         panel.xyplot(x, y, col = '#ee7621')
#                     }, xlim = c(0, 100),
#                     xlab = 'Iterations', ylab = 'Effect')
#                 })
                incProgress(0.05)
            })
            
            output$outputResult <- renderUI({
                fluidRow(
                    column(width = 12, 
                          h4('Your Best Perfect Locker Team is'),
                          htmlOutput('outcomeTable'),
#                           plotOutput('showProbabilityChart'),
#                           plotOutput('showGibbsSamplerRecord'),
                          hr()
                    )
                )
            })
        }
        else output$warnNineCard <- renderText(
            '<span style="color:#900">Please Select MORE than 9 Cards</span>')
        
    })
    
})