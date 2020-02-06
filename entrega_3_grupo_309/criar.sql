PRAGMA foreign_keys=ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS Rede;
DROP TABLE IF EXISTS Sessao;
DROP TABLE IF EXISTS Transferencia;
DROP TABLE IF EXISTS Cidade;
DROP TABLE IF EXISTS Pais;
DROP TABLE IF EXISTS Tarifario;
DROP TABLE IF EXISTS Backend;
DROP TABLE IF EXISTS VPS;
DROP TABLE IF EXISTS App;
DROP TABLE IF EXISTS InstanciaVirtual;
DROP TABLE IF EXISTS Armazenamento;
DROP TABLE IF EXISTS Servico;
DROP TABLE IF EXISTS CC;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS GPU;
DROP TABLE IF EXISTS SistemaOperativo;
DROP TABLE IF EXISTS TipoDeDisco;

CREATE TABLE Cliente(email TEXT PRIMARY KEY,
                     password_hash TEXT NOT NULL,
                     nome TEXT NOT NULL,
                     telefone TEXT NOT NULL,
                     morada TEXT NOT NULL,
                     saldo INTEGER NOT NULL DEFAULT 0,
                     CHECK(saldo >= 0));
                     
CREATE TABLE CC(numero CHAR(16) PRIMARY KEY,
                titular TEXT NOT NULL,
                ccv INTERGER NOT NULL,
                rede INTEGER NOT NULL,
                validade DATE NOT NULL,
                cliente TEXT NOT NULL,  
                FOREIGN KEY(cliente) REFERENCES Cliente(email) ON UPDATE CASCADE ON DELETE CASCADE,
                FOREIGN KEY(rede) REFERENCES Rede(id_rede) ON UPDATE CASCADE ON DELETE CASCADE,
                CHECK(ccv BETWEEN 0 AND 1000));

CREATE TABLE Rede(id_rede INTEGER PRIMARY KEY,
                  nome TEXT UNIQUE NOT NULL);

CREATE TABLE Pais(id_pais INTEGER PRIMARY KEY,
                  nome TEXT UNIQUE NOT NULL);
                  
