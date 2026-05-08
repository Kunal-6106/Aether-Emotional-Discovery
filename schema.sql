DROP DATABASE IF EXISTS aether_db;
CREATE DATABASE aether_db;
USE aether_db;

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    theme_preference ENUM('light', 'dark') DEFAULT 'dark',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- CONTENT
-- =========================
CREATE TABLE content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    release_year INT,
    rating DECIMAL(3,1),
    poster_url VARCHAR(500),
    is_featured BOOLEAN DEFAULT FALSE,
    platform VARCHAR(50),
    type ENUM('Movie', 'Series') DEFAULT 'Movie',
    language VARCHAR(50),
    duration_mins INT DEFAULT NULL,
    seasons INT DEFAULT NULL
);

-- =========================
-- WATCH HISTORY
-- =========================
CREATE TABLE watch_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    watch_duration_mins INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    device_type VARCHAR(50) DEFAULT 'Laptop',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
);

USE aether_db;

DROP TABLE IF EXISTS ratings;

CREATE TABLE ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content_id INT,
    rating_label VARCHAR(100),
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
);

-- =========================
-- USER PREFERENCES
-- =========================
CREATE TABLE user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    favorite_genre VARCHAR(50),
    favorite_language VARCHAR(50),
    favorite_platform VARCHAR(50),
    preferred_type ENUM('Movie', 'Series', 'Both') DEFAULT 'Both',
    mood_preference VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =========================
-- BOOKMARKS / WATCHLIST
-- =========================
CREATE TABLE watchlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
);

-- =========================
-- SAMPLE CONTENT (100+)
-- =========================
INSERT INTO content 
(title, description, genre, release_year, rating, poster_url, is_featured, platform, type, language, duration_mins, seasons)
VALUES

