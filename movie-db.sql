-- ########################################################
-- Project: Movie Database (Mini SQL Project)
-- Description:
--   This database stores movies, their genres, directors,
--   actors, and ratings. It can be used to practice queries
--   like joins, group by, aggregate functions, etc.
--
-- Tables:
--   1. Movies        → movie_id, title, release_year, genre_id
--   2. Genres        → genre_id, genre_name
--   3. Directors     → director_id, name
--   4. Actors        → actor_id, name
--   5. MovieActors   → movie_id, actor_id  (many-to-many relation)
--   6. Ratings       → rating_id, movie_id, rating
--
-- Practice Queries Ideas:
--   - List all movies with their genres
--   - Find top-rated movies
--   - Get all movies directed by a specific director
--   - Find actors who acted in more than 2 movies
--
-- ########################################################

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS MovieDB;
USE MovieDB;

-- Step 2: Create Tables
CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

CREATE TABLE Directors (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    release_year INT,
    genre_id INT,
    director_id INT,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id),
    FOREIGN KEY (director_id) REFERENCES Directors(director_id)
);

CREATE TABLE Actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Junction table (Many-to-Many between Movies & Actors)
CREATE TABLE MovieActors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    rating DECIMAL(3,1),  -- Example: 8.5
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Step 3: Insert Sample Data
INSERT INTO Genres (genre_name) VALUES
('Action'), ('Drama'), ('Comedy'), ('Sci-Fi');

INSERT INTO Directors (name) VALUES
('Christopher Nolan'), ('Steven Spielberg'), ('Quentin Tarantino');

INSERT INTO Movies (title, release_year, genre_id, director_id) VALUES
('Inception', 2010, 4, 1),
('Interstellar', 2014, 4, 1),
('Pulp Fiction', 1994, 2, 3),
('Jurassic Park', 1993, 1, 2);

INSERT INTO Actors (name) VALUES
('Leonardo DiCaprio'), ('Matthew McConaughey'), ('Samuel L. Jackson'), ('Laura Dern');

INSERT INTO MovieActors (movie_id, actor_id) VALUES
(1, 1),  -- Inception: Leonardo DiCaprio
(2, 2),  -- Interstellar: Matthew McConaughey
(3, 3),  -- Pulp Fiction: Samuel L. Jackson
(4, 4);  -- Jurassic Park: Laura Dern

INSERT INTO Ratings (movie_id, rating) VALUES
(1, 8.8), (2, 8.6), (3, 8.9), (4, 8.1);

-- Step 4: Example Queries
-- List all movies with their genres and directors
SELECT m.title, m.release_year, g.genre_name, d.name AS director
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
JOIN Directors d ON m.director_id = d.director_id;

-- Find top 3 highest-rated movies
SELECT m.title, r.rating
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
ORDER BY r.rating DESC
LIMIT 3;

-- Find all actors in 'Inception'
SELECT a.name AS actor
FROM Actors a
JOIN MovieActors ma ON a.actor_id = ma.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id
WHERE m.title = 'Inception';
