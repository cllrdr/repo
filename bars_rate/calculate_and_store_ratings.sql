-- Устанавливаем схему по умолчанию
SET search_path TO bar_rate;

CREATE OR REPLACE PROCEDURE calculate_and_store_ratings(user_id INTEGER)
AS $$
DECLARE
    bar_record RECORD;
    calculated_value NUMERIC(4,2);
BEGIN
    -- Очищаем предыдущие расчеты для этого пользователя
    DELETE FROM bar_user_ratings WHERE bar_user_ratings.user_id = calculate_and_store_ratings.user_id;
    
    -- Рассчитываем и сохраняем рейтинги для всех баров
    FOR bar_record IN SELECT id FROM bars LOOP
        -- Вычисляем рейтинг
        calculated_value := calculate_bar_rating(bar_record.id, user_id);
        
        -- Сохраняем результат в новую таблицу
        INSERT INTO bar_user_ratings (bar_id, user_id, calculated_rate)
        VALUES (bar_record.id, user_id, calculated_value)
        ON CONFLICT ON CONSTRAINT bar_user_ratings_pkey 
        DO UPDATE SET calculated_rate = EXCLUDED.calculated_rate, 
                     calculation_date = CURRENT_TIMESTAMP;
    END LOOP;
    
    COMMIT;
END;
$$ LANGUAGE plpgsql;