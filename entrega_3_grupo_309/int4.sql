--QUERY do tempo medio que cada utilizador corre instancia virtual
.mode    columns
.headers    on
.nullvalue    NULL

SELECT cliente, Cast(Avg(data_fecho-data_abertura) as int) as tempo_corrido FROM
Sessao INNER JOIN Servico
ON ins=id_serv
WHERE data_fecho IS NOT NULL
GROUP BY cliente;