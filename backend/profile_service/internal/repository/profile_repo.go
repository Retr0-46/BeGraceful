package repository

import (
    "database/sql"
    "errors"
    "time"

    "github.com/lib/pq"
    "profile_service/internal/model"
)

var (
    ErrNotFound       = errors.New("profile not found")
    ErrAlreadyCreated = errors.New("profile already exists")
)

type ProfileRepo interface {
    Create(p *model.Profile) error
    FindByUserID(userID string) (*model.Profile, error)
}

type repo struct {
    db *sql.DB
}

func NewProfileRepo(db *sql.DB) ProfileRepo {
    return &repo{db: db}
}

func (r *repo) Create(p *model.Profile) error {
    _, err := r.db.Exec(
        `INSERT INTO profile.profiles 
         (user_id,first_name,last_name,gender,date_of_birth,
          height_cm,weight_kg,activity_level,goal_weight_kg,objective,created_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)`,
        p.UserID, p.FirstName, p.LastName, p.Gender, p.DateOfBirth,
        p.HeightCm, p.WeightKg, p.ActivityLevel, p.GoalWeightKg,
        p.Objective, time.Now(),
    )
    if err != nil {
        // Проверяем, unique_violation ли это (код 23505)
        if pgErr, ok := err.(*pq.Error); ok && pgErr.Code == "23505" {
            return ErrAlreadyCreated
        }
        return err
    }
    return nil
}

func (r *repo) FindByUserID(userID string) (*model.Profile, error) {
    p := &model.Profile{}
    row := r.db.QueryRow(
        `SELECT user_id,first_name,last_name,gender,date_of_birth,
                height_cm,weight_kg,activity_level,goal_weight_kg,objective,created_at
           FROM profile.profiles WHERE user_id=$1`,
        userID,
    )
    if err := row.Scan(
        &p.UserID, &p.FirstName, &p.LastName, &p.Gender, &p.DateOfBirth,
        &p.HeightCm, &p.WeightKg, &p.ActivityLevel, &p.GoalWeightKg,
        &p.Objective, &p.CreatedAt,
    ); err != nil {
        if err == sql.ErrNoRows {
            return nil, ErrNotFound
        }
        return nil, err
    }
    return p, nil
}
