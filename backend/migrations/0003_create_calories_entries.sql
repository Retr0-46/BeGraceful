CREATE SCHEMA IF NOT EXISTS calories;

CREATE TABLE calories.food_entries (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL,
  entry_date DATE NOT NULL,
  calories   INT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE calories.workout_entries (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL,
  entry_date      DATE NOT NULL,
  calories_burned INT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
