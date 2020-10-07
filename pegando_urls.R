
# Pacotes -----------------------------------------------------------------

library(rvest)
library(tidyverse)
library(magrittr)
library(scales)
library(knitr)
library(lubridate)
library(tibble)



# Pegando URL -------------------------------------------------------------

url <- "http://www.adpmnet.com.br/index.php?option=com_contpubl&submenu=1&brasao=P314350.GIF&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&cnpj=18296665000150&tpformpdf=49&ano=2017&mes=12&idorg=164&titulo=Receitas&dsufe=Estado%20de%20Minas%20Gerais&nome_mat=1&nao_proventos=0&nao_descontos=0&xts=0"

##Pegando nome mes e ano

mes_ano <- url %>% read_html() %>% 
  html_nodes('.table-head') %>% 
  html_text() %>% 
  str_remove_all("\\n") %>% 
  str_remove_all(regex("^(\\s)*")) %>% 
  str_remove_all(regex("(\\s)*$"))

##Nome das colunas
nomes_colunas <- url %>% read_html() %>% 
  html_nodes('th') %>% 
  html_text()

nomes_colunas <- nomes_colunas[2:8]

##Dados data frame

dados_df <- url %>% read_html() %>% 
  html_nodes('td') %>% 
  html_text() %>% 
  matrix(nrow = 7, ncol = 453) %>% 
  t() %>% 
  as.data.frame()

##Inserindo nome das colunas

colnames(dados_df) <- nomes_colunas

##Colocando data

dados_df <- dados_df %>% mutate(data = mes_ano)



# Pegando todas as urls pra loop ------------------------------------------

url_geral <-  "http://www.adpmnet.com.br/index.php?option=com_contpubl&submenu=1&cnpj=18296665000150&idreg=&tpformtab=jos_coputvcb3&tpformpdf=49&tpform=2&idorg=164&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Receitas&idtpc=0&nome_mat=1&nao_proventos=0&nao_descontos=0"


links <- url_geral %>% read_html() %>% 
  html_nodes("td a") %>% 
  html_attr("href")


for (i in 1:length(links)) {
  links[i] <- paste0("http://www.adpmnet.com.br", links[i])
}



df_receita <- dados_df
