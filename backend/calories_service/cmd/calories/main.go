package main

import (
    "database/sql"
    "log"
    "os"

    _ "github.com/lib/pq"
    "github.com/gin-gonic/gin"

    "calories_service/internal/handler"
    "calories_service/internal/repository"
    "calories_service/internal/service"
)

func main() {
    dsn := os.Getenv("DATABASE_URL")
    if dsn == "" {
        log.Fatal("DATABASE_URL is not set")
    }
    profileURL := os.Getenv("PROFILE_SERVICE_URL")
    if profileURL == "" {
        log.Fatal("PROFILE_SERVICE_URL is not set")
    }

    db, err := sql.Open("postgres", dsn)
    if err != nil {
        log.Fatalf("db connect: %v", err)
    }
    defer db.Close()

    repo := repository.NewCaloriesRepo(db)
    svc  := service.NewCaloriesService(repo, profileURL)
    hnd  := handler.NewCaloriesHandler(svc)

    r := gin.Default()
    grp := r.Group("/api/v1/calories")
    {
        grp.POST("/food", hnd.LogFood)
        grp.POST("/workout", hnd.LogWorkout)
        grp.GET("/summary", hnd.GetSummary)
    }
    r.StaticFile("/swagger.yaml", "./swagger.yaml")

    log.Println("🔥 calories-service listening on :8080")
    r.Run(":8080")
}
