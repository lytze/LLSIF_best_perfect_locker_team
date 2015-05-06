require(shiny)

shinyUI(fluidPage(
    
    title = 'Best Perfect Locker Team Organizer',
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "table.css"),
        tags$link(rel = "stylesheet", type = "text/css", href = "resTable.css"),
        tags$script(type = "text/javascript", src = "ga.js")
    ),
    
    uiOutput('outputResult'),
    
    fluidRow(
        
        column(width = 7,
            
               htmlOutput('tryO'),
        
            h4('选择您拥有的判定卡'),
            
            helpText('下列卡片按照卡片 ID 排列, 为方便选择, 您可以在游戏中 \
                    "其他 -> 相簿" 中查看到按 ID 排列的卡片列表'),
            
            # show a table of candidate card list
            htmlOutput('cardList')
            
        ),
        
        column(width = 5,
        
            # add new data
            h4('添加新卡面'),
            helpText('这里您可以添加列表中没有的卡片'),
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
            
            h4('修改运行参数'),
            numericInput(inputId = 'songLen',
                         label = '歌曲长度 (分):',
                         value = 2,
                         min = 3, max = 5, step = 0.01),
            numericInput(inputId = 'noteNum',
                         label = 'Note 数量:',
                         value = 390,
                         min = 10, max = 600, step = 1),
            actionButton(inputId = 'submit', label = '确认',
                         icon('ok', lib = 'glyphicon')),
            htmlOutput('warnNineCard'),
            
            hr(),
            
            h5('Visit me at:'),
            tags$p('github: ', 
                   tags$a('click here', href = 'https://github.com/lytze')),
            tags$p('my Home Page: ',
                   tags$a('click here', href = 'http://www.lytzeworkshop.com')),
            tags$p('Webo: ',
                   tags$a('click here', href = 'http://www.weibo.com/2265661804'))
        
        )
        
    ),
    
    tags$script(type = "text/javascript", src = "table.js")
    
))