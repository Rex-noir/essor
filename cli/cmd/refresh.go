package main

import (
	"fmt"
	"habit_tracker/api/internal/config"
	"log"
	"os"
	"os/exec"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatalln("Error loading .env file", err)
	}

	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalln("Error loading config:", err)
	}

	fmt.Printf("Dropping and recreating database %s...\n", cfg.DBName)

	// Drop the database
	dropCmd := exec.Command("psql",
		"-U", cfg.DBUser,
		"-h", cfg.DBHost,
		"-p", fmt.Sprintf("%d", cfg.DBPort),
		"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s;", cfg.DBName),
	)
	dropCmd.Env = append(os.Environ(), fmt.Sprintf("PGPASSWORD=%s", cfg.DBPass))
	dropCmd.Stdout = os.Stdout
	dropCmd.Stderr = os.Stderr

	if err := dropCmd.Run(); err != nil {
		log.Fatalf("Failed to drop database: %v\n", err)
	}

	// Create the database
	createCmd := exec.Command("psql",
		"-U", cfg.DBUser,
		"-h", cfg.DBHost,
		"-p", fmt.Sprintf("%d", cfg.DBPort),
		"-c", fmt.Sprintf("CREATE DATABASE %s;", cfg.DBName),
	)
	createCmd.Env = append(os.Environ(), fmt.Sprintf("PGPASSWORD=%s", cfg.DBPass))
	createCmd.Stdout = os.Stdout
	createCmd.Stderr = os.Stderr

	if err := createCmd.Run(); err != nil {
		log.Fatalf("Failed to create database: %v\n", err)
	}

	fmt.Println("Running tern migration...")

	ternCmd := exec.Command("tern", "migrate")
	ternCmd.Stdout = os.Stdout
	ternCmd.Stderr = os.Stderr

	if err := ternCmd.Run(); err != nil {
		log.Fatalf("Tern migration failed: %v\n", err)
	}

	fmt.Println("✅ Fresh migration completed.")
}
