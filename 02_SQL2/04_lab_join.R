
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

# 1. nomes dos cursos nas turmas
DBI::dbListTables(con)[1:6]

query1 <- "SELECT C.id_curso, C.nome_curso, T.id_turma FROM dbo.Turmas T
           INNER JOIN dbo.Cursos C ON T.id_curso = C.id_curso"

DBI::dbGetQuery(con, query1)

# 2. numero de turmas por id_curso e nome_curso em andamento

DBI::dbGetQuery(con, "SELECT T.data_termino FROM Turmas T")

query2 <- "SELECT C.id_curso, C.nome_curso, count(id_turma) AS total_turmas 
           FROM dbo.Turmas  T 
           INNER JOIN dbo.Cursos C ON T.id_curso = C.id_curso
           WHERE T.data_termino > '2022-10-10'
           GROUP BY C.id_curso, C.nome_curso;"

DBI::dbGetQuery(con, query2)

# 3. Cursos independnetes se tem ou nao turmas, com o numero de turmas en andamento

query3 <- "SELECT C.id_curso, C.nome_curso, COUNT(T.id_turma) AS total_turmas 
           FROM dbo.Cursos C
           LEFT JOIN dbo.Turmas T ON C.id_curso = T.id_curso
           WHERE T.data_termino > '2022-10-10'
           GROUP BY C.id_curso, C.nome_curso;"

DBI::dbGetQuery(con, query3)

query4 <- "SELECT C.id_curso, C.nome_curso, COUNT(T.id_turma) AS total_turmas 
           FROM dbo.Turmas T
           RIGHT JOIN dbo.Cursos C ON T.id_curso = C.id_curso
           WHERE T.data_termino > '2022 - 10 - 10'
           GROUP BY C.id_curso, C.nome_curso;"

DBI::dbGetQuery(con, query4)

# 4. Lista completa de alunos (Tabela Alunos e Turmas)
query5 <- "SELECT A.id_aluno, A.nome, A.sexo, A.data_nascimento, 
          C.id_curso, C.nome_curso, 
          T.id_turma, T.data_inicio, T.data_termino,
          AT.valor_turma, AT.desconto
          FROM dbo.Cursos C 
          INNER JOIN dbo.Turmas T ON C.id_curso = T.id_curso
          INNER JOIN dbo.AlunoxTurma AT ON T.id_turma = AT.id_turma
          INNER JOIN dbo.Alunos A ON AT.id_aluno = A.id_aluno;"


DBI::dbGetQuery(con, query5) %>% View()

# 5. Quantidades de turmas com alunos

query6 <- "SELECT T.id_turma, C.nome_curso, COUNT(AT.id_aluno) AS n
          FROM AlunoxTurma AT
          INNER JOIN Turmas T ON T.id_turma = AT.id_turma
          INNER JOIN Cursos C ON T.id_curso = C.id_curso 
          GROUP BY T.id_turma, C.nome_curso
          ORDER BY T.id_turma, C.nome_curso, n;
          "
DBI::dbGetQuery(con, query6) 

# 6. desconetar
DBI::dbDisconnect(con)
