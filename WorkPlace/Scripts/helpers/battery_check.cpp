#include <print>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <sstream>
#include <vector>
#include <memory>
#include <string_view>
#include <charconv>
#include <cctype>

const int LOW_THRESHOLD = 30;

std::string sound_file() {
  const char *home = std::getenv("HOME");
  return std::string(home ? home : "") + "/.config/sound_events/low_power.wav";
}

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
  std::string state;
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

std::string abbreviate_name(std::string_view name) {
  std::string abbr;
  bool new_word = true;
  int word_count = 0;

  for (size_t i = 0; i < name.size(); ++i) {
    char c = name[i];
    if (std::isspace(c) || c == '-' || c == '_') {
      new_word = true;
    } else if (new_word) {
      if (std::isalnum(c)) {
        abbr += static_cast<char>(std::toupper(c));
        word_count++;

        if (word_count == 1 && i + 1 < name.size() && std::isupper(name[i + 1])) {
          abbr += name[i + 1];
          i++; // skip next char
        }
      }
      new_word = false;
    }
  }
  return abbr;
}

// Short display name for the bar: keep it if tiny, else abbreviate to initials.
std::string short_name(std::string_view name) {
  if (name.size() <= 10)
    return std::string(name);
  std::string abbr = abbreviate_name(name);
  if (!abbr.empty())
    return abbr;
  return shorten_name(name);
}

bool is_notable(const DeviceInfo &d) { return d.is_charging || d.percentage < LOW_THRESHOLD; }

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
    } else if (size_t pos = line.find("state:"); pos != std::string::npos) {
      info.state = std::string(trim(std::string_view(line).substr(pos + 6)));
      if (info.state.find("charging") != std::string::npos && info.state.find("discharging") == std::string::npos) {
        info.is_charging = true;
      }
    } else if (line.find("icon-name:") != std::string::npos) {
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

std::vector<DeviceInfo> collect_devices() {
  std::string raw_list = exec("upower -e");
  if (raw_list.empty())
    return {};

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
        std::string cmd = "aplay \"" + sound_file() + "\" >/dev/null 2>&1 &";
        std::system(cmd.c_str());
      }
    }
  }
  return devices;
}

// Bar-friendly one-liner: only low/charging devices are listed,
// empty string when every battery is above the low threshold.
// '!name: NN%' = low, 'name: NN%+' = charging.
std::string format_compact(const std::vector<DeviceInfo> &devices) {
  std::vector<const DeviceInfo *> notable;
  for (const auto &d : devices) {
    if (is_notable(d))
      notable.push_back(&d);
  }
  if (notable.empty())
    return "";

  std::string out;
  for (const auto *d : notable) {
    if (!out.empty())
      out += ' ';
    bool low = !d->is_charging && d->percentage < LOW_THRESHOLD;
    if (low)
      out += '!';
    out += short_name(d->model);
    out += ": " + std::to_string(d->percentage) + "%";
    if (d->is_charging)
      out += '+';
  }
  return out;
}

// Full detail, one device per line.
std::string format_full(const std::vector<DeviceInfo> &devices) {
  if (devices.empty())
    return "No battery devices found";

  std::string out;
  for (const auto &d : devices) {
    if (!out.empty())
      out += '\n';
    out += d.model + ": " + std::to_string(d.percentage) + "% ";
    out += d.is_charging ? "charging" : (d.state.empty() ? "unknown" : d.state);
    if (!d.is_charging && d.percentage < LOW_THRESHOLD)
      out += " (LOW)";
  }
  return out;
}

std::string json_escape(std::string_view s) {
  std::string out;
  for (char c : s) {
    switch (c) {
    case '"':
      out += "\\\"";
      break;
    case '\\':
      out += "\\\\";
      break;
    case '\n':
      out += "\\n";
      break;
    case '\r':
      out += "\\r";
      break;
    case '\t':
      out += "\\t";
      break;
    default:
      if (static_cast<unsigned char>(c) < 0x20)
        continue;
      out += c;
    }
  }
  return out;
}

// Waybar renders tooltips as pango markup.
std::string pango_escape(std::string_view s) {
  std::string out;
  for (char c : s) {
    if (c == '&')
      out += "&amp;";
    else if (c == '<')
      out += "&lt;";
    else if (c == '>')
      out += "&gt;";
    else
      out += c;
  }
  return out;
}

std::string shell_quote(std::string_view s) {
  std::string out = "'";
  for (char c : s) {
    if (c == '\'')
      out += "'\\''";
    else
      out += c;
  }
  out += "'";
  return out;
}

void send_notification(const std::vector<DeviceInfo> &devices) {
  bool any_low = false;
  for (const auto &d : devices) {
    if (!d.is_charging && d.percentage < LOW_THRESHOLD)
      any_low = true;
  }
  std::string cmd = "notify-send -a Battery -u " + std::string(any_low ? "critical" : "normal") + " " + shell_quote("Battery") + " " +
                    shell_quote(format_full(devices)) + " >/dev/null 2>&1";
  std::system(cmd.c_str());
}

void print_usage() {
  std::print("usage: battery_check [--full|--json|--notify]\n"
             "  (default)  compact bar output: only low (below 30%) or charging\n"
             "             devices, nothing at all when all batteries are fine\n"
             "  --full     full details, one device per line\n"
             "  --json     waybar JSON: text = compact, tooltip = full details\n"
             "  --notify   show full details as a desktop notification\n"
             "  --help     show this help\n");
}

int main(int argc, char **argv) {
  bool full = false, json = false, notify = false;

  for (int i = 1; i < argc; ++i) {
    std::string_view arg = argv[i];
    if (arg == "--full" || arg == "-f") {
      full = true;
    } else if (arg == "--json") {
      json = true;
    } else if (arg == "--notify" || arg == "-n") {
      notify = true;
    } else if (arg == "--help" || arg == "-h") {
      print_usage();
      return 0;
    } else {
      std::print(stderr, "battery_check: unknown option '{}'\n", arg);
      print_usage();
      return 1;
    }
  }

  std::vector<DeviceInfo> devices = collect_devices();

  if (notify) {
    send_notification(devices);
    return 0;
  }

  if (full) {
    std::print("{}\n", format_full(devices));
    return 0;
  }

  if (json) {
    std::print("{{\"text\": \"{}\", \"tooltip\": \"{}\"}}\n", json_escape(format_compact(devices)), json_escape(pango_escape(format_full(devices))));
    return 0;
  }

  std::print("{}\n", format_compact(devices));
  return 0;
}
