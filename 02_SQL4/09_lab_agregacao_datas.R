

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


# DATETIME desde 01/01/1753 armazena ate centesima de segundo
# SMALLDATETIME desde 01/01/1990 armazena ate segundos

# 1. funcao GETDATE
query1 <- "SELECT GETDATE() -- data e hora atual"

DBI::dbGetQuery(con, query1)

# 2. funcao convert
query2 <- "SELECT convert(char, GETDATE(), 103); -- 103 formato dd/mm/aaaa"
query2 <- "SELECT convert(char, GETDATE(), 102); -- 102 formato aaaa.mm.dd"
query2 <- "SELECT convert(char, GETDATE(), 1);   --  1 formato dd/mm/aa"
DBI::dbGetQuery(con, query2)

# 3. extrair ano, mes ou dia de uma data
query3 <- "SELECT DATEPART(DAY, GETDATE()) AS dia;   -- extrai o dia"
query3 <- "SELECT DATEPART(MONTH, GETDATE()) AS mes; -- extrai o mes"
query3 <- "SELECT DATEPART(YEAR, GETDATE()) AS ano;       -- extrai oano"
query3 <- "SELECT DATEPART(YEAR, '13/10/2022') AS ano;       -- extrai oano"
DBI::dbGetQuery(con, query3)

# 4. anos de nascimento distintos dos alunos
query4 <- "SELECT DISTINCT(DATEPART(MONTH, A.data_nascimento)) AS mes FROM dbo.Alunos A
           ORDER BY mes;"

DBI::dbGetQuery(con, query4)

# funcao DATEADD: incrementar e descrementar ao intervalo 
query5 <- "SELECT DATEADD(YEAR, 1, GETDATE()) AS ano; -- adicionar um ano  "
query5 <- "SELECT DATEADD(YEAR, -1, GETDATE()) AS ano -- sustrair um ano"
query5 <- "SELECT CONVERT(DATE, DATEADD(YEAR, 1, GETDATE()), 103) AS ano -- converte para form. DATE"
query5 <- "SELECT DATEADD(MONTH, 2, GETDATE()) as mes;"
query5 <- "SELECT DATEADD(DAY, 15, GETDATE()) AS data" 
query5 <- "SELECT CONVERT(DATE, DATEADD(DAY, 16, GETDATE()))"
query5 <- "SELECT DATEADD(HOUR, 3, GETDATE())"
query5 <- "SELECT CONVERT(DATETIME, DATEADD(HOUR, 3, GETDATE()))"

DBI::dbGetQuery(con, query5)

# funcao DATEDIFF: diferenca entre datas
query6 <- "SELECT DATEDIFF(YEAR, GETDATE(), DATEADD(YEAR, 3, GETDATE())) AS ano"
query6 <- "SELECT DATEDIFF(MONTH, GETDATE(), DATEADD(MONTH, 5, GETDATE())) AS meses"
query6 <- "SELECT DATEDIFF(MONTH, GETDATE(), DATEADD(YEAR, 3, GETDATE())) AS meses"
query6 <- "SELECT DATEDIFF(HOUR, GETDATE(), DATEADD(HOUR, 3, GETDATE())) AS HORAS"

DBI::dbGetQuery(con, query6)


# desconetar
DBI::dbDisconnect(con)
