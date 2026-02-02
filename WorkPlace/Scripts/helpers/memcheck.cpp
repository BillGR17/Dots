#include <print>
#include <fstream>
#include <string>
#include <string_view>
#include <charconv>

// Use string_view to avoid copying strings when passing arguments
long get_mem_value(std::string_view key) {
  std::ifstream file("/proc/meminfo");

  if (!file.is_open()) {
    std::println(stderr, "Error: Could not open /proc/meminfo");
    std::exit(EXIT_FAILURE);
  }

  std::string line;
  long value = 0;

  while (std::getline(file, line)) {
    if (line.contains(key)) {
      // Find the start of the number
      auto const digit_pos = line.find_first_of("0123456789");

      if (digit_pos != std::string::npos) {
        // std::from_chars is faster and safer than atoi or sscanf
        std::from_chars(line.data() + digit_pos, line.data() + line.size(), value);
      }
      return value;
    }
  }

  return 0; // Return 0 if key not found
}

int main() {
  const long total_kb = get_mem_value("MemTotal");
  const long available_kb = get_mem_value("MemAvailable");

  // Calculate used memory
  const long used_kb = total_kb - available_kb;

  // Convert to GB (floating point arithmetic)
  const double total_gb = static_cast<double>(total_kb) / 1024.0 / 1024.0;
  const double used_gb = static_cast<double>(used_kb) / 1024.0 / 1024.0;

  // {:.2f} limits the float to 2 decimal places
  std::println("{:.2f}gb {:.2f}gb", used_gb, total_gb);

  return 0;
}
