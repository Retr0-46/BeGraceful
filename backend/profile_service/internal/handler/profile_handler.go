package handler

import (
	"log"
    "net/http"

    "profile_service/internal/model"
    "profile_service/internal/service"

	"github.com/gin-gonic/gin"
)

type ProfileHandler struct {
    svc *service.ProfileService
}

func NewProfileHandler(s *service.ProfileService) *ProfileHandler {
    return &ProfileHandler{svc: s}
}

// POST /api/v1/profiles
func (h *ProfileHandler) CreateProfile(c *gin.Context) {
    var input model.ProfileInput
    if err := c.ShouldBindJSON(&input); err != nil {
		log.Printf("[ERROR] CreateProfile: invalid input - %v", err)
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
        return
    }
	log.Printf("[DEBUG] CreateProfile: creating profile for user_id=%s", input.UserID)
    if err := h.svc.CreateProfile(&input); err != nil {
		log.Printf("[ERROR] CreateProfile: service error - %v", err)
        switch err {
        case service.ErrProfileAlreadyExists:
            c.JSON(http.StatusConflict, gin.H{"error": model.NewError("PROFILE_ALREADY_EXISTS", err.Error())})
        default:
            c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        }
        return
    }
	log.Printf("[DEBUG] CreateProfile: profile created successfully for user_id=%s", input.UserID)
    c.JSON(http.StatusCreated, gin.H{"data": gin.H{"message": "Profile created"}})
}

// GET /api/v1/profiles/:user_id
func (h *ProfileHandler) GetProfile(c *gin.Context) {
    userID := c.Param("user_id")
    p, err := h.svc.GetProfile(userID)
    if err != nil {
        switch err {
        case service.ErrProfileNotFound:
            c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("PROFILE_NOT_FOUND", err.Error())})
        default:
            c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        }
        return
    }
    c.JSON(http.StatusOK, gin.H{"data": p})
}

// PUT /api/v1/profiles/:user_id
func (h *ProfileHandler) UpdateProfile(c *gin.Context) {
    userID := c.Param("user_id")
    var input model.ProfileInput
    if err := c.ShouldBindJSON(&input); err != nil {
        log.Printf("[ERROR] UpdateProfile: invalid input - %v", err)
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
        return
    }
    // Ensure user_id in path matches the one in body
    input.UserID = userID
    
    log.Printf("[DEBUG] UpdateProfile: updating profile for user_id=%s", userID)
    if err := h.svc.UpdateProfile(&input); err != nil {
        log.Printf("[ERROR] UpdateProfile: service error - %v", err)
        switch err {
        case service.ErrProfileNotFound:
            c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("PROFILE_NOT_FOUND", err.Error())})
        default:
            c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        }
        return
    }
    log.Printf("[DEBUG] UpdateProfile: profile updated successfully for user_id=%s", userID)
    c.JSON(http.StatusOK, gin.H{"data": gin.H{"message": "Profile updated"}})
}

// PATCH /api/v1/profiles/:user_id/weight
func (h *ProfileHandler) UpdateWeight(c *gin.Context) {
	userID := c.Param("user_id")
	var req struct {
		WeightKg int `json:"weight_kg" binding:"required,min=10,max=500"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[ERROR] UpdateWeight: invalid input - %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
		return
	}
	
	log.Printf("[DEBUG] UpdateWeight: updating weight for user_id=%s to %d", userID, req.WeightKg)
	if err := h.svc.UpdateWeight(userID, req.WeightKg); err != nil {
		log.Printf("[ERROR] UpdateWeight: service error - %v", err)
		switch err {
		case service.ErrProfileNotFound:
			c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("PROFILE_NOT_FOUND", err.Error())})
		default:
			c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
		}
		return
	}
	log.Printf("[DEBUG] UpdateWeight: weight updated successfully for user_id=%s", userID)
	c.JSON(http.StatusOK, gin.H{"data": gin.H{"message": "Weight updated"}})
}
