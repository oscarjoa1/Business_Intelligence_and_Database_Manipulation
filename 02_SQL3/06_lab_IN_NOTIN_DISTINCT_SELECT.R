
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

# 1. Total de turmas por cursos 
query1 <- "SELECT T.id_curso, COUNT(T.id_turma) n_turma
           FROM dbo.Turmas T
           GROUP BY T.id_curso
           ORDER BY T.id_curso;"
DBI::dbGetQuery(con, query1)

# 2. Total de turmas por cursos com seu nome
query2 <- "SELECT C.id_curso, C.nome_curso, COUNT(T.id_turma) AS n_turma
          FROM dbo.Turmas T
          INNER JOIN dbo.Cursos C ON T.id_curso = C.id_curso
          GROUP BY C.id_curso, C.nome_curso
          ORDER BY C.id_curso, C.nome_curso;
          "
DBI::dbGetQuery(con, query2)

query3 <- "SELECT C.id_curso, C.nome_curso, T.id_turma 
          FROM dbo.Turmas T          
          INNER JOIN dbo.Cursos C ON T.id_curso = C.id_curso
          WHERE C.id_curso = 1
          "
DBI::dbGetQuery(con, query3)

query4 <- "SELECT *
          FROM dbo.Turmas T
          WHERE T.id_curso = 1;"

DBI::dbGetQuery(con, query4)

# 3. turmas para id_curso em 1 ou 5, WHERE

query5 <- "SELECT *
          FROM dbo.Turmas T
          WHERE T.id_curso IN (1, 5)
          ORDER BY T.id_curso, T.id_turma;
          "
DBI::dbGetQuery(con, query5)

# 4. turmas para id_curso != c(1, 5), com NOT IN

query6 <- "SELECT * 
          FROM dbo.Turmas T
          WHERE T.id_curso NOT IN (1, 5)
          ORDER BY T.id_curso
          "
DBI::dbGetQuery(con, query6)

# 5. Ano de nascimentos distintos dos alunos
query7 <- "SELECT DISTINCT DATEPART(YEAR, A.data_nascimento) AS year
          FROM dbo.Alunos A
          ORDER BY year;
          "
DBI::dbGetQuery(con, query7)

query7 <- "SELECT DISTINCT DATEPART(YEAR, A.data_nascimento) AS year
          FROM dbo.Alunos A
          ORDER BY 1 -- ordena a primeira coluna de forma crescente
          "
DBI::dbGetQuery(con, query7)

# 6. Uso do ASC e DESC

query8 <- "SELECT DISTINCT DATEPART(YEAR, A.data_nascimento) AS year
          FROM dbo.Alunos A
          ORDER BY 1 ASC -- o 1 é primeira coluna, ordena a primeira coluna de forma crescente
          "
DBI::dbGetQuery(con, query8)

query9 <- "SELECT DISTINCT DATEPART(YEAR, A.data_nascimento) AS year
          FROM dbo.Alunos A
          ORDER BY 1 DESC-- ordena a primeira coluna de forma crescente
          "
DBI::dbGetQuery(con, query9)

# 7. lista completa de alunos por sexo masculino

query10 <- "SELECT A.data_nascimento, A.id_aluno, A.nome, A.sexo,
            AT.desconto, AT.valor_turma, 
            T.data_inicio, T.data_termino, T.id_turma, 
            C.id_curso, C.nome_curso
            FROM dbo.Alunos A
            INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
            INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
            INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
            WHERE A.sexo = 'M'
            ORDER BY A.nome;
            "
DBI::dbGetQuery(con, query10) %>% View()


# 8. desconetar
DBI::dbDisconnect(con)

