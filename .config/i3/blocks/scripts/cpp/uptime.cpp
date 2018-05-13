#include <iostream>

int main(){
  system("uptime|awk '{print $3}'| tr ',' ' '");
  return 0;
}

