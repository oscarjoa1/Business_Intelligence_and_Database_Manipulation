# limpar objetos
rm(list = ls())

# pacotes
library(DBI)
library(odbc)
library(config)
library(tidyverse)

# local
path <- 'C:/Users/oscar/Desktop/SQL_server/SQL'
setwd(path)

#-------------------------------------- conexao ---------------------------------------#
# 1. verficar se 'odbc' reconhece os drivers instalados
sort(unique(odbc::odbcListDrivers()[[1]]))

# 2. atraves de DSN (recomendavel)
con1 <- DBI::dbConnect(odbc::odbc(),'sqlcourse')

# 3. atraves de argumentos 
con2 <- DBI::dbConnect(odbc::odbc(),
                      Driver = "SQL Server",
                      Server = "DATAOSCAR", 
                      Database = "SQL_01",
                      Trusted_Connection = "True")

#-------------------------------------- SQL ---------------------------------------#
 
# 1. lista de tabelas
sort(DBI::dbListTables(con1))[1:10]

# 2. criar tabelas e relacoes
query1 <- paste('CREATE TABLE Alunos(',
                'id_aluno              INT PRIMARY KEY NOT NULL,',
                'nome                  VARCHAR(100) NOT NULL,',
                'data_nascimento       DATE NOT NULL,',
                'sexo                  VARCHAR(1), -- F femenino ou M masculino',
                'data_cadastro         DATETIME NOT NULL,',
                'login_cadastro        VARCHAR(20)',
                ');', sep = '\n')

DBI::dbExecute(con1, query1)

query2 <- 'CREATE TABLE Cursos(
          id_curso INT PRIMARY KEY NOT NULL,
          nome_curso VARCHAR(100) NOT NULL,
          data_cadastro DATETIME NOT NULL,
          login_cadastro VARCHAR(20));'

DBI::dbExecute(con1, query2)


query3 <- 'CREATE TABLE Situacao(
          id_situacao    INT PRIMARY KEY NOT NULL,
          situacao       VARCHAR(200) NOT NULL,
          data_cadastro  DATETIME NOT NULL,
          login_cadastro VARCHAR(20) NOT NULL
          );'

DBI::dbExecute(con1, query3)


query4 <- 'CREATE TABLE Turmas(
          id_turma       INT PRIMARY KEY NOT NULL,
          id_curso       INT NOT NULL,
          id_aluno       INT NOT NULL,
          valor_turma    numeric(15, 2) NOT NULL,
          desconto       numeric(3, 2) NOT NULL,
          data_inicio    DATE NOT NULL,
          data_termino   DATE NOT NULL,
          data_cadastro  DATETIME NOT NULL,
          login_cadastro VARCHAR(20) NOT NULL);'

DBI::dbExecute(con1, query4)


query5 <- 'CREATE TABLE registro_presenca(
          id_turma    INT NOT NULL,
          id_aluno    INT NOT NULL,
          id_situacao INT NOT NULL,
          data_presenca DATE NOT NULL,
          data_cadastro DATETIME NOT NULL,
          login_cadastro VARCHAR(20) NOT NULL
          );'

DBI::dbExecute(con1, query5)

query7 <- 'ALTER TABLE Turmas
           ADD CONSTRAINT fk_cursotur FOREIGN KEY (id_curso) REFERENCES Cursos (id_curso);
           ALTER TABLE Turmas
           ADD CONSTRAINT fk_alunotur FOREIGN KEY (id_aluno) REFERENCES Alunos (id_aluno)'

DBI::dbExecute(con1, query7)

query8 <- 'ALTER TABLE registro_presenca
           ADD CONSTRAINT fk_turmareg FOREIGN KEY (id_turma) REFERENCES Turmas (id_turma);
           ALTER TABLE registro_presenca
           ADD CONSTRAINT fk_alunoreg FOREIGN KEY (id_aluno) REFERENCES Alunos (id_aluno);
           ALTER TABLE registro_presenca
           ADD CONSTRAINT fk_situacaoreg FOREIGN KEY (id_situacao) REFERENCES Situacao (id_situacao);
            '
DBI::dbExecute(con1, query8)


query6 <- '/*DROP TABLE Alunos;
          DROP TABLE Cursos;
          DROP TABLE situacao;
          DROP TABLE Turmas;
          DROP TABLE registro_presenca*/;'


DBI::dbExecute(con1, query6)

# 3. importando tabelas e inserir valores

# Alunos
DBI::dbListFields(con1, 'Alunos')

alunos <- readr::read_csv(file = 'dados_alunos.csv',
                          col_types = cols(id_aluno = 'i',
                                           nome = 'c',
                                           data_nascimento = 'D',
                                           sexo = 'c',
                                           data_cadastro = 'T',
                                           login_cadastro = 'c'))


DBI::dbWriteTable(con1, 'Alunos', alunos, append = TRUE)
DBI::dbGetQuery(con1, 'SELECT * FROM dbo.Alunos;')

# Cursos
DBI::dbListFields(con1, 'Cursos')

cursos <- readr::read_csv('cursos.csv',
                          col_types = cols(id_curso = 'i',
                                           nome_curso = 'c',
                                           data_cadastro = 'T',
                                           login_cadastro = 'c'))


