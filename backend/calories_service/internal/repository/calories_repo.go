package repository

import (
    "database/sql"
)

type CaloriesRepo interface {
    AddFood(userID string, date string, cals int) error
    AddWorkout(userID string, date string, calsBurned int) error
    SumFood(userID string, date string) (int, error)
    SumWorkout(userID string, date string) (int, error)
}

type repo struct {
    db *sql.DB
}

func NewCaloriesRepo(db *sql.DB) CaloriesRepo {
    return &repo{db: db}
}

func (r *repo) AddFood(userID, date string, cals int) error {
    _, err := r.db.Exec(
        `INSERT INTO calories.food_entries (user_id,entry_date,calories) VALUES ($1,$2,$3)`,
        userID, date, cals,
    )
    return err
}

func (r *repo) AddWorkout(userID, date string, calsBurned int) error {
    _, err := r.db.Exec(
        `INSERT INTO calories.workout_entries (user_id,entry_date,calories_burned) VALUES ($1,$2,$3)`,
        userID, date, calsBurned,
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
