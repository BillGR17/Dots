#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void exec(char* x, int s) {
  char b[128];
  FILE* cmd = popen(x, "r");
  if (cmd == NULL) {
    perror("Error while running the command.\n");
    exit(2);
  }
  // clear the command
  // and store only the popen output
  memset(x, 0, (char)sizeof(x));
  while (fgets(b, 128, cmd)) { strncat(x, b, s); }
  pclose(cmd);
}
void strip(char* s) {
  char* p2 = s;
  while (*s != '\0') {
    if (*s != '\n') {
      *p2++ = *s++;
    } else {
      ++s;
    }
  }
  *p2 = '\0';
}
int main() {
  char* e = getenv("BLOCK_INSTANCE");
  if (e == NULL) { exit(1); }
  char find[100];
  sprintf(find, "upower -e|grep %s|head -1", e);
  exec(find, sizeof(find));
  strip(find);
  char info[256];
  sprintf(info, "upower -i %s|grep percentage|awk '{print $2}'", find);
  exec(info, sizeof(info));
  printf("%s", info);
  fflush(stdout);
  return 0;
}
