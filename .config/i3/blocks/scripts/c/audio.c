#include <stdio.h>
#include <stdlib.h>
int main() {
  char* e = getenv("BLOCK_BUTTON");
  if (e != NULL) {
    int m = atoi(e);
    switch (m) {
      case 1: system("pulsemixer --toggle-mute&"); break;
      case 4:
        system("pulsemixer --unmute&");
        system("pulsemixer --change-volume +1&");
        break;
      case 5:
        system("pulsemixer --unmute&");
        system("pulsemixer --change-volume -1&");
        break;
    }
  }
  system("if [[ $(pulsemixer --get-mute) == 0 ]];then pulsemixer --get-volume;else echo 'MUTED';fi");
  return 0;
}
