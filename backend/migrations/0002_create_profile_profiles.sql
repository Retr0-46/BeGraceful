CREATE SCHEMA IF NOT EXISTS profile;

CREATE TABLE profile.profiles (
  user_id        UUID PRIMARY KEY,
  first_name     TEXT NOT NULL,
  last_name      TEXT NOT NULL,
  gender         TEXT NOT NULL,
  date_of_birth  DATE NOT NULL,
  height_cm      INT NOT NULL,
  weight_kg      INT NOT NULL,
  activity_level TEXT NOT NULL,
  goal_weight_kg INT NOT NULL,
  objective      TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
