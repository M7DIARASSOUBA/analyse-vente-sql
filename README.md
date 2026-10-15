# Analyse des ventes d'un e-commerce (SQL)

## Contexte

Analyse de 1 067 371 lignes de ventes (décembre 2009 à décembre 2011) d'un e-commerce, avec SQLite et DB Browser for SQLite. Données : dataset Online Retail II (Kaggle).

## Questions et résultats

**1. Qualité des données**

- 1 067 371 lignes au total
- 243 007 lignes (**22,8 %**) sans numéro client, exclues des analyses par client
- 22 950 lignes de retours (**2,2 %**), quantité négative
- 6 207 lignes (**0,6 %**) avec un prix nul ou négatif

**2. Poids des retours**

- Retours et annulations : **-1 527 041**
- Ventes (frais de port inclus) : **environ 20,8 M**
- Les retours représentent environ **7,3 %** *du chiffre d'affaires des ventes*
- *Chiffre d'affaires net* : **environ 19,3 M**

**3. Top 10 produits par chiffre d'affaires net** (ventes moins retours et annulations, hors frais de port)

- REGENCY CAKESTAND 3 TIER : 327 814
- WHITE HANGING HEART T-LIGHT HOLDER : 257 534
- JUMBO BAG RED RETROSPOT : 148 801
- PARTY BUNTING : 147 949
- ASSORTED COLOUR BIRD ORNAMENT : 131 414
- PAPER CHAIN KIT 50'S CHRISTMAS : 121 662
- CHILLI LIGHTS : 84 854
- ROTATING SILVER ANGELS T-LIGHT HLDR : 73 815
- BLACK RECORD COVER FRAME : 69 247
- JUMBO BAG STRAWBERRY : 69 054

**4. Croissance 2010 vs 2011** (janvier à novembre, décembre 2011 étant incomplet)

- *Chiffre d'affaires* : **8 905 175 en 2010, 9 182 022 en 2011, soit +3,1 %**
- Forte saisonnalité : pic en novembre (**1,47 M en 2010, 1,51 M en 2011**), creux en janvier et février 2011 (691 365 et 523 632)

**5. Concentration clients**

- Les *10 meilleurs clients* représentent **16,3 %** du *chiffre d'affaires net* des clients identifiés
- Ils sont 10 sur 5 942 clients identifiés (**environ 0,17 %**)
- Calcul limité aux lignes avec un numéro client (**77 % des lignes**), net des retours et annulations

## Points de vigilance

- Décembre 2011 incomplet : données jusqu'au 9 décembre
- Quasi aucune vente le samedi : 30 factures, toutes le 5 décembre 2009
- Lignes POSTAGE, DOTCOM POSTAGE et Manual exclues des classements produits
- Une commande de 80 995 pièces annulée 12 minutes plus tard (factures 581483 et C581484) gonfle le chiffre d'affaires brut : le classement des produits est donc calculé en net
- Numéros clients importés avec un « .0 » (ex. 14911.0)

## Compétences

SELECT, WHERE, GROUP BY, JOIN, CASE WHEN, sous-requêtes, CTE, fonctions de fenêtre

## Fichiers

- analyse.sql : les requêtes de chaque question
