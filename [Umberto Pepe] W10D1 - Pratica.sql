/* 1. Esplora la tabelle dei prodotti (DimProduct)
Inseriamo l'elemento * selezionare tutte le colonne
La chiamata del FROM è nomeschema.nometabella */

SELECT 
    *
FROM
    adv.dimproduct;

/* 2. Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi ProductKey, ProductAlternateKey, 
EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno */
SELECT 
    adv.dimproduct.ProductKey AS Codice_Prodotto,
    adv.dimproduct.ProductAlternateKey AS Codice_modello,
    adv.dimproduct.EnglishProductName AS Nome_inglese,
    adv.dimproduct.Color AS Colore,
    adv.dimproduct.StandardCost AS Costo_standard,
    adv.dimproduct.FinishedGoodsFlag AS Finito
FROM
    adv.dimproduct;
    
/* 3. Partendo dalla query scritta nel passaggio precedente, esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1. */
SELECT 
    adv.dimproduct.ProductKey AS Codice_Prodotto,
    adv.dimproduct.ProductAlternateKey AS Codice_modello,
    adv.dimproduct.EnglishProductName AS Nome_inglese,
    adv.dimproduct.Color AS Colore,
    adv.dimproduct.StandardCost AS Costo_standard,
    adv.dimproduct.FinishedGoodsFlag AS Finito
    -- COUNT(*)
FROM
    adv.dimproduct
WHERE
	adv.dimproduct.FinishedGoodsFlag = 1;
    
/* 4. Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello (ProductAlternateKey) comincia con FR oppure BK. 
	Il result set deve contenere il codice prodotto (ProductKey), il modello, il nome del prodotto, 
    il costo standard (StandardCost) e il prezzo di listino (ListPrice).*/
SELECT 
	-- dimproduct.ProductAlternateKey AS Cod_Modello,
    dimproduct.ProductKey AS Cod_Prodotto,
	dimproduct.ModelName AS Modello,
    dimproduct.EnglishProductName AS Nome_Prodotto,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.ListPrice AS Prezzo_Listino
FROM
	adv.dimproduct
WHERE
	dimproduct.ProductAlternateKey LIKE "FR%" OR dimproduct.ProductAlternateKey LIKE "BK%";

/* 5. Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dall’azienda (ListPrice - StandardCost) */
SELECT 
	-- dimproduct.ProductAlternateKey AS Cod_Modello,
    dimproduct.ProductKey AS Cod_Prodotto,
	dimproduct.ModelName AS Modello,
    dimproduct.EnglishProductName AS Nome_Prodotto,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.ListPrice AS Prezzo_Listino,
    dimproduct.ListPrice - dimproduct.StandardCost AS Markup
FROM
	adv.dimproduct
WHERE
	dimproduct.ProductAlternateKey LIKE "FR%" OR dimproduct.ProductAlternateKey LIKE "BK%";

/* 6. Scrivi un’altra query al fine di esporre l’elenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000. */
SELECT 
    dimproduct.ProductKey AS Chiave,
    dimproduct.ProductAlternateKey AS Cod_Modello,
    dimproduct.EnglishProductName AS Nome_Modello,
    dimproduct.Color AS Colore,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.FinishedGoodsFlag AS Finito
FROM
    adv.dimproduct
WHERE
    StandardCost BETWEEN 1000 AND 2000
        AND FinishedGoodsFlag = 1
ORDER BY StandardCost;

/* Alternativa */
SELECT 
    dimproduct.ProductKey AS Chiave,
    dimproduct.ProductAlternateKey AS Cod_Modello,
    dimproduct.EnglishProductName AS Nome_Modello,
    dimproduct.Color AS Colore,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.FinishedGoodsFlag AS Finito
FROM
    adv.dimproduct
WHERE
    StandardCost >= 1000 AND StandardCost <= 2000
        AND FinishedGoodsFlag = 1
ORDER BY StandardCost;

/* 7. Esplora la tabella degli impiegati aziendali (DimEmployee) */
SELECT
	*
FROM
	dimemployee;

/* 8.Esponi, interrogando la tabella degli impiegati aziendali, l’elenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1. */
SELECT
	*
FROM
	dimemployee
WHERE
	SalesPersonFlag = 1;

/* 9.Interroga la tabella delle vendite (FactResellerSales). Esponi in output l’elenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto: 
597, 598, 477, 214. Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost). */
SELECT
	*, SalesAmount - TotalProductCost
FROM
	factresellersales
WHERE
	OrderDate >= '2020/01/01'
AND ProductKey IN (597, 598, 477, 214);
