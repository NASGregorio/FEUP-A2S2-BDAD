DROP TRIGGER IF EXISTS Block_NoFunds_Servico;

CREATE TRIGGER IF NOT EXISTS Block_NoFunds_Servico
   BEFORE INSERT
   ON Servico
   FOR EACH ROW
   WHEN (SELECT saldo FROM Cliente WHERE email=NEW.cliente)=0 AND (SELECT COUNT(*) FROM CC WHERE CC.cliente = NEW.cliente)=0
BEGIN
	SELECT raise(rollback, 'No funds to start the service, add a CC');
END;