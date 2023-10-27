-- 1 Crie um trigger que, após inserir um novo cliente na tabela Clientes, insira uma mensagem na tabela Auditoria informando a data e hora da inserção.
create trigger after_Cliente_insert 
 after insert on Clientes
  FOR EACH row
  insert into Auditoria (mensagem, data_hora) values ('Novo Cliente', now());

-- 2 Antes de excluir um cliente da tabela Clientes, crie um trigger que insira uma mensagem na tabela Auditoria informando sobre a tentativa de exclusão.
 create trigger before_Cliente_delete
  before delete on Clientes
  for each row
  insert into Auditoria
  set action = 'Delete',
  nome = old.nome;

-- 3 Após atualizar o nome de um cliente na tabela Clientes, insira uma mensagem na tabela Auditoria mostrando o nome antigo e o novo nome.
create trigger after_cliente_update
  after update on Clientes
  for each row
  insert into Auditoria
  set action = 'Update',
  old.nome = new.nome;

delimiter $$
-- 4 Não permita que o nome do cliente seja atualizado para uma string vazia ou NULL. Se alguém tentar fazer isso, o trigger deve impedir a atualização e inserir uma mensagem na tabela Auditoria.
CREATE TRIGGER before_cliente_update
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
  IF NEW.nome IS NULL OR NEW.nome = '' THEN
     INSERT INTO Auditoria
    SET mensagem = 'erro';
  ELSE
    INSERT INTO Auditoria (action, mensagem, data_hora)
    VALUES ('Update', 'Nome atualizado', NOW());
  END IF;
END;
$$
delimiter ;
-- 5 Em uma loja, ao inserir um novo pedido na tabela Pedidos, o estoque do produto em questão, presente na tabela Produtos, deve ser decrementado. Se o estoque ficar abaixo de 5 unidades, uma mensagem deve ser inserida na tabela Auditoria.
delimiter $$
create trigger after_pedido_insert
after insert on Pedidos
for each row
begin
 UPDATE Produtos
  SET estoque = estoque - quantidade
   WHERE produto_id = NEW.produto_id;
  IF (SELECT estoque FROM Produtos WHERE produto_id = NEW.produto_id) < 5 THEN
    
INSERT INTO Auditoria (mensagem, data_hora) 
    VALUES ('Estoque baixo para o produto ' || NEW.produto_id, NOW());
  END IF;

end;
$$
delimiter ;
