package repository

import (
	"database/sql"
)

type CaloriesRepo interface {
	AddFood(userID string, date string, name string, calories int, proteins, fats, carbs float64, mealType string) error
	AddWorkout(userID string, date string, name string, durationMinutes, caloriesBurned int) error
	SumFood(userID string, date string) (int, error)
	SumWorkout(userID string, date string) (int, error)
	GetFoodEntries(userID string, date string) ([]FoodEntry, error)
	GetWorkoutEntries(userID string, date string) ([]WorkoutEntry, error)
}

type FoodEntry struct {
	ID       string  `json:"id"`
	Name     string  `json:"name"`
	Calories int     `json:"calories"`
	Proteins float64 `json:"proteins"`
	Fats     float64 `json:"fats"`
	Carbs    float64 `json:"carbs"`
	MealType string  `json:"meal_type"`
}

type WorkoutEntry struct {
	ID              string `json:"id"`
	Name            string `json:"name"`
	DurationMinutes int    `json:"duration_minutes"`
	CaloriesBurned  int    `json:"calories_burned"`
}

type repo struct {
	db *sql.DB
}

func NewCaloriesRepo(db *sql.DB) CaloriesRepo {
	return &repo{db: db}
}

func (r *repo) AddFood(userID, date string, name string, calories int, proteins, fats, carbs float64, mealType string) error {
	_, err := r.db.Exec(
		`INSERT INTO calories.food_entries (user_id, entry_date, name, calories, proteins, fats, carbs, meal_type) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		userID, date, name, calories, proteins, fats, carbs, mealType,
	)
	return err
}

func (r *repo) AddWorkout(userID, date string, name string, durationMinutes, caloriesBurned int) error {
	_, err := r.db.Exec(
		`INSERT INTO calories.workout_entries (user_id, entry_date, name, duration_minutes, calories_burned) 
         VALUES ($1, $2, $3, $4, $5)`,
		userID, date, name, durationMinutes, caloriesBurned,
	)
	return err
}

func (r *repo) SumFood(userID, date string) (int, error) {
	var sum sql.NullInt64
	err := r.db.QueryRow(
		`SELECT COALESCE(SUM(calories),0) FROM calories.food_entries WHERE user_id=$1 AND entry_date=$2`,
		userID, date,
	).Scan(&sum)
	if err != nil {
		return 0, err
	}
	return int(sum.Int64), nil
}

func (r *repo) SumWorkout(userID, date string) (int, error) {
	var sum sql.NullInt64
	err := r.db.QueryRow(
		`SELECT COALESCE(SUM(calories_burned),0) FROM calories.workout_entries WHERE user_id=$1 AND entry_date=$2`,
		userID, date,
	).Scan(&sum)
	if err != nil {
		return 0, err
	}
	return int(sum.Int64), nil
}

func (r *repo) GetFoodEntries(userID, date string) ([]FoodEntry, error) {
	rows, err := r.db.Query(
		`SELECT id, name, calories, proteins, fats, carbs, meal_type 
         FROM calories.food_entries 
         WHERE user_id=$1 AND entry_date=$2 
         ORDER BY created_at`,
		userID, date,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var entries []FoodEntry
	for rows.Next() {
		var entry FoodEntry
		err := rows.Scan(&entry.ID, &entry.Name, &entry.Calories, &entry.Proteins, &entry.Fats, &entry.Carbs, &entry.MealType)
		if err != nil {
			return nil, err
		}
		entries = append(entries, entry)
	}
	return entries, nil
}

func (r *repo) GetWorkoutEntries(userID, date string) ([]WorkoutEntry, error) {
	rows, err := r.db.Query(
		`SELECT id, name, duration_minutes, calories_burned 
         FROM calories.workout_entries 
         WHERE user_id=$1 AND entry_date=$2 
         ORDER BY created_at`,
		userID, date,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var entries []WorkoutEntry
	for rows.Next() {
		var entry WorkoutEntry
		err := rows.Scan(&entry.ID, &entry.Name, &entry.DurationMinutes, &entry.CaloriesBurned)
		if err != nil {
			return nil, err
		}
		entries = append(entries, entry)
	}
	return entries, nil
}
