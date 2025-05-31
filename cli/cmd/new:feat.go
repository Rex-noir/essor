package cmd

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"
)

var (
	apiFlag      bool
	databaseFlag bool
)

// new:featCmd represents the new:feat command
var newFeatCmd = &cobra.Command{
	Use:   "new:feat [name]",
	Short: "Add new feature to the project.",
	Long:  `This will write up new feature inside the specified application. Default is api.`,
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		featureName := args[0]
		target := "api"

		if databaseFlag {
			target = "database"
		}

		dirPath := filepath.Join(target, featureName)
		err := os.MkdirAll(dirPath, os.ModePerm)
		if err != nil {
			log.Fatalf("Failed to create directory: %v", err)
		}

		fileName := strings.ToLower(featureName) + ".go"
		filePath := filepath.Join(dirPath, fileName)

		content := fmt.Sprintf("package %s\n", featureName)

		err = os.WriteFile(filePath, []byte(content), 0644)
		if err != nil {
			log.Fatalf("Failed to create file: %v", err)
		}

		fmt.Printf("Created feature '%s' in %s\n", featureName, dirPath)
	},
}

func init() {
	rootCmd.AddCommand(newFeatCmd)

	newFeatCmd.Flags().BoolVar(&apiFlag, "api", false, "Create feature in api module")
	newFeatCmd.Flags().BoolVar(&databaseFlag, "database", false, "Create feature in database module")
}
