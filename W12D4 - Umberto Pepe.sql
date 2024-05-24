/*ToysGroup è un’azienda che distribuisce articoli (giocatoli) in diverse aree geografiche del mondo. 
I prodotti sono classificati in categorie e i mercati di riferimento dell’azienda sono classificati in regioni di vendita. 
In particolare: 
Le entità individuabili in questo scenario sono le seguenti: 
- Product 
- Region 
- Sales  

Le relazioni tra le entità possono essere descritte nel modo seguente: 
1) Product e Sales:
    1.1) Un prodotto può essere venduto tante volte (o nessuna) per cui è contenuto in una o più transazioni di vendita. 
    1.2) Ciascuna transazione di vendita è riferita ad uno solo prodotto 

2) Region e Sales 
   2.1) Possono esserci molte o nessuna transazione per ciascuna regione 
   2.2) Ciascuna transazione di vendita è riferita ad una sola regione

Fornisci schema concettuale e schema logico.

Crea e popola le tabelle utilizzando dati a tua discrezione (sono sufficienti pochi record per tabella; riporta le query utilizzate).*/ 


-- Creo lo schema 'ToysGroup' e imposto lo schema 'ToysGroup' come schema di default

CREATE SCHEMA ToysGroup;
USE ToysGroup;



-- Creo le tabelle Product, Region, Sales

