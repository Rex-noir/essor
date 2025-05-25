package config

import (
	"fmt"
	"os"
	"strconv"
)

type AppConfig struct {
	DBHost     string
	DBPort     int
	DBUser     string
	DBPass     string
	DBName     string
	ServerPort string
}

func LoadConfig() (*AppConfig, error) {

	cfg := &AppConfig{}

	cfg.DBUser = os.Getenv("DB_USER")
	if cfg.DBUser == "" {
		return nil, fmt.Errorf("DB_USER environment variable not set")
	}

	cfg.DBPass = os.Getenv("DB_PASS")
	if cfg.DBPass == "" {
		return nil, fmt.Errorf("DB_PASS environment variable not set")
	}

	cfg.DBHost = os.Getenv("DB_HOST")
	if cfg.DBHost == "" {
		return nil, fmt.Errorf("DB_HOST environment variable not set")
	}

	dbPortStr := os.Getenv("DB_PORT")
	if dbPortStr == "" {
		return nil, fmt.Errorf("DB_PORT environment variable not set")
	}
	port, err := strconv.Atoi(dbPortStr)
	if err != nil {
		return nil, fmt.Errorf("invalid DB_PORT: %w", err)
	}
	cfg.DBPort = port

	cfg.DBName = os.Getenv("DB_NAME")
	if cfg.DBName == "" {
		return nil, fmt.Errorf("DB_NAME environment variable not set")
	}

	cfg.ServerPort = os.Getenv("SERVER_PORT")
	if cfg.ServerPort == "" {
		cfg.ServerPort = ":8080" // Default port
	}

	return cfg, nil

}

// GetDBConnString constructs the PostgreSQL connection string.
func (c *AppConfig) GetDBConnString() string {
	return fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable",
		c.DBUser, c.DBPass, c.DBHost, c.DBPort, c.DBName)
}
