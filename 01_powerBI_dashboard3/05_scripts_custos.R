
# apagar variaveis
rm(list = ls())

# local
path <- "C:/Users/oscar/Desktop/R_Python_SQL_PBI/power_bi/cap04"
setwd(path)

# pacotes
library(tidyverse)
library(magrittr)
library(lubridate)

#------------------------------- preparacao ---------------------------------#

# dados

mycols <- readr::cols_only(Data = col_date("%d/%m/%Y"),
                           Produto = col_character(),
                           `Serial number` = col_character(),
                           `Valor de Venda` = col_double(),
                           `Preço Custo` = col_double(),
                           `Duração Venda Telefone (mins)` = col_integer(),
                           `Tempo Preparação (mins)` = col_integer())

custo <- readr::read_csv(file = "Custos.csv",
                         locale = locale(encoding = "Latin1"),
                         col_types = mycols) %>% 
  setNames(c("data", "produto", "numberSerial", "venda",
             "custo", "duracaoVenda","tempo"))

# salvar dados
readr::write_csv(custo, "custo1.csv")

#------------------------------- importar dados ---------------------------#
















