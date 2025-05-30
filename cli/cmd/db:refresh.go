/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"habit_tracker/api/internal/config"
	"log"
	"os"
	"os/exec"

	"github.com/joho/godotenv"
	"github.com/spf13/cobra"
)

// db:refreshCmd represents the db:refresh command
var dbRefreshCmd = &cobra.Command{
	Use:   "db:refresh",
	Short: "Refresh database tables.",
	Long:  `This drops of the tables and run migrations again.`,
	Run: func(cmd *cobra.Command, args []string) {
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
	},
}

func init() {
	rootCmd.AddCommand(dbRefreshCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// db:refreshCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// db:refreshCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
