-- =========================================
--  CREATE DATABASE
-- =========================================
CREATE DATABASE cricket_management;
USE cricket_management;

-- =========================================
--  TABLES
-- =========================================
CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(30),
    debut_year INT,
    retirement_year INT NULL
);

CREATE TABLE player_format_stats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    format VARCHAR(20),
    matches INT,
    innings INT,
    runs INT,
    highest_score VARCHAR(10),
    average DECIMAL(5,2),
    strike_rate DECIMAL(5,2),
    centuries INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- =========================================
-- ✅ INSERT DATA
-- =========================================
INSERT INTO players (name, role, debut_year, retirement_year) VALUES
('Rohit Sharma', 'Batsman', 2007, NULL),
('Virat Kohli', 'Batsman', 2008, NULL),
('MS Dhoni', 'Wicketkeeper Batsman', 2004, 2019),
('Sachin Tendulkar', 'Batsman', 1989, 2013);

INSERT INTO player_format_stats VALUES
(NULL, 1, 'Test', 67, 116, 4301, '212', 40.6, 57.1, 12),
(NULL, 1, 'ODI', 276, 268, 11370, '264', 49.2, 92.7, 33),
(NULL, 1, 'T20I', 159, 151, 4231, '121*', 32.0, 140.9, 5),

(NULL, 2, 'Test', 123, 210, 9230, '254*', 46.9, 55.6, 30),
(NULL, 2, 'ODI', 305, 293, 14255, '183', 57.7, 93.3, 51),
(NULL, 2, 'T20I', 125, 117, 4188, '122*', 48.7, 137.0, 1),

(NULL, 3, 'Test', 90, 144, 4876, '224', 38.1, 59.1, 6),
(NULL, 3, 'ODI', 350, 297, 10773, '183*', 50.6, 87.6, 10),
(NULL, 3, 'T20I', 98, 85, 1617, '56', 37.6, 126.1, 0),

(NULL, 4, 'Test', 200, 329, 15921, '248*', 53.8, 0, 51),
(NULL, 4, 'ODI', 463, 452, 18426, '200*', 44.8, 86.2, 49),
(NULL, 4, 'T20I', 1, 1, 10, '10', 10.0, 83.3, 0);

-- =========================================
-- ✅ 25 SIMPLE SQL QUERIES
-- =========================================

-- 1. Show all players
SELECT * FROM players;

-- 2. List all batsmen
SELECT name FROM players WHERE role LIKE '%Batsman%';

-- 3. Active players
SELECT name FROM players WHERE retirement_year IS NULL;

-- 4. Players sorted by debut year
SELECT name, debut_year FROM players ORDER BY debut_year;

-- 5. Total runs by each player
SELECT p.name, SUM(s.runs) AS total_runs
FROM players p JOIN player_format_stats s USING(player_id)
GROUP BY p.player_id;

-- 6. Average batting average by format
SELECT format, AVG(average) 
FROM player_format_stats GROUP BY format;

-- 7. Highest ODI run scorer
SELECT name FROM players WHERE player_id = (
    SELECT player_id FROM player_format_stats
    WHERE format='ODI' ORDER BY runs DESC LIMIT 1
);

-- 8. Player with most centuries
SELECT name FROM players WHERE player_id = (
    SELECT player_id FROM player_format_stats
    ORDER BY centuries DESC LIMIT 1
);

-- 9. Player, format & runs (JOIN)
SELECT p.name, s.format, s.runs
FROM players p JOIN player_format_stats s USING(player_id);

-- 10. ODI stats only
SELECT name, runs FROM players JOIN player_format_stats USING(player_id)
WHERE format='ODI';

-- 11. Players with total runs > 15000
SELECT p.name, SUM(s.runs) AS total_runs
FROM players p JOIN player_format_stats s USING(player_id)
GROUP BY p.player_id HAVING total_runs > 15000;

-- 12. Players debut between 2000-2010
SELECT name FROM players WHERE debut_year BETWEEN 2000 AND 2010;

-- 13. Find player with highest Test average
SELECT name FROM players WHERE player_id = (
    SELECT player_id FROM player_format_stats
    WHERE format='Test' ORDER BY average DESC LIMIT 1
);

-- 14. List formats played by Virat Kohli
SELECT format FROM player_format_stats s 
JOIN players p USING(player_id) 
WHERE p.name='Virat Kohli';

-- 15. Players whose name contains 'a'
SELECT name FROM players WHERE name LIKE '%a%';

-- 16. Count players
SELECT COUNT(*) AS total_players FROM players;

-- 17. Sort by name
SELECT name FROM players ORDER BY name;

-- 18. Limit example
SELECT name FROM players LIMIT 2;

-- 19. IN example
SELECT name FROM players WHERE name IN ('Rohit Sharma','Virat Kohli');

-- 20. Change role of Rohit
UPDATE players SET role='Top Order Batsman' WHERE name='Rohit Sharma';

-- 21. Delete dummy low run entries (example)
DELETE FROM player_format_stats WHERE runs < 20;

-- 22. CASE: Player status
SELECT name,
CASE WHEN retirement_year IS NULL THEN 'Active' ELSE 'Retired' END AS status
FROM players;

-- 23. Show Test strike rate highest
SELECT p.name FROM players p
JOIN player_format_stats s USING(player_id)
WHERE format='Test'
ORDER BY strike_rate DESC LIMIT 1;

-- 24. Total centuries by each player
SELECT p.name, SUM(s.centuries) AS total_centuries
FROM players p JOIN player_format_stats s USING(player_id)
GROUP BY p.player_id;

-- 25. Subquery: Players with centuries > 40
SELECT name FROM players WHERE player_id IN (
    SELECT player_id FROM player_format_stats WHERE centuries > 40
);

-- =========================================
-- VIEW (Total Runs)
-- =========================================
CREATE VIEW player_total_runs AS
SELECT player_id, SUM(runs) AS total_runs
FROM player_format_stats
GROUP BY player_id;

-- Show view
SELECT p.name, v.total_runs
FROM players p JOIN player_total_runs v USING(player_id);
