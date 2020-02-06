SELECT Count(*) FROM Servico
WHERE Servico.cliente IN
(SELECT email FROM
Cliente INNER JOIN CC
ON email=cliente
WHERE saldo == 0
GROUP BY email
HAVING COUNT(*)=1) AND data_cancelamento IS NULL;

DELETE FROM CC WHERE cliente = 'michellerodriguez.represent@fe.up.pt';

SELECT Count(*) FROM Servico
WHERE Servico.cliente IN
(SELECT email FROM
Cliente INNER JOIN CC
ON email=cliente
WHERE saldo == 0
GROUP BY email
HAVING COUNT(*)=1) AND data_cancelamento IS NULL;