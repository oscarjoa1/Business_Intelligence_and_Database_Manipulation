

#--------------------------------------------------------------------------------------#
# Autor: OSCAR J. O. AYALA
# 
# conecte-se comigo no likedin www.linkedin.com/in/oscar-dataanalysis-datascience
# para usar este material, faça referência a mim
#--------------------------------------------------------------------------------------#


# limpar objetos
rm(list = ls())

# pacotes
library(DBI)
library(odbc)
library(tidyverse)

# local
path <- 'C:/Users/oscar/Desktop/SQL_server/SQL'
setwd(path)

# verificar conexao
sort(unique(odbc::odbcListDrivers()[[1]]))

# conexao
con <- DBI::dbConnect(odbc::odbc(), "sqlcourse")

# 1. WHERE com operador "=" 
query1 <- "SELECT A.* FROM Alunos A
           WHERE A.nome = 'Aline Abboud' "

DBI::dbGetQuery(con, query1)

# 2. WHERE com operador "<" para inteiros 
query2 <- "SELECT A.* FROM Alunos A
          WHERE A.id_aluno < 30"

DBI::dbGetQuery(con, query2)

# 3. WHERE com operador "<>" 
query3 <- "SELECT A.* FROM Alunos A
           WHERE A.nome <> 'Aline Abboud' "

DBI::dbGetQuery(con, query3)
 #(todos os registros sao exibidos menos "Alune Abboud")
 #(pode-se usar )

# 4. WHERE tambem fucnionam para datas
query4 <- "SELECT A.* FROM Alunos A
           WHERE A.data_nascimento = '1990-10-19' "

DBI::dbGetQuery(con, query4)

query5 <- "SELECT A.* FROM Alunos A
           WHERE A.data_nascimento > '1990-10-19' "

DBI::dbGetQuery(con, query5)

 #(esta comparacao funciona para os operados >, <, >=, <=, = ou <>)
 #(para datas em oracle se tem a funcao to_date('19901019', 'yyyymmdd'))

# 5. WHERE com '!='

query6 <- "SELECT A.* FROM Alunos A
           WHERE A.sexo != 'M' "

DBI::dbGetQuery(con, query6)
 #(os registro dos estudantes femeninos)
 

query7 <- "SELECT A.* FROM Alunos A
           WHERE A.sexo  = 'M' "

DBI::dbGetQuery(con, query7)
 #(os registros dos estudantes masculinos)

# 6. WHERE com a clausula 'AND'

query8 <- "SELECT A.* FROM Alunos A
           WHERE A.sexo = 'M' 
           AND A.data_nascimento < '1990-10-19'
           AND A.id_aluno < 30"

DBI::dbGetQuery(con, query8)

# 7. WHERE selecionado campos e apenas o ano, funcao year()

query9 <- "SELECT A.id_aluno, A.nome, year(A.data_nascimento) AS year 
           FROM Alunos A
           WHERE A.data_nascimento < '1991-01-01' "

DBI::dbGetQuery(con, query9)

# 8. WHERE com operador floor (redonder para o inteiro)
DBI::dbListTables(con)[1:10]
DBI::dbListFields(con, "AlunoxTurma")

query10 <- "SELECT AT.id_turma, AT.id_aluno, floor(AT.valor_turma) FROM AlunoxTurma AT 
            WHERE AT.valor_turma > 1200"

DBI::dbGetQuery(con, query10)

# desconetar 
DBI::dbDisconnect(con)




