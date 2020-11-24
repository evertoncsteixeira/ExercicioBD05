
SELECT C.Marca, C.modelo, SUM(V.distanciaPercorrida) as Distancia
FROM carro C 
INNER JOIN viagem V ON (V.idCarro = C.id)
GROUP BY C.idEmpresa,C.marca,C.modelo

SELECT E.Nome as Empresa
FROM empresa E
LEFT OUTER JOIN carro C ON (C.idEmpresa = E.id)
WHERE C.idEmpresa IS NULL;

SELECT C.marca,C.modelo 
FROM carro C
LEFT OUTER JOIN viagem V ON (V.idCarro = C.id)
WHERE V.idCarro IS NULL;

SELECT C.Marca, C.modelo, COUNT(V.idCarro) as Viagens
FROM carro C 
INNER JOIN viagem V ON (V.idCarro = C.id)
INNER JOIN empresa E ON (E.id = C.idEmpresa)
GROUP BY E.nome,C.marca,C.modelo 
ORDER BY E.nome ASC, Viagens DESC


SELECT E.nome, C.Marca, C.modelo,V.distanciaPercorrida as Distancia,
CASE WHEN V.distanciaPercorrida < 1000 THEN
V.distanciaPercorrida * 10
ELSE
V.distanciaPercorrida * 15
END AS ValorViagem

FROM carro C 
INNER JOIN viagem V ON (V.idCarro = C.id)
INNER JOIN empresa E ON (E.id = C.idEmpresa)
ORDER BY E.nome ASC