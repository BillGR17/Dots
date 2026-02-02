#include <iostream>
#include <vector>
#include <string>
#include <filesystem>
#include <fstream>
#include <cstdlib>
#include <algorithm>
#include <limits>

// Modern Namespace Aliases
namespace fs = std::filesystem;

// Globals
fs::path PROTON_PREFIX;
fs::path PROTON_PATH;

// Helpers to handle Home directory expansion
fs::path get_home() {
  const char *home = std::getenv("HOME");
  return home ? fs::path(home) : fs::current_path();
}

void if_error(bool target, const std::string &msg, int code) {
  if (!target) {
    std::cerr << msg << std::endl;
    std::exit(code);
  }
}

int input_loop(const std::string &msg, int inp_min, int inp_max) {
  int r_value = 0;
  while (true) {
    std::cout << msg;
    int user_input;
    if (!(std::cin >> user_input)) {
      std::cin.clear();
      std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
      continue;
    }

    if (user_input >= inp_min && user_input <= inp_max) {
      r_value = user_input;
      break;
    }
  }
  return r_value - 1;
}

// Recursive search replacing os.walk
std::vector<fs::path> find(const std::string &name, const fs::path &path) {
  std::vector<fs::path> result;
  if (!fs::exists(path))
    return result;

  try {
    for (const auto &entry : fs::recursive_directory_iterator(path, fs::directory_options::skip_permission_denied)) {
      if (entry.is_regular_file() && entry.path().filename() == name) {
        result.push_back(entry.path());
      }
    }
  } catch (const fs::filesystem_error &e) {
    // Silently ignore access errors
  }
  return result;
}

std::vector<fs::path> find_proton() {
  std::cout << "Searching for Any Installed Proton..." << std::endl;

  std::vector<fs::path> search_steam_libs;
  fs::path conf_path = get_home() / ".config/proton/conf";

  if (fs::exists(conf_path)) {
    std::ifstream conf_file(conf_path);
    std::string line;
    while (std::getline(conf_file, line)) {
      if (!line.empty())
        search_steam_libs.emplace_back(line);
    }
    std::cout << "Found ~/.config/proton/conf" << std::endl;
    std::cout << "Proton path[s]: ";
    for (const auto &p : search_steam_libs) {
      std::cout << p << " ";
    }
    std::cout << std::endl;
  } else {
    std::cout << "Couldn't find ~/.config/proton/conf\nDefault path .local/share/Steam" << std::endl;
    search_steam_libs.push_back(get_home() / ".local/share/Steam");
  }

  std::vector<fs::path> proton_list;
  for (const auto &x : search_steam_libs) {
    auto found = find("proton", x);
    proton_list.insert(proton_list.end(), found.begin(), found.end());
  }

  if_error(!proton_list.empty(), "No Proton found", 1);
  return proton_list;
}

fs::path pwd_pfx(const fs::path &loc) {
  fs::path current_pfx = fs::current_path() / ".proton";
  std::cout << "Checking for previous proton run: ";

  if (fs::exists(current_pfx)) {
    std::cout << current_pfx.string() << std::endl;
    PROTON_PREFIX = current_pfx / "pfx";
    return current_pfx;
  } else {
    fs::path path = loc / ".proton";
    std::cout << path.string() << std::endl;
    PROTON_PREFIX = loc / ".proton/pfx";
    return path;
  }
}

// Forward declaration
void new_run(const fs::path &loc);
void set_env();

void check_prev_run(const fs::path &loc) {
  fs::path path = pwd_pfx(loc);
  fs::path last_file_path = path / "last";

  if (fs::exists(last_file_path)) {
    std::ifstream file(last_file_path);
    std::string last_proton_str;
    std::getline(file, last_proton_str);

    fs::path last_proton_dir(last_proton_str);

    if (fs::exists(last_proton_dir / "proton")) {
      std::cout << "Found last Proton used: " << last_proton_str << std::endl;
      PROTON_PATH = last_proton_dir;
      set_env();
    } else {
      std::cout << "Couldn't find the proton used last time: " << last_proton_str << std::endl;
      new_run(loc);
      set_env();
    }
  } else {
    std::cout << "No Previous run\nCreating new prefix" << std::endl;
    new_run(loc);
    set_env();
  }
}

void new_run(const fs::path &loc) {
  auto protons_found = find_proton();

  std::string msg = "Select Proton Version to use:\n";
  int idx = 1;
  for (const auto &text : protons_found) {
    msg += "[" + std::to_string(idx++) + "]" + text.string() + "\n";
  }

  int option = input_loop(msg, 1, protons_found.size());

  PROTON_PATH = protons_found[option].parent_path();

  fs::path proton_dir = loc / ".proton";
  if (!fs::exists(proton_dir)) {
    fs::create_directories(proton_dir);
  }

  std::ofstream out(proton_dir / "last");
  out << PROTON_PATH.string();
  out.close();

  if (!fs::exists(PROTON_PREFIX)) {
    fs::create_directories(PROTON_PREFIX);
  }
}