CREATE TABLE Cidade(id_cidade INTEGER PRIMARY KEY,
                    nome TEXT NOT NULL, 
                    pais INTEGER NOT NULL,
                    UNIQUE(nome, pais),
                    FOREIGN KEY(pais) REFERENCES Pais(id_pais) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE Servico(id_serv INTEGER PRIMARY KEY,
                     cliente TEXT NOT NULL,
                     data_inicio DATETIME NOT NULL,
                     data_cancelamento DATETIME DEFAULT NULL,
                     custo_mensal REAL NOT NULL DEFAULT 0.0,
                     cidade INTEGER NOT NULL,
                     UNIQUE(cliente, data_inicio),
                     CONSTRAINT email FOREIGN KEY(cliente) REFERENCES Cliente(email) ON UPDATE CASCADE ON DELETE CASCADE,
                     CONSTRAINT cidade FOREIGN KEY(cidade) REFERENCES Cidade(id_cidade) ON UPDATE CASCADE ON DELETE CASCADE,
                     CHECK(data_cancelamento > data_inicio));

CREATE TABLE Tarifario(id_tarifario INTEGER PRIMARY KEY,
                       limite_tb REAL NOT NULL,
						custo_base REAL NOT NULL,
                       custo_gb_extra REAL NOT NULL,
					   UNIQUE(limite_tb, custo_base, custo_gb_extra),
                       CHECK(limite_tb > 0 AND custo_gb_extra > 0 AND custo_base > 0));
                       
CREATE TABLE TipoDeDisco(id_disco INTEGER PRIMARY KEY,
                         nome TEXT NOT NULL,
						 capacidade INTEGER NOT NULL,
                         custo_mensal REAL NOT NULL,
                         custo_gb_escrito REAL NOT NULL,
						 UNIQUE(nome, capacidade, custo_mensal, custo_gb_escrito),
                         CHECK(capacidade > 0 AND custo_mensal > 0 AND custo_gb_escrito > 0));
                         
CREATE TABLE Armazenamento(servico INTEGER PRIMARY KEY,
                           custo_variavel REAL NOT NULL,
                           custo_fixo REAL NOT NULL,
                           tarifario INTEGER NOT NULL,
                           tipo_disco INTEGER NOT NULL, 
                           FOREIGN KEY(servico) REFERENCES Servico(id_serv) ON UPDATE CASCADE ON DELETE CASCADE,
                           FOREIGN KEY(tarifario) REFERENCES Tarifario(id_tarifario) ON UPDATE CASCADE ON DELETE CASCADE, 
                           FOREIGN KEY(tipo_disco) REFERENCES TipoDeDisco(id_disco) ON UPDATE CASCADE ON DELETE CASCADE,
                           CHECK(custo_variavel >= 0 AND custo_fixo > 0));


CREATE TABLE InstanciaVirtual(servico INTEGER NOT NULL PRIMARY KEY,
                              custo_arranque REAL NOT NULL DEFAULT 0.9,
                              custo_hora REAL NOT NULL DEFAULT 2, 
							  armazenamento INTEGER UNIQUE NOT NULL,
                              FOREIGN KEY(servico) REFERENCES Servico(id_serv) ON UPDATE CASCADE ON DELETE CASCADE,
                              FOREIGN KEY(armazenamento) REFERENCES Armazenamento(servico) ON UPDATE CASCADE ON DELETE CASCADE,
                              CHECK(custo_arranque > 0.0 AND custo_hora > 0.0));
                              
CREATE TABLE Sessao(ins INTEGER NOT NULL,
                    data_abertura DATETIME NOT NULL,
                    data_fecho DATETIME DEFAULT NULL,
                    PRIMARY KEY(ins, data_abertura),
                    FOREIGN KEY(ins) REFERENCES InstanciaVirtual(servico) ON UPDATE CASCADE ON DELETE CASCADE,
                    CHECK(data_fecho > data_abertura));
                              
CREATE TABLE Backend(id_backend INTEGER PRIMARY KEY,
                     nome TEXT NOT NULL,
                     major INTEGER NOT NULL,
                     minor INTEGER NOT NULL,
                     custo_hora REAL NOT NULL,
                     UNIQUE(nome, major, minor),
                     CHECK(custo_hora >= 0.0));
                     
CREATE TABLE App(servico INTERGER PRIMARY KEY,
                 num_instancias INTEGER NOT NULL DEFAULT 1,
                 backend INTEGER NOT NULL,
				 FOREIGN KEY(servico) REFERENCES InstanciaVirtual(servico) ON UPDATE CASCADE ON DELETE CASCADE,
                 FOREIGN KEY(backend) REFERENCES Backend(id_backend) ON UPDATE CASCADE ON DELETE CASCADE,
                 CHECK(num_instancias > 0));
                 
CREATE TABLE GPU(id_gpu INTEGER PRIMARY KEY,
                 vendor TEXT NOT NULL,
                 modelo TEXT NOT NULL,
                 version INTEGER NOT NULL,
                 custo_hora REAL NOT NULL,
                 UNIQUE(vendor, modelo, version),
                 CHECK(custo_hora > 0.0));
                 
CREATE TABLE SistemaOperativo(id_so INTEGER PRIMARY KEY,
                              nome TEXT NOT NULL,
                              flavor TEXT NOT NULL,
                              version INTEGER NOT NULL,
                              custo_hora REAL NOT NULL,
                              UNIQUE(nome, flavor, version),
                              CHECK(custo_hora >= 0.0));
                              
CREATE TABLE VPS(servico INTEGER PRIMARY KEY,
                 num_cores INTEGER NOT NULL,
                 num_ram INTEGER NOT NULL, 
                 so INTEGER NOT NULL,
                 gpu INTEGER DEFAULT NULL,
                 CONSTRAINT instancia FOREIGN KEY(servico) REFERENCES InstanciaVirtual(servico) ON UPDATE CASCADE ON DELETE CASCADE,
                 CONSTRAINT sistema FOREIGN KEY(so) REFERENCES SistemaOperativo(id_so) ON UPDATE CASCADE ON DELETE CASCADE,
                 CONSTRAINT placa FOREIGN KEY(gpu) REFERENCES GPU(id_gpu) ON UPDATE CASCADE ON DELETE CASCADE,
                 CHECK(num_cores > 0 AND num_ram > 0 AND (num_ram/num_cores) <= 8.0));
                 
CREATE TABLE Transferencia(nome_ficheiro TEXT NOT NULL,
                           tamanho UNSIGNED NOT NULL, 
                           b_leitura INTEGER NOT NULL, 
                           data DATETIME NOT NULL, 
                           armazenamento INTEGER NOT NULL,
                           PRIMARY KEY(armazenamento, data),
                           FOREIGN KEY(armazenamento) REFERENCES Armazenamento(servico) ON UPDATE CASCADE ON DELETE CASCADE,
                           CHECK(tamanho > 0));
                           
                           
COMMIT;
