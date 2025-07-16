package model

// FoodInput — модель для записи съеденных калорий
type FoodInput struct {
	UserID    string  `json:"user_id"    binding:"required,uuid4"`
	EntryDate string  `json:"entry_date" binding:"required,datetime=2006-01-02"`
	Name      string  `json:"name"       binding:"required"`
	Calories  int     `json:"calories"   binding:"required,min=1"`
	Proteins  float64 `json:"proteins"   binding:"required,min=0"`
	Fats      float64 `json:"fats"       binding:"required,min=0"`
	Carbs     float64 `json:"carbs"      binding:"required,min=0"`
	MealType  string  `json:"meal_type"  binding:"required"` // breakfast, lunch, dinner, snacks
}
