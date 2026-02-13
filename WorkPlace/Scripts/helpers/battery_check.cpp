#include <print>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <memory>
#include <string_view>
#include <charconv>

const int LOW_THRESHOLD = 20;
const std::string SOUND_FILE = std::string(std::getenv("HOME")) + "/.config/sound_events/low_power.wav";

std::string exec(const char *cmd) {
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
  if (!pipe)
    return "";
  std::string result;
  std::array<char, 128> buffer;
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    result += buffer.data();
  }
  return result;
}

struct DeviceInfo {
  int percentage = -1;
  bool is_charging = false;
  std::string model = "Unknown";
};

std::string_view trim(std::string_view s) {
  auto start = s.find_first_not_of(" \t\n");
  if (start == std::string_view::npos)
    return "";
  auto end = s.find_last_not_of(" \t\n");
  return s.substr(start, end - start + 1);
}

std::string shorten_name(std::string_view name) {
  if (name.size() <= 20) {
    return std::string(name);
  }
  return std::string(name.substr(0, 17)) + "...";
}

DeviceInfo inspect_device(const std::string &path) {
  DeviceInfo info;
  std::string cmd = "upower -i " + path;
  std::string output = exec(cmd.c_str());
  std::stringstream ss(output);
  std::string line;

  while (std::getline(ss, line)) {
    if (size_t pos = line.find("percentage:"); pos != std::string::npos) {
      std::string_view val(line);
      val = val.substr(pos + 11);
      size_t num_start = val.find_first_of("0123456789");
      if (num_start != std::string_view::npos) {
        std::from_chars(val.data() + num_start, val.data() + val.size(), info.percentage);
      }
    } else if (line.find("state:") != std::string::npos) {
      if (line.find("charging") != std::string::npos && line.find("discharging") == std::string::npos) {
        info.is_charging = true;
      }
    } else if (size_t pos = line.find("model:"); pos != std::string::npos) {
      std::string_view m_view(line);
      info.model = std::string(trim(m_view.substr(pos + 6)));
    }
  }
  return info;
}

int main() {
  std::string raw_list = exec("upower -e");
  if (raw_list.empty())
    return 1;

  std::stringstream ss(raw_list);
  std::string path;
  std::vector<DeviceInfo> devices;

  while (std::getline(ss, path)) {
    if (!path.empty() && path.back() == '\n')
      path.pop_back();
    if (path.empty())
      continue;

    DeviceInfo info = inspect_device(path);

    // Filter: Must have valid % and Model must not be "Unknown"
    if (info.percentage >= 0 && info.model != "Unknown") {
      devices.push_back(info);

      // Audio Alert Logic (kept internal, not printed)
      if (!info.is_charging && info.percentage < LOW_THRESHOLD) {
        std::string cmd = "aplay \"" + SOUND_FILE + "\" >/dev/null 2>&1 &";
        std::system(cmd.c_str());
      }
    }
  }

  std::map<std::string, int> total_counts;
  for (auto &d : devices) {
    d.model = shorten_name(d.model);
    total_counts[d.model]++;
  }

  std::map<std::string, int> current_counts;
  for (auto &d : devices) {
    if (total_counts[d.model] > 1) {
      current_counts[d.model]++;
      d.model += " (" + std::to_string(current_counts[d.model]) + ")";
    }
  }

  // Print all on one line: Model: Percentage%
  for (size_t i = 0; i < devices.size(); ++i) {
    const auto &d = devices[i];

    if (i > 0)
      std::print(" ");

    std::print("{}: {}%", d.model, d.percentage);
  }

  if (!devices.empty()) {
    std::println("");
  }

  return 0;
}
