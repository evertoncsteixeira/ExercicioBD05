DROP DATABASE Sql_exercicios;
CREATE DATABASE Sql_exercicios;
CREATE TABLE Planos (
CodPlano INT IDENTITY PRIMARY KEY,
NomePLano VARCHAR(100) NOT NULL,
ValorPlano NUMERIC(11,2) NOT NULL CHECK(ValorPlano > 0));

INSERT INTO Planos VALUES ('100 Minutos',80);
INSERT INTO Planos VALUES ('150 Minutos',130);
INSERT INTO Planos VALUES ('200 Minutos',160);
INSERT INTO Planos VALUES ('250 Minutos',220);
INSERT INTO Planos VALUES ('300 Minutos',260);
INSERT INTO Planos VALUES ('600 Minutos',350);

CREATE TABLE Servicos (
CodServico INT IDENTITY PRIMARY KEY,
NomeServico VARCHAR(100) NOT NULL,
ValorServico NUMERIC(11,2) NOT NULL CHECK(ValorServico >= 0));

INSERT INTO Servicos VALUES ('100 SMS',10);
INSERT INTO Servicos VALUES ('SMS Ilimitado',30);
INSERT INTO Servicos VALUES ('Internet 500 MB',40);
INSERT INTO Servicos VALUES ('Internet 1 GB',60);
INSERT INTO Servicos VALUES ('Internet 2 GB',70);

CREATE TABLE Cliente (
CodCliente INT PRIMARY KEY,
NomeCliente VARCHAR(100) NOT NULL,
DataInicio DATE NOT NULL);

INSERT INTO Cliente VALUES (1234,'Cliente A','10-15-2012');
INSERT INTO Cliente VALUES (2468,'Cliente B','11-20-2012');
INSERT INTO Cliente VALUES (3702,'Cliente C','11-25-2012');
INSERT INTO Cliente VALUES (4936,'Cliente D','12-01-2012');
INSERT INTO Cliente VALUES (6170,'Cliente E','12-18-2012');
INSERT INTO Cliente VALUES (7404,'Cliente F','01-20-2013');
INSERT INTO Cliente VALUES (8638,'Cliente G','01-25-2013');

CREATE TABLE Contratos (
CodCliente INT NOT NULL,
CodPlano INT NOT NULL,
CodServico INT NOT NULL,
StatusServico CHAR(1) CHECK (StatusServico = 'A' OR StatusServico = 'E' OR StatusServico = 'D') DEFAULT ('A'), 
DataServico DATE NOT NULL

PRIMARY KEY (CodCliente,CodPlano,CodServico,StatusServico,DataServico));

INSERT INTO Contratos VALUES (1234,3,1,'E','10/15/2012');
INSERT INTO Contratos VALUES (1234,3,3,'E','10/15/2012');
INSERT INTO Contratos VALUES (1234,3,3,'A','10/16/2012');
INSERT INTO Contratos VALUES (1234,3,1,'A','10/16/2012');
INSERT INTO Contratos VALUES (2468,4,4,'E','11/20/2012');
INSERT INTO Contratos VALUES (2468,4,4,'A','11/21/2012');
INSERT INTO Contratos VALUES (6170,6,2,'E','12/18/2012');
INSERT INTO Contratos VALUES (6170,6,5,'E','12/19/2012');
INSERT INTO Contratos VALUES (6170,6,2,'A','12/20/2012');
INSERT INTO Contratos VALUES (6170,6,5,'A','12/21/2012');
INSERT INTO Contratos VALUES (1234,3,1,'D','01/10/2013');
INSERT INTO Contratos VALUES (1234,3,3,'D','01/10/2013');
INSERT INTO Contratos VALUES (1234,2,1,'E','01/10/2013');
INSERT INTO Contratos VALUES (1234,2,1,'A','01/11/2013');
INSERT INTO Contratos VALUES (2468,4,4,'D','01/25/2013');
INSERT INTO Contratos VALUES (7404,2,1,'E','01/20/2013');
INSERT INTO Contratos VALUES (7404,2,5,'E','01/20/2013');
INSERT INTO Contratos VALUES (7404,2,5,'A','01/21/2013');
INSERT INTO Contratos VALUES (7404,2,1,'A','01/22/2013');
INSERT INTO Contratos VALUES (8638,6,5,'E','01/25/2013');
INSERT INTO Contratos VALUES (8638,6,5,'A','01/26/2013');
INSERT INTO Contratos VALUES (7404,2,5,'D','02/03/2013');

SELECT C.NomeCliente,P.NomePLano,COUNT(DISTINCT(CT.StatusServico)) AS Status
FROM Cliente C
INNER JOIN Contratos CT ON (CT.CodCliente = C.CodCliente)
INNER JOIN Planos P ON (P.CodPlano = CT.CodPlano)
GROUP BY C.NomeCliente,P.NomePlano
ORDER BY C.NomeCliente;

SELECT C.NomeCliente,P.NomePLano,COUNT(DISTINCT(CT.StatusServico)) AS Status
FROM Cliente C
INNER JOIN Contratos CT ON (CT.CodCliente = C.CodCliente)
INNER JOIN Planos P ON (P.CodPlano = CT.CodPlano)
WHERE CT.StatusServico <> 'E'
GROUP BY C.NomeCliente,P.NomePlano
ORDER BY C.NomeCliente;

SELECT C.NomeCliente,P.NomePLano, CASE WHEN SUM(S.ValorServico) > 400 THEN
SUM(S.ValorServico) * 0.92
WHEN SUM(S.ValorServico) <= 400 AND SUM(S.ValorServico) > 300 THEN
SUM(S.ValorServico) * 0.95
WHEN SUM(S.ValorServico) <= 300 AND SUM(S.ValorServico) >= 200 THEN
SUM(S.ValorServico) * 0.97
ELSE
SUM(S.ValorServico)
END AS Total
FROM Cliente C
INNER JOIN Contratos CT ON (CT.CodCliente = C.CodCliente)
INNER JOIN Planos P ON (P.CodPlano = CT.CodPlano)
INNER JOIN Servicos S ON (S.CodServico = CT.CodServico)
WHERE CT.StatusServico <> 'E'
GROUP BY C.NomeCliente,P.NomePlano
ORDER BY C.NomeCliente;


SELECT C.NomeCliente, S.NomeServico,DATEDIFF(MONTH,CT.DataServico,GETDATE()) AS Meses
FROM Cliente C
INNER JOIN Contratos CT ON (CT.CodCliente = C.CodCliente)
INNER JOIN Planos P ON (P.CodPlano = CT.CodPlano)
INNER JOIN Servicos S ON (S.CodServico = CT.CodServico)
WHERE CT.StatusServico = 'A'
ORDER BY C.NomeCliente;
