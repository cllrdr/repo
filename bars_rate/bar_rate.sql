-- Создаем схему
CREATE SCHEMA bar_rate;

-- Устанавливаем схему по умолчанию
SET search_path TO bar_rate;

-- Таблица categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quality INTEGER CHECK (quality BETWEEN 1 AND 10),
    assortment INTEGER CHECK (assortment BETWEEN 1 AND 10),
    atmosphere INTEGER CHECK (atmosphere BETWEEN 1 AND 10),
    food INTEGER CHECK (food BETWEEN 1 AND 10),
    queues INTEGER CHECK (queues BETWEEN 1 AND 10)
);

-- Таблица users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    login VARCHAR(255) NOT NULL
);

-- Таблица bars
CREATE TABLE bars (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    coordinates POINT,
    info TEXT,
    category_id INTEGER NOT NULL,
    rate NUMERIC(3, 1),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Таблица bar_points
CREATE TABLE bar_points (
    id INTEGER,
    quality INTEGER CHECK (quality BETWEEN 1 AND 10),
    assortment INTEGER CHECK (assortment BETWEEN 1 AND 10),
    atmosphere INTEGER CHECK (atmosphere BETWEEN 1 AND 10),
    food INTEGER CHECK (food BETWEEN 1 AND 10),
    queues INTEGER CHECK (queues BETWEEN 1 AND 10),
    FOREIGN KEY (id) REFERENCES bars(id)
);

-- Таблица user_points
CREATE TABLE user_points (
    id INTEGER,
    quality INTEGER CHECK (quality BETWEEN 1 AND 10),
    assortment INTEGER CHECK (assortment BETWEEN 1 AND 10),
    atmosphere INTEGER CHECK (atmosphere BETWEEN 1 AND 10),
    food INTEGER CHECK (food BETWEEN 1 AND 10),
    queues INTEGER CHECK (queues BETWEEN 1 AND 10),
    FOREIGN KEY (id) REFERENCES users(id)
);

-- Таблица bar_user_rating
CREATE TABLE bar_user_ratings (
    bar_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    calculated_rate NUMERIC(4,2) NOT NULL,
    calculation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (bar_id, user_id),
    FOREIGN KEY (bar_id) REFERENCES bars(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);