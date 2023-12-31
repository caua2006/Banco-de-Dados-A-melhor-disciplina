create database exercicio_fixacao;
use exercicio_fixacao;
-- 1) Funções de String: ----------------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
create table nomes(
	nome varchar(100)
);
insert into nomes values("Roberta"),("Roberto"),("Maria Clara"),("João");
-- b) -------------------------------------------------------------------------------------------------------------------
select upper(nome) from nomes;
-- c) -------------------------------------------------------------------------------------------------------------------
SELECT 
    LENGTH(nome)
FROM
    nomes;
-- d) -------------------------------------------------------------------------------------------------------------------
SELECT 
    CASE
        WHEN nome LIKE '%a' THEN CONCAT('Sra.', nome)
        ELSE CONCAT('Sr.', nome)
    END AS Sra_ou_Sr
FROM nomes;


-- 2) Funções Numéricas: ----------------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------

create table produtos(
	id_produto int auto_increment primary key,
	produto varchar(100),
    preco float,
    quantidade integer
);
insert into produtos(produto,preco,quantidade) values("Jordan 4",1234.89,56),("Lebron 13",899.99,90),("CJR IV MVP",3000.00,15),("Jordan 36",699.99,49);
select * from produtos;
-- b) -------------------------------------------------------------------------------------------------------------------
select round(preco,2) from produtos;
-- c) -------------------------------------------------------------------------------------------------------------------
select abs(quantidade) from produtos;
-- d) -------------------------------------------------------------------------------------------------------------------
select round(avg(preco),2) from produtos;

-- 3) Funções de Data: -------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
create table eventos(
	data_evento datetime
);
insert into eventos values("2022-03-16 23:26:55");
select * from eventos;
-- b) -------------------------------------------------------------------------------------------------------------------
insert into eventos values(now());
-- c) -------------------------------------------------------------------------------------------------------------------
select datediff(now(),"2006-08-12");
-- d) ------------------------------------------------------------------------------------------------------------------
select dayname(data_evento) from eventos;

-- 4) Funções de Controle de Fluxo: -------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
select IF(quantidade < 1,"Fora de estoque","Em estoque") from produtos;
-- b) -------------------------------------------------------------------------------------------------------------------
SELECT 
    CASE
        WHEN preco < 800 THEN "Barato"
        WHEN preco > 800 && preco < 1300 THEN "Médio" 
        ELSE  "Caro"
    END AS Classificacao
FROM produtos;
-- 5)  Função Personalizada: -------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
delimiter //
create function TOTAL_VALOR( preco float,  qnt_produto integer) returns float deterministic
begin
	return round(preco * qnt_produto,2);
end;
//
delimiter ;
select TOTAL_VALOR(100,90);
-- b) -------------------------------------------------------------------------------------------------------------------
select * from produtos;
call TOTAL_VALOR(1234.89,56);
call TOTAL_VALOR(899.99,90);
call TOTAL_VALOR(3000,15);
call TOTAL_VALOR(699.99,49);

-- 6) Funções de Agregação: -------------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
select count(produto) from produtos;
-- b) -------------------------------------------------------------------------------------------------------------------
select max(preco) from produtos;
-- c) -------------------------------------------------------------------------------------------------------------------
select min(preco) from produtos;
-- d) -------------------------------------------------------------------------------------------------------------------
select sum(IF(quantidade < 50,"Fora de estoque",quantidade))  from produtos;

-- 7) Funções de Agregação: ----------------------------------------------------------------------------------------------

-- a) -------------------------------------------------------------------------------------------------------------------
delimiter //
create function FATORIAL_NUM(num_user bigint) returns bigint deterministic
begin
	declare fatorial_num_user bigint default num_user;
    fatorial_loop: LOOP
		set fatorial_num_user = fatorial_num_user * (num_user - 1);
        set num_user = num_user - 1;
        if num_user = 1 then return fatorial_num_user; 
        leave fatorial_loop;
        end if;
    END LOOP fatorial_loop;
    
end;
//
delimiter ;
select FATORIAL_NUM(5);
-- b) -------------------------------------------------------------------------------------------------------------------
delimiter //
create function f_exponencial( num_1 int, num_2 int) returns int deterministic
begin
	return power(num_1,num_2);
end;
//
delimiter ;
select f_exponencial(3,4);
-- c) -------------------------------------------------------------------------------------------------------------------
delimiter //
create function sp_isPalindromo(word varchar(100)) returns boolean deterministic
begin
	return if(lower(word) = lower(reverse(word)),true,false);
end;
//
delimiter ;
drop procedure sp_isPalindromo;
select sp_isPalindromo('Roma é amor');








