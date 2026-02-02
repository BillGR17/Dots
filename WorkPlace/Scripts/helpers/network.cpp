#include <print>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
#include <memory>
#include <array>
#include <string_view>
#include <charconv>
#include <sstream>

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

void strip_newline(std::string &s) {
  if (!s.empty() && s.back() == '\n')
    s.pop_back();
}

int get_wifi_signal() {
  std::string output = exec("nmcli -t -f IN-USE,SIGNAL dev wifi list");
  std::stringstream ss(output);
  std::string line;

  while (std::getline(ss, line)) {
    if (line.starts_with('*')) {
      size_t colon = line.find(':');
      if (colon != std::string::npos) {
        int signal = 0;
        auto val_str = line.substr(colon + 1);
        std::from_chars(val_str.data(), val_str.data() + val_str.size(), signal);
        return signal;
      }
    }
  }
  return 0;
}

std::string get_bar_icon(int strength) {
  int bars = strength / 25;
  switch (bars) {
  case 4:
    return "▂▄▆▉";
  case 3:
    return "▂▄▆ ";
  case 2:
    return "▂▄  ";
  case 1:
    return "▂   ";
  default:
    return "    ";
  }
}

int main(int argc, char *argv[]) {
  // Check command line arguments for -ui
  if (argc > 1 && std::string_view(argv[1]) == "-ui") {
    std::system("alacritty -e nmtui &");
  }

  std::string output = exec("nmcli -t -f TYPE,DEVICE,NAME c s --active");

  if (output.empty()) {
    std::println("Disconnected");
    return 0;
  }

  std::stringstream ss(output);
  std::string line;
  std::getline(ss, line);
  strip_newline(line);

  size_t first_colon = line.find(':');
  size_t second_colon = line.find(':', first_colon + 1);

  if (first_colon == std::string::npos || second_colon == std::string::npos) {
    std::println("Disconnected");
    return 0;
  }

  std::string type = line.substr(0, first_colon);
  std::string device = line.substr(first_colon + 1, second_colon - first_colon - 1);
  std::string ssid = line.substr(second_colon + 1);

  if (type == "802-11-wireless" || type == "wifi") {
    int signal = get_wifi_signal();
    std::string icon = get_bar_icon(signal);
    std::println("{} {}", ssid, icon);
  } else if (type == "802-3-ethernet" || type == "ethernet") {
    std::println("{}", device);
  } else {
    std::println("{}", ssid);
  }

  return 0;
}
