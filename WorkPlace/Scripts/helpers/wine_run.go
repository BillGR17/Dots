package main

import (
  "fmt"
  "log"
  "os"
  "os/exec"
  "path/filepath"
  "strings"
)

const (
  // Sets prefix location structure.
  rootPrefixDir = ".wine"
  pfxDir        = "pfx"
)

var (
  // Files with these suffixes will be run with Wine.
  wineFiletypes = []string{".exe", ".msi", ".msu"}
)

// fileExists checks if a file or directory exists.
func fileExists(path string) bool {
  _, err := os.Stat(path)
  return !os.IsNotExist(err)
}

// setEnv sets all the necessary environment variables for Wine and DXVK.
func setEnv(winePrefix string) {
  dxvkPath := filepath.Dir(winePrefix)
  os.Setenv("WINEPREFIX", winePrefix)
  os.Setenv("WINEARCH", "win64")
  os.Setenv("DXVK_STATE_CACHE_PATH", dxvkPath)
  os.Setenv("DXVK_LOG_PATH", dxvkPath)
  log.Printf("Environment set:\n  WINEPREFIX=%s\n", winePrefix)
}

// runCommandInPrefix executes a command, ensuring output is streamed to the user.
func runCommandInPrefix(name string, args ...string) error {
  log.Printf("Running: %s %s\n", name, strings.Join(args, " "))
  cmd := exec.Command(name, args...)
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr
  cmd.Stdin = os.Stdin
  return cmd.Run()
}

// checkForPrefix finds an existing prefix or creates a new one.
// It returns the path to the application's root directory (where .wine is located).
func checkForPrefix(pwd, targetDir string) (string, error) {
  prefixPathInPwd := filepath.Join(pwd, rootPrefixDir, pfxDir)
  prefixPathInTarget := filepath.Join(targetDir, rootPrefixDir, pfxDir)

  // Check if prefix exists in the current working directory first.
  if fileExists(prefixPathInPwd) {
    fmt.Println("Prefix found in:", pwd)
    setEnv(prefixPathInPwd)
    return pwd, nil
  }

  // Check if prefix exists next to the target executable.
  if fileExists(prefixPathInTarget) {
    fmt.Println("Prefix found in:", targetDir)
    setEnv(prefixPathInTarget)
    return targetDir, nil
  }

  // If no prefix is found, create it in the target directory.
  fmt.Println("Creating prefix in:", targetDir)
  if err := os.MkdirAll(prefixPathInTarget, 0755); err != nil {
    return "", fmt.Errorf("failed to create prefix directory: %w", err)
  }
  setEnv(prefixPathInTarget)

  // Initialize the new prefix.
  if err := runCommandInPrefix("wineboot"); err != nil {
    log.Println("Warning: winecfg might have failed during initial setup.")
  }

  return targetDir, nil
}

// setupDxvk checks for a flag file and runs DXVK setup if it doesn't exist.
func setupDxvk(prefixBaseDir string) error {
  dxvkFlagFile := filepath.Join(prefixBaseDir, rootPrefixDir, "dxvk_installed")
  if !fileExists(dxvkFlagFile) {
    fmt.Println("First time setup: Installing DXVK...")
    if err := runCommandInPrefix("setup_dxvk", "install"); err != nil {
      return fmt.Errorf("setup_dxvk failed: %w", err)
    }
    // Create the flag file to prevent running setup again.
    f, err := os.Create(dxvkFlagFile)
    if err != nil {
      log.Printf("Warning: Could not create DXVK flag file: %v\n", err)
    } else {
      f.Close()
    }
  }
  return nil
}

// runWine handles the execution of Windows executables (.exe, .msi, etc.).
func runWine(args []string) error {
  pwd, err := os.Getwd()
  if err != nil {
    return fmt.Errorf("could not get current working directory: %w", err)
  }

  target, err := filepath.Abs(args[0])
  if err != nil {
    return fmt.Errorf("could not get absolute path for target: %w", err)
  }
  targetDir := filepath.Dir(target)

  prefixBaseDir, err := checkForPrefix(pwd, targetDir)
  if err != nil {
    return err
  }

  if err := setupDxvk(prefixBaseDir); err != nil {
    return err
  }

  // Prepare arguments for wine. The executable path is the first arg.
  wineArgs := append([]string{target}, args[1:]...)
  return runCommandInPrefix("wine", wineArgs...)
}

// runGenericCommand handles other commands like 'winecfg', 'winetricks', etc.
// It sets up a prefix in the current directory if one doesn't exist.
func runGenericCommand(args []string) error {
  pwd, err := os.Getwd()
  if err != nil {
    return fmt.Errorf("could not get current working directory: %w", err)
  }

  // For generic commands, the prefix is always in the current directory.
  if _, err := checkForPrefix(pwd, pwd); err != nil {
    return err
  }

  command := args[0]
  commandArgs := args[1:]
  return runCommandInPrefix(command, commandArgs...)
}

func main() {
  log.SetFlags(0)
  args := os.Args[1:]
  if len(args) == 0 {
    scriptName := filepath.Base(os.Args[0])
    fmt.Printf("A Wine wrapper to manage prefixes on a per-application basis.\n\n")
    fmt.Printf("Usage:\n")
    fmt.Printf("  %s <program.exe> [args...]\n", scriptName)
    fmt.Printf("  %s <wine_command> [args...]\n\n", scriptName)
    fmt.Printf("Examples:\n")
    fmt.Printf("  %s setup.exe\n", scriptName)
    fmt.Printf("  %s winecfg\n", scriptName)
    fmt.Printf("  %s winetricks corefonts\n", scriptName)
    os.Exit(1)
  }

  firstArg := args[0]
  isWineFile := false
  for _, suffix := range wineFiletypes {
    if strings.HasSuffix(strings.ToLower(firstArg), suffix) {
      isWineFile = true
      break
    }
  }

  var err error
  if isWineFile {
    if !fileExists(firstArg) {
      log.Fatalf("Error: File not found: %s", firstArg)
    }
    err = runWine(args)
  } else {
    err = runGenericCommand(args)
  }
  if err != nil {
    log.Fatal(err)
  }
}
