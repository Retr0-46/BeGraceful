package main

import (
    "database/sql"
    "log"
    "os"

    _ "github.com/lib/pq"
    "github.com/gin-gonic/gin"

    "auth_service/internal/handler"
    "auth_service/internal/repository"
    "auth_service/internal/service"
)

func main() {
    // 1) Конфиг из окружения
    dsn := os.Getenv("DATABASE_URL")
    if dsn == "" {
        log.Fatal("DATABASE_URL is not set")
    }
    jwtSecret := os.Getenv("JWT_SECRET")
    if jwtSecret == "" {
        log.Fatal("JWT_SECRET is not set")
    }
    profileURL := os.Getenv("PROFILE_SERVICE_URL")
    if profileURL == "" {
        log.Fatal("PROFILE_SERVICE_URL is not set")
    }

    // 2) Подключаемся к БД
    db, err := sql.Open("postgres", dsn)
    if err != nil {
        log.Fatalf("failed to connect to db: %v", err)
    }
    defer db.Close()

    // 3) Инициализируем слои
    userRepo := repository.NewUserRepo(db)
    authSvc  := service.NewAuthService(userRepo, jwtSecret, profileURL)
    authHnd  := handler.NewAuthHandler(authSvc)

    // 4) Запускаем HTTP-server
    r := gin.Default()
    api := r.Group("/api/v1/auth")
    {
        api.POST("/register", authHnd.Register)
        api.POST("/complete-profile", authHnd.CompleteProfile)
    }
    // Экспонируем Swagger
    r.StaticFile("/swagger.yaml", "./swagger.yaml")

    log.Println("🔑 auth-service listening on :8080")
    if err := r.Run(":8080"); err != nil {
        log.Fatalf("server error: %v", err)
    }
}
