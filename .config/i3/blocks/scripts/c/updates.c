#include <stdio.h>
#include <stdlib.h>
int main() {
  char* e = getenv("BLOCK_BUTTON");
  // check for updates by default
  system("checkupdates > /tmp/updates_list;yay -Qua >> /tmp/updates_list;cat /tmp/updates_list|wc -l");
  // if a button has been pressed run different commands
  if (e != NULL) {
    int m = atoi(e);
    switch (m) {
      // since middle click is less accidentally pressed
      // it should run the yay command which now shows all packages before upgrading
      case 2: system("xterm -e zsh -c \"yay -Syu&&echo 'All Done :)'&&read\""); break;
    }
  }
  return 0;
}
