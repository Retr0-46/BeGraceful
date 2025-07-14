package model

import "time"

// Profile — полная модель профиля
type Profile struct {
    UserID        string    `json:"user_id"`
    FirstName     string    `json:"first_name"`
    LastName      string    `json:"last_name"`
    Gender        string    `json:"gender"`
    DateOfBirth   string    `json:"date_of_birth"`
    HeightCm      int       `json:"height_cm"`
    WeightKg      int       `json:"weight_kg"`
    ActivityLevel string    `json:"activity_level"`
    GoalWeightKg  int       `json:"goal_weight_kg"`
    Objective     string    `json:"objective"`
    CreatedAt     time.Time `json:"created_at"`
}
