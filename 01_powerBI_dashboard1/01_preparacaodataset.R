
# apagar variaveis
rm(list = ls())

# local
path <- "C:/Users/oscar/Desktop/R_Python_SQL_PBI/power_bi/cap02"
setwd(path)

# pacotes
library(tidyverse)
library(magrittr)

#-------------------------- importar dados --------------------------------#

# dados teste
testData <- readr::read_csv2(file = "dataset.csv",
                             locale = locale(decimal_mark = ","))

# verificar tipo do campo "Quantidade"
testData %>% 
  dplyr::select(Quantidade) %>% 
  dplyr::filter(Quantidade == as.integer(Quantidade)) %>% 
  nrow()

# tipo dos campos
spec(testData)

mycols <- readr::cols_only(ID_Pedido = col_character(),
                           Data_Pedido = col_character(),
                           ID_Cliente = col_character(),
                           Segmento = col_character(),
                           Regiao = col_character(),
                           Pais = col_character(),
                           `Product ID` = col_character(),
                           Categoria = col_character(),
                           SubCategoria = col_character(),
                           Total_Vendas = col_double(),
                           Quantidade = col_integer(),
                           Desconto = col_double(),
                           Lucro = col_double(),
                           Prioridade = col_character())


# importacao 
dat <- readr::read_csv2(file = "dataset.csv",
                        col_types = mycols,
                        locale = locale(decimal_mark = ","))

#---------------------------------- preparacao -----------------------------#

# mudar tipo de Quantidade e nome de uma variavel
dat %<>% 
  dplyr::mutate(Data_Pedido = lubridate::dmy(Data_Pedido)) %>% 
  dplyr::rename(Product_ID = `Product ID`)

# qualidade
summary(dat)

# exportar dados
readr::write_csv(dat, file = "02_dataset.csv")
readr::write_csv2(dat, file = "02_dataset.csv")

