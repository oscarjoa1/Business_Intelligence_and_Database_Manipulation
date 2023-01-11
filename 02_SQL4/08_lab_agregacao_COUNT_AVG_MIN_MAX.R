

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

# comentarios

'
-- 1. AVG: ignora valores nulos. Indecas-se ALL por default

-- Funcao de sintaxis de agregacao DETERMINISTIC
AVG ( [ ALL | DISTINCT ] expression )  

-- sintaxis funcao analitica NOT DETERMINISTIC
AVG ( [ ALL | DISTINCT ] expression )  
[ OVER ( [ partition_by_clause ] order_by_clause ) ]

-- 2. COUNT: returnao tipo de dados INT.

-- Aggregation Function Syntax DETERMINISTIC 
COUNT ( { [ [ ALL | DISTINCT ] expression ] | * } )  

-- Analytic Function Syntax NOT DETERMINISTIC 
COUNT ( [ ALL ]  { expression | * } ) OVER ( [ <partitioXn_by_clause> ] )  

-- COUNT(*) retorna o número de linhas de uma tabela. Nao ignora valores NULL e duplicatas.

-- COUNT(ALL expressão ) avalia a expressão para cada linha em um grupo e retorna o número de valores não nulos.

-- COUNT(DISTINCT expression ) avalia a expressão para cada linha em um grupo e retorna o número de valores exclusivos e não nulos.

-- 3. MAX e  MMIN: ignora valores NULL. 
    Retornam NULL quando nao ha linha para selecionar ou todas foram NULL
    Para campos carater MAX ou MIN encontra o valor mais alto na sequência de agrupamento.

-- Aggregation Function Syntax  DETERMINISTIC
MAX( [ ALL | DISTINCT ] expression )  
  
-- Analytic Function Syntax  NOT DETERMINISTIC
MAX ([ ALL ] expression) OVER ( <partition_by_clause> [ <order_by_clause> ] )

-- Aggregation Function Syntax DETERMINISTIC 
MIN ( [ ALL | DISTINCT ] expression )  
  
-- Analytic Function Syntax NOT DETERMINISTIC  
MIN ( [ ALL ] expression ) OVER ( [ <partition_by_clause> ] [ <order_by_clause> ] )

'

# 1. soma simples

query1 <- "SELECT SUM(AT.Valor_turma) AS total 
           FROM dbo.AlunoxTurma AT;"

DBI::dbGetQuery(con, query1)

# 2. valor total por turma

query2 <- "SELECT T.id_turma, SUM(AT.valor_turma) AS valor_turma
          FROM dbo.AlunoxTurma AT 
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          GROUP BY T.id_turma
          "
DBI::dbGetQuery(con, query2)

# 3. valor total por curso e turmas
query3 <- "SELECT C.nome_curso, T.id_turma, SUM(AT.valor_turma) AS valor_turma
          FROM dbo.Cursos C 
          INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
          INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma)
          GROUP BY C.nome_curso, T.id_turma
          "
DBI::dbGetQuery(con, query3)

# 4. numero de alunos por curso
query4 <- "SELECT C.id_curso, C.nome_curso, COUNT(A.id_aluno) AS n_alunos
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query4)

# 5. numero de alunos e lucro por curso 

query4 <- "SELECT C.id_curso, C.nome_curso, COUNT(A.id_aluno) AS n_alunos,
          SUM(AT.desconto) AS desconto_total,
          ROUND(SUM(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_total
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query4)

# 6. numero de alunos e lucro por curso e ano

query4 <- "SELECT C.id_curso, C.nome_curso,
          COUNT(A.id_aluno) AS n_alunos,
          SUM(AT.desconto) AS desconto_total,
          ROUND(SUM(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_total
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso, DATEPART(YEAR, T.data_inicio)
          "
DBI::dbGetQuery(con, query4)

# 7.  numero de estudante, media de valor, desconto e lucro por curso

query5 <- "SELECT C.id_curso, C.nome_curso,
          ROUND(COUNT(A.id_aluno), 0)AS total_aluno,
          ROUND(AVG(AT.desconto), 0) AS desconto_medio,
          ROUND(AVG(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_medio
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query5)

# 8. O maior valor pago por cursa e turma 

query6 <- "SELECT C.id_curso, C.nome_curso,
          ROUND(COUNT(A.id_aluno), 0) AS total_aluno,
          MAX(AT.desconto) AS desconto_medio,
          MAX((AT.valor_turma - AT.valor_turma * AT.desconto)) AS lucro_maximo
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query6)

# 8. O minimo valor pago por curso e turma 

query7 <- "SELECT C.id_curso, C.nome_curso,
          ROUND(COUNT(A.id_aluno), 0)AS total_aluno,
          MIN(AT.desconto) AS desconto_minimo,
          MIN((AT.valor_turma - AT.valor_turma * AT.desconto)) AS lucro_minimo
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query7)

# 9. o valor pago minimo e maximo e sua diferenca
query8 <- "SELECT C.id_curso, C.nome_curso,
          ROUND(COUNT(A.id_aluno), 0)AS total_aluno,
          MIN((AT.valor_turma - AT.valor_turma * AT.desconto)) AS lucro_minimo,
          MAX((AT.valor_turma - AT.valor_turma * AT.desconto)) AS lucro_maximo,
          MAX((AT.valor_turma - AT.valor_turma * AT.desconto)) - 
          MIN((AT.valor_turma - AT.valor_turma * AT.desconto)) AS diferenca
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY C.nome_curso, C.id_curso
          "
DBI::dbGetQuery(con, query8)

# 10. desconetar
DBI::dbDisconnect(con)
