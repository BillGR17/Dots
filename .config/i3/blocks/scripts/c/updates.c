#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
void checkupdates() {
  system("checkupdates > /tmp/updates_list;yay -Qua >> /tmp/updates_list");
}
int getlines(const char* filename) {
  FILE* fp = fopen(filename, "r");
  if (fp == NULL) {
    perror("fopen");
    exit(EXIT_FAILURE);
  }
  int i = 0;
  char c;
  for (c = getc(fp); c != EOF; c = getc(fp))
    if (c == '\n') // Increment count if this character is newline
      i = i + 1;
  fclose(fp);
  return i;
}
int main() {
  char* e = getenv("BLOCK_BUTTON");
  int m = 0;
  if (e != NULL) m = atoi(e);
  int updates = 0;
  switch (m) {
    // since middle click is less accidentally pressed
    // it should run the yay command which now shows all packages before upgrading
    case 2:
      system("xterm -e zsh -c \"cat /tmp/updates_list&&yay -Syu&&echo 'All Done :)'&&read\"");
      // check again for updates and update
      // run the results for the i3block once more
      checkupdates();
      updates = getlines("/tmp/updates_list");
      printf("%d\n", updates);
      break;
    default:
      // check for updates by default
      checkupdates();
      updates = getlines("/tmp/updates_list");
      printf("%d\n", updates);
  }
  return 0;
}
