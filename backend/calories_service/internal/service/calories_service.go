package service

import (
    "encoding/json"
    "errors"
    "fmt"
    "net/http"
    "time"

    "calories_service/internal/model"
    "calories_service/internal/repository"
)

var (
    ErrUserNotFound       = errors.New("profile not found")
    ErrInvalidProfileData = errors.New("invalid profile data")
)

type CaloriesService struct {
    repo              repository.CaloriesRepo
    httpClient        *http.Client
    profileServiceURL string
}

func NewCaloriesService(repo repository.CaloriesRepo, profileURL string) *CaloriesService {
    return &CaloriesService{
        repo:              repo,
        httpClient:        &http.Client{Timeout: 5 * time.Second},
        profileServiceURL: profileURL,
    }
}

func (s *CaloriesService) LogFood(input *model.FoodInput) error {
    // проверяем профиль существует
    if ok, err := s.profileExists(input.UserID); err != nil {
        return err
    } else if !ok {
        return ErrUserNotFound
    }
    return s.repo.AddFood(input.UserID, input.EntryDate, input.Calories)
}

func (s *CaloriesService) LogWorkout(input *model.WorkoutInput) error {
    if ok, err := s.profileExists(input.UserID); err != nil {
        return err
    } else if !ok {
        return ErrUserNotFound
    }
    return s.repo.AddWorkout(input.UserID, input.EntryDate, input.CaloriesBurned)
}

func (s *CaloriesService) GetDailySummary(userID, date string) (*model.SummaryResponse, error) {
    // 1) проверяем профиль
    pr, err := s.fetchProfile(userID)
    if err != nil {
        if err == ErrUserNotFound {
            return nil, ErrUserNotFound
        }
        return nil, err
    }
    // 2) считаем съеденное и сожжённое
    consumed, err := s.repo.SumFood(userID, date)
    if err != nil {
        return nil, err
    }
    burned, err := s.repo.SumWorkout(userID, date)
    if err != nil {
        return nil, err
    }
    // 3) рассчитываем цель по Mifflin-St Jeor
    age := int(time.Since(pr.DateOfBirth).Hours() / 24 / 365)
    var bmr float64
	weight := float64(pr.WeightKg)
	height := float64(pr.HeightCm)
	a := float64(age)
    if pr.Gender == "male" {
    	bmr = 10*weight + 6.25*height - 5*a + 5
	} else {
    	bmr = 10*weight + 6.25*height - 5*a - 161
	}
    var factor float64
    switch pr.ActivityLevel {
    case "low":
        factor = 1.2
    case "moderate":
        factor = 1.55
    case "high":
        factor = 1.725
    default:
        factor = 1.2
    }
    goal := int(bmr * factor)

    remaining := goal - consumed + burned

    return &model.SummaryResponse{
        Consumed:  consumed,
        Burned:    burned,
        Remaining: remaining,
        Goal:      goal,
    }, nil
}

// profileExists делает GET /api/v1/profiles/{userID}
func (s *CaloriesService) profileExists(userID string) (bool, error) {
    url := fmt.Sprintf("%s/api/v1/profiles/%s", s.profileServiceURL, userID)
    resp, err := s.httpClient.Get(url)
    if err != nil {
        return false, err
    }
    defer resp.Body.Close()
    if resp.StatusCode == http.StatusOK {
        return true, nil
    }
    if resp.StatusCode == http.StatusNotFound {
        return false, nil
    }
    return false, fmt.Errorf("profile-service returned %d", resp.StatusCode)
}

// fetchProfile получает данные профиля для расчётов
func (s *CaloriesService) fetchProfile(userID string) (*Profile, error) {
    // В profile_service GET /api/v1/profiles/:user_id возвращает {"data":{…}}
    url := fmt.Sprintf("%s/api/v1/profiles/%s", s.profileServiceURL, userID)
    resp, err := s.httpClient.Get(url)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    if resp.StatusCode == http.StatusNotFound {
        return nil, ErrUserNotFound
    }
    var wrapper struct {
        Data struct {
            FirstName     string `json:"first_name"`
            LastName      string `json:"last_name"`
            Gender        string `json:"gender"`
            DateOfBirth   string `json:"date_of_birth"`
            HeightCm      int    `json:"height_cm"`
            WeightKg      int    `json:"weight_kg"`
            ActivityLevel string `json:"activity_level"`
        } `json:"data"`
    }
    if err := json.NewDecoder(resp.Body).Decode(&wrapper); err != nil {
        return nil, err
    }
    dob, err := time.Parse("2006-01-02", wrapper.Data.DateOfBirth)
    if err != nil {
        return nil, ErrInvalidProfileData
    }
    return &Profile{
        Gender:        wrapper.Data.Gender,
        DateOfBirth:   dob,
        HeightCm:      wrapper.Data.HeightCm,
        WeightKg:      wrapper.Data.WeightKg,
        ActivityLevel: wrapper.Data.ActivityLevel,
    }, nil
}

// Profile — минимальная модель для расчётов
type Profile struct {
    Gender        string
    DateOfBirth   time.Time
    HeightCm      int
    WeightKg      int
    ActivityLevel string
}
