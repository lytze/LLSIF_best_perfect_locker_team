setwd('~/CodeRMain/shinyApps/best_pflocker_team/')
tb <- read.table('LoveliveSIF_CNServer_pfLocker_card_list_raw.tsv',
                 sep = '\t', header = T, quote = '"')
tb$头像 <- NULL

No <- tb$No
Name <- tb$名字
Appeal <- tb$技能
Img0 <- paste('./img/', ifelse(No < 100, '0', ''), No, '.jpg', sep = '')
Img1 <- paste('./img/', ifelse(No < 100, '0', ''), No, '_ido.jpg', sep = '')

require(stringr)

Name <- gsub('\\(.*\\)', '', Name)
Rareness <- str_extract(Name, '..$')
Name <- str_replace(Name, '..$', '')
Jump <- str_extract(Appeal, '[0-9]+')
Appeal <- str_replace(Appeal, '[0-9]+', '')
Type <- ifelse(grepl('Note', Appeal), 'N', 'S')
Rate <- str_extract(Appeal, '[0-9]+')
Appeal <- str_replace(Appeal, '[0-9]+', '')
Appeal <- str_extract(Appeal, '[0-9].*秒$')
Duration <- gsub('秒', '', Appeal)

data <- data.frame(
    CardID = No, Img0 = Img0, Img1 = Img1, Name = Name, Rareness = Rareness,
    Jump = Jump, Type = Type, Rate = Rate, Duration = Duration)

data <- data[order(data$CardID), ]

write.csv(data, 'LoveliveSIF_CNServer_pfLocker_card_list.csv', row.names = F)

require(knitr)
Img <- paste('<img src = "', data$Img0, '">
             <img src = "', data$Img1, '">', sep = '')
data_o <- cbind(No = data$CardID, 图像 = Img, 角色 = as.character(data$Name),
                稀有度 = data$Rareness, 
                判定间隔 = paste(data$Jump,
                    ifelse(data$Type == 'S', '秒', 'Notes')),
                成功概率 = paste(data$Rate, '%', sep = ''),
                持续时间 = paste(data$Duration, '秒'))
htmlLines <- kable(data_o, format = 'html',
                   align = 'c', table.attr = 'class="gridtable"',
                   escape = F)
writeLines(c(
    '<html>
    <style type="text/css">
    table.gridtable {
    font-family: verdana,arial,sans-serif;
    font-size:11px;
    color:#333333;
    border-width: 1px;
    border-color: #666666;
    border-collapse: collapse;
    width: 68%
    }
    table.gridtable th {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    background-color: #dedede;
    height: 70
    }
    table.gridtable td {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    }
    table.gridtable tr {
    background-color: #ffffff;
    }
    table.gridtable tr:hover {
    background-color: #ffff66;
    }
    </style>
    <body>
    <center><h2>Love Live! SIF 国服判定卡列表</h2></center><hr>
    <center>',
    htmlLines,
    '</center><hr>
    <p>数据来源于<a href="http://lovelivecnwiki.sinaapp.com/index.php/%E9%A6%96%E9%A1%B5">Lovelive!Wiki国服</a></p>
    <script>
        function mOver(obj) {
            obj.style.backgroundColor="#ffff66"
        }
        function mOut(obj) {
            obj.style.backgroundColor="#ffff66"
        }
    </script>
    </body>
    </html>'), 'table.html')
