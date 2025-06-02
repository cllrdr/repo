# Описание схемы для оценки баров

таблица: bars
поля: id, name, coordinates, info, category_id, rate
id - index, primary key
name, category_id - NOT NULL
category_id - foreign key на categories.id

таблица: users
поля: id, login
id - index, primary key

таблица: categories
поля: id, name, quality, assortment, atmosphere, food, queues
id - index, primary key
name - NOT NULL

таблица: bar_points
поля: id, quality, assortment, atmosphere, food, queues
id - index, foreign key на bars.id

таблица: user_points
поля: id, quality, assortment, atmosphere, food, queues
id - index, foreign key на user.id

Все поля quality, assortment, atmosphere, food, queues будут содержать оценку по шкале от 1 до 10 в целых числах.




