package main

import (
	"context"
	"essor/backend/api/auth"
	"essor/backend/api/ping"
	"essor/backend/database"
	"essor/backend/internal/config"
	"fmt"
	"log"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	dbCtx, dbCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer dbCancel()

	dbPool, err := database.ConnectDB(dbCtx, cfg.GetDBConnString())
	if err != nil {
		log.Fatalf("Failed to establish database connection: %v", err)
	}
	defer dbPool.Close()

	queries := database.New(dbPool)

	router := gin.Default()
	api := router.Group("/api")

	// Register PING ROUTES
	ping.RegisterRoutes(api)

	// Register AUTH routes
	authService := auth.NewAuthService(queries, cfg)
	auth.RegisterRoutes(api, authService)

	fmt.Printf("Server starting on port %s\n", cfg.ServerPort)
	if err := router.Run(cfg.ServerPort); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
