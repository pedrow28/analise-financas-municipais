# Pacotes -----------------------------------------------------------------

library(rvest)
library(tidyverse)
library(magrittr)
library(scales)
library(knitr)
library(lubridate)
library(tibble)

# Pegando todas as urls pra loop ------------------------------------------

url_geral <-  "http://www.adpmnet.com.br/index.php?option=com_contpubl&submenu=1&cnpj=18296665000150&idreg=&tpformtab=jos_coputvcb3&tpformpdf=49&tpform=2&idorg=164&dsorg=Prefeitura%20Municipal%20de%20Morada%20Nova%20de%20Minas&dsufe=Estado%20de%20Minas%20Gerais&brasao=P314350.GIF&titulo=Receitas&idtpc=0&nome_mat=1&nao_proventos=0&nao_descontos=0"

# A URL acima contém todos os links com todos os meses de receita do município

links <- url_geral %>% read_html() %>% 
  html_nodes("td a") %>% 
  html_attr("href")

# Essa parte do código extraiu os links de referencia que levam a cada pagina de receita


for (i in 1:length(links)) {
  links[i] <- paste0("http://www.adpmnet.com.br", links[i])
}

#Como percerbi que os links de referência são complementos ao site padrão da empresa que os compila
# coloquei esse paste para gerar os links finais


##Removendo links quebrados out nov dez 2020

links <- c(links[1:9], links[13:length(links)])


# LOOP --------------------------------------------------------------------

lista_mes <- list()
lista_dfs <- list()

## Criando listas para armazenar nomes dos meses e data frames

i = 1

## Indexador para interação while

while(i < length(links)) {
  
  ##Pegando nome mes e ano
  
  mes_ano <- links[i] %>% read_html() %>% 
    html_nodes('.table-head') %>% 
    html_text() %>% 
    str_remove_all("\\n") %>% 
    str_remove_all(regex("^(\\s)*")) %>% 
    str_remove_all(regex("(\\s)*$"))  ## Esses tratamentos da string é para padronizar o nome dos mese
  
  lista_mes[i] <- mes_ano
  
  ##Nome das colunas
  nomes_colunas <- links[i] %>% read_html() %>% 
    html_nodes('th') %>% 
    html_text() # aqui retirei o nome das colunas, que estava em classe diferente no HTML
  
  nomes_colunas <- nomes_colunas[2:8] # Pela formatação da página, os nomes vieram desorganizados
  
  ##Dados data frame
  
  dados_df <- links[i] %>% read_html() %>% 
    html_nodes('td') %>% 
    html_text() %>% 
    matrix(nrow = 7, ncol = 453) %>% ## Como puxou tudo em texto simples, colocando nessa matriz os
    t() %>%                          ## Estruturou
    as.data.frame()
  
  ##Inserindo nome das colunas
  
  colnames(dados_df) <- nomes_colunas
  
  ##Colocando data
  
  dados_df <- dados_df %>% mutate(data = mes_ano)
  
  df_receita <- bind_rows(df_receita, dados_df)
  
  lista_dfs[i] <- dados_df
  
  ##Colocados os nomes e data.frames nas listas
  
  i = i + 1 ##Iteração seguinte
  
}


# Fundindo todos os data frames -------------------------------------------


## Necessário transformar os valores em números

##E também tem uns números negativos

df_receita %>% mutate(pos_neg = case_when(str_detect(Valor, "-") ~ "Negativo",
                                          TRUE ~ "Postivo")) %>% ##Indicando polaridade
  mutate(Valor = str_remove_all(Valor, "-")) %>%
  separate(Valor, into = c("Reais", "Centavos"), sep = ",", remove = FALSE) %>%
  mutate(Reais = parse_number(Reais),
         Centavos = parse_number(Centavos)) %>% View()
## Vou ter que puxar os centavos e juntar depois