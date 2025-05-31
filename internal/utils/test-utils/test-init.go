package testutils

import (
	"log"
	"os"
	"path/filepath"

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
