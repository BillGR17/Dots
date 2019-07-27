#include <stdio.h>
#include <stdlib.h>
int main(){
  char *e=getenv("BLOCK_BUTTON");
  if(e==NULL){
    exit(1);
  }
  int m = atoi(e);
  switch (m) {
    case 1:
      system("amixer -q sset Master,0 toggle");
      break;
    case 4:
      system("amixer -q sset Master 1%+ unmute");
      break;
    case 5:
      system("amixer -q sset Master 1%- unmute");
      break;
  }
  system("if [[ $(amixer get Master|grep -Fc \"[off]\") == 0 ]];then echo -e ' '$(amixer get Master|grep -E -o '[0-9]{1,3}?%'|head -1);else echo -e ' Muted';fi");
  return 0;
}
