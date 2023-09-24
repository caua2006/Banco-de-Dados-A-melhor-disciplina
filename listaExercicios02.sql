delimiter //
-- Atividade 1
create procedure sp_ListarAutores()
begin 
	select * from autor;
end;
//
call sp_ListarAutores();

-- Atividade 2
create procedure sp_LivrosPorCategoria(in nomeCategoria varchar(100))
begin
	declare id_categoria int;
    select Categoria_ID into id_categoria from categoria where nomeCategoria = nome;
	select * from livro where Categoria_ID = id_categoria;
end;
//

call sp_LivrosPorCategoria('Autoajuda');
//

-- Atividade 3
create procedure sp_ContarLivrosPorCategoria(in nomeCategoria varchar(100))
begin
	declare id_categoria int;
    select Categoria_ID into id_categoria from categoria where nomeCategoria = nome;
	select count(Categoria_ID) as QuantidadesLivros from livro where Categoria_ID = id_categoria group by Categoria_ID;
end;
//
call sp_ContarLivrosPorCategoria('Ciência');
//
-- Atividade 4
create procedure sp_VerificarLivrosCategoria(in nome_categoria varchar(100))
begin
	declare id_categoria int;
    declare qnt_livros_categorias int;
    declare livro_existente varchar(100);
    
    select Categoria_ID into id_categoria from categoria where nome_categoria = nome;
    select count(Categoria_ID) into qnt_livros_categorias from livro where Categoria_ID = id_categoria group by Categoria_ID;
    if qnt_livros_categorias = 0 then 
		 set livro_existente = 'Categoria não possui livros';
	elseif qnt_livros_categorias > 0 then
		 set livro_existente = 'Categoria possui livros';
    end if;
        select livro_existente;
end;
//
-- drop procedure sp_VerificarLivrosCategoria//
call sp_VerificarLivrosCategoria('Ciência')//

delimiter ;