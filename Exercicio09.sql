CREATE TABLE Editora (
Codigo INT IDENTITY PRIMARY KEY,
Nome VARCHAR(100) NOT NULL UNIQUE,
Site_editora VARCHAR(100));

INSERT INTO Editora VALUES('Pearson','www.pearson.com.br');
INSERT INTO Editora VALUES('CivilizaçãoBrasileira',NULL);	
INSERT INTO Editora VALUES('Makron Books','www.mbooks.com.br');
INSERT INTO Editora VALUES('LTC','www.ltceditora.com.br');
INSERT INTO Editora VALUES('Atual','www.atualeditora.com.br');
INSERT INTO Editora VALUES('Moderna','www.moderna.com.br');

CREATE TABLE Autor (
Codigo INT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Biografia VARCHAR(200) NOT NULL);

INSERT INTO Autor VALUES(101,'Andrew Tannenbaun','Desenvolvedor do Minix');
INSERT INTO Autor VALUES(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil');
INSERT INTO Autor VALUES(103,'Diva Marília','Flemming	Professora adjunta da UFSC');
INSERT INTO Autor VALUES(104,'David Halliday','Ph.D. da University of Pittsburgh');
INSERT INTO Autor VALUES(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS');
INSERT INTO Autor VALUES(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem');
INSERT INTO Autor VALUES(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT');
INSERT INTO Autor VALUES(108,'Carlos Morimoto','Criador do Kurumin Linux');

CREATE TABLE Estoque (
Codigo INT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL UNIQUE,
Quantidade INT NOT NULL,
Valor NUMERIC(11,2) CHECK (Valor > 0),
Cod_Editora INT NOT NULL,
Cod_Autor INT NOT NULL

FOREIGN KEY (Cod_Editora) REFERENCES Editora(Codigo),
FOREIGN KEY (Cod_Autor) REFERENCES Autor(Codigo));

INSERT INTO Estoque VALUES(10001,'Sistemas Operacionais Modernos',4,108.00,1,101);
INSERT INTO Estoque VALUES(10002,'A Arte da Política',2,55.00,2,102);
INSERT INTO Estoque VALUES(10003,'Calculo A',12,79.00,3,103);
INSERT INTO Estoque VALUES(10004,'Fundamentos de Física I',26,68.00,4,104);
INSERT INTO Estoque VALUES(10005,'Geometria Analítica',1,95.00,3,105);
INSERT INTO Estoque VALUES(10006,'Gramática Reflexiva',10,49.00,5,106);
INSERT INTO Estoque VALUES(10007,'Fundamentos de Física III',1,78.00,4,104);
INSERT INTO Estoque VALUES(10008,'Calculo B',3,95.00,3,103);


CREATE TABLE Compras (
Codigo INT NOT NULL,
Cod_Livro INT NOT NULL,
Quantidade INT NOT NULL CHECK (Quantidade > 0),
Valor NUMERIC(11,2) CHECK (Valor > 0),
Data_Compra Date
PRIMARY KEY (Codigo,Cod_Livro)
FOREIGN KEY (Cod_Livro) REFERENCES Estoque(Codigo));

INSERT INTO Compras VALUES(15051,10003,2,158.00,'07-04-2020');
INSERT INTO Compras VALUES(15051,10008,1,95.00,'07-04-2020');
INSERT INTO Compras VALUES(15051,10004,1,68.00,'07-04-2020');
INSERT INTO Compras VALUES(15051,10007,1,78.00,'07-04-2020');
INSERT INTO Compras VALUES(15052,10006,1,49.00,'07-05-2020');
INSERT INTO Compras VALUES(15052,10002,3,165.00,'07-05-2020');
INSERT INTO Compras VALUES(15053,10001,1,108.00,'07-05-2020');
INSERT INTO Compras VALUES(15054,10003,1,79.00,'08-06-2020');
INSERT INTO Compras VALUES(15054,10008,1,95.00,'08-06-2020');

SELECT DISTINCT(L.Nome) as Livro, L.Valor, E.Nome as Editora, A.Nome as Autor
FROM Estoque L
INNER JOIN Autor A ON (A.Codigo = L.Cod_Autor)
INNER JOIN Editora E ON (E.Codigo = L.Cod_Editora)
INNER JOIN Compras C ON(C.Cod_Livro = L.Codigo);

SELECT L.Nome as Livro, C.Valor, C.Quantidade
FROM Estoque L
INNER JOIN Compras C ON(C.Cod_Livro = L.Codigo)
WHERE C.Codigo = 15051; 


SELECT L.Nome as Livro, CASE WHEN LEN(E.Site_editora) > 10 THEN 
SUBSTRING(E.Site_editora,5,95)
ELSE 
 E.Site_editora
END AS Site_Editora
FROM Estoque L
INNER JOIN Editora E ON (E.Codigo = L.Cod_Editora)
WHERE E.Nome = 'Makron books';


SELECT L.Nome as Livro, A.Biografia
FROM Estoque L
INNER JOIN Autor A ON (A.Codigo = L.Cod_Autor)
WHERE A.Nome = 'David Halliday';

SELECT C.Codigo, C.Quantidade
FROM Estoque L
INNER JOIN Compras C ON(C.Cod_Livro = L.Codigo)
WHERE L.Nome = 'Sistemas Operacionais Modernos'; 

SELECT L.Nome as Livro
FROM Estoque L
LEFT OUTER JOIN Compras C ON(C.Cod_Livro = L.Codigo)
WHERE C.Cod_Livro IS NULL;

SELECT L.Nome as Livro
FROM Compras C 
LEFT OUTER JOIN Estoque L ON(C.Cod_Livro = L.Codigo)
WHERE L.Codigo IS NULL;

SELECT E.Nome as Editora, CASE WHEN LEN(E.Site_editora) > 10 THEN 
SUBSTRING(E.Site_editora,5,95)
ELSE 
 E.Site_editora
END AS Site_Editora
FROM Estoque L
RIGHT OUTER JOIN Editora E ON (E.Codigo = L.Cod_Editora)
WHERE L.Cod_Editora IS NULL;

SELECT A.Nome as Autor, CASE WHEN SUBSTRING(A.Biografia,1,9) = 'Doutorado' THEN
'Ph.D' + SUBSTRING(A.Biografia,10,190)
ELSE
A.Biografia
END AS Biografia
FROM Estoque L
RIGHT OUTER JOIN Autor A ON (A.Codigo = L.Cod_Autor)
WHERE L.Cod_Autor IS NULL;

SELECT DISTINCT(A.Nome) as Autor, MAX(L.Valor) as Valor
FROM Estoque L
INNER JOIN Autor A ON (A.Codigo = L.Cod_Autor)
GROUP BY A.Nome
ORDER BY Valor DESC;

SELECT DISTINCT(C.Codigo) as Codigo, SUM(C.Quantidade) as Qtd, SUM(C.Valor) as Total
FROM Compras C
GROUP BY C.Codigo
ORDER BY C.Codigo ASC;


SELECT DISTINCT (E.Nome) as Editora, AVG(L.Valor) as Media
FROM Estoque L
INNER JOIN Editora E ON (E.Codigo = L.Cod_Editora)
GROUP BY E.Nome
ORDER BY Media ASC;

SELECT L.Nome as Livro,L.Quantidade, E.Nome as Editora, CASE WHEN LEN(E.Site_editora) > 10 THEN 
SUBSTRING(E.Site_editora,5,95)
ELSE 
 E.Site_editora
END AS Site_Editora,
CASE WHEN L.Quantidade > 10 THEN
'Estoque Suficiente'
WHEN L.Quantidade <= 10 AND L.Quantidade >= 5 THEN
'Produto Acabando'
ELSE
'Produto em Ponto de Pedido' 
END AS Status
FROM Estoque L
INNER JOIN Editora E ON (E.Codigo = L.Cod_Editora)
ORDER BY L.Quantidade ASC;


SELECT L.Codigo as Codigo, L.Nome as Livro,A.Nome as Autor, 
CASE WHEN E.Site_editora IS NOT NULL THEN
E.Nome + ' - ' + E.Site_editora
ELSE
E.Nome
END AS Editora
FROM Estoque L
INNER JOIN Autor A ON (A.Codigo = L.Cod_Autor)
INNER JOIN Editora E ON (E.Codigo = L.Cod_Editora);

SELECT C.Codigo, DATEDIFF(DAY,C.Data_Compra,GETDATE()) AS Dias,DATEDIFF(MONTH,C.Data_Compra,GETDATE()) AS Meses
FROM Estoque L
INNER JOIN Compras C ON(C.Cod_Livro = L.Codigo);

SELECT DISTINCT(C.Codigo) as Codigo, SUM(C.Valor) as Total
FROM Estoque L
INNER JOIN Compras C ON(C.Cod_Livro = L.Codigo)
GROUP BY C.Codigo
HAVING SUM(C.Valor) > 200;