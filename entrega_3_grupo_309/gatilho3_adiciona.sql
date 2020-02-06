DROP TRIGGER IF EXISTS AtualizaPreco_Tarifario;

CREATE TRIGGER IF NOT EXISTS AtualizaPreco_Tarifario
   AFTER UPDATE
   ON Tarifario
   FOR EACH ROW
BEGIN
	UPDATE Armazenamento
	SET custo_fixo = NEW.custo_base + (SELECT custo_mensal FROM TipoDeDisco WHERE id_disco=Armazenamento.tipo_disco)
	WHERE (Armazenamento.tarifario = NEW.id_tarifario);
	
	UPDATE Servico
	SET custo_mensal = (SELECT custo_fixo FROM Armazenamento WHERE Armazenamento.servico = Servico.id_serv)
	WHERE Servico.id_serv IN (SELECT servico FROM Armazenamento WHERE Armazenamento.tarifario=NEW.id_tarifario);
END;