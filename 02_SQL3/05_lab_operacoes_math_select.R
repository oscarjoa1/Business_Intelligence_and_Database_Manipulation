

#--------------------------------------------------------------------------------------#
# Autor: OSCAR J. O. AYALA
# 
# conecte-se comigo no likedin www.linkedin.com/in/oscar-dataanalysis-datascience
# para usar este material, faça referência a mim
#--------------------------------------------------------------------------------------#


# limpar objetos
rm(list = ls())

# local
path <- "C:/Users/oscar/Desktop/SQL_server/SQL"
setwd(path)

# pacotes
library(DBI)
library(odbc)
library(tidyverse)

# verificar conexao driver
sort(unique(odbc::odbcListDrivers()[[1]]))

# conexao
con <- DBI::dbConnect(odbc::odbc(), 'sqlcourse')

# 1. soma e sustracao
query1 <- "SELECT 29 + 60 + 100 AS total1,
                  180 + 200 + 500 AS total2,
                  200 - 2 * 100 AS total3;"

DBI::dbGetQuery(con, query1)

# 2. divisao e multiplicao
query2 <- "SELECT 50 / 2   AS div_exact,
                  49.0 / 2 AS div_noexac, -- para divisoes nao exatas
                  3 * 3    AS mult_exact,
                  3.88 * 9 AS mult_noexact; -- para multiplicacoes nao exatas" 
DBI::dbGetQuery(con, query2)

# 3. Potenciacao

query3 <- "SELECT power(7, 2) AS result1, -- power(n, k), n o numero e k a potencia 
                  power(10, 3) AS result2"

DBI::dbGetQuery(con, query3)

# 4. porcentagem
query4 <- "SELECT 100 * 0.1 AS result -- usa-se o opereador de multiplicacao" 
DBI::dbGetQuery(con, query4)

# 5. raiz quadrada
query5 <- "SELECT sqrt(4) AS total"
DBI::dbGetQuery(con, query5)

# 6. data atual no formato dttm
query6 <- "SELECT GATEDATE() AS data"
DBI::dbGetQuery(con, query6)

# 7. sinal
query7 <- "SELECT sign(1) sinal -- 1 para + e -1 para -
           SELECT sign(-1)"
DBI::dbGetQuery(con, query7)

# desconetar 
DBI::dbDisconnect(con)

