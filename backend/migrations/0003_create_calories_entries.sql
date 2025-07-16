-- Создание схемы для калорий
CREATE SCHEMA IF NOT EXISTS calories;

-- Таблица для записей о съеденной пище
CREATE TABLE IF NOT EXISTS calories.food_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    entry_date DATE NOT NULL,
    name VARCHAR(255) NOT NULL,
    calories INTEGER NOT NULL CHECK (calories > 0),
    proteins DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (proteins >= 0),
    fats DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (fats >= 0),
    carbs DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (carbs >= 0),
    meal_type VARCHAR(50) NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snacks')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица для записей о тренировках
CREATE TABLE IF NOT EXISTS calories.workout_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    entry_date DATE NOT NULL,
    name VARCHAR(255) NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    calories_burned INTEGER NOT NULL CHECK (calories_burned > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Индексы для оптимизации запросов
CREATE INDEX IF NOT EXISTS idx_food_entries_user_date ON calories.food_entries(user_id, entry_date);
CREATE INDEX IF NOT EXISTS idx_workout_entries_user_date ON calories.workout_entries(user_id, entry_date);

-- Триггеры для обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_food_entries_updated_at 
    BEFORE UPDATE ON calories.food_entries 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_entries_updated_at 
    BEFORE UPDATE ON calories.workout_entries 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
