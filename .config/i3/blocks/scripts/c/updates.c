#include <stdio.h>
#include <stdlib.h>
int main() {
  char* e = getenv("BLOCK_BUTTON");
  int m = 0;
  if (e != NULL) m = atoi(e);
  switch (m) {
    // since middle click is less accidentally pressed
    // it should run the yay command which now shows all packages before upgrading
    case 2:
      system("xterm -e zsh -c \"yay -Syu&&echo 'All Done :)'&&read\"");
      // since we just run upgrade command just throw 0 packages
      // to show something on i3block
      puts("0");
      break;
      // check for updates by default
    default: system("checkupdates > /tmp/updates_list;yay -Qua >> /tmp/updates_list;cat /tmp/updates_list|wc -l");
  }
  return 0;
}
