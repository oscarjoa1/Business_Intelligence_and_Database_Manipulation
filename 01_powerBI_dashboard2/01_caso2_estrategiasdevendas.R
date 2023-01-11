# limpar variaveis
rm(list = ls())

# local
path <- "C:/Users/oscar/Desktop/R_Python_SQL_PBI/power_bi/cap03"
setwd(path)

# pacotes
library(tidyverse)
library(magrittr)
library(DBI)
library(odbc)

#----------------------------- dados iniciais ---------------------------------#
# dados
dat <- readxl::read_excel(path = "Vendas.xlsx",
                          sheet = "Vendas",
                          range = "A1:L458")

dat %<>%
  dplyr::rename(ID_Produto = `ID-Produto`) %>% 
  dplyr::rename(ID_vendedor = `ID-Vendedor`) %>% 
  dplyr::rename(Data_venda = `Data Venda`) %>% 
  dplyr::rename(ID_loja = Loja) %>% 
  dplyr::mutate(Data_venda = lubridate::as_date(Data_venda), 
                ID_vendedor = as.integer(ID_vendedor)) 
# conversao a .csv
readr::write_csv(dat, file = "Vendas02.csv")

#----------------------- Tabelas de dimensoes e fatos  ------------------------#

DIM_produtos <- dat %>% 
  dplyr::select(1:5) %>%
  dplyr::rename(Name_produto = Produto) %>% 
  dplyr::distinct()

DIM_lojas <- dat %>% 
  dplyr::select(6:8) %>% 
  dplyr::distinct()

DIM_funcionarios <- dat %>% 
  dplyr::select(9:10) %>% 
  dplyr::rename(Name_vendedor = Vendedor) %>% 
  dplyr::relocate(ID_vendedor, .before = "Name_vendedor") %>% 
  dplyr::distinct()

DIM_datas <- dat %>% 
  dplyr::select(11:12) %>% 
  dplyr::select(-ValorVenda) %>% 
  dplyr::distinct()

tb_vendas <- dat %>% 
  dplyr::select(c(1, 6, 10, 11, 12))

# decarregar arquivos em .csv
readr::write_csv(DIM_produtos, "DIM_produtos.csv")
readr::write_csv(DIM_lojas, "DIM_lojas.csv")
readr::write_csv(DIM_funcionarios, "DIM_funcionarios.csv")
readr::write_csv(DIM_datas, "DIM_datas.csv")
readr::write_csv(tb_vendas, "tb_vendas.csv")

#------------------------------ banco de dados relacionais --------------------#

# verificar se 'odbc' reconhece os driver´s instalados
sort(unique(odbc::odbcListDrivers()[[1]]))

# conectar com o bd
con <- DBI::dbConnect(odbc::odbc(), "caso02_powerbi")

# criar tabelas 

exec1 <- "CREATE TABLE dbo.DIM_produtos(
          ID_Produto   VARCHAR(50)  PRIMARY KEY NOT NULL,
          Name_produto VARCHAR(100) NOT NULL,
          Categoria    VARCHAR(50)  NOT NULL,
          Segmento     VARCHAR(50)  NOT NULL,
          Fabricante   VARCHAR(50)  NOT NULL);"

DBI::dbExecute(con, exec1)
DBI::dbGetQuery(con, "SELECT DP.* FROM DIM_produtos AS DP;")


exec2 <- "CREATE TABLE dbo.DIM_lojas(
          ID_loja VARCHAR(50)  PRIMARY KEY NOT NULL,
          Cidade  VARCHAR(50) NOT NULL,
          Estado VARCHAR(50) NOT NULL);"

DBI::dbExecute(con, exec2)
DBI::dbGetQuery(con, "SELECT DL.* FROM dbo.DIM_lojas AS DL;")

exec3 <- "CREATE TABLE dbo.DIM_funcionarios(
          ID_vendedor   INT PRIMARY KEY NOT NULL,
          Name_vendedor VARCHAR(50) NOT NULL);"

DBI::dbExecute(con, exec3)
DBI::dbGetQuery(con, "SELECT DF.* FROM dbo.DIM_funcionarios AS DF;")

exec4 <-"CREATE TABLE dbo.DIM_datas(
         Data_venda DATE PRIMARY KEY NOT NULL);"

DBI::dbExecute(con, exec4)
DBI::dbGetQuery(con, "SELECT DD.* FROM dbo.DIM_datas AS DD;")

exec5 <- "CREATE TABLE dbo.tb_vendas(
          ID_Produto  VARCHAR(50) NOT NULL,
          ID_loja     VARCHAR(50) NOT NULL,
          ID_vendedor INT         NOT NULL,
          Data_venda  DATE        NOT NULL);"
DBI::dbExecute(con, exec5)

exec5 <- "ALTER TABLE dbo.tb_vendas
          ADD ValorVenda numeric(15, 3);"
DBI::dbExecute(con, exec5)

DBI::dbGetQuery(con, "SELECT DV.* FROM dbo.tb_vendas AS DV;")

# criar CONSTRAINT

DBI::dbListTables(con)

exec6 <- "ALTER TABLE dbo.tb_vendas
          ADD CONSTRAINT fk_prodvendas FOREIGN KEY (ID_Produto) REFERENCES dbo.DIM_produtos (ID_Produto);
          
          ALTER TABLE dbo.tb_vendas
          ADD CONSTRAINT fk_lojavendas FOREIGN KEY (ID_loja) REFERENCES dbo.DIM_lojas (ID_loja);
          
          ALTER TABLE dbo.tb_vendas 
          ADD CONSTRAINT fk_venvendas FOREIGN KEY (ID_vendedor) REFERENCES dbo.DIM_funcionarios (ID_vendedor);
          
          ALTER TABLE dbo.tb_vendas 
          ADD CONSTRAINT fk_datavendas FOREIGN KEY (Data_venda) REFERENCES dbo.DIM_datas (Data_venda);
          "
DBI::dbExecute(con, exec6)


# insertar dados nas tabelas
DBI::dbListTables(con)[1:10]

DBI::dbWriteTable(con, "DIM_produtos",    DIM_produtos,   append = TRUE)
DBI::dbWriteTable(con, "DIM_lojas",        DIM_lojas,        append = TRUE)
DBI::dbWriteTable(con, "DIM_funcionarios", DIM_funcionarios, append = TRUE)
DBI::dbWriteTable(con, "DIM_datas",        DIM_datas,        append = TRUE)
DBI::dbWriteTable(con, "tb_vendas",        tb_vendas,        append = TRUE)


DBI::dbGetQuery(con, "SELECT * FROM dbo.DIM_produtos") %>% dplyr::as_tibble()
DBI::dbGetQuery(con, "SELECT * FROM DIM_lojas") %>% dplyr::as_tibble() 
DBI::dbGetQuery(con, "SELECT * FROM DIM_funcionarios") %>% dplyr::as_tibble()
DBI::dbGetQuery(con, "SELECT * FROM DIM_datas") %>% dplyr::as_tibble()
DBI::dbGetQuery(con, "SELECT * FROM tb_vendas") %>% dplyr::as_tibble()

# Desconetar db
DBI::dbDisconnect(con)

