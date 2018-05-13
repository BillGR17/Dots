#include <iostream>

int main(){
  system("xwininfo -id $(xprop -root| awk '/NET_ACTIVE_WINDOW/ { print $5; exit }') |sed -n 2p |grep -o '\".*\"' |sed 's/\"//g'");
  return 0;
}