void change_proton(fs::path loc) {
  if (loc.empty()) {
    loc = fs::current_path();
  }

  int option = input_loop("Change Proton Version:\n[1] Replace existing\n[2] Create New Prefix\n\n*The old prefix will be renamed\n**If u had "
                          "another old prefix it will be removed.\n",
                          1, 2);

  PROTON_PREFIX = loc / ".proton/pfx";
  fs::path last_file = loc / ".proton/last";

  if (fs::exists(last_file)) {
    fs::remove(last_file);
  }

  fs::path old_pfx = fs::path(PROTON_PREFIX.string() + "_old");

  if (fs::exists(old_pfx)) {
    fs::remove_all(old_pfx);
  }

  if (option == 0) { // Index 0 is [1] Replace existing
    std::cout << "Moving pfx_old..." << std::endl;
    fs::rename(PROTON_PREFIX, old_pfx);
  } else {
    std::cout << "Copying pfx_old..." << std::endl;
    fs::create_directories(old_pfx);
    for (const auto &entry : fs::recursive_directory_iterator(PROTON_PREFIX)) {
      if (entry.path().filename() == "dosdevices")
        continue;

      auto relative = fs::relative(entry.path(), PROTON_PREFIX);
      auto target = old_pfx / relative;

      if (fs::is_directory(entry)) {
        fs::create_directories(target);
      } else {
        fs::copy_file(entry.path(), target, fs::copy_options::overwrite_existing);
      }
    }
  }

  new_run(loc);
  std::cout << "All Done!" << std::endl;
  std::exit(0);
}

void set_env() {
  std::cout << "PROTON_PREFIX: " << PROTON_PREFIX.string() << std::endl;

  setenv("PROTON_PREFIX", PROTON_PREFIX.c_str(), 1);
  setenv("STEAM_COMPAT_DATA_PATH", PROTON_PREFIX.c_str(), 1);

  std::string client_path = (get_home() / ".local/share/Steam").string();
  setenv("STEAM_COMPAT_CLIENT_INSTALL_PATH", client_path.c_str(), 1);

  setenv("WINEPREFIX", PROTON_PREFIX.c_str(), 1);
  setenv("WINEARCH", "win64", 1);

  std::string wine_bin = (PROTON_PATH / "dist/bin/wine64").string();
  setenv("WINE", wine_bin.c_str(), 1);

  std::string wine_server = (PROTON_PATH / "dist/bin/wineserver").string();
  setenv("WINESERVER", wine_server.c_str(), 1);
}

void run(const std::string &target) {
  std::string cmd = "'" + (PROTON_PATH / "proton").string() + "' run " + target;
  std::cout << "Executing: " << cmd << std::endl;
  std::system(cmd.c_str());
}

fs::path ifloc(const std::vector<std::string> &args) {
  if (args.size() > 2) {
    fs::path loc = fs::canonical(args[2]);
    if (fs::exists(loc)) {
      std::cout << "Running in location: " << loc.string() << std::endl;
      return loc;
    }
  }
  return "";
}

int main(int argc, char *argv[]) {
  std::vector<std::string> args(argv, argv + argc);
  std::vector<std::string> filetypes = {".exe", ".msi"};

  if (args.size() > 1) {
    bool is_exe = false;
    for (const auto &ft : filetypes) {
      if (args[1].find(ft) != std::string::npos) {
        is_exe = true;
        break;
      }
    }

    if (is_exe) {
      fs::path target = fs::canonical(args[1]);
      check_prev_run(target.parent_path());

      std::string extra_args = "";
      for (size_t i = 2; i < args.size(); ++i) {
        extra_args += args[i] + " ";
      }

      run("'" + target.string() + "' " + extra_args);

    } else if (args[1].find("wine") != std::string::npos) {
      check_prev_run(fs::current_path());
      run(args[1]);

    } else if (args[1].find("change") != std::string::npos) {
      change_proton(ifloc(args));

    } else {
      std::cout << "Not sure what you are trying to do right now..." << std::endl;
    }
  } else {
    std::string script = fs::path(args[0]).filename().string();
    std::cout << "Available arguments:\n\n\n"
              << script << " game.exe\n"
              << script << " winecfg/winetricks\n"
              << script << " change\n\n\n"
              << "If u dont provide the location on winecfg/winetricks or on change,\n"
              << "the script will start on current location" << std::endl;
  }

  return 0;
}
