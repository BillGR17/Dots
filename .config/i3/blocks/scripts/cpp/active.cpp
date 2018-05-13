#include <iostream>

int main(){
  system("xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) WM_NAME | cut -d '\"' -f 2");
  return 0;
}

