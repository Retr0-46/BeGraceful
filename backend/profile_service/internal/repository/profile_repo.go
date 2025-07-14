package repository

import (
    "database/sql"
    "errors"
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
    // Ваша реализация...
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
                height_cm,weight_kg,activity_level,goal_weight_kg,objective,created_at
           FROM profile.profiles WHERE user_id = $1`,
        userID,
    ).Scan(
        &p.UserID, &p.FirstName, &p.LastName, &p.Gender, &dob,
        &p.HeightCm, &p.WeightKg, &p.ActivityLevel, &p.GoalWeightKg,
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

    return p, nil
}
