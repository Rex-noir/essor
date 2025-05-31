package cmd

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"
)

var useFolder bool

// new:utilCmd represents the new:util command
var newUtilCmd = &cobra.Command{
	Use:   "new:util [name]",
	Short: "Add a new util file inside internal/utils",
	Long:  `Creates a new utility function inside internal/utils, optionally in its own folder if --folder is used.`,
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		utilName := strings.ToLower(args[0])

		var targetDir string
		if useFolder {
			targetDir = filepath.Join("internal", "utils", utilName)
		} else {
			targetDir = filepath.Join("internal", "utils")
		}

		err := os.MkdirAll(targetDir, os.ModePerm)
		if err != nil {
			log.Fatalf("Failed to create util directory: %v", err)
		}

		fileName := utilName + ".go"
		filePath := filepath.Join(targetDir, fileName)

		packageName := "utils"
		if useFolder {
			packageName = utilName
		}

		content := fmt.Sprintf(`package %s

// %s is a utility function placeholder.
func %s() {
	// TODO: Implement
}
`, packageName, utilName, strings.Title(utilName))

		err = os.WriteFile(filePath, []byte(content), 0644)
		if err != nil {
			log.Fatalf("Failed to write util file: %v", err)
		}

		fmt.Printf("Created utility: %s\n", filePath)
	},
}

func init() {
	rootCmd.AddCommand(newUtilCmd)

	newUtilCmd.Flags().BoolVar(&useFolder, "folder", false, "Create a separate folder for this util")
}
