
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
con <- DBI::dbConnect(odbc::odbc(), 'sqlcourse')

#1. selecao de dados
query1 <- 'SELECT * FROM dbo.Alunos;'
DBI::dbGetQuery(con, query1)

 #(dbo. e a extensao padrao, indica o sistema de db estou trabalhando, financeiro, contavel)
 #(esta extensao para sistemas de financias pode ser 'fin', para cotaveis 'ctb')
 #(porem nao sao necessario para fazer consultas)
 #(os SELECT´s nao sao sensiveis a maiusculas). Veja

query2 <- 'SELECT * FROM TURMAS;'
DBI::dbGetQuery(con, query2)

 # (caso tenha de duas tabelas com o mesmo nome e extesao diferente preciso indica - las)
 # (o ideal e colocar sempre a extensao da tabela)

query3 <- 'SELECT * FROM dbo.TURMAS;'
DBI::dbGetQuery(con, query3)

 # (o '*' significa todos os campos)

#2. Pode-se realizar uma consulta com o nome da tabela no inicio
query4 <- 'SELECT Cursos.* FROM Cursos;'

DBI::dbGetQuery(con, query4)
 #(esta forma ideal quando tem-se varios campos com os mesmo nome)
 #(assim, pode - se relacionar o nome do campo a uma tabela)
 #(Curso.* relaciona o nome de todos os campos da tabela curso)

#3. Selecionar alguns campos
DBI::dbListFields(con, 'Cursos')


query5 <- 'SELECT id_curso, login_cadastro FROM dbo.Cursos;'
DBI::dbGetQuery(con, query5)

#4. Nome da turma e curso
query6 <- 'SELECT dbo.Cursos.id_curso, id_turma, nome_curso FROM dbo.Cursos
          INNER JOIN dbo.Turmas ON dbo.Cursos.id_curso = dbo.Turmas.id_curso'

DBI::dbGetQuery(con, query6)

 #(permite a extensao padrao dbo) 
 #(para igualdades nao permite '==')

#5. Alias no SELECT
query7 <- 'SELECT T.id_turma, T.id_curso, T.login_cadastro 
           FROM dbo.Turmas T;'

DBI::dbGetQuery(con, query7)

query8 <- 'SELECT C.id_curso, T.id_turma, C.nome_curso FROM dbo.Cursos C
          INNER JOIN dbo.Turmas T ON C.id_curso = T.id_curso'

DBI::dbGetQuery(con, query8)

#6. Personalizar nomes para campos
query9 <- 'SELECT T.id_curso AS idc, T.id_turma AS idt, T.login_cadastro AS usuario
           FROM dbo.Turmas T;'
DBI::dbGetQuery(con, query9)

#7. desconetar 
DBI::dbDisconnect(con)

