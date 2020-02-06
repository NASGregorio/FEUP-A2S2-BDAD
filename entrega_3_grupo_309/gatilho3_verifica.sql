SELECT custo_fixo FROM Armazenamento WHERE tarifario=1 LIMIT 1;

UPDATE Tarifario
	SET
		custo_base = (SELECT custo_base FROM Tarifario WHERE id_tarifario = 1)+1
	WHERE id_tarifario=1;
	
SELECT custo_fixo FROM Armazenamento WHERE tarifario=1 LIMIT 1;
