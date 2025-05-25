package main

import (
	"context"
	"fmt"
	"habit_tracker/api/auth"
	"habit_tracker/api/database"
	"habit_tracker/api/internal/config"
	"habit_tracker/api/ping"
	"log"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {

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
	auth.RegisterRoutes(api, queries)

	fmt.Printf("Server starting on port %s\n", cfg.ServerPort)
	if err := router.Run(cfg.ServerPort); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
