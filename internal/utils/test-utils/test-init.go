package utils

import (
	"context"
	"essor/backend/database"
	"essor/backend/internal/config"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func init() {
	rootDir := findRootDir()

	if rootDir == "" {
		log.Fatal("Could not locate project root for .env file")
	}

	err := godotenv.Load(filepath.Join(rootDir, ".env"))
	if err != nil {
		log.Fatalf("Failed to load .env file from %s: %v", rootDir, err)
	}
}

func findRootDir() string {
	dir, err := os.Getwd()
	if err != nil {
		return ""
	}

	for {
		if _, err := os.Stat(filepath.Join(dir, ".env")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}

	return ""
}

func SetupTestDB() *database.Queries {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	dbCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	db, err := database.ConnectDB(dbCtx, cfg.GetDBConnString())
	if err != nil {
		log.Fatalf("Failed to connect to DB: %v", err)
	}

	return database.New(db)
}

func NewApiRouter() (*gin.Engine, *gin.RouterGroup) {
	gin.SetMode(gin.TestMode)
	r := gin.Default()

	api := r.Group("/api")
	return r, api
}
