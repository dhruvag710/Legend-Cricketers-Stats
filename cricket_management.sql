
CREATE DATABASE cricket_management;
USE cricket_management;

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

CREATE VIEW player_total_runs AS
SELECT player_id, SUM(runs) AS total_runs
FROM player_format_stats
GROUP BY player_id;
