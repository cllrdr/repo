CREATE OR REPLACE FUNCTION calculate_bar_rating(bar_id INTEGER, user_id INTEGER)
RETURNS NUMERIC(4,2) AS $$
DECLARE
    -- Переменные для хранения оценок пользователя
    up_quality NUMERIC;
    up_assortment NUMERIC;
    up_atmosphere NUMERIC;
    up_food NUMERIC;
    up_queues NUMERIC;
    up_sum NUMERIC;
    
    -- Переменные для хранения оценок категории
    cat_quality NUMERIC;
    cat_assortment NUMERIC;
    cat_atmosphere NUMERIC;
    cat_food NUMERIC;
    cat_queues NUMERIC;
    cat_sum NUMERIC;
    
    -- Переменные для хранения комбинированных весов
    combined_quality NUMERIC;
    combined_assortment NUMERIC;
    combined_atmosphere NUMERIC;
    combined_food NUMERIC;
    combined_queues NUMERIC;
    combined_sum NUMERIC;
    
    -- Переменные для хранения нормированных весов
    norm_quality NUMERIC;
    norm_assortment NUMERIC;
    norm_atmosphere NUMERIC;
    norm_food NUMERIC;
    norm_queues NUMERIC;
    
    -- Переменные для хранения оценок бара
    bp_quality INTEGER;
    bp_assortment INTEGER;
    bp_atmosphere INTEGER;
    bp_food INTEGER;
    bp_queues INTEGER;
    
    -- Результирующий рейтинг
    result_rating NUMERIC;
    
    -- ID категории бара
    bar_category_id INTEGER;
BEGIN
    -- Получаем category_id бара
    SELECT category_id INTO bar_category_id FROM bars WHERE id = bar_id;
    
    -- 1) Получаем и нормируем оценки пользователя
    SELECT 
        quality, assortment, atmosphere, food, queues,
        (quality + assortment + atmosphere + food + queues) AS sum
    INTO 
        up_quality, up_assortment, up_atmosphere, up_food, up_queues, up_sum
    FROM user_points 
    WHERE id = user_id;
    
    -- Нормируем оценки пользователя
    up_quality := up_quality / up_sum;
    up_assortment := up_assortment / up_sum;
    up_atmosphere := up_atmosphere / up_sum;
    up_food := up_food / up_sum;
    up_queues := up_queues / up_sum;
    
    -- 2) Получаем и нормируем оценки категории
    SELECT 
        quality, assortment, atmosphere, food, queues,
        (quality + assortment + atmosphere + food + queues) AS sum
    INTO 
        cat_quality, cat_assortment, cat_atmosphere, cat_food, cat_queues, cat_sum
    FROM categories 
    WHERE id = bar_category_id;
    
    -- Нормируем оценки категории
    cat_quality := cat_quality / cat_sum;
    cat_assortment := cat_assortment / cat_sum;
    cat_atmosphere := cat_atmosphere / cat_sum;
    cat_food := cat_food / cat_sum;
    cat_queues := cat_queues / cat_sum;
    
    -- 3) Складываем и нормируем комбинированные оценки
    combined_quality := up_quality + cat_quality;
    combined_assortment := up_assortment + cat_assortment;
    combined_atmosphere := up_atmosphere + cat_atmosphere;
    combined_food := up_food + cat_food;
    combined_queues := up_queues + cat_queues;
    combined_sum := combined_quality + combined_assortment + combined_atmosphere + combined_food + combined_queues;
    
    -- Нормируем комбинированные оценки
    norm_quality := combined_quality / combined_sum;
    norm_assortment := combined_assortment / combined_sum;
    norm_atmosphere := combined_atmosphere / combined_sum;
    norm_food := combined_food / combined_sum;
    norm_queues := combined_queues / combined_sum;
    
    -- 4) Получаем оценки бара и вычисляем рейтинг
    SELECT 
        quality, assortment, atmosphere, food, queues
    INTO 
        bp_quality, bp_assortment, bp_atmosphere, bp_food, bp_queues
    FROM bar_points 
    WHERE id = bar_id;
    
    -- Вычисляем рейтинг (умножаем оценки бара на нормированные веса и суммируем)
    result_rating := 
        (bp_quality * norm_quality) +
        (bp_assortment * norm_assortment) +
        (bp_atmosphere * norm_atmosphere) +
        (bp_food * norm_food) +
        (bp_queues * norm_queues);
    
    -- Масштабируем результат к шкале 1-10 (если нужно)
    -- result_rating := result_rating * 10 / (
    --    norm_quality + norm_assortment + norm_atmosphere + norm_food + norm_queues
    -- );
    
    -- Округляем до одного знака после запятой
    RETURN ROUND(result_rating, 2);
END;
$$ LANGUAGE plpgsql;