CREATE TABLE Prodotto (
    ID_Prodotto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Nome_Prodotto VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Prezzo_Unitario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Regione (
    Paese VARCHAR(50) NOT NULL PRIMARY KEY,
    Nome_Regione VARCHAR(100) NOT NULL    
);

CREATE TABLE Vendite (
    ID_Vendita INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Data_Vendita DATE NOT NULL,
    Quantita INT NOT NULL,
    ID_Prodotto INT NOT NULL,
    Paese VARCHAR(50) NOT NULL,
    FOREIGN KEY (ID_Prodotto) REFERENCES Prodotto(ID_Prodotto),
    FOREIGN KEY (Paese) REFERENCES Regione(Paese)
);



-- popolo le tabelle Prodotto, Regione, Vendite

INSERT INTO Prodotto (Nome_Prodotto, Categoria, Prezzo_Unitario) VALUES
('Orsacchiotto', 'Peluche', 19.99),
('Automobile', 'Veicoli', 9.99),
('Barbie', 'Bambole', 49.99),
('Luffy Gear 5', 'Action Figures', 14.99),
('Puzzle', 'Giochi da tavolo', 12.99),
('Lego', 'Collezionismo', 59.99),
('Battaglia Navale', 'Giochi da tavolo', 29.99),
('Pistola ad acqua', 'Giochi Estate', 7.99),
('Drone', 'Elettronica', 99.99),
('Trenino', 'Veicoli', 39.99);

INSERT INTO Regione (Nome_Regione, Paese) VALUES
('Nord America', 'USA'),
('Europa', 'Germania'),
('Asia', 'Giappone'),
('Sud America', 'Brasile'),
('Africa', 'Sudafrica'),
('Oceania', 'Australia'),
('Europa', 'Francia'),
('Asia', 'Cina'),
('Nord America', 'Canada'),
('Europa', 'Italia');

INSERT INTO Vendite (Data_Vendita, Quantita, ID_Prodotto, Paese) VALUES
('2022-01-15', 5, 1, 'USA'),
('2022-02-20', 3, 2, 'Germania'),
('2022-03-05', 10, 3, 'Giappone'),
('2022-04-10', 7, 4, 'Brasile'),
('2022-05-25', 2, 5, 'Sudafrica'),
('2022-07-04', 4, 7, 'Francia'),
('2022-09-10', 9, 9, 'Cina'),
('2022-10-20', 11, 10, 'Canada'),
('2022-11-11', 15, 1, 'Italia'),
('2022-12-01', 12, 2, 'Australia'),
('2023-01-22', 5, 3, 'USA'),
('2023-02-28', 7, 4, 'Germania'),
('2023-03-18', 9, 5, 'Giappone'),
('2023-04-22', 3, 7, 'Brasile'),
('2023-05-15', 14, 7, 'Sudafrica'),
('2023-06-11', 10, 9, 'Francia'),
('2023-07-19', 5, 9, 'Cina'),
('2023-08-21', 8, 10, 'Canada'),
('2023-09-10', 6, 1, 'Italia'),
('2023-10-05', 3, 4, 'Australia'),
('2023-11-15', 7, 2, 'USA'),
('2023-12-30', 4, 3, 'Germania');


/*Dopo la creazione e l’inserimento dei dati nelle tabelle, esegui e riporta delle query utili a: 
1.Verificare che i campi definiti come PK siano univoci.*/ 

SELECT ID_Prodotto, COUNT(*)
FROM prodotto
GROUP BY ID_Prodotto;

SELECT Paese, COUNT(*)
FROM Regione
GROUP BY Paese;

SELECT ID_Vendita, COUNT(*)
FROM Vendite
GROUP BY ID_Vendita;


/*2.Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno.*/
SELECT 
    P.Nome_Prodotto,
    YEAR(S.Data_Vendita) AS Anno,
    SUM(S.Quantita * P.Prezzo_Unitario) AS Tot_Fatturato
FROM 
    prodotto P
JOIN     -- NO LEFT JOIN PER RICHIESTA TRACCIA DI "SOLI PRODOTTI VENDUTI"
    vendite S ON P.ID_Prodotto = S.ID_Prodotto
GROUP BY 
    P.Nome_Prodotto, YEAR(S.Data_Vendita)
ORDER BY 
    P.Nome_Prodotto, Anno;

/*3.Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.*/
SELECT 
    YEAR(S.Data_Vendita) AS Anno,
    R.Paese,
    SUM(S.Quantita * P.Prezzo_Unitario) AS Tot_Fatturato
FROM 
    vendite S
JOIN 
    prodotto P ON S.ID_Prodotto = P.ID_Prodotto
JOIN 
    Regione R ON S.Paese = R.Paese
GROUP BY 
    Anno, R.Paese
ORDER BY 
    Anno, Tot_Fatturato DESC;


/*4.Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?*/
SELECT 
    P.Categoria AS Categoria,
    SUM(S.Quantita) AS Tot_Quantita
FROM 
    vendite S
JOIN 
    prodotto P ON S.ID_Prodotto = P.ID_Prodotto
GROUP BY 
    P.Categoria
ORDER BY 
    Tot_Quantita DESC
LIMIT 1;

/*In questo caso il LIMIT è OK dato che abbiamo un solo valore MAX,
ma per completezza ho preferito inserire anche una query con la funzione MAX*/

SELECT 
    P.Categoria,
    SUM(S.Quantita) AS Tot_Quantita
FROM 
    Prodotto P
JOIN 
    Vendite S ON P.ID_Prodotto = S.ID_Prodotto
GROUP BY 
    P.Categoria
HAVING 
    SUM(S.Quantita) = (
        SELECT 
            MAX(Tot_Quantita)
        FROM 
            (SELECT 
                 SUM(V.Quantita) AS Tot_Quantita
             FROM 
                 Vendite V
             JOIN 
                 Prodotto T ON V.ID_Prodotto = T.ID_Prodotto
             GROUP BY 
                 T.Categoria) AS Max_Quantita);


/*5.Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti?
	Proponi due approcci risolutivi differenti.*/
SELECT 
    Nome_Prodotto
FROM 
    Prodotto
WHERE 
    ID_Prodotto NOT IN (
        SELECT DISTINCT ID_Prodotto
        FROM Vendite
    );
    
SELECT 
    P.Nome_Prodotto
FROM 
    Prodotto P
LEFT JOIN 
    Vendite S ON P.ID_Prodotto = S.ID_Prodotto
WHERE 
    S.ID_Prodotto IS NULL;

/*6.Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente).*/
SELECT 
    P.Nome_Prodotto,
    MAX(S.Data_Vendita) AS UltimaDataVendita
FROM 
    Prodotto P
LEFT JOIN  -- Ho impostato LEFT JOIN perché volevo mostrare anche i prodotti invenduti
    Vendite S ON P.ID_Prodotto = S.ID_Prodotto
GROUP BY 
    P.Nome_Prodotto;
