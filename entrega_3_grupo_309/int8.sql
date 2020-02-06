--QUERY PRECO MEDIA QUE CADA UTILIZADOR PARA POR ARMAZENAMENTO de capacidade entre X e Y
.mode    columns
.headers    on
.nullvalue    NULL

SELECT Avg(Servico.custo_mensal) FROM
TipoDeDisco
INNER JOIN Armazenamento
ON id_disco = tipo_disco
INNER JOIN Servico
ON  servico = id_serv
WHERE data_cancelamento IS NOT NULL AND capacidade BETWEEN X AND Y;

SELECT Avg(custo_mensal) FROM
(SELECT id_disco, capacidade FROM TipoDeDisco
WHERE capacidade BETWEEN X AND Y)
INNER JOIN Armazenamento
ON id_disco = tipo_disco
INNER JOIN Servico
ON  servico = id_serv
WHERE data_cancelamento IS NOT NULL;