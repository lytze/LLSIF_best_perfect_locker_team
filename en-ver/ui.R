require(shiny)

shinyUI(fluidPage(
    
    title = 'Best Perfect Locker Team Organizer',
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "table.css"),
        tags$link(rel = "stylesheet", type = "text/css", href = "resTable.css")
    ),
    
    uiOutput('outputResult'),
    
    fluidRow(
        
        column(width = 7,
            
               htmlOutput('tryO'),
        
            h4('Select Perfect Locker Cards in Your Box'),
            
            helpText('The list is sorted according to the card ID, you can \
                    go into "Album" in the game for conveniance which in also \
                    sorted by card ID'),
            
            # show a table of candidate card list
            htmlOutput('cardList')
            
        ),
        
        column(width = 5,
        
            # add new data
            h4('Add New Card'),
            helpText('You can add cards absent from the list'),
            textInput(inputId = 'newName',
                      label = 'Card Name:',
                      value = 'new card'),
            numericInput(inputId = 'newInterval',
                         label = 'Yell Interval:',
                         value = 1,
                         min = 0.5, max = 30, step = 0.5),
            selectInput(inputId = 'newType',
                        label = 'Interval Type:',
                        choices = c('Second', 'Note Number')),
            numericInput(inputId = 'newRate',
                         label = 'Success Rate (%):',
                         value = 36,
                         min = 0, max = 100, step = 1),
            numericInput(inputId = 'newDur',
                         label = 'Effect Duration (sec):',
                         value = 3,
                         min = 0, max = 20, step = 0.5),
            actionButton(inputId = 'addNew', label = 'ADD',
                         icon('plus', lib = 'glyphicon')),
            
            hr(),
            
            h4('Fix Program Parameters'),
            numericInput(inputId = 'songLen',
                         label = 'Song Length (min):',
                         value = 4,
                         min = 3, max = 5, step = 0.01),
            numericInput(inputId = 'noteNum',
                         label = 'Note Number:',
                         value = 390,
                         min = 10, max = 600, step = 1),
            actionButton(inputId = 'submit', label = 'RUN For Me',
                         icon('ok', lib = 'glyphicon')),
            htmlOutput('warnNineCard'),
            
            hr(),
            
            h5('Visit me at:'),
            tags$p('github: ', 
                   tags$a('click here', href = 'https://github.com/')),
            tags$p('my Home Page: ',
                   tags$a('click here', href = 'https://www.lytzeworkshop.com')),
            tags$p('Webo: ',
                   tags$a('click here', href = 'http://www.weibo.com/2265661804/'))
        
        )
        
    ),
    
    tags$script(type = "text/javascript", src = "table.js")
    
))