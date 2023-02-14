
# apagar objetos
rm(list = ls())

# packages
library(tidyverse)

# local
setwd("C:/Users/oscar/Desktop/R_Python_SQL_PBI/power_bi/cap04/projeto_Marketing")

#--------------------------------- Preparacao ----------------------------------#
# importar dados test
test <- readr::read_csv2(file = "dados_marketing.csv")
test %>% 
  dplyr::filter(!is.na(`Salario Anual`)) %>% 
  nrow()

# tipologia das colunas
mycols <- cols(
  ID = col_integer(),
  `Ano Nascimento` = col_double(),
  Escolaridade = col_character(),
  `Estado Civil` = col_character(),
  `Salario Anual` = col_integer(),
  `Filhos em Casa` = col_integer(),
  `Adolescentes em Casa` = col_integer(),
  `Data Cadastro` = col_character(),
  `Dias Desde Ultima Compra` = col_integer(),
  `Gasto com Eletronicos` = col_integer(),
  `Gasto com Brinquedos` = col_integer(),
  `Gasto com Moveis` = col_integer(),
  `Gasto com Utilidades` = col_integer(),
  `Gasto com Alimentos` = col_integer(),
  `Gasto com Vestuario` = col_integer(),
  `Numero de Compras com Desconto` = col_integer(),
  `Numero de Compras na Web` = col_integer(),
  `Numero de Compras via Catalogo` = col_integer(),
  `Numero de Compras na Loja` = col_integer(),
  `Numero Visitas WebSite Mes` = col_integer(),
  `Compra na Campanha 1` = col_integer(),
  `Compra na Campanha 2` = col_integer(),
  `Compra na Campanha 3` = col_integer(),
  `Compra na Campanha 4` = col_integer(),
  `Compra na Campanha 5` = col_integer(),
  Comprou = col_integer(),
  Pais = col_character()
)


test %>% 
  filter(is.na(`Salario Anual`))

# importacao de dados
market <- readr::read_csv2(file = "dados_marketing.csv", 
                           col_types = mycols,
                           show_col_types = FALSE, 
                           locale = locale(decimal_mark = ","))  %>% stats::setNames(str_replace_all(names(test), " ", "_")) %>% 
  dplyr::mutate(Data_Cadastro = lubridate::dmy(Data_Cadastro))
rm(test)

# exportar dados
 readr::write_csv(market, "DadosMarketing.csv", na = "")

# data quality 
summary(market)

#------------------------------ analise descritiva ---------------------------#

# dados
mycols <- cols(
  ID = col_integer(),
  Ano_Nascimento = col_integer(),
  Escolaridade = col_character(),
  Estado_Civil = col_character(),
  Salario_Anual = col_integer(),
  Filhos_em_Casa = col_integer(),
  Adolescentes_em_Casa = col_integer(),
  Data_Cadastro = col_date(format = ""),
  Dias_Desde_Ultima_Compra = col_integer(),
  Gasto_com_Eletronicos = col_integer(),
  Gasto_com_Brinquedos = col_integer(),
  Gasto_com_Moveis = col_integer(),
  Gasto_com_Utilidades = col_integer(),
  Gasto_com_Alimentos = col_integer(),
  Gasto_com_Vestuario = col_integer(),
  Numero_de_Compras_com_Desconto = col_integer(),
  Numero_de_Compras_na_Web = col_integer(),
  Numero_de_Compras_via_Catalogo = col_integer(),
  Numero_de_Compras_na_Loja = col_integer(),
  Numero_Visitas_WebSite_Mes = col_integer(),
  Compra_na_Campanha_1 = col_integer(),
  Compra_na_Campanha_2 = col_integer(),
  Compra_na_Campanha_3 = col_integer(),
  Compra_na_Campanha_4 = col_integer(),
  Compra_na_Campanha_5 = col_integer(),
  Comprou = col_integer(),
  Pais = col_character()
)
market <- readr::read_csv(file = "DadosMarketing.csv",
                          col_types = mycols,
                          show_col_types = FALSE)
spec(market)

# data quality
summary(market)
market1 <- market %>% 
  dplyr::filter(Salario_Anual < 666666)
summary(market1)

# Media Salarial Anual por Número de Filhos
market1 %>% 
  dplyr::group_by(Filhos_em_Casa) %>% 
  dplyr::summarise(mediaSalarioAnual = mean(Salario_Anual)) %>% 
  ggplot2::ggplot(mapping = ggplot2::aes(as.factor(Filhos_em_Casa), mediaSalarioAnual, group = 1)) +
  ggplot2::geom_point() +
  ggplot2::geom_line(color = "green") +
  ggplot2::xlab("Número de Filhos") + 
  ggplot2::ylab("Media Salarial Anual") + 
  ggplot2::ggtitle("Media Salarial Anual por Número de Filhos") +
  ggplot2::theme_light()


# Media Gasto anual por Número de Filhos
colnames(market1)
market1 %>% 
  dplyr::mutate(Gastos_Total = Gasto_com_Brinquedos + Gasto_com_Utilidades + 
                  Gasto_com_Vestuario + Gasto_com_Eletronicos + 
                  Gasto_com_Moveis + Gasto_com_Alimentos) %>% 
  dplyr::group_by(Filhos_em_Casa) %>% 
  dplyr::summarise(mediaGastoTotal = mean(Gastos_Total)) %>% 
  ggplot2::ggplot(mapping = ggplot2::aes(as.factor(Filhos_em_Casa), mediaGastoTotal, group = 1)) +
  ggplot2::geom_point() +
  ggplot2::geom_line(color = "green") +
  ggplot2::xlab("Número de Filhos") + 
  ggplot2::ylab("Media Gasto Total") + 
  ggplot2::ggtitle("Media Gasto Total Anual por Número de Filhos") +
  ggplot2::theme_light()


market1 %>% 
  dplyr::mutate(Gastos_Total = Gasto_com_Brinquedos + Gasto_com_Utilidades + 
                  Gasto_com_Vestuario + Gasto_com_Eletronicos + 
                  Gasto_com_Moveis + Gasto_com_Alimentos) %>% 
  dplyr::group_by(Filhos_em_Casa) %>% 
  dplyr::summarise(GastoTotal = sum(Gastos_Total)) %>% 
  colSums()
