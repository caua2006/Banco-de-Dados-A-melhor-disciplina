-- Atividade 1
select titulo from livros;


-- Atividade 2
select nome from autores where nascimento < '1900-01-01';  


-- Atividade 3
select livros.titulo, autores.nome 
from livros 
inner join autores on livros.autor_id = autores.id
where autores.nome ='J.K. Rowling'; 

-- Atividade 4
select matriculas.curso, alunos.nome from matriculas 
inner join alunos on matriculas.aluno_id = alunos.id
where matriculas.curso = 'Engenharia de Software';

-- Atividade 5
select produto, sum(receita) as receitas_total 
from vendas 
group by produto;

-- Atividade 6
select nome, count(livros.autor_id) as livros_total_autor 
from autores 
inner join livros on autores.id = livros.autor_id 
group by nome;

-- Atividade 7
select curso, count(aluno_id) as alunos_curso 
from matriculas 
inner join alunos on alunos.id = matriculas.aluno_id 
group by curso;
