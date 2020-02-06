--QUERY das apps a correr backend BACK entre versoes X.y  e W.z
--DUVIDA de x <= y <= z
.mode    columns
.headers    on
.nullvalue    NULL

SELECT DISTINCT cliente FROM
(SELECT id_backend FROM Backend WHERE nome=BACK AND (X <= major AND major <= W) AND (
		(X < major AND major < W) OR (major = X AND minor >= y) OR (major = W AND minor <= z)) 
		) INNER JOIN App 
ON id_backend = backend
INNER JOIN Servico
ON servico = id_serv
WHERE data_cancelamento IS NULL;


SELECT DISTINCT cliente FROM
(SELECT id_backend FROM Backend WHERE nome=BACK AND (major+minor/10.0) BETWEEN X.y AND W.z
		) INNER JOIN App 
ON id_backend = backend
INNER JOIN Servico
ON servico = id_serv
WHERE data_cancelamento IS NULL;