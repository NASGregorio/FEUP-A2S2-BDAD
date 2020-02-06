--QUERY rede da qual maior numero de pessoas se inscrevem para servico
.mode    columns
.headers    on
.nullvalue    NULL

SELECT id_rede, Count(*) as cont FROM
(SELECT DISTINCT cliente FROM Servico)
NATURAL JOIN CC
INNER JOIN Rede
ON id_rede = rede
GROUP BY rede
ORDER BY cont DESC LIMIT 1;