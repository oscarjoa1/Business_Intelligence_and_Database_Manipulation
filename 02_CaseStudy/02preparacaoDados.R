
#------------------------------------------------------------------------------#
# Oscar J. O. Ayala
# Para fazer uso deste material me referencie
# Me siga no linkedln: linkedin.com/in/oscar-dataanalysis-datascience
#------------------------------------------------------------------------------#

# limpar variaveis
rm(list = ls())

# pacotes
library(tidyverse)
library(magrittr)
library(lubridate)

#-------------------------- importacao e preparacao ---------------------------#

  # tabela dim_clientes
namescols <- c("id_cliente", "nome_cliente", "segmento", "cidade", "estado", "pais", "mercado", "regiao")
dim_clientes <- readr::read_csv2(file = "Clientes.csv",
                                 show_col_types = FALSE) %>% setNames(namescols)

  # tabela dim_pedidos
namescols <- c("id_pedido", "data_pedido", "data_envio", "modo_envio", "tipo_prioridade")
dim_pedidos <- readr::read_csv2(file = "Pedidos.csv",
                                show_col_types = FALSE) %>% 
  setNames(namescols) %>% 
  dplyr::mutate(data_pedido = lubridate::dmy(data_pedido),
                                     data_envio = lubridate::dmy(data_envio))

  # tabela dim_produto
namescols <- c("id_produto", "categoria", "subcategoria", "nome_produto")
dim_produtos <- readr::read_csv2(file = "Produtos.csv",
                                show_col_types = FALSE) %>% setNames(namescols)

  # tabela fato_vendas
namescols <- c("id_pedido", "id_cliente", "id_produto", "valor_venda", "quantidade_venda",
               "custo_envio")
fato_vendas <- readr::read_csv2(file = "Vendas.csv",
                                locale = locale(decimal_mark = ","),
                                show_col_types = FALSE) %>% 
  setNames(namescols) %>% 
  dplyr::mutate(quantidade_venda = as.integer(quantidade_venda))

# verificar chaves primarias

# dim_clientes --- id_cliente (PK) 
dim_clientes %>% 
  dplyr::count(id_cliente, regiao) %>% 
  dplyr::filter(n > 1)

# dim_pedidos --- id_pedidos (pk)
dim_pedidos %>% 
  dplyr::count(id_pedido) %>% 
  dplyr::filter(n > 1)

dim_pedidos %>% 
  dplyr::filter(id_pedido == "CA-2012-124891")

'
A chave tem duas entradas CA-2012-124891, 
possivelmente um erro de digitacao elimina-se um registro
'
dim_pedidos %<>% 
  dplyr::distinct()

# dim_produtos -- id_produto (pk)

dim_produtos %>% 
  dplyr::count(id_produto) %>% 
  dplyr::filter(n > 1)

'
A chave tem duas entradas TEC-AC-10003033, 
possivelmente um erro de digitacao elimina-se um registro
'

dim_produtos %>% 
  dplyr::filter(id_produto == "TEC-AC-10003033")

dim_produtos %<>% 
  dplyr::distinct()

# fato_vendas: id_pedido (fk), id_cliente(fk), id_produto(fk)
fato_vendas%>% 
  dplyr::count(id_pedido) %>% 
  dplyr::filter(n > 1)


fato_vendas%>% 
  dplyr::count(id_cliente) %>% 
  dplyr::filter(n > 1)

fato_vendas%>% 
  dplyr::count(id_produto) %>% 
  dplyr::filter(n > 1)

# exportar tabelas
write.csv(dim_clientes, file = "dim_clientes.csv")
write.csv(dim_pedidos, file = "dim_pedidos.csv")
write.csv(dim_produtos, file = "dim_produtos.csv")
write.csv(fato_vendas, file = "fato_vendas.csv")

#-------------------------------------- fim ----------------------------------#



