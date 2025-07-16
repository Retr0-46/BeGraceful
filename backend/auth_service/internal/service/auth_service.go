package service

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"log" // добавляем логирование
	"net/http"
	"time"

	"auth_service/internal/model"
	"auth_service/internal/repository"

	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrInvalidCreds  = errors.New("invalid credentials")
	ErrProfileExists = errors.New("profile already exists")
	ErrUserNotFound  = errors.New("user not found")
)

type AuthService struct {
	repo              repository.UserRepo
	jwtSecret         []byte
	httpClient        *http.Client
	profileServiceURL string
}

func NewAuthService(repo repository.UserRepo, jwtSecret, profileServiceURL string) *AuthService {
	return &AuthService{
		repo:              repo,
		jwtSecret:         []byte(jwtSecret),
		httpClient:        &http.Client{Timeout: 5 * time.Second},
		profileServiceURL: profileServiceURL,
	}
}

// Step1Result — результат шага 1 регистрации
type Step1Result struct {
	NewUser bool
	UserID  string
	JWT     string
}

// Register выполняет шаг 1: создаёт нового юзера или логинит
func (s *AuthService) Register(email, pass string) (*Step1Result, error) {
	u, err := s.repo.FindByEmail(email)
	if err == repository.ErrNotFound {
		// новый юзер
		hash, err := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)
		if err != nil {
			return nil, err
		}
		id, err := s.repo.Create(email, string(hash))
		if err != nil {
			return nil, err
		}
		log.Printf("[DEBUG] Register: created user_id=%s", id)
		return &Step1Result{NewUser: true, UserID: id}, nil
	}
	if err != nil {
		return nil, err
	}
	// существующий — проверяем пароль
	if bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(pass)) != nil {
		return nil, ErrInvalidCreds
	}
	// проверяем, есть ли профиль
	hasProfile, err := s.checkProfile(u.ID)
	if err != nil {
		return nil, err
	}
	if hasProfile {
		token, err := s.generateJWT(u.ID)
		if err != nil {
			return nil, err
		}
		log.Printf("[DEBUG] Register: login user_id=%s (profile exists)", u.ID)
		return &Step1Result{NewUser: false, JWT: token}, nil
	}
	log.Printf("[DEBUG] Register: login user_id=%s (profile not complete)", u.ID)
	return &Step1Result{NewUser: false, UserID: u.ID}, nil
}

// checkProfile делает GET /api/v1/profiles/{userID} на profile-service
// и возвращает true, если профиль уже есть (200), false при 404
func (s *AuthService) checkProfile(userID string) (bool, error) {
	url := fmt.Sprintf("%s/api/v1/profiles/%s", s.profileServiceURL, userID)
	resp, err := s.httpClient.Get(url)
	if err != nil {
		return false, err
	}
	defer resp.Body.Close()
	switch resp.StatusCode {
	case http.StatusOK:
		return true, nil
	case http.StatusNotFound:
		return false, nil
	default:
		return false, fmt.Errorf("profile-service returned status %d", resp.StatusCode)
	}
}

// CompleteProfile выполняет шаг 2: отправляет профиль в profile-service и возвращает JWT
func (s *AuthService) CompleteProfile(userID string, p *model.ProfileInput) (string, error) {
	log.Printf("[DEBUG] CompleteProfile: user_id=%s", userID)
	// проверяем, что пользователь существует
	if _, err := s.repo.FindByID(userID); err == repository.ErrNotFound {
		log.Printf("[ERROR] user not found: %v", err)
		return "", ErrUserNotFound
	} else if err != nil {
		log.Printf("[ERROR] repo.FindByID: %v", err)
		return "", err
	}

	created, err := s.callProfileService(p)
	if err != nil {
		log.Printf("[ERROR] callProfileService: %v", err)
		return "", err
	}
	if !created {
		log.Printf("[ERROR] profile already exists for userID=%s", userID)
		return "", ErrProfileExists
	}

	log.Printf("[DEBUG] CompleteProfile: generating JWT for user_id=%s", userID)
	return s.generateJWT(userID)
}

// callProfileService делает POST /api/v1/profiles на profile-service
// и возвращает true при 201, false при 409
func (s *AuthService) callProfileService(p *model.ProfileInput) (bool, error) {
	log.Printf("[DEBUG] callProfileService: creating profile for user_id=%s", p.UserID)
	url := fmt.Sprintf("%s/api/v1/profiles", s.profileServiceURL)
	body, err := json.Marshal(p)
	if err != nil {
		log.Printf("[ERROR] json.Marshal profile: %v", err)
		return false, err
	}
	req, err := http.NewRequest(http.MethodPost, url, bytes.NewBuffer(body))
	if err != nil {
		log.Printf("[ERROR] NewRequest profile: %v", err)
		return false, err
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.httpClient.Do(req)
	if err != nil {
		log.Printf("[ERROR] httpClient.Do profile: %v", err)
		return false, err
	}
	defer resp.Body.Close()

	switch resp.StatusCode {
	case http.StatusCreated:
		log.Printf("[DEBUG] callProfileService: profile created for user_id=%s", p.UserID)
		return true, nil
	case http.StatusConflict:
		log.Printf("[ERROR] profile-service conflict (409) for userID=%s", p.UserID)
		return false, nil
	default:
		log.Printf("[ERROR] profile-service returned status %d for userID=%s", resp.StatusCode, p.UserID)
		return false, fmt.Errorf("profile-service returned status %d", resp.StatusCode)
	}
}

// generateJWT собирает и подписывает токен по userID
func (s *AuthService) generateJWT(sub string) (string, error) {
	log.Printf("[DEBUG] generateJWT: sub(user_id)=%s", sub)
	claims := jwt.MapClaims{
		"sub": sub,
		"exp": time.Now().Add(72 * time.Hour).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(s.jwtSecret)
}
