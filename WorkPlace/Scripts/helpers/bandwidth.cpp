#include <array>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <string>

// Executes a shell command and returns its standard output.
std::string executeCommand(const char *cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
  if (!pipe) {
    throw std::runtime_error("popen() failed!");
  }
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    result += buffer.data();
  }
  return result;
}

// Gets the primary active network interface using nmcli.
std::string getActiveInterface() {
  const char *command = "nmcli -g DEVICE connection show --active | grep -vw \"lo\" | head -n1";
  try {
    std::string interfaceName = executeCommand(command);
    // The command output will likely have a trailing newline, so remove it.
    if (!interfaceName.empty() && interfaceName.back() == '\n') {
      interfaceName.pop_back();
    }
    return interfaceName;
  } catch (const std::runtime_error &e) {
    std::cerr << "Error executing command to find interface: " << e.what() << std::endl;
    return "";
  }
}

// Reads a numerical value from the first line of a file.
long long readValueFromFile(const std::filesystem::path &filePath) {
  if (!std::filesystem::exists(filePath)) {
    return 0;
  }
  std::ifstream fileStream(filePath);
  if (!fileStream.is_open()) {
    return 0;
  }
  std::string line;
  if (std::getline(fileStream, line)) {
    try {
      return std::stoll(line);
    } catch (...) {
      return 0;
    }
  }
  return 0;
}

// Writes a numerical value to a file, overwriting its contents.
void writeValueToFile(const std::filesystem::path &filePath, long long value) {
  if (filePath.has_parent_path()) {
    std::filesystem::create_directories(filePath.parent_path());
  }
  std::ofstream fileStream(filePath, std::ios::trunc);
  if (!fileStream.is_open()) {
    std::cerr << "Error: Could not open file for writing: " << filePath << "\n";
    return;
  }
  fileStream << value;
}

// Formats bytes per second into a human-readable string (B, K, M, G).
std::string formatBandwidth(long long bytesPerSecond) {
  if (bytesPerSecond < 0)
    bytesPerSecond = 0;
  const double kb = 1024.0;
  const double mb = kb * 1024.0;
  const double gb = mb * 1024.0;
  std::ostringstream oss;
  oss << std::fixed << std::setprecision(2);
  if (bytesPerSecond >= gb) {
    oss << bytesPerSecond / gb << "G";
  } else if (bytesPerSecond >= mb) {
    oss << bytesPerSecond / mb << "M";
  } else if (bytesPerSecond >= kb) {
    oss << bytesPerSecond / kb << "K";
  } else {
    oss << static_cast<long long>(bytesPerSecond) << "B";
  }
  return oss.str();
}

int main() {
  // Dynamically find the active network interface
  const std::string interfaceName = getActiveInterface();

  if (interfaceName.empty()) {
    std::cerr << "Error: Could not determine an active network interface.\n";
    // Provide a clear error message in the Waybar output
    std::cout << " No Interface" << std::endl;
    return 1;
  }

  // Define paths for network statistics and temporary state files
  const auto rxPath = std::filesystem::path("/sys/class/net/") / interfaceName / "statistics" / "rx_bytes";
  const auto txPath = std::filesystem::path("/sys/class/net/") / interfaceName / "statistics" / "tx_bytes";
  const auto tempDir = std::filesystem::path("/tmp/waybar-bandwidth/");
  const auto prevRxPath = tempDir / (interfaceName + "_rx");
  const auto prevTxPath = tempDir / (interfaceName + "_tx");

  // Read current and previous byte counts
  const long long currentRx = readValueFromFile(rxPath);
  const long long currentTx = readValueFromFile(txPath);
  const long long prevRx = readValueFromFile(prevRxPath);
  const long long prevTx = readValueFromFile(prevTxPath);

  // Calculate speed (assuming this script is called once per second)
  const long long downloadSpeed = currentRx - prevRx;
  const long long uploadSpeed = currentTx - prevTx;

  std::cout << "▲ " << std::left << std::setw(7) << formatBandwidth(downloadSpeed) << " ▼ " << std::left << std::setw(7)
            << formatBandwidth(uploadSpeed) << std::endl;

  // Save current values for the next execution
  writeValueToFile(prevRxPath, currentRx);
  writeValueToFile(prevTxPath, currentTx);

  return 0;
}
