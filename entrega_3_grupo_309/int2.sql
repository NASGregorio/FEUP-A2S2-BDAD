--QUERY dos paises com datacenters a correr todas as versoes de NOME_BACKEND
.mode    columns
.headers    on
.nullvalue    NULL

SELECT id_pais, nome_pais FROM
(Select DISTINCT App.backend as id_back, Cidade.pais as id_pais, Pais.nome as nome_pais FROM App
	INNER JOIN Servico
	ON App.servico = Servico.id_serv
	INNER JOIN Cidade
	ON Servico.cidade = Cidade.id_cidade
	INNER JOIN Pais
	ON Cidade.pais = Pais.id_pais
	WHERE App.backend IN (SELECT id_backend FROM Backend WHERE nome = NOME_BACKEND))
	GROUP BY id_pais
	HAVING Count(id_back) = (SELECT Count(*) FROM Backend WHERE nome = NOME_BACKEND);