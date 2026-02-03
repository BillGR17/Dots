#include <print>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <filesystem>
#include <algorithm>
#include <cstdlib>
#include <unistd.h>
#include <sys/wait.h>

namespace fs = std::filesystem;

const std::string ROOT_PREFIX_DIR = ".wine";
const std::string PFX_DIR = "pfx";
const std::vector<std::string> WINE_FILETYPES = {".exe", ".msi", ".msu"};

// Helper to convert vector<string> to char* array for execvp
std::vector<char *> to_argv(const std::vector<std::string> &args) {
  std::vector<char *> argv;
  for (const auto &arg : args) {
    argv.push_back(const_cast<char *>(arg.c_str()));
  }
  argv.push_back(nullptr);
  return argv;
}

// Executes a command.
void run_command(std::vector<std::string> args, bool wait_for_exit = true) {
  if (args.empty())
    return;

  // Manual join for printing to avoid dependency issues or complex range formatters
  std::print("Running:");
  for (const auto &arg : args) {
    std::print(" {}", arg);
  }
  std::println(""); // Newline

  if (!wait_for_exit) {
    auto argv = to_argv(args);
    execvp(argv[0], argv.data());
    std::println(stderr, "Error: Failed to exec {}", args[0]);
    std::exit(1);
  }

  pid_t pid = fork();
  if (pid == 0) {
    auto argv = to_argv(args);
    execvp(argv[0], argv.data());
    std::println(stderr, "Error: Failed to exec {}", args[0]);
    std::exit(1);
  } else if (pid > 0) {
    int status;
    waitpid(pid, &status, 0);
  } else {
    std::println(stderr, "Error: Fork failed");
  }
}

void set_env_vars(const fs::path &wine_prefix) {
  fs::path dxvk_path = wine_prefix.parent_path();

  setenv("WINEPREFIX", wine_prefix.c_str(), 1);
  setenv("WINEARCH", "win64", 1);
  setenv("DXVK_STATE_CACHE_PATH", dxvk_path.c_str(), 1);
  setenv("DXVK_LOG_PATH", dxvk_path.c_str(), 1);

  std::println("Environment set:\n  WINEPREFIX={}", wine_prefix.string());
}

fs::path check_for_prefix(const fs::path &pwd, const fs::path &target_dir) {
  fs::path prefix_in_pwd = pwd / ROOT_PREFIX_DIR / PFX_DIR;
  fs::path prefix_in_target = target_dir / ROOT_PREFIX_DIR / PFX_DIR;

  if (fs::exists(prefix_in_pwd)) {
    std::println("Prefix found in: {}", pwd.string());
    set_env_vars(prefix_in_pwd);
    return pwd;
  }

  if (fs::exists(prefix_in_target)) {
    std::println("Prefix found in: {}", target_dir.string());
    set_env_vars(prefix_in_target);
    return target_dir;
  }

  std::println("Creating prefix in: {}", target_dir.string());
  try {
    fs::create_directories(prefix_in_target);
  } catch (const fs::filesystem_error &e) {
    std::println(stderr, "Error creating prefix: {}", e.what());
    std::exit(1);
  }

  set_env_vars(prefix_in_target);
  run_command({"wineboot"}, true);

  return target_dir;
}

void setup_dxvk(const fs::path &prefix_base_dir) {
  fs::path dxvk_flag = prefix_base_dir / ROOT_PREFIX_DIR / "dxvk_installed";

  if (!fs::exists(dxvk_flag)) {
    std::println("First time setup: Installing DXVK...");
    run_command({"setup_dxvk", "install"}, true);

    std::ofstream(dxvk_flag).close();
  }
}

bool has_wine_extension(std::string_view filename) {
  std::string lower_name;
  lower_name.reserve(filename.size());
  for (unsigned char c : filename)
    lower_name += std::tolower(c);

  for (const auto &ext : WINE_FILETYPES) {
    if (lower_name.size() >= ext.size() && lower_name.compare(lower_name.size() - ext.size(), ext.size(), ext) == 0) {
      return true;
    }
  }
  return false;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    std::string script_name = fs::path(argv[0]).filename().string();
    std::println("A Wine wrapper to manage prefixes on a per-application basis.");
    std::println("Usage:\n  {} <program.exe> [args...]", script_name);
    return 1;
  }

  std::vector<std::string> args;
  for (int i = 1; i < argc; ++i)
    args.emplace_back(argv[i]);

  std::string first_arg = args[0];
  fs::path pwd = fs::current_path();

  if (has_wine_extension(first_arg)) {
    fs::path target_path = fs::absolute(first_arg);
    if (!fs::exists(target_path)) {
      std::println(stderr, "Error: File not found: {}", first_arg);
      return 1;
    }

    fs::path target_dir = target_path.parent_path();
    fs::path prefix_base = check_for_prefix(pwd, target_dir);

    setup_dxvk(prefix_base);

    std::vector<std::string> wine_args = {"wine", target_path.string()};
    for (size_t i = 1; i < args.size(); ++i)
      wine_args.push_back(args[i]);

    run_command(wine_args, false);

  } else {
    check_for_prefix(pwd, pwd);
    run_command(args, false);
  }

  return 0;
}
