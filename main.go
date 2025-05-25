package main

import (
	"context"
	"fmt"
	"habit_tracker/api/auth"
	"habit_tracker/api/database"
	"habit_tracker/api/ping"
	"log"
	"os"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {

	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbHost := os.Getenv("DB_HOST")
	dbPortStr := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")

	if dbUser == "" {
		log.Fatal("DB_USER environment variable not set")
	}
	if dbPass == "" {
		log.Fatal("DB_PASS environment variable not set")
	}
	if dbHost == "" {
		log.Fatal("DB_HOST environment variable not set")
	}
	if dbPortStr == "" {
		log.Fatal("DB_PORT environment variable not set")
	}
	dbPort, err := strconv.Atoi(dbPortStr) // Convert port to int
	if err != nil {
		log.Fatalf("Invalid DB_PORT: %v", err)
	}
	if dbName == "" {
		log.Fatal("DB_NAME environment variable not set")
	}

	connString := fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable", dbUser, dbPass, dbHost, dbPort, dbName)
	fmt.Printf("Attempting to connect to: %s\n", connString) // For debugging (remove in production)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel() // Always call cancel to release context resources

	dbPool, err := pgxpool.New(ctx, connString)
	if err != nil {
		log.Fatalf("Failed to connect to DB: %v", err)
	}
	defer dbPool.Close() // Ensure the connection pool is closed when main exits

	err = dbPool.Ping(ctx)
	if err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}
	fmt.Println("Successfully connected to the database!")

	queries := database.New(dbPool)

	router := gin.Default()
	api := router.Group("/api")

	// Register PING ROUTES
	ping.RegisterRoutes(api)
	auth.RegisterRoutes(api, queries)

	router.Run()
}
