#include <stdio.h>
#include <stdlib.h>
int main() {
  char* e = getenv("BLOCK_BUTTON");
  if (e != NULL) {
    int m = atoi(e);
    switch (m) {
      case 1:
        system("pactl set-sink-mute @DEFAULT_SINK@ toggle");
        break;
        break;
      case 4: system("pactl set-sink-volume @DEFAULT_SINK@ +1%"); break;
      case 5: system("pactl set-sink-volume @DEFAULT_SINK@ -1%"); break;
    }
  }
  system("if [[ $(pactl get-sink-mute @DEFAULT_SINK@|awk '{print $2}') == 'no'  ]];then pactl get-sink-volume "
         "@DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -n 1;else echo 'MUTED';fi");
  return 0;
}
