package handler

import (
    "net/http"

    "github.com/gin-gonic/gin"

    "calories_service/internal/model"
    "calories_service/internal/service"
)

type CaloriesHandler struct {
    svc *service.CaloriesService
}

func NewCaloriesHandler(s *service.CaloriesService) *CaloriesHandler {
    return &CaloriesHandler{svc: s}
}

// POST /api/v1/calories/food
func (h *CaloriesHandler) LogFood(c *gin.Context) {
    var req model.FoodInput
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
        return
    }
    if err := h.svc.LogFood(&req); err != nil {
        code := "SERVER_ERROR"
        if err == service.ErrUserNotFound {
            c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("USER_NOT_FOUND", err.Error())})
            return
        }
        c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError(code, err.Error())})
        return
    }
    c.JSON(http.StatusCreated, gin.H{"data": gin.H{"message": "Food entry created"}})
}

// POST /api/v1/calories/workout
func (h *CaloriesHandler) LogWorkout(c *gin.Context) {
    var req model.WorkoutInput
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", err.Error())})
        return
    }
    if err := h.svc.LogWorkout(&req); err != nil {
        if err == service.ErrUserNotFound {
            c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("USER_NOT_FOUND", err.Error())})
            return
        }
        c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        return
    }
    c.JSON(http.StatusCreated, gin.H{"data": gin.H{"message": "Workout entry created"}})
}

// GET /api/v1/calories/summary?user_id=…&date=YYYY-MM-DD
func (h *CaloriesHandler) GetSummary(c *gin.Context) {
    userID := c.Query("user_id")
    date := c.Query("date")
    if userID == "" || date == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": model.NewError("INVALID_INPUT", "user_id and date are required")})
        return
    }
    summary, err := h.svc.GetDailySummary(userID, date)
    if err != nil {
        if err == service.ErrUserNotFound {
            c.JSON(http.StatusNotFound, gin.H{"error": model.NewError("USER_NOT_FOUND", err.Error())})
            return
        }
        c.JSON(http.StatusInternalServerError, gin.H{"error": model.NewError("SERVER_ERROR", err.Error())})
        return
    }
    c.JSON(http.StatusOK, gin.H{"data": summary})
}
