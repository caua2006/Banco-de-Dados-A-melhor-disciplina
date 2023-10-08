delimiter //
create procedure total_livros_por_genero(in nome_Genero varchar(255))
begin
	DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE qnt_livro int;
    declare nome_livro varchar(255);
    declare nomeGenero varchar(255);
	
    DECLARE cursor_livros CURSOR FOR select genero.id, nome_genero, titulo 
    from genero 
    inner join livro on livro.id_genero = genero.id 
    where nome_genero = nome_Genero;
   open cursor_livros;
    fetch_loop: LOOP
		fetch cursor_livros into qnt_livro ,nomeGenero, nome_livro;
		IF done THEN
			LEAVE fetch_loop;
		END IF;
        select qnt_livro ,nomeGenero, nome_livro;
	END LOOP fetch_loop;
    close cursor_livros;

    
end;
//
delimiter ;
drop procedure total_livros_por_genero;
call total_livros_por_genero('Ficção Científica');

select genero.id, nome_genero, titulo from genero inner join livro on livro.id_genero = genero.id where nome_genero = 'Ficção Científica';