-- HOLLYWOOD MOVIES
('Interstellar', 'A breathtaking journey through space, time, sacrifice, and love.', 'Sci-Fi', 2014, 8.6, 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', TRUE, 'Netflix', 'Movie', 'English', 169, NULL),
('The Dark Knight', 'A gritty masterpiece where chaos challenges order in Gotham.', 'Action', 2008, 9.0, 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg', TRUE, 'Prime Video', 'Movie', 'English', 152, NULL),
('Inception', 'Dreams within dreams inside a stunning heist of the subconscious.', 'Sci-Fi', 2010, 8.8, 'https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg', TRUE, 'Prime Video', 'Movie', 'English', 148, NULL),
('Fight Club', 'An explosive descent into masculinity, chaos, and identity.', 'Drama', 1999, 8.8, 'https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg', FALSE, 'Netflix', 'Movie', 'English', 139, NULL),
('The Social Network', 'The rise of Facebook and the loneliness behind ambition.', 'Drama', 2010, 7.7, 'https://image.tmdb.org/t/p/w500/n0ybibhJtQ5icDqTp8eRytcIHJx.jpg', FALSE, 'Sony LIV', 'Movie', 'English', 120, NULL),
('Whiplash', 'Obsession, discipline, and the brutal cost of greatness.', 'Drama', 2014, 8.5, 'https://image.tmdb.org/t/p/w500/7fn624j5lj3xTme2SgiLCeuedmO.jpg', TRUE, 'Netflix', 'Movie', 'English', 106, NULL),
('The Prestige', 'Two rival magicians destroy themselves in pursuit of perfection.', 'Thriller', 2006, 8.5, 'https://image.tmdb.org/t/p/w500/bdN3gXuIZYaJP7ftKK2sU0nPtEA.jpg', FALSE, 'Prime Video', 'Movie', 'English', 130, NULL),
('Shutter Island', 'A psychological storm wrapped in paranoia and grief.', 'Thriller', 2010, 8.2, 'https://image.tmdb.org/t/p/w500/52d7P4M5b9x8F4V3J7M4x2J6W7Y.jpg', FALSE, 'Netflix', 'Movie', 'English', 138, NULL),
('Gone Girl', 'A marriage turns into a terrifying performance of manipulation.', 'Thriller', 2014, 8.1, 'https://image.tmdb.org/t/p/w500/ts996lKsxvjkO2yiYG0ht4qAicO.jpg', FALSE, 'Disney+ Hotstar', 'Movie', 'English', 149, NULL),
('Prisoners', 'A father crosses moral boundaries in search of his missing daughter.', 'Crime', 2013, 8.1, 'https://image.tmdb.org/t/p/w500/uhviyknTT5cEQXbn6vWIqfM4vGm.jpg', FALSE, 'Netflix', 'Movie', 'English', 153, NULL),
('Se7en', 'A detective thriller soaked in dread and moral rot.', 'Crime', 1995, 8.6, 'https://image.tmdb.org/t/p/w500/6yoghtyTpznpBik8EngEmJskVUO.jpg', FALSE, 'Prime Video', 'Movie', 'English', 127, NULL),
('Nightcrawler', 'A disturbing portrait of ambition without conscience.', 'Thriller', 2014, 7.8, 'https://image.tmdb.org/t/p/w500/gYPIRu0jX2kq3xQ8P0Y4Z5Jv1P0.jpg', FALSE, 'Netflix', 'Movie', 'English', 117, NULL),
('Blade Runner 2049', 'A hypnotic sci-fi meditation on identity and memory.', 'Sci-Fi', 2017, 8.0, 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', TRUE, 'Prime Video', 'Movie', 'English', 164, NULL),
('Dune', 'A majestic political and spiritual war unfolds in the desert.', 'Sci-Fi', 2021, 8.0, 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', TRUE, 'Netflix', 'Movie', 'English', 155, NULL),
('The Batman', 'A rain-soaked detective noir wrapped in vengeance.', 'Action', 2022, 7.8, 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg', TRUE, 'JioHotstar', 'Movie', 'English', 176, NULL),
('Joker', 'A haunting character study of loneliness and collapse.', 'Drama', 2019, 8.4, 'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg', FALSE, 'Netflix', 'Movie', 'English', 122, NULL),
('Oppenheimer', 'A towering story of brilliance, guilt, and destruction.', 'Drama', 2023, 8.4, 'https://image.tmdb.org/t/p/w500/8Gxv0d7VHyVi7klGdM6H0G0QWwN.jpg', TRUE, 'JioHotstar', 'Movie', 'English', 180, NULL),
('John Wick', 'Elegant violence and grief-fueled revenge at full speed.', 'Action', 2014, 7.4, 'https://image.tmdb.org/t/p/w500/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg', FALSE, 'Prime Video', 'Movie', 'English', 101, NULL),
('Mad Max: Fury Road', 'Pure kinetic madness and visual adrenaline.', 'Action', 2015, 8.1, 'https://image.tmdb.org/t/p/w500/hA2ple9q4qnwxp3hKVNhroipsir.jpg', FALSE, 'Netflix', 'Movie', 'English', 120, NULL),
('The Wolf of Wall Street', 'A filthy, hilarious spiral into greed and excess.', 'Comedy', 2013, 8.2, 'https://image.tmdb.org/t/p/w500/34m2tygAYBGqA9MXKhRDtzYd4MR.jpg', FALSE, 'Prime Video', 'Movie', 'English', 180, NULL),

('The Matrix', 'Reality bends under the weight of truth and rebellion.', 'Sci-Fi', 1999, 8.7, 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg', TRUE, 'Netflix', 'Movie', 'English', 136, NULL),
('Gladiator', 'A betrayed general seeks justice in blood and sand.', 'Action', 2000, 8.5, 'https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg', FALSE, 'Prime Video', 'Movie', 'English', 155, NULL),
('The Shawshank Redemption', 'Hope survives even in the darkest prison walls.', 'Drama', 1994, 9.3, 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg', TRUE, 'Netflix', 'Movie', 'English', 142, NULL),
('The Godfather', 'Power, family, and corruption define a mafia dynasty.', 'Crime', 1972, 9.2, 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg', TRUE, 'Prime Video', 'Movie', 'English', 175, NULL),
('The Godfather Part II', 'Legacy deepens as power poisons everything it touches.', 'Crime', 1974, 9.0, 'https://image.tmdb.org/t/p/w500/amvmeQWheahG3StKwIE1f7jRnkZ.jpg', FALSE, 'Prime Video', 'Movie', 'English', 202, NULL),
('Pulp Fiction', 'Crime, cool, and chaos in nonlinear perfection.', 'Crime', 1994, 8.9, 'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg', FALSE, 'Netflix', 'Movie', 'English', 154, NULL),
('The Silence of the Lambs', 'A chilling psychological duel with a monster.', 'Thriller', 1991, 8.6, 'https://image.tmdb.org/t/p/w500/uS9m8OBk1A8eM9I042bx8XXpqAq.jpg', FALSE, 'Prime Video', 'Movie', 'English', 118, NULL),
('Parasite', 'Class warfare unfolds with ruthless elegance.', 'Thriller', 2019, 8.5, 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg', TRUE, 'Netflix', 'Movie', 'Korean', 132, NULL),
('La La Land', 'Dreams and love collide under city lights.', 'Romance', 2016, 8.0, 'https://image.tmdb.org/t/p/w500/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg', FALSE, 'Prime Video', 'Movie', 'English', 128, NULL),
('Titanic', 'Love blooms briefly on a doomed ship.', 'Romance', 1997, 7.9, 'https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg', FALSE, 'Disney+ Hotstar', 'Movie', 'English', 195, NULL),
('Avatar', 'A soldier enters a lush alien world and changes sides.', 'Sci-Fi', 2009, 7.8, 'https://image.tmdb.org/t/p/w500/kyeqWdyUXW608qlYkRqosgbbJyK.jpg', TRUE, 'Disney+ Hotstar', 'Movie', 'English', 162, NULL),
('Avengers: Endgame', 'Heroes unite for one final impossible battle.', 'Action', 2019, 8.4, 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg', TRUE, 'Disney+ Hotstar', 'Movie', 'English', 181, NULL),
('Spider-Man: Into the Spider-Verse', 'Style, heart, and multiverse madness in animation form.', 'Animation', 2018, 8.4, 'https://image.tmdb.org/t/p/w500/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg', FALSE, 'Netflix', 'Movie', 'English', 117, NULL),
('The Grand Budapest Hotel', 'A charmingly absurd caper wrapped in pastel elegance.', 'Comedy', 2014, 8.1, 'https://image.tmdb.org/t/p/w500/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg', FALSE, 'Prime Video', 'Movie', 'English', 100, NULL),
('Her', 'An intimate futuristic romance about loneliness and connection.', 'Romance', 2013, 8.0, 'https://image.tmdb.org/t/p/w500/yk4J4aewWYNiBhD49WD7UaBBn37.jpg', FALSE, 'Netflix', 'Movie', 'English', 126, NULL),
('The Truman Show', 'A man discovers his life is a manufactured spectacle.', 'Drama', 1998, 8.2, 'https://image.tmdb.org/t/p/w500/vuza0WqY239yBXOadKlGwJsZJFE.jpg', FALSE, 'Prime Video', 'Movie', 'English', 103, NULL),
('Arrival', 'Language, time, and grief intersect through alien contact.', 'Sci-Fi', 2016, 8.0, 'https://image.tmdb.org/t/p/w500/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg', FALSE, 'Netflix', 'Movie', 'English', 116, NULL),
('The Revenant', 'A brutal survival odyssey driven by vengeance.', 'Adventure', 2015, 8.0, 'https://image.tmdb.org/t/p/w500/ji3ecJphATlVgWNY0B0RVXZizdf.jpg', FALSE, 'Prime Video', 'Movie', 'English', 156, NULL),
('Ford v Ferrari', 'Speed, rivalry, and obsession roar on the racetrack.', 'Drama', 2019, 8.1, 'https://image.tmdb.org/t/p/w500/dR1Ju50iudrOh3YgfwkAU1g2HZe.jpg', FALSE, 'Disney+ Hotstar', 'Movie', 'English', 152, NULL),

-- BOLLYWOOD / HINDI
('3 Idiots', 'A heartfelt, hilarious, and inspiring story about friendship and education.', 'Drama', 2009, 8.4, 'https://image.tmdb.org/t/p/w500/66A9MqXOyVFCssoloscw79z8Tew.jpg', TRUE, 'Netflix', 'Movie', 'Hindi', 170, NULL),
('Zindagi Na Milegi Dobara', 'Friendship, freedom, and emotional awakening across Spain.', 'Drama', 2011, 8.2, 'https://image.tmdb.org/t/p/w500/6P6hQ5Y9QXWfX8k1M7Y2x0o8Q7P.jpg', TRUE, 'Netflix', 'Movie', 'Hindi', 155, NULL),
('Tamasha', 'A poetic exploration of identity, performance, and love.', 'Romance', 2015, 7.3, 'https://image.tmdb.org/t/p/w500/m2D0rL1M3qJxK4lY5p7j8R9v1T2.jpg', FALSE, 'JioHotstar', 'Movie', 'Hindi', 139, NULL),
('Yeh Jawaani Hai Deewani', 'Youth, longing, travel, and love wrapped in nostalgia.', 'Romance', 2013, 7.2, 'https://image.tmdb.org/t/p/w500/em39H81XLCDgXsI7frM9N3d6b0V.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 160, NULL),
('Barfi!', 'A tender, whimsical romance filled with warmth and pain.', 'Romance', 2012, 8.1, 'https://image.tmdb.org/t/p/w500/4X0gJx4Y8K8k2V6h5M4Q8P1Y9Z1.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 151, NULL),
('Andhadhun', 'A darkly funny thriller where nothing is what it seems.', 'Thriller', 2018, 8.2, 'https://image.tmdb.org/t/p/w500/fQY8P8N6n1K5r7b4T2x6W8e3Q1R.jpg', TRUE, 'Netflix', 'Movie', 'Hindi', 139, NULL),
('Drishyam', 'A family man uses intelligence and calm to outplay the system.', 'Thriller', 2015, 8.2, 'https://image.tmdb.org/t/p/w500/vYw4gkM3T7oN9qQ2R1b4X5W6P7L.jpg', FALSE, 'Prime Video', 'Movie', 'Hindi', 163, NULL),
('Kahaani', 'A pregnant woman navigates a city of secrets and deception.', 'Thriller', 2012, 8.1, 'https://image.tmdb.org/t/p/w500/7YQ4N8J2B1V6M3R9Q0L4T5P8X1Z.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 122, NULL),
('Gangs of Wasseypur', 'Violence, legacy, politics, and revenge across generations.', 'Crime', 2012, 8.2, 'https://image.tmdb.org/t/p/w500/3zQ2X1Y7P8L5M6N9R4V2B0K1Q8J.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 160, NULL),
('Rockstar', 'A broken artist turns pain into immortal music.', 'Drama', 2011, 7.7, 'https://image.tmdb.org/t/p/w500/x3qJj0F7b2L6K4M8Q5N1T9R2P7W.jpg', FALSE, 'JioHotstar', 'Movie', 'Hindi', 159, NULL),
('Wake Up Sid', 'A coming-of-age comfort film about growth and purpose.', 'Drama', 2009, 7.6, 'https://image.tmdb.org/t/p/w500/u8L1R4M2Q6T5X7P9V3N1B8K0W4Y.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 138, NULL),
('Chhichhore', 'A nostalgic and emotional reminder that failure is not the end.', 'Drama', 2019, 8.3, 'https://image.tmdb.org/t/p/w500/7sGJb5M1X4P9Q2R8L6T3V0N5Y1W.jpg', FALSE, 'Disney+ Hotstar', 'Movie', 'Hindi', 143, NULL),
('Dil Chahta Hai', 'Friendship and adulthood arrive with equal force.', 'Drama', 2001, 8.1, 'https://image.tmdb.org/t/p/w500/m4hN6g6nM3mZQzS7vR8Y3t6J9kA.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 183, NULL),
('Kal Ho Naa Ho', 'Love, friendship, and loss wrapped in warmth.', 'Romance', 2003, 8.0, 'https://image.tmdb.org/t/p/w500/4wHh4kW0WkQ9jZVxj2fN3wR0P7Q.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 186, NULL),
('Taare Zameen Par', 'A deeply moving story about childhood and understanding.', 'Drama', 2007, 8.4, 'https://image.tmdb.org/t/p/w500/tN5nZt8b0gY2wQ8c4qA6nN7mL2H.jpg', TRUE, 'Netflix', 'Movie', 'Hindi', 165, NULL),
('Bhool Bhulaiyaa', 'Comedy and psychological horror collide in a haunted haveli.', 'Comedy', 2007, 7.4, 'https://image.tmdb.org/t/p/w500/4l9l1G6v7x4aR2Y8dJ9Q3bN6kM0.jpg', FALSE, 'Prime Video', 'Movie', 'Hindi', 151, NULL),
('PK', 'A curious outsider questions faith, systems, and humanity.', 'Comedy', 2014, 8.1, 'https://image.tmdb.org/t/p/w500/dCgm7efXDmiABSdWDHBDBx2jwmn.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 153, NULL),
('Queen', 'A solo honeymoon becomes a journey of self-worth.', 'Drama', 2014, 8.1, 'https://image.tmdb.org/t/p/w500/fn5t3A1M0v0Y8X4R2J7N3Q8L6P2.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 146, NULL),
('Article 15', 'A cop confronts caste violence and institutional rot.', 'Crime', 2019, 8.1, 'https://image.tmdb.org/t/p/w500/6WBeq4fCfn7AN0o21W9qNcRF2l9.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 130, NULL),
('Udaan', 'A boy struggles against control to reclaim his life.', 'Drama', 2010, 8.1, 'https://image.tmdb.org/t/p/w500/f5Y5c5kP4l0dT7gQ8nN6rB3vJ2L.jpg', FALSE, 'Netflix', 'Movie', 'Hindi', 134, NULL),

-- ANIME MOVIES / SERIES
('Your Name', 'A visually stunning emotional romance woven through time and fate.', 'Anime', 2016, 8.4, 'https://image.tmdb.org/t/p/w500/q719jXXEzOoYaps6babgKnONONX.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 106, NULL),
('A Silent Voice', 'A painful and beautiful story of guilt, redemption, and connection.', 'Anime', 2016, 8.1, 'https://image.tmdb.org/t/p/w500/tuFaWiqX0TXoWu7DGNcmX3UW7sT.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 130, NULL),
('Weathering With You', 'Love and climate fantasy collide in gorgeous visual form.', 'Anime', 2019, 7.5, 'https://image.tmdb.org/t/p/w500/qgrk7r1fV4IjuoeiGS5HOhXNdLJ.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 112, NULL),
('Suzume', 'A mystical road journey through grief, memory, and healing.', 'Anime', 2022, 7.6, 'https://image.tmdb.org/t/p/w500/vIeu8WysZrTSFb2uhPViKjX9EcC.jpg', FALSE, 'Crunchyroll', 'Movie', 'Japanese', 122, NULL),
('Spirited Away', 'A timeless fantasy masterpiece full of wonder and symbolism.', 'Anime', 2001, 9.3, 'https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg', TRUE, 'Netflix', 'Movie', 'Japanese', 125, NULL),
('Howl''s Moving Castle', 'A magical anti-war fairytale wrapped in tenderness.', 'Anime', 2004, 8.2, 'https://image.tmdb.org/t/p/w500/23hUJh7JdO23SpgUB5oiFDQk2wX.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 119, NULL),
('Princess Mononoke', 'Nature, war, and humanity clash in mythic grandeur.', 'Anime', 1997, 8.4, 'https://image.tmdb.org/t/p/w500/cMYCDADoLKLbB83g4WnJegaZimC.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 134, NULL),
('Grave of the Fireflies', 'A devastating anti-war story of survival and loss.', 'Anime', 1988, 8.5, 'https://image.tmdb.org/t/p/w500/k9tv1rXZbOhH7eiCk378x61kNQ1.jpg', FALSE, 'Netflix', 'Movie', 'Japanese', 89, NULL),
('Attack on Titan', 'Humanity fights for survival against terrifying giants.', 'Anime', 2013, 9.0, 'https://image.tmdb.org/t/p/w500/hTP1DtLGFamjfu8WqjnuQdP1n4i.jpg', TRUE, 'Crunchyroll', 'Series', 'Japanese', NULL, 4),
('Death Note', 'A genius student discovers a notebook that grants deadly power.', 'Anime', 2006, 9.0, 'https://image.tmdb.org/t/p/w500/tCZFfYTIwrR7n94J6G14Y4hAFU6.jpg', TRUE, 'Netflix', 'Series', 'Japanese', NULL, 1),
('Demon Slayer', 'Stylish sword fights and emotional family-driven storytelling.', 'Anime', 2019, 8.7, 'https://image.tmdb.org/t/p/w500/wrCVHdkBlBWdJUZPvnJWcBRuhSY.jpg', FALSE, 'Crunchyroll', 'Series', 'Japanese', NULL, 4),
('Jujutsu Kaisen', 'Cursed energy, stylish combat, and modern shonen charisma.', 'Anime', 2020, 8.6, 'https://image.tmdb.org/t/p/w500/hFWP5HkbVEe40hrXgtCeQxoccHE.jpg', FALSE, 'Crunchyroll', 'Series', 'Japanese', NULL, 2),
('Naruto', 'A lonely ninja dreams of recognition and greatness.', 'Anime', 2002, 8.4, 'https://image.tmdb.org/t/p/w500/vauCEnR7CiyBDzRCeElKkCaXIYu.jpg', FALSE, 'Crunchyroll', 'Series', 'Japanese', NULL, 5),
('One Piece', 'Pirates chase freedom, treasure, and impossible dreams.', 'Anime', 1999, 8.9, 'https://image.tmdb.org/t/p/w500/eiYVyQh8QbM6B4D9t0Vb2cA8wT7.jpg', TRUE, 'Crunchyroll', 'Series', 'Japanese', NULL, 20),
('Vinland Saga', 'War, revenge, and purpose collide in Viking bloodshed.', 'Anime', 2019, 8.8, 'https://image.tmdb.org/t/p/w500/x7wW6fJzj1jA4W4K6gJ7M9R4b8X.jpg', FALSE, 'Netflix', 'Series', 'Japanese', NULL, 2),
('Monster', 'A surgeon hunts the human monster he once saved.', 'Anime', 2004, 8.7, 'https://image.tmdb.org/t/p/w500/rhP5A9k5X9l6Q0dV4J2P8R7T3W1.jpg', FALSE, 'Netflix', 'Series', 'Japanese', NULL, 1),
('Erased', 'A man travels back in time to prevent a childhood tragedy.', 'Anime', 2016, 8.5, 'https://image.tmdb.org/t/p/w500/8Q2K4H7L1M5V9T3N6P0X2R8J1W4.jpg', FALSE, 'Netflix', 'Series', 'Japanese', NULL, 1),
('Steins;Gate', 'A bizarre invention spirals into a brilliant time-travel thriller.', 'Anime', 2011, 8.8, 'https://image.tmdb.org/t/p/w500/cux0qQYQh6kM9A4n5x7vJ8R2bL1.jpg', FALSE, 'Netflix', 'Series', 'Japanese', NULL, 1),
('Blue Lock', 'Ego, ambition, and football intensity turned into anime spectacle.', 'Anime', 2022, 8.3, 'https://image.tmdb.org/t/p/w500/7iJ5r6n2P0Q4W8M1V3X9T6L2B4K.jpg', FALSE, 'Crunchyroll', 'Series', 'Japanese', NULL, 1),
('Haikyuu!!', 'Volleyball becomes pure adrenaline and heart.', 'Anime', 2014, 8.7, 'https://image.tmdb.org/t/p/w500/4Q5s6T7R8Y9U1I2O3P4A5S6D7F8.jpg', FALSE, 'Crunchyroll', 'Series', 'Japanese', NULL, 4),

-- WEB SERIES / GLOBAL SERIES
('Stranger Things', 'A thrilling supernatural mystery with friendship at its core.', 'Sci-Fi', 2016, 8.7, 'https://image.tmdb.org/t/p/w500/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', TRUE, 'Netflix', 'Series', 'English', NULL, 4),
('Breaking Bad', 'A chemistry teacher descends into the brutal world of meth production.', 'Crime', 2008, 9.5, 'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg', TRUE, 'Netflix', 'Series', 'English', NULL, 5),
('Better Call Saul', 'A tragic, brilliant descent into legal and moral corruption.', 'Crime', 2015, 9.0, 'https://image.tmdb.org/t/p/w500/fC2HDm5t0kHl7M8e7k7bmjKJj4k.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 6),
('Dark', 'Time travel, grief, and existential dread in a perfect labyrinth.', 'Sci-Fi', 2017, 8.7, 'https://image.tmdb.org/t/p/w500/5Lo5L4yRbkQ9wq6W6q3G7M7r9ZK.jpg', TRUE, 'Netflix', 'Series', 'German', NULL, 3),
('The Bear', 'An intense and emotional kitchen drama about grief, pressure, and craft.', 'Drama', 2022, 8.6, 'https://image.tmdb.org/t/p/w500/sHFlbKS3WLqMnp9tV0gcbmK2JzQ.jpg', FALSE, 'Disney+ Hotstar', 'Series', 'English', NULL, 3),
('True Detective', 'Bleak philosophy and murder investigation collide in unforgettable style.', 'Crime', 2014, 8.9, 'https://image.tmdb.org/t/p/w500/6X7K4J3L1M9Q8P2V5T0N4B6Y1W.jpg', FALSE, 'JioHotstar', 'Series', 'English', NULL, 4),
('Sherlock', 'Sharp, stylish deduction with modern energy.', 'Crime', 2010, 9.1, 'https://image.tmdb.org/t/p/w500/7WTsnHkbA0FaG6R9twfFde0I9hl.jpg', FALSE, 'Prime Video', 'Series', 'English', NULL, 4),
('Peaky Blinders', 'Style, smoke, power, and family in post-war Birmingham.', 'Crime', 2013, 8.8, 'https://image.tmdb.org/t/p/w500/vUUqzWa2LnHIVqkaKVlVGkVcZIW.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 6),
('The Last of Us', 'Love and survival endure in a broken world.', 'Drama', 2023, 8.8, 'https://image.tmdb.org/t/p/w500/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg', FALSE, 'JioHotstar', 'Series', 'English', NULL, 1),
('Euphoria', 'Youth, trauma, beauty, and self-destruction in neon form.', 'Drama', 2019, 8.3, 'https://image.tmdb.org/t/p/w500/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg', FALSE, 'JioHotstar', 'Series', 'English', NULL, 2),
('Game of Thrones', 'Power, betrayal, and war consume kingdoms.', 'Fantasy', 2011, 9.2, 'https://image.tmdb.org/t/p/w500/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg', TRUE, 'JioHotstar', 'Series', 'English', NULL, 8),
('House of the Dragon', 'Fire, blood, and succession tear a dynasty apart.', 'Fantasy', 2022, 8.4, 'https://image.tmdb.org/t/p/w500/z2yahl2uefxDCl0nogcRBstwruJ.jpg', FALSE, 'JioHotstar', 'Series', 'English', NULL, 2),
('The Office', 'Workplace absurdity turned into comfort television.', 'Comedy', 2005, 8.9, 'https://image.tmdb.org/t/p/w500/qWnJzyZhyy74gjpSjIXWmuk0ifX.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 9),
('Friends', 'Six friends, one city, endless comfort and chaos.', 'Comedy', 1994, 8.9, 'https://image.tmdb.org/t/p/w500/2koX1xLkpTQM4IZebYvKysFW1Nh.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 10),
('Black Mirror', 'Technology exposes the darkest parts of humanity.', 'Sci-Fi', 2011, 8.7, 'https://image.tmdb.org/t/p/w500/7PRddO7z7mcPi21nZTCMGShAyy1.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 6),
('The Boys', 'Superheroes are corrupted by fame, power, and brutality.', 'Action', 2019, 8.7, 'https://image.tmdb.org/t/p/w500/stTEycfG9928HYGEISBFaG1ngjM.jpg', FALSE, 'Prime Video', 'Series', 'English', NULL, 4),
('Mindhunter', 'FBI agents build criminal profiling from pure obsession.', 'Crime', 2017, 8.6, 'https://image.tmdb.org/t/p/w500/fbKE87mojpIETWepSbD5Qt741fp.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 2),
('The Queen''s Gambit', 'Chess becomes style, addiction, and brilliance.', 'Drama', 2020, 8.5, 'https://image.tmdb.org/t/p/w500/zU0htwkhNvBQdVSIKB9s6hgVeFK.jpg', FALSE, 'Netflix', 'Series', 'English', NULL, 1),
('Arcane', 'Animation, tragedy, and spectacle merge beautifully.', 'Animation', 2021, 9.0, 'https://image.tmdb.org/t/p/w500/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg', TRUE, 'Netflix', 'Series', 'English', NULL, 2),
('Money Heist', 'A stylish rebellion unfolds through masks and tension.', 'Thriller', 2017, 8.2, 'https://image.tmdb.org/t/p/w500/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg', FALSE, 'Netflix', 'Series', 'Spanish', NULL, 5);