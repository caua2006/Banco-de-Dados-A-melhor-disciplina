-- 1. Função para Contagem de Livros por Gênero -------------------------------------------------------------------------------
delimiter //

create function total_livros_por_genero( p_nome_Genero varchar(255)) returns int deterministic
begin
	DECLARE done_loop int default 0;
    DECLARE id_livro_genero int;
	
    declare p_qnt_livro_por_genero int default 0;
    DECLARE cursor_livros CURSOR FOR select genero.id 
    from genero 
    inner join livro on livro.id_genero = genero.id 
    where nome_genero = p_nome_Genero;
    declare continue handler for not found set done_loop = 1;
    
    
	open cursor_livros;
    
    while(done_loop != 1) do
		fetch cursor_livros into id_livro_genero;
		set p_qnt_livro_por_genero = p_qnt_livro_por_genero + 1;
        if done_loop != 0 then
			set p_qnt_livro_por_genero = p_qnt_livro_por_genero - 1;
        end if;
    end while;
    
    close cursor_livros;
    return p_qnt_livro_por_genero;
end;
//

delimiter ;

select total_livros_por_genero('Romance');

-- 2. Função para Listar Livros de um Autor Específico ------------------------------------------------------------------------
delimiter //

create procedure listar_livros_por_autor( p_primeiro_nome varchar(255),p_segundo_nome varchar(255))
begin
	DECLARE done_loop int default 0;
    declare v_id_autor int;
    declare v_id_autor_cursor int;
    declare v_id_livro int;
    declare titulo_livro varchar(255);
    
    
    DECLARE cursor_livros_autor CURSOR FOR select id_autor, id_livro from livro_autor;
    declare continue handler for not found set done_loop = 1;
    drop table temp_table;
    create temporary table if not exists temp_table (titulo_livro VARCHAR(255));
    select id into v_id_autor from autor where primeiro_nome = p_primeiro_nome and ultimo_nome = p_segundo_nome;
    open cursor_livros_autor;
    while(done_loop != 1) do
		fetch cursor_livros_autor into v_id_autor_cursor, v_id_livro;
		 if v_id_autor = v_id_autor_cursor then
			select titulo into titulo_livro from livro where id = v_id_livro;
			insert into temp_table values(titulo_livro);
        end if;
    end while;
    close cursor_livros_autor;
    select * from temp_table;
end;
//

delimiter ;

call listar_livros_por_autor('Maria','Fernandes');



    
-- 3. Função para Atualizar Resumos de Livros    ------------------------------------------------------------------------
delimiter //
create function atualizar_resumos () returns varchar(255) deterministic
begin 
	DECLARE done_loop int default 0;
    declare id_for_book_cursor int;
    declare v_resumo_for_book text;
    declare cursor_update_resumos_livros cursor for select id, resumo from livro;
    declare continue handler for not found set done_loop = 1;
    open cursor_update_resumos_livros;
    while(done_loop != 1)do
		fetch cursor_update_resumos_livros into id_for_book_cursor, v_resumo_for_book;
        update livro set resumo = CONCAT(v_resumo_for_book, " Este é um excelente livro!") where id = id_for_book_cursor;
    end while;
    close cursor_update_resumos_livros;
    return "Atualizado";
end;
//
delimiter ;
select atualizar_resumos();
select resumo from livro;



-- 4. Função para Obter a Média de Livros por Editora   ------------------------------------------------------------------------
delimiter //
create function media_livros_por_editora() returns float deterministic
begin
	DECLARE done_loop int default 0;
    declare v_id_editora int;
    declare v_total_editora int default 0;
    declare total_livros int default 0;
    declare qnt_livro_for_editora int;
    
    declare cursor_id_editora cursor for select id from editora;
    declare continue handler for not found set done_loop = 1;
    open cursor_id_editora;
    while(done_loop != 1)do
		fetch cursor_id_editora into v_id_editora;
        set v_total_editora = v_total_editora + 1;
        
        select count(livro.id) into qnt_livro_for_editora from livro inner join editora on livro.id_editora = editora.id where id_editora = v_id_editora;
        set total_livros = total_livros + qnt_livro_for_editora;
        if done_loop != 0 then
			set total_livros = total_livros - qnt_livro_for_editora;
            set v_total_editora = v_total_editora - 1;
			return round(total_livros/v_total_editora,2);
            end if;
    end while;
    close cursor_id_editora;
end;
//
delimiter ;

select media_livros_por_editora();
--  5. Função para Listar Autores sem Livros Publicados -------------------------------------------------------------------------
delimiter //
create procedure autores_sem_livros ()
begin
	DECLARE done_loop int default 0;
    declare v_id_autor int;
    declare v_livro int;
    declare v_primeiro_nome varchar(255);
    declare v_ultimo_nome varchar(255);
    
    declare cursor_id_autor cursor for select id from autor;
    declare continue handler for not found set done_loop = 1;
    drop table temp_table;
    create temporary table if not exists temp_table ( primeiro_nome VARCHAR(255) default "Todo os autores tem livros",ultimo_nome VARCHAR(255));
    open cursor_id_autor;
    while(done_loop != 1)do
		fetch cursor_id_autor into v_id_autor;
        select count(id_livro) into v_livro from livro_autor where id_autor = v_id_autor;
        if v_livro <=> 0 then
			select primeiro_nome,ultimo_nome into v_primeiro_nome ,v_ultimo_nome from autor where id = v_id_autor;
			if not exists(select primeiro_nome,ultimo_nome from temp_table where primeiro_nome = v_primeiro_nome and ultimo_nome = v_ultimo_nome)
            then 
				insert into temp_table values(v_primeiro_nome ,v_ultimo_nome);
            end if;
        end if;
    end while;
    close cursor_id_autor;
    select * from temp_table;
end;
//
delimiter ;
call autores_sem_livros ();








