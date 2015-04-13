require(shiny)

shinyUI(fluidPage(
    
    title = 'Best Perfect Locker Team Organizer',
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "table.css")
    ),
    
    uiOutput('outputResult'),
    
    fluidRow(
        
        column(width = 7,
        
            h4('选择您拥有的判定卡'),
            
            helpText('下列卡片按照卡片 ID 排列, 您可以在游戏中 "其他 -> 相簿" \
                     中查看到按 ID 排列的卡片列表'),
            
            # show a table of candidate card list
            htmlOutput('cardList')
            
        ),
        
        column(width = 5,
        
            # add new data
            h4('添加新卡面'),
            textInput(inputId = 'newName',
                      label = '卡面名字:',
                      value = '新卡面'),
            numericInput(inputId = 'newInterval',
                         label = '判定间隔:',
                         value = 1,
                         min = 0.5, max = 30, step = 0.5),
            selectInput(inputId = 'newType',
                        label = '间隔类型:',
                        choices = c('秒数', 'Note 数')),
            numericInput(inputId = 'newRate',
                         label = '成功几率 (%):',
                         value = 36,
                         min = 0, max = 100, step = 1),
            numericInput(inputId = 'newDur',
                         label = '持续时间 (秒):',
                         value = 3,
                         min = 0, max = 20, step = 0.5),
            actionButton(inputId = 'addNew', label = '加入',
                         icon('plus', lib = 'glyphicon')),
            
            hr(),
            
            actionButton(inputId = 'submit', label = '确认',
                         icon('ok', lib = 'glyphicon'))
        
        )
        # click submit to submit the selection
        
    )
    
))