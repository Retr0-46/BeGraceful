package handler

import (
  "net/http"

  "github.com/gin-gonic/gin"
  "auth_service/internal/model"
  "auth_service/internal/service"
)

type AuthHandler struct{ svc *service.AuthService }

func NewAuthHandler(s *service.AuthService) *AuthHandler {
  return &AuthHandler{svc: s}
}

func (h *AuthHandler) Register(c *gin.Context) {
  var req struct {
    Email    string `json:"email"    binding:"required,email"`
    Password string `json:"password" binding:"required,min=8"`
  }
  if err := c.ShouldBindJSON(&req); err != nil {
    c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
    return
  }
  res, err := h.svc.Register(req.Email, req.Password)
  if err == service.ErrInvalidCreds {
    c.JSON(http.StatusUnauthorized, gin.H{"error": model.NewError("INVALID_CREDENTIALS", "Email or password is incorrect")})
    return
  } else if err != nil {
    c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("DB_ERROR", err.Error())})
    return
  }
  if res.NewUser {
    c.JSON(http.StatusCreated, gin.H{"data": gin.H{"user_id": res.UserID, "status": "INCOMPLETE_PROFILE"}})
  } else if res.JWT != "" {
    c.JSON(http.StatusOK, gin.H{"data": gin.H{"jwt": res.JWT, "status": "OK"}})
  } else {
    c.JSON(http.StatusOK, gin.H{"data": gin.H{"user_id": res.UserID, "status": "INCOMPLETE_PROFILE"}})
  }
}

func (h *AuthHandler) CompleteProfile(c *gin.Context) {
  var req model.ProfileInput
  if err := c.ShouldBindJSON(&req); err != nil {
    c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
    return
  }
  jwt, err := h.svc.CompleteProfile(req.UserID, &req)
  if err != nil {
    switch err.Error() {
    case "profile already exists":
      c.JSON(http.StatusConflict, gin.H{"error": model.NewError("PROFILE_ALREADY_EXISTS", err.Error())})
    default:
      c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("USER_NOT_FOUND", err.Error())})
    }
    return
  }
  c.JSON(http.StatusOK, gin.H{"data": gin.H{"jwt": jwt, "status": "PROFILE_COMPLETED"}})
}
