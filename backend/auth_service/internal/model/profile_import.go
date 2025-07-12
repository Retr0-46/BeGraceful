package model

// ProfileInput — входная модель для /complete-profile
type ProfileInput struct {
    UserID        string `json:"user_id"        binding:"required,uuid4"`
    FirstName     string `json:"first_name"     binding:"required"`
    LastName      string `json:"last_name"      binding:"required"`
    Gender        string `json:"gender"         binding:"required,oneof=male female other"`
    DateOfBirth   string `json:"date_of_birth"  binding:"required,datetime=2006-01-02"`
    HeightCm      int    `json:"height_cm"      binding:"required,min=30,max=300"`
    WeightKg      int    `json:"weight_kg"      binding:"required,min=10,max=500"`
    ActivityLevel string `json:"activity_level" binding:"required,oneof=low moderate high"`
    GoalWeightKg  int    `json:"goal_weight_kg" binding:"required,min=10,max=500"`
    Objective     string `json:"objective"      binding:"required"` // lose_weight, gain_mass и т.д.
}
