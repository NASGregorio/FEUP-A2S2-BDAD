INSERT INTO Servico(cliente, data_inicio, cidade) VALUES ('williamnichols.each@fe.up.pt', strftime('%s', 'now'), 1);
INSERT INTO Armazenamento VALUES ((SELECT Max(id_serv) FROM Servico), 1, 1, 1, 1);

SELECT CASE cast(custo_fixo as TEXT)
		WHEN '39.66'
		THEN 'CORRETO 1'
		ELSE 'ERRADO 1'
		END coiso
		FROM Armazenamento
		WHERE (Armazenamento.servico in (SELECT Max(Armazenamento.servico) FROM Armazenamento));
		
SELECT CASE cast(custo_mensal as TEXT)
		WHEN '39.66'
		THEN 'CORRETO 2'
		ELSE 'ERRADO 2'
		END coiso
		FROM Servico
		WHERE (Servico.id_serv in (SELECT Max(Servico.id_serv) FROM Servico));