--QUERY DOS UTILIZADORES QUE NAO UTILIZAM SERVICO HA x DIAS
.mode    columns
.headers    on
.nullvalue    NULL

SELECT cliente, Round((strftime('%s', 'now')-Max(data_cancelamento))/(24.0*3600.0), 2) as dias_sem_utilizar FROM Servico 
WHERE cliente NOT IN (SELECT cliente FROM Servico WHERE data_cancelamento IS NULL)
GROUP BY cliente
HAVING (strftime('%s', 'now')-Max(data_cancelamento))>DIAS_SEM_UTILIZAR*24*3600;