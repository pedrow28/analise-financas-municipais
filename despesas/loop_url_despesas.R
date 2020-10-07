# Pacotes -----------------------------------------------------------------

library(rvest)
library(tidyverse)
library(magrittr)
library(scales)
library(knitr)
library(lubridate)
library(tibble)


# Gerando URLs ------------------------------------------------------------

url_padrao_pagos <- "http://www.adpmnet.com.br/index.php?option=com_contpubl&xts=0&idorg=164&ano=2017&mes=10&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Despesas&tpformpdf=57&contraste=true"



datas <- seq(as.Date("2017/01/01"), as.Date("2020/08/30"), by = "month")


df <- data.frame(url = url_padrao_pagos, data = datas) %>% 
  mutate(mes = month(data),
         ano = year(data)) %>% 
  mutate(colar1 = "http://www.adpmnet.com.br/index.php?option=com_contpubl&xts=0&idorg=164&ano=",
         colar2 = "&mes=",
         colar3 = "&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&
           dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Despesas&tpformpdf=57
         &contraste=true") %>% 
  mutate(url_final = paste0(colar1, ano, colar2, mes, colar3)) %>% 



urls <- df %>% pull(url_final)


