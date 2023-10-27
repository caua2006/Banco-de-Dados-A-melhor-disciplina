---1---------------------------------
create trigger after_Cliente_insert 
 after insert on Clientes
  FOR EACH row
  insert into Auditoria (mensagem, data_hora) values ('Novo Cliente', now());

----2-----------------------
 create trigger before_Cliente_delete
  before delete on Clientes
  for each row
  insert into Auditoria
  set action = 'Delete',
  nome = old.nome;

-----3------------------------
create trigger after_cliente_update
  after update on Clientes
  for each row
  insert into Auditoria
  set action = 'Update',
  old.nome = new.nome;
