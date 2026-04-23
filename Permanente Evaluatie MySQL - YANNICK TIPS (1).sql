/****************************  PERMANENTE AVALUATIE MYSQL  ****************************
-- NAAM: YANNICK TIPS 
-- GROEP: LEUVEN 2025
-- DATUM: 01/02/2026

/************************************  OEFENING 1  ************************************
OPDRACHT:
Maak voor iedere tennisspeler een username aan. 
Deze bestaat uit de letter "S", de eerste drie letters van hun achternaam en de dag waarop ze geboren zijn. 

VERWACHT RESULTAAT:
+--------------+------------+----------+
| NAAM         | GEB_DATUM  | USERNAME |
+--------------+------------+----------+
| Elfring      | 1948-09-01 | SELF1    |
| Permentier   | 1964-06-25 | SPER25   |
| Wijers       | 1963-05-11 | SWIJ11   |
| Niewenburg   | 1962-07-08 | SNIE8    |
| Cools        | 1964-12-28 | SCOO28   |
| Cools        | 1963-06-22 | SCOO22   |
| Bischoff     | 1956-10-29 | SBIS29   |
| Bakker, de   | 1963-01-09 | SBAK9    |
| Bohemen, van | 1971-08-17 | SBOH17   |
| Hofland      | 1956-11-11 | SHOF11   |
| Meuleman     | 1963-05-14 | SMEU14   |
| Permentier   | 1963-02-28 | SPER28   |
| Moerman      | 1970-05-10 | SMOE10   |
| Baalen, van  | 1963-10-01 | SBAA1    |
+--------------+------------+----------+

JOUW QUERY:                                                         */

SELECT 
    NAAM
    , GEB_DATUM
    , CONCAT("S", UPPER(LEFT(NAAM, 3)),  DAY(GEB_DATUM)) AS USERNAME
FROM
    tennis.spelers;

/************************************  OEFENING 2  ************************************
OPDRACHT:
Geef een unieke lijst van actieve bestuursleden (actieve bestuursleden hebben geen einddatum) 
die een boete hebben gekregen van meer dan 50 euro en die al een wedstrijd hebben gespeeld. 
Sorteer op spelersnr.

VERWACHT RESULTAAT:
+-----------+------------+--------+
| spelersnr | naam       | bedrag |
+-----------+------------+--------+
| 6         | Permentier | 100.00 |
+-----------+------------+--------+

JOUW QUERY:                                                         */

SELECT 
    b.SPELERSNR
    , s.NAAM
    , bo.BEDRAG
FROM bestuursleden AS b
LEFT JOIN spelers AS s
	on b.SPELERSNR = s.SPELERSNR
LEFT JOIN boetes AS bo
	on s.SPELERSNR = bo.SPELERSNR
WHERE 
	isnull(b.EIND_DATUM)
    and bo.BEDRAG > 50
    and b.SPELERSNR IN 
		(SELECT
			w.SPELERSNR
		FROM wedstrijden AS w
        );

/************************************  OEFENING 3  ************************************
OPDRACHT:
Geef een lijst van bestuursleden die meer dan 1 functie hebben uitgevoerd.

VERWACHT RESULTAAT:
+-----------+-------------+------------+-----------------+
| spelersnr | naam        | geb_datum  | aantal_functies |
+-----------+-------------+------------+-----------------+
| 2         | Elfring     | 1948-09-01 | 2               |
| 6         | Permentier  | 1964-06-25 | 4               |
| 8         | Niewenburg  | 1962-07-08 | 4               |
| 27        | Cools       | 1964-12-28 | 3               |
| 112       | Baalen, van | 1963-10-01 | 2               |
+-----------+-------------+------------+-----------------+

JOUW QUERY:                                                         */

SELECT 
	b.SPELERSNR
    , s.NAAM
    , s.GEB_DATUM
    , count(b.SPELERSNR) AS aantal_functies
FROM bestuursleden AS b
LEFT JOIN spelers AS s
	ON b.SPELERSNR = s.SPELERSNR
GROUP BY
	b.SPELERSNR;

/************************************  OEFENING 4  ************************************
OPDRACHT:
Wat is het gemiddelde totaalbedrag aan boetes voor spelers die in Den Haag en Rotterdam wonen?

VERWACHT RESULTAAT:
+------------+
| GEMIDDELDE |
+------------+
| 100.00     |
+------------+

JOUW QUERY:                                                         */

SELECT 
    ROUND(AVG(b.BEDRAG),2) AS GEMIDDELDE    
FROM boetes AS b
WHERE
	b.SPELERSNR IN
		(SELECT
        s.SPELERSNR
        FROM spelers AS s
        WHERE
			PLAATS = "DEN HAAG" OR "ROTTERDAM"
		)
GROUP BY
	b.SPELERSNR;

/************************************  OEFENING 5  ************************************
OPDRACHT:
Geef een lijst van alle spelers met hun gemiddelde bedrag aan boetes. 
Indien een speler nog geen boete heeft gehad staat er 0.

VERWACHT RESULTAAT:
+--------------+------------------+
| naam         | gemiddeld_bedrag |
+--------------+------------------+
| Elfring      | 0                |
| Permentier   | 100.00           |
| Wijers       | 0                |
| Niewenburg   | 25.00            |
| Cools        | 87.50            |
| Bischoff     | 0                |
| Bakker, de   | 43.33            |
| Bohemen, van | 0                |
| Hofland      | 0                |
| Meuleman     | 0                |
| Moerman      | 50.00            |
| Baalen, van  | 0                |
+--------------+------------------+

JOUW QUERY:                                                         */

-- Ontwikkel of plak je SELECT query hier --
SELECT 
    s.naam
    , CASE
		WHEN AVG(b.bedrag) IS NULL THEN 0
		ELSE ROUND(AVG(b.bedrag), 2)
		END AS gemiddelde
FROM tennis.spelers AS s
LEFT JOIN tennis.boetes AS b
	ON s.spelersnr = b.spelersnr
GROUP BY
	s.naam;

