package main

import (
    "database/sql"
    "log"
    "os"

    _ "github.com/lib/pq"
    "github.com/gin-gonic/gin"

    "profile_service/internal/handler"
    "profile_service/internal/repository"
    "profile_service/internal/service"
)

func main() {
    dsn := os.Getenv("DATABASE_URL")
    if dsn == "" {
        log.Fatal("DATABASE_URL is not set")
    }

    db, err := sql.Open("postgres", dsn)
    if err != nil {
        log.Fatalf("db connect: %v", err)
    }
    defer db.Close()

    repo := repository.NewProfileRepo(db)
    svc  := service.NewProfileService(repo)
    hnd  := handler.NewProfileHandler(svc)

    r := gin.Default()
    api := r.Group("/api/v1/profiles")
    {
        api.POST("", hnd.CreateProfile)
        api.GET("/:user_id", hnd.GetProfile)
    }

    // Swagger
    r.StaticFile("/swagger.yaml", "./swagger.yaml")

    log.Println("📇 profile-service listening on :8080")
    r.Run(":8080")
}
