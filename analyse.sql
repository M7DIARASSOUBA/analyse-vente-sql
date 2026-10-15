-- ============================================================
-- Analyse des ventes d'un e-commerce (SQLite)
-- Table source : retail (dataset Online Retail II, Kaggle)
-- Colonnes : Invoice, StockCode, Description, Quantity,
--            InvoiceDate, Price, "Customer ID", Country
-- ============================================================


-- ------------------------------------------------------------
-- PRÉPARATION : tables dérivées et index
-- ------------------------------------------------------------

CREATE TABLE products AS
SELECT StockCode, MAX(Description) AS Description
FROM retail
GROUP BY StockCode;

CREATE TABLE customers AS
SELECT "Customer ID" AS customer_id, MAX(Country) AS Country
FROM retail
WHERE "Customer ID" IS NOT NULL AND "Customer ID" <> ''
GROUP BY "Customer ID";

CREATE INDEX idx_stock ON retail(StockCode);
CREATE INDEX idx_cust ON retail("Customer ID");


-- ------------------------------------------------------------
-- QUESTION 1 : Quelle est la qualité des données ?
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total,
    SUM("Customer ID" = '' OR "Customer ID" IS NULL) AS sans_client,
    SUM(Quantity < 0) AS retours,
    SUM(Price <= 0) AS prix_nuls
FROM retail;


-- ------------------------------------------------------------
-- QUESTION 2 : Combien pèsent les retours ?
-- ------------------------------------------------------------

SELECT
    CASE WHEN Quantity > 0 THEN 'Vente' ELSE 'Retour' END AS type,
    COUNT(*) AS nb_lignes,
    ROUND(SUM(Quantity * Price), 0) AS montant
FROM retail
GROUP BY type;


-- ------------------------------------------------------------
-- QUESTION 3 : Quels sont les 10 meilleurs produits ?
-- Chiffre d'affaires NET (ventes moins retours et annulations),
-- hors frais de port et lignes manuelles.
-- ------------------------------------------------------------

SELECT
    Description,
    ROUND(SUM(Quantity * Price), 0) AS ca_net
FROM retail
WHERE Description NOT LIKE '%POSTAGE%'
  AND Description <> 'Manual'
GROUP BY Description
ORDER BY ca_net DESC
LIMIT 10;


-- ------------------------------------------------------------
-- QUESTION 4 : L'activité grandit-elle d'une année à l'autre ?
-- Janvier à novembre uniquement : décembre 2011 est incomplet
-- (données jusqu'au 9 décembre).
-- ------------------------------------------------------------

SELECT
    SUBSTR(InvoiceDate, 1, 4) AS annee,
    ROUND(SUM(Quantity * Price), 0) AS ca
FROM retail
WHERE Quantity > 0
  AND SUBSTR(InvoiceDate, 6, 2) <= '11'
GROUP BY annee;

-- Complément : chiffre d'affaires par mois et cumul
WITH m AS (
    SELECT SUBSTR(InvoiceDate, 1, 7) AS mois,
           SUM(Quantity * Price) AS ca
    FROM retail
    WHERE Quantity > 0
    GROUP BY mois
)
SELECT mois, ca, SUM(ca) OVER (ORDER BY mois) AS ca_cumule
FROM m;


-- ------------------------------------------------------------
-- QUESTION 5 : Les ventes dépendent-elles de quelques clients ?
-- Part des 10 meilleurs clients dans le chiffre d'affaires NET
-- (ventes moins retours et annulations) des clients identifiés.
-- ------------------------------------------------------------

WITH c AS (
    SELECT "Customer ID" AS id, SUM(Quantity * Price) AS ca
    FROM retail
    WHERE "Customer ID" <> ''
    GROUP BY id
    ORDER BY ca DESC
    LIMIT 10
)
SELECT ROUND(
    SUM(ca) * 100.0 /
    (SELECT SUM(Quantity * Price)
     FROM retail
     WHERE "Customer ID" <> ''),
    1) AS part_top10_pct
FROM c;

-- Nombre de clients identifiés
SELECT COUNT(*) FROM customers;


-- ------------------------------------------------------------
-- VÉRIFICATIONS (points de vigilance du README)
-- ------------------------------------------------------------

-- Date de la dernière facture (mois incomplet ?)
SELECT MAX(InvoiceDate) FROM retail;

-- Ventes par jour de la semaine (0 = dimanche, 6 = samedi)
SELECT STRFTIME('%w', InvoiceDate) AS jour,
       COUNT(DISTINCT Invoice) AS nb_factures,
       SUM(Quantity * Price) AS ca
FROM retail
WHERE Quantity > 0
GROUP BY jour
ORDER BY jour;

-- Grosse commande annulée quelques minutes plus tard
SELECT Invoice, Quantity, Price, InvoiceDate
FROM retail
WHERE Description LIKE 'PAPER CRAFT%'
  AND ABS(Quantity) > 10000;

