--QUERY dos utilizadores que ultrapassam limites do tarifario
.mode    columns
.headers    on
.nullvalue    NULL


SELECT cliente FROM
Servico INNER JOIN Transferencia
ON armazenamento = id_serv
INNER JOIN Armazenamento
ON armazenamento = servico
INNER JOIN Tarifario
ON tarifario=id_tarifario
WHERE data BETWEEN DATA_INCIO and DATA_INICIO+30*24*3600
GROUP BY cliente
HAVING Sum(tamanho) > limite_tb*1024;