DBI::dbWriteTable(con1, 'Cursos', cursos, append = TRUE)
DBI::dbGetQuery(con1, 'SELECT * FROM dbo.Cursos;')

# situacao
DBI::dbListFields(con1, 'Situacao')

situacao <- readr::read_csv('situacao.csv',
                            col_types = cols(id_situacao = 'i',
                                             situacao = 'c',
                                             data_cadastro = 'T',
                                             login_cadastro = 'c'))

readr::write_csv(situacao, 'situacao.csv')

DBI::dbWriteTable(con1, 'Situacao', situacao, append = TRUE)
DBI::dbGetQuery(con1, 'SELECT * FROM dbo.Situacao;')

# Turmas

DBI::dbListFields(con1, 'Turmas')

turmas <- readr::read_csv('turmas.csv',
                          col_types = cols(id_turma = 'i',
                                           id_curso = 'i',
                                           id_aluno = 'i',
                                           valor_turma = 'd',    
                                           desconto = 'd',
                                           data_inicio = 'D',
                                           data_termino = 'D',
                                           data_cadastro = 'T',
                                           login_cadastro = 'c'))

DBI::dbWriteTable(con1, 'Turmas', turmas, append = TRUE)
DBI::dbGetQuery(con1, 'SELECT * FROM dbo.Turmas;')

# Registro presenca


registro_presenca <- readr::read_csv('registro_presenca.csv',
                                     col_types = cols(id_turma = 'i',
                                                      id_aluno = 'i',
                                                      id_situacao = 'i',
                                                      data_presenca = 'D',
                                                      data_cadastro = 'T',
                                                      login_cadastro  = 'c'))

DBI::dbWriteTable(con1, 'registro_presenca', registro_presenca, append = TRUE)
DBI::dbGetQuery(con1, 'SELECT * FROM dbo.registro_presenca;')

# Verificando insercao de dados

query9 <- 'SELECT * FROM dbo.Cursos;'
query9 <- 'SELECT * FROM dbo.Alunos;'
query9 <- 'SELECT * FROM dbo.Situacao;'
query9 <- 'SELECT * FROM dbo.Turmas;'
query9 <- 'SELECT * FROM dbo.registro_presenca;'

DBI::dbGetQuery(con1, query9) 

# adicionando tabela

query10 <- 'ALTER TABLE Turmas
            DROP CONSTRAINT fk_alunotur;'

DBI::dbExecute(con1, query10)

query11 <- 'ALTER TABLE Turmas
            DROP COLUMN id_aluno;
            ALTER TABLE Turmas
            DROP COLUMN valor_turma;
            ALTER TABLE Turmas
            DROP COLUMN desconto
'
DBI::dbExecute(con1, query11)

query12 <- 'CREATE TABLE AlunoxTurma(
          id_turma       INT NOT NULL,
          id_aluno       INT NOT NULL,
          valor_turma    numeric(15, 2) NOT NULL,
          desconto       numeric(3, 2) NOT NULL,
          data_cadastro  DATETIME NOT NULL,
          login_cadastro VARCHAR(20) NOT NULL);'

DBI::dbExecute(con1, query12)



# Modificacao dos datos tabela Turma
turmas <- DBI::dbGetQuery(con1, 'SELECT * FROM dbo.Turmas;') %>%
          dplyr::slice_head(n = 100)

query14 <- 'ALTER TABLE registro_presenca
            DROP CONSTRAINT fk_turmareg;'

DBI::dbExecute(con1, query14)

query15 <- 'DELETE FROM Turmas 
            WHERE id_turma > 100'

query15 <- 'DELETE FROM registro_presenca
            WHERE id_turma > 100;'


DBI::dbExecute(con1, query15)

query16 <- 'ALTER TABLE registro_presenca
            ADD CONSTRAINT fk_turmareg FOREIGN KEY (id_turma) REFERENCES Turmas (id_turma);'

DBI::dbExecute(con1, query16)

# relacionar tabela nova
query13 <- 'ALTER TABLE AlunoxTurma
            ADD CONSTRAINT fk_turmaaxt FOREIGN KEY (id_turma) REFERENCES Turmas (id_turma);
            ALTER TABLE AlunoxTurma
            ADD CONSTRAINT fk_alunoaxt FOREIGN KEY (id_aluno) REFERENCES Alunos (id_aluno);'


DBI::dbExecute(con1, query13)


query12 <- 'CREATE TABLE AlunoxTurma(
          id_turma       INT NOT NULL,
          id_aluno       INT NOT NULL,
          valor_turma    numeric(15, 2) NOT NULL,
          desconto       numeric(3, 2) NOT NULL,
          data_cadastro  DATETIME NOT NULL,
          login_cadastro VARCHAR(20) NOT NULL);'

# inserir valores novos

alunosxturmas <- dplyr::tibble(id_turma = c(rep(turmas$id_turma, 7), 1:92),
              id_aluno = alunos$id_aluno,
              valor_turma = runif(792, 1000, 2000),
              desconto    = 0,
              data_cadastro = lubridate::make_datetime(2022, 10, 09, 12, 49),
              login_cadastro = 'DATAOSCAR')

readr::write_csv(alunosxturmas, 'alunosxturmas.csv')

DBI::dbWriteTable(con1, 'AlunoxTurma', alunosxturmas, append = TRUE)

# desconetar db
DBI::dbDisconnect(con1)

