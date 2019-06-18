#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void exec(char *x,int s){
  char b[128];
  FILE *cmd=popen(x,"r");
  if (cmd == NULL){
    perror("Error while running the command.\n");
    exit(2);
  }
  //clear the command
  //and store only the popen output
  memset(x,0,(char)sizeof(x));
  while(fgets(b,128,cmd)){
    strncat(x,b,s);
  }
  pclose(cmd);
}

int main(){
  char *e=getenv("BLOCK_INSTANCE");
  if(e==NULL){
    exit(1);
  }
  //playerctl -l has some weird delay and causes a lot of problems
  //this checks if the player exists in dbus
  char x[4098]="dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames";
  exec(x,sizeof(x));
  if(strstr(x,e)!=NULL){
    char s[128];
    sprintf(s,"playerctl -p %s status",e);
    exec(s,sizeof(s));
    char i[128];
    sprintf(i,"playerctl -p %s metadata --format '{{ artist }} ~ {{ title }}'",e);
    exec(i,sizeof(i));
    if(strstr(s,"Playing")!=NULL){
      printf(" %s\n",i);
    }else if(strstr(s,"Paused")!=NULL){
      printf(" %s\n",i);
    }
  }else{
    puts("");
  }
  fflush(stdout);
  return 0;
}
