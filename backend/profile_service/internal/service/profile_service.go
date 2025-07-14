package service

import (
    "errors"

    "profile_service/internal/model"
    "profile_service/internal/repository"
)

var (
    ErrProfileNotFound      = errors.New("profile not found")
    ErrProfileAlreadyExists = errors.New("profile already exists")
)

type ProfileService struct {
    repo repository.ProfileRepo
}

func NewProfileService(r repository.ProfileRepo) *ProfileService {
    return &ProfileService{repo: r}
}

func (s *ProfileService) CreateProfile(input *model.ProfileInput) error {
    // конвертация ProfileInput → model.Profile
    p := &model.Profile{
        UserID:        input.UserID,
        FirstName:     input.FirstName,
        LastName:      input.LastName,
        Gender:        input.Gender,
        DateOfBirth:   input.DateOfBirth,
        HeightCm:      input.HeightCm,
        WeightKg:      input.WeightKg,
        ActivityLevel: input.ActivityLevel,
        GoalWeightKg:  input.GoalWeightKg,
        Objective:     input.Objective,
    }
    if err := s.repo.Create(p); err != nil {
        if err == repository.ErrAlreadyCreated {
            return ErrProfileAlreadyExists
        }
        return err
    }
    return nil
}

func (s *ProfileService) GetProfile(userID string) (*model.Profile, error) {
    p, err := s.repo.FindByUserID(userID)
    if err != nil {
        if err == repository.ErrNotFound {
            return nil, ErrProfileNotFound
        }
        return nil, err
    }
    return p, nil
}
