package model

// FoodInput — модель для записи съеденных калорий
type FoodInput struct {
    UserID    string `json:"user_id"    binding:"required,uuid4"`
    EntryDate string `json:"entry_date" binding:"required,datetime=2006-01-02"`
    Calories  int    `json:"calories"   binding:"required,min=1"`
}
