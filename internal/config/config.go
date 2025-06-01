package config

import (
	"fmt"
	"os"
	"strconv"
)

type AppConfig struct {
	DBHost             string
	DBPort             int
	DBUser             string
	DBPass             string
	DBName             string
	ServerPort         string
	CookieSecure       bool
	CookieHTTPOnly     bool
	CookieDomain       string
	AccessTokenMaxAge  int
	RefreshTokenMaxAge int
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
		cfg.ServerPort = ":8080"
	}

	secureFlag := os.Getenv("COOKIE_SECURE")
	cfg.CookieSecure = secureFlag == "true"

	httpOnlyFlag := os.Getenv("COOKIE_HTTPONLY")
	cfg.CookieHTTPOnly = httpOnlyFlag != "false"

	cfg.CookieDomain = os.Getenv("COOKIE_DOMAIN")

	accessTokenMaxAge := os.Getenv("ACCESS_TOKEN_MAX_AGE")
	if accessTokenMaxAge == "" {
		cfg.AccessTokenMaxAge = 900
	}

	refreshTokenMaxAge := os.Getenv("REFRESH_TOKEN_MAX_AGE")
	if refreshTokenMaxAge == "" {
		cfg.RefreshTokenMaxAge = 604800
	}

	return cfg, nil

}

func (c *AppConfig) GetDBConnString() string {
	return fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable",
		c.DBUser, c.DBPass, c.DBHost, c.DBPort, c.DBName)
}

func (c *AppConfig) GetCookieSecure() bool {
	return c.CookieSecure
}

func (c *AppConfig) GetCookieHTTPOnly() bool {
	return c.CookieHTTPOnly
}

func (c *AppConfig) GetCookieDomain() string {
	return c.CookieDomain
}

func (c *AppConfig) GetAccessTokenMaxAge() int {
	return c.AccessTokenMaxAge
}
func (c *AppConfig) GetRefreshTokenMaxAge() int {
	return c.RefreshTokenMaxAge
}
