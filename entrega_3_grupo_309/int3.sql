--QUERY da cidade por pais com maior numero de servicos a correr
.mode    columns
.headers    on
.nullvalue    NULL

SELECT Pais.nome, cidade_nome, numero FROM
(SELECT
 pais,
 COUNT(id_serv) as numero, Cidade.nome as cidade_nome
FROM
 Servico INNER JOIN Cidade ON cidade = id_cidade
WHERE data_cancelamento IS NOT NULL
GROUP BY
 cidade) INNER JOIN Pais
ON id_pais=pais
GROUP BY id_pais
HAVING Max(numero);