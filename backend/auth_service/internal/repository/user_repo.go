package repository

import (
    "database/sql"
    "errors"

    "auth_service/internal/model"
)

var ErrNotFound = errors.New("not found")

// UserRepo описывает методы для работы с таблицей auth.users
type UserRepo interface {
    FindByEmail(email string) (*model.User, error)
    FindByID(id string) (*model.User, error)
    Create(email, passwordHash string) (string, error)
}

type repo struct {
    db *sql.DB
}

// NewUserRepo создаёт репозиторий
func NewUserRepo(db *sql.DB) UserRepo {
    return &repo{db: db}
}

func (r *repo) FindByEmail(email string) (*model.User, error) {
    u := &model.User{}
    err := r.db.QueryRow(
        `SELECT id, email, password_hash, created_at 
           FROM auth.users 
          WHERE email = $1`,
        email,
    ).Scan(&u.ID, &u.Email, &u.PasswordHash, &u.CreatedAt)

    if err == sql.ErrNoRows {
        return nil, ErrNotFound
    }
    return u, err
}

func (r *repo) FindByID(id string) (*model.User, error) {
    u := &model.User{}
    err := r.db.QueryRow(
        `SELECT id, email, password_hash, created_at 
           FROM auth.users 
          WHERE id = $1`,
        id,
    ).Scan(&u.ID, &u.Email, &u.PasswordHash, &u.CreatedAt)

    if err == sql.ErrNoRows {
        return nil, ErrNotFound
    }
    return u, err
}

func (r *repo) Create(email, passwordHash string) (string, error) {
    var id string
    err := r.db.QueryRow(
        `INSERT INTO auth.users (email, password_hash) 
            VALUES ($1, $2) 
         RETURNING id`,
        email, passwordHash,
    ).Scan(&id)
    return id, err
}
