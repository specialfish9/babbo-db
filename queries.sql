SELECT deleg.name, deleg.surname 
FROM delivery deliv, child c, delegate deleg
WHERE c.name = 'name' 
AND c.surname = 'surname'
AND c.id = deliv.child_id
AND deliv.delegate_id = deleg.id; 

SELECT e.name, e.surname 
FROM elf e 
JOIN (
	SELECT g.elf_id 
	FROM gift g
	JOIN (
		SELECT deliv.id
		FROM delivery deliv
		JOIN delegate deleg
		ON deleg.name = 'John'
		AND deleg.surname = 'Doe'
		AND deliv.delegate_id = deleg.id
	) AS d
	ON d.id = g.delivery_id
) AS g
ON g.elf_id = e.id;

SELECT SUM(m.unit_cost * gm.material_quantity)
AS Cost
FROM gift_material gm
JOIN material m
ON m.id = gm.material_id 
WHERE gm.gift_id = 0;

WITH RECURSIVE tmp (name, father_id, mother_id, father_name, 
    mother_name)
AS (
	-- Base case query
	SELECT r.name, r.father_id , r.mother_id, fr.name,
        mr.name
	FROM reindeer r
	-- Fetch father name from ID
	JOIN reindeer fr
	ON fr.id = r.father_id 
	-- Fetch mother name from ID
	JOIN reindeer mr
	ON mr.id = r.mother_id 
	WHERE r.name = 'Rudolph4'
	
	UNION ALL
	-- Recursive case query
	SELECT r2.name, r2.father_id, r2.mother_id, fr2.name,
        mr2.name
	FROM reindeer r2
	INNER JOIN tmp
	-- Fetch father name
	JOIN reindeer fr2
	ON fr2.id = r2.father_id 
	-- Fetch mother name
	JOIN reindeer mr2
	ON mr2.id = r2.mother_id 
	WHERE r2.id = tmp.father_id 
	OR r2.id = tmp.mother_id
);

SELECT name, father_name, mother_name FROM tmp t;

SELECT pog.child_id 
FROM period_of_goodness pog 
JOIN child c
ON c.id  = pog.id 
WHERE ISNULL(pog.good_to);

SELECT pog.id 
FROM period_of_goodness pog 
WHERE NOT ISNULL(pog.good_to) 
AND pog.child_id NOT IN (
	SELECT child_id 
	FROM period_of_goodness pog2 
	WHERE ISNULL(pog2.good_to) 
);

SELECT m.name, m.stock
FROM material m
JOIN gift_material gm ON gm.material_id = m.id
JOIN gift g ON gm.gift_id = g.id
JOIN delivery d ON g.delivery_id = d.id
WHERE d.child_id IN (
	SELECT c.id
 	FROM child c
  	JOIN country co ON c.country_id = co.id
   	WHERE co.name = 'Italy'
)

SELECT m.name, mc.name AS category
FROM material m
JOIN material_category mc ON mc.material_id = m.id
JOIN gift_material gm ON gm.material_id = m.id
JOIN gift g ON gm.gift_id = g.id
WHERE g.elf_id IN(
	SELECT id
 	FROM elf
  	WHERE name = 'John' AND surname = 'Doe'
)

SELECT c.name, c.surname
FROM child c
JOIN delivery d ON d.child_id = c.id
JOIN delegate dg ON d.delegate_id = dg.id
WHERE dg.sled_id IN(
	SELECT s.id
 	FROM sled s
  	JOIN sled_model sm ON s.model_id = sm.id
	WHERE sm.manufacturer = 'Ski-Doo' 
 	AND sm.code = 'Expedition'
)

SELECT e.name, e.surname, w.open_at AS opening, 
	w.close_at AS closing
FROM elf e
JOIN workshop w ON e.workshop_id = w.id
WHERE e.working_to IS NULL
\end{lstlisting}

-- {Operazione 11} Restituire i fornitori ordinati base al valore dei materiali
-- venduti e attualmente in magazzino
SELECT s.company_name, SUM(m.unit_cost * m.stock) AS net
FROM supplier s
JOIN material_category mc ON mc.supplier_id = s.id
JOIN material m ON mc.material_id = m.id
GROUP BY m.id
ORDER BY SUM(m.unit_cost * m.stock)
