/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"context"
	"essor/backend/database"
	"essor/backend/internal/config"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/joho/godotenv"
	"github.com/spf13/cobra"
)

// db:seedCmd represents the db:seed command
var dbseedCmd = &cobra.Command{
	Use:   "db:seed",
	Short: "Seed database with initial data.",
	Long:  `This will run the database seeder `,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Running seeders..")
		godotenv.Load()
		config, err := config.LoadConfig()
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()

		connStr := config.GetDBConnString()
		db, err := database.ConnectDB(ctx, connStr)
		if err != nil {
			log.Fatalf("Error opening DB: %v", err)
		}

		defer db.Close()

		files, err := filepath.Glob("database/seeders/*.sql")
		if err != nil {
			log.Fatalf("Error reading seeder files: %v", err)
		}

		for _, file := range files {
			fmt.Printf("Seeding: %s\n", file)

			sqlBytes, err := os.ReadFile(file)
			if err != nil {
				log.Printf("Failed to read %s: %v", file, err)
				continue
			}

			_, err = db.Exec(ctx, string(sqlBytes))
			if err != nil {
				log.Printf("Failed to execute %s: %v", file, err)
				continue
			}

			fmt.Printf("✓ Executed %s\n", file)
		}

	},
}

func init() {
	rootCmd.AddCommand(dbseedCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// db:seedCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// db:seedCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
