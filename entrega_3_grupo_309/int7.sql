--QUERY todos os utilizadores que fizeram mais de X transferencias num dado periodo de tempo
--DUVIDA de x <= y <= z
.mode    columns
.headers    on
.nullvalue    NULL

SELECT cliente FROM
Transferencia INNER JOIN Servico
ON armazenamento=id_serv
WHERE data BETEWEEN MIN_DATA and MAX_DATA
GROUP BY cliente
HAVING COUNT(*) > X;