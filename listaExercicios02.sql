delimiter //
-- Atividade 1 -----------------------------------------------------------------------------------------------
create procedure sp_ListarAutores()
begin 
	select * from autor;
end;
//
call sp_ListarAutores();
//
-- Atividade 2 -----------------------------------------------------------------------------------------------
create procedure sp_LivrosPorCategoria(in nomeCategoria varchar(100))
begin
	declare id_categoria int;
    select Categoria_ID into id_categoria from categoria where nomeCategoria = nome;
	select * from livro where Categoria_ID = id_categoria;
end;
//

call sp_LivrosPorCategoria('Autoajuda');
//

-- Atividade 3 -----------------------------------------------------------------------------------------------
create procedure sp_ContarLivrosPorCategoria(in nomeCategoria varchar(100))
begin
	declare id_categoria int;
    select Categoria_ID into id_categoria from categoria where nomeCategoria = nome;
	select count(Categoria_ID) as QuantidadesLivros from livro where Categoria_ID = id_categoria group by Categoria_ID;
end;
//
call sp_ContarLivrosPorCategoria('Ciência');
//
-- Atividade 4 -----------------------------------------------------------------------------------------------
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
-- Atividade 5 -----------------------------------------------------------------------------------------------
create procedure sp_LivrosAteAno(in ano int)
begin
	 select Titulo, Ano_Publicacao from livro where Ano_Publicacao <= ano order by Ano_Publicacao;
end;
//
call sp_LivrosAteAno(1999)//

-- Atividade 6 -----------------------------------------------------------------------------------------------
create procedure sp_TitulosPorCategoria(in nomeCategoria varchar(100))
begin
	declare id_categoria int;
    select Categoria_ID into id_categoria from categoria where nomeCategoria = nome;
	select Titulo from livro where Categoria_ID = id_categoria;
end;
//
call sp_TitulosPorCategoria('Romance')//

-- Atividade  7-----------------------------------------------------------------------------------------------
create procedure sp_AdicionarLivro(in nome_livro varchar(100),in editora_id int, in ano_publicacao int,in n_paginas int , in categoria_id int)
begin
	declare id_livro int default 1;
    declare Livro_nao_repetido boolean default true;
    declare Titulo_livro varchar(255);
    declare qnt_livros int;
    declare msg_erro varchar(200);
    select count(*) into qnt_livros from livro;
    
    
	while Livro_nao_repetido and id_livro <= qnt_livros   DO 
		select Titulo into Titulo_livro from livro where Livro_ID = id_livro;
        if nome_livro = Titulo_livro or editora_id > 2  then
			set Livro_nao_repetido = false;
            set msg_erro = "Titulo do livro repetido ou ID da editora inserido errado";
            select msg_erro;
		else
			set id_livro = id_livro + 1;
		end if;
			
	end while;
    if Livro_nao_repetido then 
		insert into livro values(qnt_livros + 1 ,nome_livro, editora_id ,  ano_publicacao , n_paginas  ,  categoria_id ) ;
    end if;
    
		
end;
//
-- drop procedure sp_AdicionarLivro;
call sp_AdicionarLivro('Lebron James', 2,2023,456,2)//
-- Atividade  8 -----------------------------------------------------------------------------------------------
create procedure sp_AutorMaisAntigo()
begin
	select Nome, Sobrenome from autor order by Data_Nascimento limit 1;
end;
//
-- drop procedure sp_AutorMaisAntigo;
call sp_AutorMaisAntigo()//
delimiter ;