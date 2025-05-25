package main

import (
	"context"
	"habit_tracker/api/auth"
	"habit_tracker/api/database"
	"habit_tracker/api/ping"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {

	dbPool, err := pgxpool.New(context.Background(), "postgres://user:pass@localhost:5432/mydb")

	if err != nil {
		log.Fatalf("Failed to connect to DB: %v", err)
	}
	queries := database.New(dbPool)

	router := gin.Default()
	api := router.Group("/api")

	// Register PING ROUTES
	ping.RegisterRoutes(api)
	auth.RegisterRoutes(api, queries)

	router.Run()
}
