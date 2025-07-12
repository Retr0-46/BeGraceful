package model

// RegisterInput — входная модель для /register
type RegisterInput struct {
    Email    string `json:"email"    binding:"required,email"`
    Password string `json:"password" binding:"required,min=8"`
}
