DROP TRIGGER IF EXISTS CC_Remove;

CREATE TRIGGER IF NOT EXISTS CC_Remove
   AFTER DELETE
   ON CC
   FOR EACH ROW
   WHEN NOT EXISTS (SELECT * FROM CC Where CC.cliente = OLD.cliente) AND (SELECT saldo FROM Cliente WHERE email=OLD.cliente)=0
BEGIN
	UPDATE Servico
	SET data_cancelamento = strftime('%s', 'now')
	WHERE (Servico.cliente = OLD.cliente AND data_cancelamento IS NULL);
	
	UPDATE Sessao
	SET data_fecho = strftime('%s', 'now')
	WHERE (Sessao.ins in (SELECT id_serv FROM Servico WHERE Servico.cliente = OLD.cliente) AND data_fecho IS NULL);
END;