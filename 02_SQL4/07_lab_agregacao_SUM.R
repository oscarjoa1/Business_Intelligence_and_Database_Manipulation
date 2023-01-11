

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

# comentarios funcao agreg. SUM
'
-- ignora os valores nulos

-- Aggregate Function Syntax:    
SUM ( [ ALL | DISTINCT ] expression ) -- O padrao ALL

-- Analytic Function Syntax:   
SUM ([ ALL ] expression) OVER ( [ partition_by_clause ] order_by_clause) -- O padrao ALL
'

# 1. pago por estudante

query1 <- "SELECT C.nome_curso, T.id_turma, 
           AT.valor_turma, (AT.valor_turma - AT.valor_turma * AT.desconto) AS lucro_turma
           FROM dbo.Cursos C 
           INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
           INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma);
          "
DBI::dbGetQuery(con, query1)

  # 2. ganho total por curso e turma
query2 <- "SELECT C.nome_curso, C.id_curso, T.id_turma, 
           SUM(AT.valor_turma - AT.valor_turma * AT.desconto) AS lucro_turma
           FROM dbo.Cursos C 
           INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
           INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma)
           INNER JOIN dbo.Alunos A ON (AT.id_aluno = A.id_aluno)
           GROUP BY C.nome_curso, C.id_curso, T.id_turma
           "
DBI::dbGetQuery(con, query2)

# 3. lucro total por apenas por curso
query3 <- "SELECT C.nome_curso, C.id_curso, 
           SUM(AT.valor_turma - AT.valor_turma * AT.desconto) AS lucro_turma
           FROM dbo.Cursos C 
           INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
           INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma)
           INNER JOIN dbo.Alunos A ON (AT.id_aluno = A.id_aluno)
           GROUP BY C.nome_curso, C.id_curso
           "
DBI::dbGetQuery(con, query3)

# 4. ganho e lucro por curso e turma 
query4 <- "SELECT C.nome_curso, T.id_turma, 
           SUM(AT.valor_turma) AS valor_turma,
           SUM(AT.desconto) AS valor_desconto,
           SUM (AT.valor_turma - AT.valor_turma * AT.desconto) AS lucro_turma
           FROM dbo.Cursos C 
           INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
           INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma)
           GROUP BY C.nome_curso, T.id_turma;
          "
DBI::dbGetQuery(con, query4)

# 5. redondear ganho e lucro por curso e turma 

query5 <- "SELECT C.nome_curso, T.id_turma, 
           ROUND(SUM(AT.valor_turma), 0) AS valor_turma,
           ROUND(SUM(AT.desconto), 0) AS valor_desconto,
           ROUND(SUM (AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_turma
           FROM dbo.Cursos C 
           INNER JOIN dbo.Turmas T ON (C.id_curso = T.id_curso)
           INNER JOIN dbo.AlunoxTurma AT ON (T.id_turma = AT.id_turma)
           GROUP BY C.nome_curso, T.id_turma;
          "
DBI::dbGetQuery(con, query5)

# 6. lucro anual por curso e turma

query6 <- "SELECT DATEPART(YEAR, T.data_inicio) AS year, C.nome_curso, T.id_turma, 
          ROUND(SUM(AT.valor_turma), 0) AS valor_turma_anual, 
          ROUND(SUM(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_anual
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY DATEPART(YEAR, T.data_inicio), C.nome_curso, T.id_turma"

DBI::dbGetQuery(con, query6)          

# 7. lucro anual por curso

query7 <- "SELECT DATEPART(YEAR, T.data_inicio) AS year, C.nome_curso, 
          ROUND(SUM(AT.valor_turma), 0) AS valor_turma_anual, 
          ROUND(SUM(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_anual
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY DATEPART(YEAR, T.data_inicio), C.nome_curso"

DBI::dbGetQuery(con, query7)    


# 8. lucro anual 

query7 <- "SELECT DATEPART(YEAR, T.data_inicio) AS year, 
          ROUND(SUM(AT.valor_turma), 0) AS valor_turma_anual, 
          ROUND(SUM(AT.valor_turma - AT.valor_turma * AT.desconto), 0) AS lucro_anual
          FROM dbo.Alunos A
          INNER JOIN dbo.AlunoxTurma AT ON (A.id_aluno = AT.id_aluno)
          INNER JOIN dbo.Turmas T ON (AT.id_turma = T.id_turma)
          INNER JOIN dbo.Cursos C ON (T.id_curso = C.id_curso)
          GROUP BY DATEPART(YEAR, T.data_inicio)"

DBI::dbGetQuery(con, query7)    


# 9. CUMULATIVE SUM nao deterministica clausulas OVER e ORDER BY
  #  Particionando por territorio e por ano

# criacao tabela sales
set.seed(2010)
sales <- dplyr::tibble(salesproduct = runif(10, 700, 1000),
                        territoryID = as.integer(runif(10, 1, 10)),
                        salesyear   = as.integer(runif(10, 2019, 2022)),
                        businessID  = as.integer(runif(10, 200, 300)))
DBI::dbWriteTable(con, 'sales', sales)

query8 <- "SELECT * FROM dbo.sales;"
DBI::dbGetQuery(con, query8)  

# consulta
query9 <- "SELECT S.businessID, S.salesyear, S.territoryID,
           CONVERT(vARCHAR(15), 
                   SUM(S.salesproduct) OVER(PARTITION BY S.territoryID
                                            ORDER BY S.salesyear), 
                    1) AS partsum
           FROM dbo.Sales S;
          "

query9 <- "SELECT S.businessID, S.salesyear, S.territoryID,
           SUM(S.salesproduct) OVER(PARTITION BY S.territoryID
                                    ORDER BY S.salesyear) AS partsum
           FROM dbo.Sales S;
          "
DBI::dbGetQuery(con, query9)  
dplyr::as_tibble(DBI::dbGetQuery(con, query9))

# 10. desconetar
DBI::dbDisconnect(con)









