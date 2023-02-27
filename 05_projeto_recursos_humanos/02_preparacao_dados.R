
#1. limpar objetos
rm(list = ls())

#2. pacote
library(tidyverse)
library(magrittr)

#3. dados
dat <- readr::read_csv(file = "DatasetRH.csv")
names(dat) <- names(dat) %>% stringr::str_replace(" ", "_")

#4. qualidade de dados: tipo - estrutura - valores nulos - consistencia
data_quality <- summary(dat) %>% 
  dplyr::as_tibble(.name_repair = ~ c("var1", "var2", "var3")) %>%
  tidyr::drop_na() %>% 
  dplyr::select(-1)

data_quality %>% View()

  # boxplot e disperssao: Anos_Experiencia e Salario_Mensal
dat %>% 
  ggplot2::ggplot(ggplot2::aes(y = Anos_Experiencia)) +
  ggplot2::geom_boxplot(fill = "gray", color = "blue") +
  ggplot2::xlab("") + 
  ggplot2::ylab("Years Experience") +
  ggplot2::theme_light() -> f1

dat %>% 
  ggplot2::ggplot(ggplot2::aes(Id_Funcionario, Anos_Experiencia)) +
  ggplot2::geom_point(color = "blue") +
  ggplot2::xlab("Id Employee") + 
  ggplot2::ylab("Years Experience") +
  ggplot2::theme_light() -> f2

dat %>% 
  ggplot2::ggplot(ggplot2::aes(y = Salario_Mensal)) +
  ggplot2::geom_boxplot(fill = "gray", color = "blue") +
  ggplot2::xlab("") +
  ggplot2::ylab("Monthly Salary") +
  ggplot2::theme_light() -> f3

dat %>% 
  ggplot2::ggplot(ggplot2::aes(Id_Funcionario, Salario_Mensal)) +
  ggplot2::geom_point(color = "blue") +
  ggplot2::xlab("Id Employee") + 
  ggplot2::ylab("Monthly Salary") + 
  ggplot2::theme_light() -> f4

X11()
gridExtra::grid.arrange(f1, f2, f3, f4, ncol = 2)

'
Tem-se um bom data quality. Os campos nao tem `NAs`, sao consistente e 
sem valores atipicos que dificultem a analises. 
'

#5. adicionar campo `condiderar_promocao`

dat %<>% 
  dplyr::mutate(condiderar_promocao = ifelse(Anos_Desde_Ultima_Promocao >= 5, "s",
                                           "n"), .before = Anos_Desde_Ultima_Promocao)

dat[c('condiderar_promocao', 'Anos_Desde_Ultima_Promocao')] %>% 
  print(n = 50)

#6. salvar dados 
readr::write_csv(dat, file = "01_Dataset_RH.csv")
