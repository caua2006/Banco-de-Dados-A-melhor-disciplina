delimiter //
-- Atividade 1
create procedure sp_ListarAutores()
begin 
	select * from autor;
end;
//
call sp_ListarAutores();