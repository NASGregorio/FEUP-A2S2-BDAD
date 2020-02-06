DROP TRIGGER IF EXISTS Armazenamento_custo;

CREATE TRIGGER IF NOT EXISTS Armazenamento_custo
   AFTER INSERT
   ON Armazenamento
   FOR EACH ROW
BEGIN
	UPDATE Armazenamento
	SET custo_fixo = (SELECT custo_base FROM Tarifario WHERE id_tarifario=NEW.tarifario) + (SELECT custo_mensal FROM TipoDeDisco WHERE id_disco=NEW.tipo_disco)
	WHERE (Armazenamento.servico = NEW.servico);
	
	Update Servico
	SET custo_mensal = (SELECT custo_fixo FROM Armazenamento WHERE servico = NEW.servico)
	WHERE (Servico.id_serv = NEW.servico);
END;