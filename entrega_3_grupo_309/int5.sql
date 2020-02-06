--QUERY dos utilizadores com servico ativo no pais PAIS
.mode    columns
.headers    on
.nullvalue    NULL

SELECT DISTINCT cliente FROM
Pais INNER JOIN Cidade
ON (id_pais = pais and Pais.nome = PAIS)
INNER JOIN Servico
ON cidade=id_cidade
WHERE data_cancelamento IS NULL;