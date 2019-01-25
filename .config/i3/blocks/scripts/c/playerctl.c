#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char *exec(const char *x){
  char b[128],*r=malloc(256*sizeof(*r));
  FILE *cmd=popen(x,"r");
  if (cmd == NULL){
    perror("Error while running the command.\n");
    exit(2);
  }
  while(fgets(b,128,cmd)){
    strcpy(r,strtok(b,"\n"));
  }
  pclose(cmd);
  return r;
}

int main(){
  char *e=getenv("BLOCK_INSTANCE");
  if(e==NULL){
    exit(1);
  }
  char x[60]="playerctl -p ";
  strcat(x,e);
  char s[60];
  strcpy(s,x);
  strcat(s," status");
  const char *status=exec(s);
  if(strcmp(status,"No players found")!=0){
    strcat(x," metadata --format '{{ artist }} ~ {{ title }}'");
    const char *info=exec(x);
    if(strstr(status,"Playing")!=NULL){
      printf(" %s\n",info);
      fflush(stdout);
    }else if(strstr(status,"Paused")!=NULL){
      printf(" %s\n",info);
      fflush(stdout);
    }
  }
  return 0;
}
