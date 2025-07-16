package service

import (
	"errors"
	"log"

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
	log.Printf("[DEBUG] ProfileService.CreateProfile: starting for user_id=%s", input.UserID)
	// конвертация ProfileInput → model.Profile
	p := &model.Profile{
		UserID:          input.UserID,
		FirstName:       input.FirstName,
		LastName:        input.LastName,
		Gender:          input.Gender,
		DateOfBirth:     input.DateOfBirth,
		HeightCm:        input.HeightCm,
		WeightKg:        input.WeightKg,
		CurrentWeightKg: input.WeightKg, // Initialize current weight with initial weight (same as WeightKg)
		ActivityLevel:   input.ActivityLevel,
		GoalWeightKg:    input.GoalWeightKg,
		Objective:       input.Objective,
	}
	log.Printf("[DEBUG] ProfileService.CreateProfile: calling repo.Create for user_id=%s", p.UserID)
	if err := s.repo.Create(p); err != nil {
		log.Printf("[ERROR] ProfileService.CreateProfile: repo.Create failed - %v", err)
		if err == repository.ErrAlreadyCreated {
			return ErrProfileAlreadyExists
		}
		return err
	}
	log.Printf("[DEBUG] ProfileService.CreateProfile: profile created successfully for user_id=%s", p.UserID)
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

func (s *ProfileService) UpdateProfile(input *model.ProfileInput) error {
	log.Printf("[DEBUG] ProfileService.UpdateProfile: starting for user_id=%s", input.UserID)
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
	log.Printf("[DEBUG] ProfileService.UpdateProfile: calling repo.Update for user_id=%s", p.UserID)
	if err := s.repo.Update(p); err != nil {
		log.Printf("[ERROR] ProfileService.UpdateProfile: repo.Update failed - %v", err)
		if err == repository.ErrNotFound {
			return ErrProfileNotFound
		}
		return err
	}
	log.Printf("[DEBUG] ProfileService.UpdateProfile: profile updated successfully for user_id=%s", p.UserID)
	return nil
}

func (s *ProfileService) UpdateWeight(userID string, weightKg int) error {
	log.Printf("[DEBUG] ProfileService.UpdateWeight: starting for user_id=%s, weight=%d", userID, weightKg)
	if err := s.repo.UpdateWeight(userID, weightKg); err != nil {
		log.Printf("[ERROR] ProfileService.UpdateWeight: repo.UpdateWeight failed - %v", err)
		if err == repository.ErrNotFound {
			return ErrProfileNotFound
		}
		return err
	}
	log.Printf("[DEBUG] ProfileService.UpdateWeight: weight updated successfully for user_id=%s", userID)
	return nil
}
