#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

const std::string kUpdatesFile = "/tmp/updates_list";

void checkUpdates() {
  const std::string command = "checkupdates > " + kUpdatesFile + "; paru -Qua >> " + kUpdatesFile;
  system(command.c_str());
}

int getLineCount(const std::string &filename) {
  std::ifstream file(filename);
  if (!file.is_open()) {
    std::cerr << "Failed to open file " << filename << std::endl;
    return 0;
  }

  int count = 0;
  std::string line;
  while (std::getline(file, line)) {
    count++;
  }
  return count;
}

int main() {
  const char *buttonEnv = std::getenv("BLOCK_BUTTON");
  int mouseButton = 0;

  if (buttonEnv != nullptr) {
    mouseButton = std::atoi(buttonEnv);
  }

  switch (mouseButton) {
  case 2: {
    const std::string updateCommand = "alacritty -c \"cat " + kUpdatesFile + " &&paru -Syyuu && echo 'All Done :)' && read\"";
    system(updateCommand.c_str());

    checkUpdates();
    std::cout << getLineCount(kUpdatesFile) << std::endl;
    break;
  }
  default: {
    checkUpdates();
    std::cout << getLineCount(kUpdatesFile) << std::endl;
    break;
  }
  }

  return 0;
}
