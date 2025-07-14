package handler

import (
    "net/http"

    "github.com/gin-gonic/gin"
    "profile_service/internal/model"
    "profile_service/internal/service"
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
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
        return
    }
    if err := h.svc.CreateProfile(&input); err != nil {
        switch err {
        case service.ErrProfileAlreadyExists:
            c.JSON(http.StatusConflict, gin.H{"error": model.NewError("PROFILE_ALREADY_EXISTS", err.Error())})
        default:
            c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        }
        return
    }
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
