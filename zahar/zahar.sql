-- 1. Создание пользователя (роль)
CREATE USER zahar WITH PASSWORD 'zahar';

-- 2. Создание схемы
CREATE SCHEMA zahar AUTHORIZATION zahar;

-- 3. Установить search_path пользователю
ALTER ROLE zahar SET search_path = zahar, public;

-- 4. Дать пользователю все права на схему
GRANT ALL PRIVILEGES ON SCHEMA zahar TO zahar;

-- 5. Создать таблицы от суперпользователя, но назначить владельца
SET ROLE zahar;

-- 6. Создание таблицы notes
CREATE TABLE zahar.notes (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

-- 7. Создание таблицы tasks
CREATE TABLE zahar.tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    is_done BOOLEAN DEFAULT FALSE
);


