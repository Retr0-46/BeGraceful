package model

// WorkoutInput — модель для записи сожжённых на тренировке калорий
type WorkoutInput struct {
    UserID         string `json:"user_id"         binding:"required,uuid4"`
    EntryDate      string `json:"entry_date"      binding:"required,datetime=2006-01-02"`
    CaloriesBurned int    `json:"calories_burned" binding:"required,min=1"`
}
