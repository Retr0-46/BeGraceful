package repository

import (
	"database/sql"
	"errors"
	"log"
	"strings"
	"time"

	"profile_service/internal/model"
)

var (
	ErrNotFound       = errors.New("profile not found")
	ErrAlreadyCreated = errors.New("profile already exists")
)

// ProfileRepo описывает хранение профилей
type ProfileRepo interface {
	Create(p *model.Profile) error
	FindByUserID(userID string) (*model.Profile, error)
	Update(p *model.Profile) error
	UpdateWeight(userID string, weightKg int) error
}

// repo — закрытая реализация ProfileRepo
type repo struct {
	db *sql.DB
}

// NewProfileRepo конструирует ProfileRepo
func NewProfileRepo(db *sql.DB) ProfileRepo {
	return &repo{db: db}
}

// Create сохраняет новый профиль
func (r *repo) Create(p *model.Profile) error {
	log.Printf("[DEBUG] ProfileRepo.Create: starting for user_id=%s", p.UserID)
	_, err := r.db.Exec(
		`INSERT INTO profile.profiles
        (user_id, first_name, last_name, gender, date_of_birth, height_cm, weight_kg, current_weight_kg, activity_level, goal_weight_kg, objective, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, NOW())`,
		p.UserID, p.FirstName, p.LastName, p.Gender, p.DateOfBirth,
		p.HeightCm, p.WeightKg, p.CurrentWeightKg, p.ActivityLevel, p.GoalWeightKg, p.Objective,
	)
	if err != nil {
		log.Printf("[ERROR] ProfileRepo.Create: database error - %v", err)
		if strings.Contains(err.Error(), "duplicate key") {
			return ErrAlreadyCreated
		}
		return err
	}
	log.Printf("[DEBUG] ProfileRepo.Create: profile saved successfully for user_id=%s", p.UserID)
	return nil
}

// Update обновляет существующий профиль
func (r *repo) Update(p *model.Profile) error {
	log.Printf("[DEBUG] ProfileRepo.Update: starting for user_id=%s", p.UserID)
	_, err := r.db.Exec(
		`UPDATE profile.profiles
        SET first_name = $2, last_name = $3, gender = $4, date_of_birth = $5,
            height_cm = $6, weight_kg = $7, activity_level = $8, goal_weight_kg = $9, objective = $10
        WHERE user_id = $1`,
		p.UserID, p.FirstName, p.LastName, p.Gender, p.DateOfBirth,
		p.HeightCm, p.WeightKg, p.ActivityLevel, p.GoalWeightKg, p.Objective,
	)
	if err != nil {
		log.Printf("[ERROR] ProfileRepo.Update: database error - %v", err)
		return err
	}
	log.Printf("[DEBUG] ProfileRepo.Update: profile updated successfully for user_id=%s", p.UserID)
	return nil
}

// UpdateWeight обновляет только вес пользователя
func (r *repo) UpdateWeight(userID string, weightKg int) error {
	log.Printf("[DEBUG] ProfileRepo.UpdateWeight: starting for user_id=%s, weight=%d", userID, weightKg)
	result, err := r.db.Exec(
		`UPDATE profile.profiles SET current_weight_kg = $2 WHERE user_id = $1::uuid`,
		userID, weightKg,
	)
	if err != nil {
		log.Printf("[ERROR] ProfileRepo.UpdateWeight: database error - %v", err)
		return err
	}
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		log.Printf("[ERROR] ProfileRepo.UpdateWeight: failed to get rows affected - %v", err)
		return err
	}
	if rowsAffected == 0 {
		log.Printf("[ERROR] ProfileRepo.UpdateWeight: no rows affected for user_id=%s", userID)
		return ErrNotFound
	}
	log.Printf("[DEBUG] ProfileRepo.UpdateWeight: weight updated successfully for user_id=%s", userID)
	return nil
}

// FindByUserID ищет профиль. Если нет — возвращает ErrNotFound.
func (r *repo) FindByUserID(userID string) (*model.Profile, error) {
	// Прочитаем дату рождения и created_at как time.Time
	var dob, createdAt time.Time

	// Создаём объект для заполнения
	p := &model.Profile{}

	// Читаем из БД
	err := r.db.QueryRow(
		`SELECT user_id,first_name,last_name,gender,date_of_birth,
                height_cm,weight_kg,current_weight_kg,activity_level,goal_weight_kg,objective,created_at
           FROM profile.profiles WHERE user_id = $1::uuid`,
		userID,
	).Scan(
		&p.UserID, &p.FirstName, &p.LastName, &p.Gender, &dob,
		&p.HeightCm, &p.WeightKg, &p.CurrentWeightKg, &p.ActivityLevel, &p.GoalWeightKg,
		&p.Objective, &createdAt,
	)
	if err == sql.ErrNoRows {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, err
	}

	// Форматируем дату как "YYYY-MM-DD"
	p.DateOfBirth = dob.Format("2006-01-02")
	// При желании форматируем createdAt, например, в RFC3339
	p.CreatedAt = createdAt
	p.CreatedAtStr = createdAt.Format(time.RFC3339)

	return p, nil
}
